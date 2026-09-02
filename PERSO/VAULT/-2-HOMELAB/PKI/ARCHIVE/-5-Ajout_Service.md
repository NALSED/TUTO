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


-1.1. Si le service tourne sous un utilisateur tiers, ajouter `sednal` au groupe concerné
```
sudo usermod -aG <groupe> sednal
```
⚠️ Se déconnecter / reconnecter pour que le groupe soit pris en compte.

-1.2. Vérifier que Vault peut atteindre la machine en SSH sans mot de passe
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
sudo mkdir -p /etc/<service>/ssl/{ca,cert,keys}
```

-2.2. Appliquer les droits selon le cas :

=== Propriétaire `sednal` ===
```
sudo chown root:root /etc/<service>/ssl
sudo chown sednal:sednal /etc/<service>/ssl/{ca,cert,keys}
sudo chmod 755 /etc/<service>/ssl/{ca,cert,keys}
```

=== Service avec groupe dédié (ex: bareos) ===
```
sudo chown <user>:<groupe> /etc/<service>/ssl
sudo chmod 2775 /etc/<service>/ssl/{ca,cert,keys}
```

---

## 3️⃣ Créer les dossiers du service sur Vault

Sur **Vault (192.168.0.238)** :

```
sudo mkdir -p /etc/vault/pki/{private,public}/<service>/{rsa,ecdsa}
```

Appliquer les droits :
```
sudo chown -R vault:vault /etc/vault/pki/{private,public}/<service>
sudo chmod 700 /etc/vault/pki/private/<service>/{rsa,ecdsa}
sudo chmod 755 /etc/vault/pki/public/<service>/{rsa,ecdsa}
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
| `algo` | `rsa` \| `ecdsa` \| `dual` (RSA+ECDSA) | `dual` |
| `folder` | Dossier Vault dans `/etc/vault/pki/` | `monservice` |
| `cible` | SSH cible depuis Vault | `sednal@monservice.sednal.lan` |
| `base_dest` | Chemin SSL sur la machine cible | `/etc/monservice/ssl` |
| `owner` | Propriétaire fichiers sur la cible | `sednal:sednal` |
| `perm_key` | Permission clé privée | `F600` (ou `F640` si service tiers) |

-4.2. Exécuter
```
sudo /usr/local/bin/ajout_service.sh
```

Le script génère les certificats, déploie clés + certificats + CA sur la cible.


---

## 5️⃣ Intégrer le service dans `renew_cert.sh`

⚠️ Étape obligatoire — sans ça le certificat ne sera pas renouvelé dans 80 jours.

-6.1. Éditer le script sur Vault
```
sudo nano /etc/Vault_Script/Script_Renouvelement/renew_cert.sh
```

-6.2. Ajouter le service dans les listes en tête de script selon le type souhaité

=== RSA uniquement ===
```bash
services_rsa=(... <service>)
```

=== ECDSA uniquement ===
```bash
services_ecdsa=(... <service>)
```

=== RSA + ECDSA ===
```bash
services_rsa=(... <service>)
services_ecdsa=(... <service>)
```

-6.3. Si le dossier Vault du service ne correspond pas au nom du service, mettre à jour la fonction `path()`
```bash
path() {
    ...
    elif [[ "$1" == "<service>" ]]; then echo "<folder>"
    ...
}
```

-6.4. Ajouter le bloc de déploiement en fin de script
```bash
# ===== <SERVICE> =====
cible="<user>@<hostname>"
base_service="/etc/<service>/ssl"

ssh "$cible" "rm -f $base_service/keys/* $base_service/cert/*"

rsync -e ssh --no-p --chmod=F600 --chown=<owner> \
    "$base_pki/private/<folder>/rsa/<service>_rsa.key" \
    "$cible":"$base_service/keys/"
rsync -e ssh --no-p --chmod=F644 --chown=<owner> \
    "$base_pki/public/<folder>/rsa/<service>_rsa.crt" \
    "$cible":"$base_service/cert/"

# Si ECDSA aussi — ajouter
rsync -e ssh --no-p --chmod=F600 --chown=<owner> \
    "$base_pki/private/<folder>/ecdsa/<service>_ecdsa.key" \
    "$cible":"$base_service/keys/"
rsync -e ssh --no-p --chmod=F644 --chown=<owner> \
    "$base_pki/public/<folder>/ecdsa/<service>_ecdsa.crt" \
    "$cible":"$base_service/cert/"
```

-6.5. Ne pas oublier de redémarrer le service manuellement après le prochain renouvellement
```
sudo systemctl restart <service>
```
---

## ✅ Vérification

```
# Vérifier le certificat
openssl x509 -in /etc/<service>/ssl/cert/<service>_rsa.crt -noout -text \
    | grep -E "Subject|Issuer|Not After"

# Vérifier la chaîne de confiance
openssl verify \
    -CAfile /etc/<service>/ssl/ca/Sednal_Root_All.crt \
    /etc/<service>/ssl/cert/<service>_rsa.crt

# Vérifier le service
sudo systemctl status <service>
```
