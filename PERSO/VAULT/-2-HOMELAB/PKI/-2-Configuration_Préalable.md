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
Dans cette partie toutes les configurations préalables sur les clients ainsi que sur Vault :

- 1️⃣ Mise en Place d'un point de récupération CRL, pour les clients du réseau sur 192.168.0.239
- 2️⃣ Mise en Place d'une tâche cron pour pousser les CRL de Vault 192.168.0.238 vers le serveur Web 192.168.0.239
- 3️⃣ Les clients de Vault qui vont recevoir les certificats doivent pouvoir être contactés en `ssh` par Vault sans mot de passe.
- 4️⃣ La gestion des groupes et des utilisateurs est faite en amont pour éviter tout oubli.
- 5️⃣ Création des Répertoires Certificats sur le serveur Vault.
- 6️⃣ Mise en place certificats, sur serveur web Bareos. (Apache2)
---

### 1️⃣ Point de récupération CRL (192.168.0.239)

- 1.1. ⚠️ Point très important, le point de distribution `CRL` doit 
toujours être en `HTTP` et non en `HTTPS` pour deux raisons :

  - Si le certificat du serveur qui héberge la CRL est révoqué ou 
    invalide, les clients ne pourront pas télécharger la CRL pour 
    vérifier la révocation.

  - Lors de la validation d'un certificat, le client n'a pas encore 
    établi de contexte TLS valide pour contacter un serveur HTTPS => 
    il ne peut donc pas vérifier la CRL en HTTPS.

-1.2. Création du répertoire et droits 
```
sudo mkdir /var/www/pki/
```

```
sudo chown sednal:sednal /var/www/pki
```

```
sudo chmod 755 /var/www/pki
```

-1.3. Sur le serveur web, avec nginx créer le fichier de endpoint.
- Ici ils couvriront les CRL émises par Vault pour les CA (Root / Intermédiaire) Rsa et Ecdsa.
```
nano /etc/nginx/sites-available/pki-crl.conf
```

`=>` - Éditer
```
# ===== HTTP — CRL =====
server {
    listen 80;
    server_name infra.sednal.lan;

    # === RSA ===
    location /crl/root_r        { alias /var/www/pki/root_r.crl; }
    location /crl/intermediate_r { alias /var/www/pki/intermediate_r.crl; }

    # === ECDSA ===
    location /crl/root_e        { alias /var/www/pki/root_e.crl; }
    location /crl/intermediate_e { alias /var/www/pki/intermediate_e.crl; }
}
# ===== HTTPS =====
server {
    listen 443 ssl;
    server_name infra.sednal.lan;

    # === RSA ===
    ssl_certificate     /etc/infra/ssl/cert/infra_rsa.crt;
    ssl_certificate_key /etc/infra/ssl/keys/infra_rsa.key;
    # === ECDSA ===
    ssl_certificate     /etc/infra/ssl/cert/infra_ecdsa.crt;
    ssl_certificate_key /etc/infra/ssl/keys/infra_ecdsa.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}

```

-1.4. Créer un lien symbolique depuis sites-available vers sites-enabled
```
sudo ln -s /etc/nginx/sites-available/pki-crl.conf /etc/nginx/sites-enabled/
```

-1.5. Désactiver la page par défaut
```
sudo rm /etc/nginx/sites-enabled/default
```

⚠️ `[TEST]` ⚠️



=== RSA ===
```
curl http://infra.sednal.lan/crl/root_r
```

=== ECDSA ===
```
curl http://infra.sednal.lan/crl/root_e
```

<img width="919" height="479" alt="image" src="https://github.com/user-attachments/assets/a037facc-9726-468d-adfa-190e95dfade5" />


---

