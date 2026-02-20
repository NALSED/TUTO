# Configuration Préalable

---


`[RAPPEL]`

- **Vault PKI** : 192.168.0.238
- **Serveur Web / Infra** : 192.168.0.239
- **Serveur Bareos** : 192.168.0.240
- **DNS** : 192.168.0.241
- **Proxmox** : 192.168.0.242
- **Vps** : 176.31.163.227


---
Dans cette partie toutes les configuration préalable sur les client ainsi que sur Vault:

- 1️⃣ Mise en Place d'un point de récupération CRL, pour les clients du réseaux su 192.168.0.239
- 2️⃣ Mise en Place d'une tache cron pour pousser les CRL de Vault 192.168.0.238 vers le serveur Web 192.168.0.239
- 3️⃣ Les clients de Vault qui vont recevoir les certificats doivent pouvoir être contactés en `ssh` par Vault sans mot de passe.  
- 4️⃣ La gestion des groupes et des utilisateurs est faite en amont pour éviter tout oubli.

---

### 1️⃣ Point de récupération CRL (192.168.0.239)

- 1.1. ⚠️ Point très important, le point de distribution `CRL` doit 
toujours être en `HTTP` et non en `HTTPS` pour deux raisons :

  - Si le certificat du serveur qui héberge la CRL est révoqué ou 
    invalide, les clients ne pourront pas télécharger la CRL pour 
    vérifier la révocation → paradoxe impossible à résoudre

  - Lors de la validation d'un certificat, le client n'a pas encore 
    établi de contexte TLS valide pour contacter un serveur HTTPS → 
    il ne peut donc pas vérifier la CRL en HTTPS

-1.2. Création du répertoire
```
mkdir /var/www/pki/
```

-1.3. Sur le serveur web, avec apache 2 créer le fichier de endpoint.
- Ici ils couvriront les CRL émises par Vault pour les CA (Root / Intermédiaire) Rsa et Ecdsa.
```
nano /etc/apache2/sites-available/pki-crl.conf
```

`=>` - Éditer
```
<VirtualHost *:80>
    ServerName infra.sednal.lan

    AddType application/pkix-crl .crl

    # === RSA ===
    Alias /crl/root_r /var/www/pki/root_r.crl
    Alias /crl/intermediate_r /var/www/pki/intermediate_r.crl

    # === ECDSA ===
    Alias /crl/root_e /var/www/pki/root_e.crl
    Alias /crl/intermediate_e /var/www/pki/intermediate_e.crl

    <Directory /var/www/pki>
        Options -Indexes
        Require all granted
    </Directory>

</VirtualHost>
```

-1.4. Créer un lien symbolique depuis sites-available vers sites-enabled
```
a2ensite pki-crl.conf
```

-1.5. Redémarrer le service Apache2
```
systemctl reload apache2
```


`[NOTE]` Pour allez plus loin [OCSP](https://fr.wikipedia.org/wiki/Online_Certificate_Status_Protocol)
Ici on ne met pas cette solution en place car le service OCSP et Vault devaient être dispo 24/24.

---

### 2️⃣ Création d'une tâche cron sur Serveur Vault 192.168.0.238, pour pousser les CRL

-2.1 Edition du script 
```
nano /usr/local/bin/push-crl.sh
```

`=>` - Éditer
```
curl -s https://vault.sednal.lan:8200/v1/PKI_Sednal_Root_RSA/crl \
    -o /tmp/root_r.crl
curl -s https://vault.sednal.lan:8200/v1/PKI_Sednal_Root_ECDSA/crl \
    -o /tmp/root_e.crl
curl -s https://vault.sednal.lan:8200/v1/PKI_Sednal_Inter_RSA/crl \
    -o /tmp/intermediate_r.crl
curl -s https://vault.sednal.lan:8200/v1/PKI_Sednal_Inter_ECDSA/crl \
    -o /tmp/intermediate_e.crl

scp /tmp/root_r.crl /tmp/root_e.crl \
    /tmp/intermediate_r.crl /tmp/intermediate_e.crl \
    sednal@pihole.sednal.lan:/var/www/pki/
```


-2.2. Edition du cron 
```
crontab-e
```

`=>` - Éditer 
```
0 11 * * * /usr/local/bin/push-crl.sh
```

---

### 3️⃣ SSH

-3.1. Créer la clé 
```
ssh-keygen -t ed25519 -C "vault-admin"
```

-3.2. Copier la clé publique vers chaque machine cible
```
ssh-copy-id sednal@192.168.0.239
ssh-copy-id sednal@192.168.0.240
ssh-copy-id sednal@192.168.0.241
ssh-copy-id sednal@192.168.0.242
ssh-copy-id debian@176.31.163.227
```

---

### 4️⃣ Groupe et User

-4.1 Pour Bareos, les certificats sont utilisés, par => `bareos:bareos`, mais l'utilisateur commun à besoin de pouvoir accéder à ces fichiers.
```
sudo usermod -aG bareos sednal
```










