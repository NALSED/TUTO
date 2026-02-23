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

-1.3. Sur le serveur web, avec apache2 créer le fichier de endpoint.
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
sudo a2ensite pki-crl.conf
```

-1.5. Désactiver la page par défaut
```
sudo a2dissite 000-default.conf
```

-1.6. Redémarrer le service Apache2
```
sudo systemctl reload apache2
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
# Pousser le CRL vers serveur Apache2 (192.168.0.239)
0 11 * * * /usr/local/bin/push-crl.sh
```

---

### 3️⃣ SSH

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

### 4️⃣ Groupe et User

-4.1 Pour Bareos 192.168.0.240, les certificats sont utilisés par => `bareos:bareos`, mais l'utilisateur commun a besoin de pouvoir accéder à ces fichiers. PostgreSQL nécessite également l'accès au groupe bareos pour lire sa clé privée.
```
sudo usermod -aG bareos sednal
sudo usermod -aG bareos postgres
```

---

### 5️⃣ Création de répertoire avec Script

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
