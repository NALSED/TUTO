# Ajout d'un nouveau service PKI — Infra opérationnelle

---

`[RAPPEL]`

- **Vault PKI** : 192.168.0.238
- **Serveur Web / Infra** : 192.168.0.239
- **Serveur Bareos** : 192.168.0.240
- **DNS** : 192.168.0.241
- **Proxmox** : 192.168.0.242
- **VPS** : 176.31.163.227

---

Ce document décrit l'ajout d'un service SSL sur une infrastructure PKI déjà opérationnelle.  
Les CA Root et Intermédiaires sont en place, les scripts sont déployés sur Vault.

---

## 1️⃣ Prérequis sur la machine cible

-1.1. Vérifier que `reload_ssl.sh` est bien en place sur la machine
```
ls -la /usr/local/bin/reload_ssl.sh
```
Si absent, le déployer (voir script `reload_ssl_<machine>.sh`) et configurer le sudoers :
```
sudo visudo
```
Ajouter **uniquement** :
```
sednal ALL=(ALL) NOPASSWD: /usr/local/bin/reload_ssl.sh
```

-1.2. Si le service tourne sous un utilisateur tiers, ajouter `sednal` au groupe concerné
```
sudo usermod -aG <groupe> sednal
```
⚠️ Se déconnecter / reconnecter pour que le groupe soit pris en compte.

-1.3. Vérifier que Vault peut atteindre la machine en SSH sans mot de passe
```
# Depuis Vault
ssh <user>@<hostname>
```
Si ce n'est pas le cas :
```
ssh-copy-id <user>@<hostname>
```

---

## 2️⃣ Créer les dossiers SSL sur la machine cible

-2.1. Créer l'arborescence
```
sudo mkdir -p /etc/<service>/ssl/{CA,Cert,Keys}
```

-2.2. Appliquer les droits selon le cas :

=== Propriétaire `sednal` ===
```
sudo chown root:root /etc/<service>/ssl
sudo chown sednal:sednal /etc/<service>/ssl/{CA,Cert,Keys}
sudo chmod 755 /etc/<service>/ssl/{CA,Cert,Keys}
```

=== Service avec groupe dédié (ex: bareos) ===
```
sudo chown <user>:<groupe> /etc/<service>/ssl
sudo chmod 2775 /etc/<service>/ssl/{CA,Cert,Keys}
```

---

## 3️⃣ Créer les dossiers du service sur Vault

Sur **Vault (192.168.0.238)** :

=== RSA + ECDSA ===
```
sudo mkdir -p /etc/Vault/PKI/{private,public}/<Folder>/{Rsa,Ecdsa}
```

=== RSA uniquement ===
```
sudo mkdir -p /etc/Vault/PKI/{private,public}/<Folder>/Rsa
```

Appliquer les droits :
```
sudo chown -R vault:vault /etc/Vault/PKI/{private,public}/<Folder>
sudo chmod 700 /etc/Vault/PKI/private/<Folder>/{Rsa,Ecdsa}
sudo chmod 755 /etc/Vault/PKI/public/<Folder>/{Rsa,Ecdsa}
```

---

## 4️⃣ Remplir et exécuter `ajout_service.sh`

-4.1. Éditer le script sur Vault
```
sudo nano /usr/local/bin/ajout_service.sh
```

Remplir les variables :

| Variable | Description | Exemple |
|---|---|---|
| `service` | Nom du service | `monservice` |
| `algo` | `rsa` ou `dual` (RSA+ECDSA) | `dual` |
| `folder` | Dossier Vault dans `/etc/Vault/PKI/` | `MonService` |
| `cible` | SSH cible depuis Vault | `sednal@monservice.sednal.lan` |
| `base_dest` | Chemin SSL sur la machine cible | `/etc/monservice/ssl` |
| `owner` | Propriétaire fichiers sur la cible | `sednal:sednal` |
| `perm_key` | Permission clé privée | `F600` (ou `F640` si service tiers) |