`[NOTE]` Pour aller plus loin : [OCSP](https://fr.wikipedia.org/wiki/Online_Certificate_Status_Protocol)
Ici on ne met pas cette solution en place car le service OCSP et Vault devraient être disponibles 24/24.

---
---

### 2️⃣ Création d'une tâche cron sur Serveur Vault 192.168.0.238, pour pousser les CRL

⚠️ Avant tout mettre sednal dans le groupe vault
```
sudo /sbin/usermod -aG vault sednal
```

-2.1 Edition du script 
```
sudo nano /usr/local/bin/push-crl.sh
```

`=>` - Éditer Script : [push-crl.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/PKI/push-crl.sh)

- Droits + Execution :
```
sudo chown vault:vault /usr/local/bin/push-crl.sh
```

```
sudo chmod +x /usr/local/bin/push-crl.sh
```

-2.2. Edition du cron 
```
crontab -e
```

`=>` - Éditer 
```
# === Vault PKI ===
# Pousser le CRL vers serveur Nginx (192.168.0.239)
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

-4.1 Pour Bareos 192.168.0.240, les certificats sont utilisés par => `bareos:bareos`, mais l'utilisateur commun a besoin de pouvoir accéder à ces fichiers. PostgreSQL nécessite également l'accès au groupe bareos pour lire sa clé privée.
```
sudo usermod -aG bareos sednal
sudo usermod -aG bareos postgres
```

---

### 5️⃣ Création de répertoire avec Script sur toutes les machines

`-5.1.` Création de Arborécences sur chaque machine :
`=>` - Éditer Script Vault (192.168.0.238) : [deploiement_vault.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/PKI/DEPLOIEMENT_ARBO/%20deploiement_vault.sh)

`=>` - Éditer Script Infra (192.168.0.239) : [deploiement_infra.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/PKI/DEPLOIEMENT_ARBO/deploiement_infra.sh)

`=>` - Éditer Script Bareos (192.168.0.240) : [deploiement_bareos.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/PKI/DEPLOIEMENT_ARBO/deploiement_bareos.sh)

`=>` - Éditer Script DNS (192.168.0.241) : [deploiement_dns.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/PKI/DEPLOIEMENT_ARBO/deploiement_dns.sh)

`=>` - Éditer Script Proxmox (192.168.0.242) : [deploiement_proxmox.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/PKI/DEPLOIEMENT_ARBO/deploiement_proxmox.sh)

`=>` - Éditer Script Vps (176.31.163.227) : [deploiement_vps.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/PKI/DEPLOIEMENT_ARBO/deploiement_vps.sh)

---

`-5.2.` ⚠️ `[TESTER RSYNC]` Depuis Vault = Infra
Tester via le script : [test_rsync.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/PKI/test_rsync.sh)

---

`-5.3.` Suprimmer fichier test sur chaque machine: 

`=== INFRA ===`
```
rm /etc/infra/ssl/ca/test /etc/infra/ssl/cert/test /etc/infra/ssl/keys/test
```

`=== BAREOS ===` 
```
rm /etc/bareos/ssl/ca/test /etc/bareos/ssl/cert/test /etc/bareos/ssl/keys/test
```

`=== DNS ===` 
PIHOLE
```
rm /etc/pihole/ssl/ca/test /etc/pihole/ssl/cert/test /etc/pihole/ssl/keys/test  /etc/cockpit/ssl/ca/test /etc/cockpit/ssl/cert/test /etc/cockpit/ssl/keys/test
```

`=== PROMOX ===` 
```
rm /etc/proxmox/ssl/ca/test /etc/proxmox/ssl/cert/test /etc/proxmox/ssl/keys/test
```

`=== VPS ===` 
```
rm /etc/vps/ssl/ca/test /etc/vps/ssl/cert/test /etc/vps/ssl/keys/test
```

---
---

### 6️⃣ Mise en place certificats, sur serveur web Bareos. (Apache2)

`-6.1.` créez le vhost
````
sudo nano /etc/apache2/sites-available/bareos-webui-ssl.conf
````

`-6.2.` Editer 
````
<IfModule mod_ssl.c>
  <VirtualHost *:443>
    ServerName bareos.sednal.lan

    SSLEngine on
    SSLCertificateFile    /etc/bareos/ssl/certs/bareos.sednal.lan.crt
    SSLCertificateKeyFile /etc/bareos/ssl/private/bareos.sednal.lan.key
    SSLCACertificateFile  /etc/bareos/ssl/ca/Sednal_Root_All.crt

    Include /etc/apache2/conf-enabled/bareos-webui.conf
  </VirtualHost>
</IfModule>
````

`-6.3.` Activer
````
sudo a2ensite bareos-webui-ssl.conf
sudo apache2ctl configtest   # vérifier qu'il n'y a pas d'erreur
sudo systemctl reload apache2
````




