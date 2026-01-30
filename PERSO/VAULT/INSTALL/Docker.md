# Installation compléte et configuration de Vault 


## 1️⃣ Prérequis
#### 1.1) openssl ici => raspbery-pi 192.168.0.241
#### 1.2) kleopatra (chiffrement GPG)
#### 1.3) DNS Resolver, Ici Pfsense.
#### 1.4) optionelle : VSC pour créer les Docker compose et autre fichier de documentation.

            === PATH 192.168.0.235===
            C:\Users\sednal\vault\
            ├── docker-compose.yml  
            ├── certs\
            |   ├── vault.crt
            │   └── vault.key
            └── config\
                └── vault.hcl

            === PATH 192.168.0.241 ===
            /home/sednal/cert_vault
              |   ├── vault_ssl.cnf
              |   ├── vault.crt
              │   └── vault.key
              └── script
                  └── renew_vault_ssl.sh

---
---

## 2️⃣ Déclarer FQDN dans Pfsense
ServicesDNS => ResolverGeneral => Settings => Host Overrides

<img width="1156" height="46" alt="image" src="https://github.com/user-attachments/assets/d7de9cd3-8beb-4521-b15f-35d4e2d01145" />

---
---

## 3️⃣ Création du certificat SSL de Vault + Renouvellement

#### 3.1) Fichier de configuration certificat


      [ req ]
      default_bits       = 4096
      prompt             = no
      default_md         = sha256
      req_extensions     = req_ext
      distinguished_name = dn
      x509_extensions    = v3_ext 
      
      [ dn ]
      CN = vault.sednal.lan
      
      [ req_ext ]
      subjectAltName = @alt_names
      keyUsage = critical, digitalSignature, keyEncipherment
      extendedKeyUsage = serverAuth
      
      [ v3_ext ]
      subjectAltName = @alt_names
      keyUsage = critical, digitalSignature, keyEncipherment
      extendedKeyUsage = serverAuth
      basicConstraints = critical, CA:FALSE
      
      [ alt_names ]
      DNS.1 = vault.sednal.lan
      DNS.2 = localhost         

Ici utilisation uniquement du DNS.1, car Vault sera dans un conteneur cela évite les probléme si l'IP change.

<details>
<summary>
<h2>
 EXPLICATION FICHIER DE CONFIGURATION 
</h2>
</summary>

## Section [req]
- **default_bits = 4096** → Taille de la clé RSA (sécurité renforcée)
- **prompt = no** → Pas de questions interactives (mode automatique)
- **default_md = sha256** → Algorithme de hachage (SHA-256)
- **req_extensions = req_ext** → Extensions pour la demande CSR
- **distinguished_name = dn** → Référence vers les infos d'identité
- **x509_extensions = v3_ext** → Extensions pour le certificat final

## Section [dn]
- **CN = vault.sednal.lan** → Common Name (nom du serveur)

## Section [req_ext]
- **subjectAltName = @alt_names** → Noms alternatifs pour le certificat

## Section [v3_ext]
- **subjectAltName = @alt_names** → Noms alternatifs (DNS + IP autorisés)
- **keyUsage = critical, digitalSignature, keyEncipherment**
  - `critical` → Extension obligatoire
  - `digitalSignature` → Peut signer (authentification TLS)
  - `keyEncipherment` → Peut chiffrer des clés (sessions HTTPS)
- **extendedKeyUsage = serverAuth** → Usage : serveur web/API uniquement
- **basicConstraints = critical, CA:FALSE** → N'est PAS une autorité de certification


</details>

---

#### 3.2) Création de la clé privée

Génération de la clé privé
      openssl genrsa -out C:\Users\sednal\DOCKER\Vault\vault.key

**Remarque** pas de fichier csr, car certificat auto-signé.

---

#### 3.3) création certificat auto-signé + vérification
      openssl req -x509 -new -nodes -key /home/sednal/vault.key -out /home/sednal/vault.crt -days 365 -config /home/sednal/vault_ssl.cnf
      openssl x509 -in /home/sednal/vault.crt -text -noout