-4.2. Exécuter
```
sudo /usr/local/bin/ajout_service.sh
```

Le script génère les certificats, déploie clés + certificats sur la cible puis appelle `reload_ssl.sh` pour mettre à jour la CA système.

---

## 5️⃣ Configurer le service pour utiliser SSL

Adapter selon le service. Exemple générique :
```
ssl_cert = "/etc/<service>/ssl/Cert/<service>_rsa.crt"
ssl_key  = "/etc/<service>/ssl/Keys/<service>_rsa.key"
ssl_ca   = "/etc/<service>/ssl/CA/Sednal_Root_All.crt"
```

=== Si dual RSA + ECDSA (ex: Apache2) ===
```
# RSA
SSLCertificateFile    /etc/<service>/ssl/Cert/<service>_rsa.crt
SSLCertificateKeyFile /etc/<service>/ssl/Keys/<service>_rsa.key
# ECDSA
SSLCertificateFile    /etc/<service>/ssl/Cert/<service>_ecdsa.crt
SSLCertificateKeyFile /etc/<service>/ssl/Keys/<service>_ecdsa.key
```

=== Si PEM combiné requis (ex: Cockpit, Bareos WebUI) ===
```
cat /etc/<service>/ssl/Cert/<service>_rsa.crt \
    /etc/<service>/ssl/Keys/<service>_rsa.key \
    > /etc/<service>/ssl/<service>.pem
chmod 640 /etc/<service>/ssl/<service>.pem
```

Redémarrer le service manuellement :
```
sudo systemctl restart <service>
```

---

## 6️⃣ Intégrer le service dans `renew_cert.sh`

⚠️ Étape obligatoire — sans ça le certificat ne sera pas renouvelé dans 80 jours.

-6.1. Éditer le script sur Vault
```
sudo nano /etc/Vault_Script/Script_Renouvelement/renew_cert.sh
```

-6.2. Ajouter le service dans la liste en tête de script

=== RSA + ECDSA ===
```bash
services_dual=(proxmox cockpit infra ... <service>)
```

=== RSA uniquement ===
```bash
services_rsa=(bareos-dir ... <service>)
```

-6.3. Ajouter la fonction `path()` si le dossier Vault diffère du nom de service
```bash
path() {
    ...
    elif [[ "$1" == "<service>" ]]; then echo "<Folder>"
    fi
}
```

-6.4. Ajouter le bloc de déploiement en fin de script
```bash
# ===== <SERVICE> =====
cible="<user>@<hostname>"
base_service="/etc/<service>/ssl"

ssh "$cible" "rm -f $base_service/Keys/* $base_service/Cert/*"

rsync -e ssh --no-p --chmod=F600 --chown=<owner> \
    "$base_pki/private/<Folder>/Rsa/<service>_rsa.key" \
    "$cible":"$base_service"/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=<owner> \
    "$base_pki/public/<Folder>/Rsa/<service>_rsa.crt" \
    "$cible":"$base_service"/Cert/

# Si dual RSA + ECDSA — ajouter
rsync -e ssh --no-p --chmod=F600 --chown=<owner> \
    "$base_pki/private/<Folder>/Ecdsa/<service>_ecdsa.key" \
    "$cible":"$base_service"/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=<owner> \
    "$base_pki/public/<Folder>/Ecdsa/<service>_ecdsa.crt" \
    "$cible":"$base_service"/Cert/
```

-6.5. Ne pas oublier de redémarrer le service manuellement après le prochain renouvellement
```
sudo systemctl restart <service>
```
---

## ✅ Vérification

```
# Vérifier le certificat
openssl x509 -in /etc/<service>/ssl/Cert/<service>_rsa.crt -noout -text \
    | grep -E "Subject|Issuer|Not After"

# Vérifier la chaîne de confiance
openssl verify \
    -CAfile /etc/<service>/ssl/CA/Sednal_Root_All.crt \
    /etc/<service>/ssl/Cert/<service>_rsa.crt

# Vérifier le service
sudo systemctl status <service>
```
