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

---

### 1️⃣ Point de récupération CRL sur `Infra` (192.168.0.239)

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
sudo nano /etc/nginx/sites-available/infra.sednal.lan.conf
```

`=>` - Éditer
```
# ===== HTTP — CRL =====
server {
    listen 80;
    server_name infra.sednal.lan;

    types {
        application/pkix-crl crl;
    }

    location /crl/ {
        alias /var/www/pki/;
        autoindex off;

        location /crl/root_r         { alias /var/www/pki/root_r.crl; }
        location /crl/intermediate_r { alias /var/www/pki/intermediate_r.crl; }
        location /crl/root_e         { alias /var/www/pki/root_e.crl; }
        location /crl/intermediate_e { alias /var/www/pki/intermediate_e.crl; }
    }
}

# ===== HTTPS =====
server {
    listen 443 ssl;
    server_name infra.sednal.lan;

    # RSA
    ssl_certificate     /etc/infra/Cert/infra_rsa_full.crt;
    ssl_certificate_key /etc/infra/Keys/infra_rsa.key;

    # ECDSA
    ssl_certificate     /etc/infra/Cert/infra_ecdsa_full.crt;
    ssl_certificate_key /etc/infra/Keys/infra_ecdsa.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

-1.4. Activer le site et désactiver le défaut :
```
sudo ln -s /etc/nginx/sites-available/infra.sednal.lan.conf /etc/nginx/sites-enabled/

```

```
sudo rm -f /etc/nginx/sites-enabled/default
```

```
sudo nginx -t
```

-1.6. Redémarrer le service nginx
```
sudo systemctl restart nginx
```

⚠️ `[TEST]` ⚠️

-Pour vérifier que tout est Ok, création d'un fichier `test_rsa` et `test_ecdsa` et utilisation de curl.

=== RSA ===
```
nano /var/www/pki/root_r.crl
```

- Editer
```
test_RSA
```

=== ECDSA ===
```
nano /var/www/pki/root_e.crl
```

- Editer
```
test_ECDSA
```

- curl rsa
```
curl http://infra.sednal.lan/crl/root_r
```

- curl ecdsa
```
curl http://infra.sednal.lan/crl/root_e
```

- Pour finir
```
sudo rm /var/www/pki/root_e.crl && sudo rm /var/www/pki/root_r.crl
```

---

`[NOTE]` Pour aller plus loin : [OCSP](https://fr.wikipedia.org/wiki/Online_Certificate_Status_Protocol)
Ici on ne met pas cette solution en place car le service OCSP et Vault devraient être disponibles 24/24.

---
---

### 2️⃣ Création d'une tâche cron sur `Serveur Vault` 192.168.0.238, pour pousser les CRL

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
# Pousser le CRL vers serveur Apache2 (192.168.0.239)
0 11 * * * /usr/local/bin/push-crl.sh
```

---

### 3️⃣ SSH sur `Serveur Vault` 192.168.0.238

-3.1. Créer la clé 
```
ssh-keygen -t ed25519 -C "vault-admin"
```

-3.2. Copier la clé publique vers chaque machine cible
=IP=
```
ssh-copy-id sednal@192.168.0.239
ssh-copy-id sednal@192.168.0.240
ssh-copy-id sednal@192.168.0.241
ssh-copy-id root@192.168.0.242
ssh-copy-id debian@176.31.163.227
```

=DOMAIN=
```
ssh-copy-id sednal@infra.sednal.lan
ssh-copy-id sednal@bareos.sednal.lan
ssh-copy-id sednal@pihole.sednal.lan
ssh-copy-id root@proxmox.sednal.lan
ssh-copy-id debian@176.31.163.227
```

---

### 4️⃣ Groupe et User su `Bareos` 192.168.0.240

-4.1 Pour Bareos 192.168.0.240, les certificats sont utilisés par => `bareos:bareos`, mais l'utilisateur commun a besoin de pouvoir accéder à ces fichiers. PostgreSQL nécessite également l'accès au groupe bareos pour lire sa clé privée.
```
sudo usermod -aG bareos sednal
sudo usermod -aG bareos postgres
```

---

### 5️⃣ Création de répertoire avec Script sur `serveur Vault` 192.168.0.238

-5.1. Créer script 
```
nano /home/sednal/deploiement_vault.sh
```

```
chmod +x /home/sednal/deploiement_vault.sh
```

```
sudo chown sednal:sednal deploiement_vault.sh
```

```
sudo ./deploiement_vault.sh
```

`=>` - Éditer Script : [deploiement_vault.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/PKI/deploiement_vault.sh)


`[VERIFICATION]`

- Avec tree

```
sednal@vault:/etc/Vault$ sudo tree PKI
PKI
├── Cert_CA
│   ├── CSR
│   ├── Inter
│   └── Root
├── Config
│   └── Policy
├── private
│   ├── Bareos
│   │   ├── Ecdsa
│   │   └── Rsa
│   ├── Cockpit
│   │   ├── Ecdsa
│   │   └── Rsa
│   ├── Infra
│   │   ├── Ecdsa
│   │   └── Rsa
│   ├── Pihole
│   │   ├── Ecdsa
│   │   └── Rsa
│   ├── PostGreSQL
│   │   ├── Ecdsa
│   │   └── Rsa
│   ├── Proxmox
│   │   ├── Ecdsa
│   │   └── Rsa
│   ├── Upsnap
│   │   ├── Ecdsa
│   │   └── Rsa
│   └── Vps
│       ├── Ecdsa
│       └── Rsa
└── public
    ├── Bareos
    │   ├── Ecdsa
    │   └── Rsa
    ├── Cockpit
    │   ├── Ecdsa
    │   └── Rsa
    ├── Infra
    │   ├── Ecdsa
    │   └── Rsa
    ├── Pihole
    │   ├── Ecdsa
    │   └── Rsa
    ├── PostGreSQL
    │   ├── Ecdsa
    │   └── Rsa
    ├── Proxmox
    │   ├── Ecdsa
    │   └── Rsa
    ├── Upsnap
    │   ├── Ecdsa
    │   └── Rsa
    └── Vps
        ├── Ecdsa
        └── Rsa

57 directories, 0 files
```