Sortie :
                  
                  Certificate:
                Data:
                    Version: 3 (0x2)
                    Serial Number:
                        2c:76:68:8f:3c:ed:5d:0b:ce:6f:21:6a:36:d6:8b:96:91:e3:3a:11
                    Signature Algorithm: sha256WithRSAEncryption
                    Issuer: CN = vault.sednal.lan
                    Validity
                        Not Before: Jan 30 16:35:12 2026 GMT
                        Not After : Jan 30 16:35:12 2027 GMT
                    Subject: CN = vault.sednal.lan
                    Subject Public Key Info:
                        Public Key Algorithm: rsaEncryption
                        [...]
                    Exponent: 65537 (0x10001)
                    X509v3 extensions:
                        X509v3 Subject Alternative Name:
                            DNS:vault.sednal.lan, DNS:localhost
                        X509v3 Key Usage: critical
                            Digital Signature, Key Encipherment
                        X509v3 Extended Key Usage:
                            TLS Web Server Authentication
                        X509v3 Basic Constraints: critical
                            CA:FALSE
                Signature Algorithm: sha256WithRSAEncryptio
                      [...]

#### Droits des fichiers :
Dans l'idéal si tout se passé sur linux il faudrait réaliser le changement des droit et propriétaire
mais ici avec transfert sur windows inutil.

- vault_ssl.cnf => 640 et root : vault (Root modifie, vault lit, config protégée)
- vault.key => 600 et vault : vault (Clé privée = vault seul)
- vault.crt => 644 et vault : vault (Certificat public = tous lisent)
          
#### 3.4) Création d'un renouvelement automatique via script + systemd

#### Script qui créé une clé et un certificat puis les copie dans le bon dossier sur Win 11

`EDITION`
      
       sudo nano /home/sednal/cert_vault/script/renew_vault_ssl.sh

`SCRIPT`      
      
      #!/bin/bash
      openssl req -new -x509 -days 365 -key /home/sednal/cert_vault/vault.key -out /home/sednal/cert_vault/vault.crt -config /home/sednal/cert_vault/vault_ssl.cnf
      scp  /home/sednal/cert_vault/vault.crt sednal@192.168.0.235:DOCKER/Vault/cert
      scp  /home/sednal/cert_vault/vault.key sednal@192.168.0.235:DOCKER/Vault/cert

`EXECUTION`     
      sudo chmod +x /home/sednal/cert_vault/script/renew_vault_ssl.sh
      
#### Systemd :

`EDITION`
      
      sudo nano /etc/systemd/system/renew_vault_ssl.service 

`SERVICE`
      
      [Unit]
      Description=Renouvellement cerficats SSL Vault
      After=network.target
      
      [Service]
      Type=oneshot
      ExecStart=/home/sednal/cert_vault/script/renew_vault_ssl.sh
      User=sednal
      Group=sednal
      
      [Install]
      WantedBy=multi-user.target

---

`EDITION`
     
     sudo nano /etc/systemd/system/renew_vault_ssl.timer 

`TIMER` 
      
      [Unit]
      Description=Renouvellement du certificat tous les 330 jours
      Requires=renew_vault_ssl.service
      
      [Timer]
      OnBootSec=5min
      OnUnitActiveSec=330d
      Persistent=true
      
      [Install]
      WantedBy=timers.target

`TEST`  
      
       sudo systemctl daemon-reload 

       # .service
       sudo systemctl enable renew_vault_ssl.service 
       sudo systemctl start renew_vault_ssl.service 

       # .timer
       sudo systemctl enable renew_vault_ssl.timer 
       sudo systemctl start renew_vault_ssl.timer


<img width="1019" height="383" alt="image" src="https://github.com/user-attachments/assets/f731f65c-0495-48e4-90ad-d64d71e95290" />



C:\Users\sednal\vault\
├── docker-compose.yml  
├── certs\
|   ├── vault.crt
│   └── vault.key
└── config\
    └── vault.hcl


















      
