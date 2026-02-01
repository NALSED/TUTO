# Mise en place de l'Auto-unseal pour Vault.

---

## Installation compléte et configuration démarrage de Vault via Auto-unseal
---

---
## === SCHEMA ===

# Vault Auto-Unseal — Architecture

```
┌─────────────────────────────┐                    ┌─────────────────────────────┐
│          VAULT A            │                    │          VAULT B            │
│      Vault_auto_unseal      │                    │        Vault_root           │
│                             │                    │                             │
│  🔑 Key Provider            │                    │  🔐 Auto-Unseal             │
│                             │                    │                             │
│  Port   : 8100              │   1 encrypt ───>   │  Port   : 8200              │
│  Storage: raft              │   2 decrypt <───   │  Storage: raft              │
│  Transit: activé            │                    │  Seal   : transit → Vault A │
│  Unseal : manuel            │                    │  Token  : env var           │
│                             │                    │  Unseal : automatique       │
└─────────────────────────────┘                    └─────────────────────────────┘
        ↑                                                      ↑
        │                                                      │
  Unsealed en premier                              Se unseal automatiquement
  (vault operator init/unseal)                     via Vault A à chaque redémarrage
```

## Ordre de déploiement

```
1) Démarrer Vault A          → docker compose up -d
2) Init + Unseal Vault A     → vault operator init / unseal
3) Activer Transit sur A     → vault secrets enable transit
4) Créer la clé              → vault write transit/keys/autounseal
5) Créer policy + token      → pour autoriser Vault B
6) Démarrer Vault B          → docker compose up -d (avec le token)
```


---
---

## 1️⃣ Prérequis
#### 1.1) openssl ici => raspbery-pi 192.168.0.241
#### 1.2) kleopatra (chiffrement GPG)
#### 1.3) DNS Resolver, Ici Pfsense.
#### 1.4) optionelle : VSC pour créer les Docker compose et autre fichier de documentation.

             === PATH 192.168.0.235:8100===
            C:\Users\sednal\vault\vault
            | 
            ├── certs\
            |   ├── vault.crt
            │   └── vault.key
            └── config\
                ├── vault.hcl
                └── docker-compose.yml 

            === PATH 192.168.0.235:8200===
            C:\Users\sednal\vault\
            | 
            ├── certs\
            |   ├── vault.crt
            │   └── vault.key
            └── config\
                ├── vault.hcl
                └── docker-compose.yml 

            === PATH 192.168.0.241 ===
            /home/sednal/cert_vault
              |   | 
              |   ├── vault_ssl.cnf
              |   ├── vault.crt
              │   └── vault.key
              └── script
                  └── renew_vault_ssl.sh

            === WSL ===
            /mnt/c/Users/sednal/DOCKER/Vault
            | 
            ├── certs\
            |   ├── vault.crt
            │   └── vault.key
            └── config\
                ├── vault.hcl
                └── docker-compose.yml


---
---

## 2️⃣ Déclarer FQDN dans Pfsense
ServicesDNS => ResolverGeneral => Settings => Host Overrides

<img width="1156" height="46" alt="image" src="https://github.com/user-attachments/assets/d7de9cd3-8beb-4521-b15f-35d4e2d01145" />

---
---

## 3️⃣ Création du certificat SSL de Vault + Renouvellement

### 3.1) Fichier de configuration certificat

# Editer dans /home/sednal/cert_vault/vault_root et /home/sednal/cert_vault/vault_auto_unseal
      
      nano /home/sednal/cert_vault/vault_root/vault_root.cnf
      nano /home/sednal/cert_vault/vault_auto_unseal/vault_ssl_au.cnf

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

### 3.2) Création de la clé privée

Génération des clées privées

`root`
      openssl genrsa -out /home/sednal/cert_vault/vault_root/vault_root.key

`auto-seal`
      openssl genrsa -out /home/sednal/cert_vault/vault_auto_unseal/vault_ssl_au.key

**Remarque** pas de fichier csr, car certificat auto-signé.

---

### 3.3) création certificat auto-signé + vérification

`root`     
     
      openssl req -x509 -new -nodes -key /home/sednal/cert_vault/vault_root/vault_root.key -out /home/sednal/cert_vault/vault_root/vault_root.crt -days 365 -config /home/sednal/cert_vault/vault_root/vault_root.cnf

`auto-seal` 
      
      openssl req -x509 -new -nodes -key /home/sednal/cert_vault/vault_auto_unseal/vault_ssl_au.key -out /home/sednal/cert_vault/vault_auto_unseal/vault_ssl_au.crt -days 365 -config /home/sednal/cert_vault/vault_auto_unseal/vault_ssl_au.cnf
            
`test`            
      
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
Dans l'idéal, si tout se passait sur Linux, il faudrait réaliser le changement des droits et des propriétaires, mais ici, avec un transfert sur Windows, c'est inutile.

- vault_ssl.cnf => 640 et root : vault (Root modifie, vault lit, config protégée)
- vault.key => 600 et vault : vault (Clé privée = vault seul)
- vault.crt => 644 et vault : vault (Certificat public = tous lisent)
          
### 3.4) Création d'un renouvelement automatique via script + systemd

#### Script qui créé une clé et un certificat puis les copie dans le bon dossier sur Win 11

`EDITION`
      
       sudo nano /home/sednal/cert_vault/script/renew_vault_ssl.sh

`SCRIPT`      
      
      #!/bin/bash

      # Root
      rm  /home/sednal/cert_vault/vault_root/*.crt 
      rm  /home/sednal/cert_vault/vault_root/*.key
      
      # Auto-unseal
      rm  /home/sednal/cert_vault/vault_auto_unseal/*.crt 
      rm  /home/sednal/cert_vault/vault_auto_unseal/*.key
      
      #Génération clées
      # Root
      openssl genrsa -out /home/sednal/cert_vault/vault_root/vault_root.key
      # Auto-unseal
      openssl genrsa -out /home/sednal/cert_vault/vault_auto_unseal/vault_ssl_au.key
      
      #Génération certificacts
      # Root
      openssl req -x509 -new -nodes -key /home/sednal/cert_vault/vault_root/vault_root.key -out /home/sednal/cert_vault/vault_root/vault_root.crt -days 365 -config /home/sednal/cert_vault/vault_root/vault_root.cnf
      # Auto-unseal
      openssl req -x509 -new -nodes -key /home/sednal/cert_vault/vault_auto_unseal/vault_ssl_au.key -out /home/sednal/cert_vault/vault_auto_unseal/vault_ssl_au.crt -days 365 -config /home/sednal/cert_vault/vault_auto_unseal/vault_ssl_au.cnf
      
      # Supprime les fichiers sur Win 11
      # Root
      ssh sednal@192.168.0.235 "del C:\Users\Sednal\DOCKER\Vault\Vault_root\cert\vault_root.crt"
      ssh sednal@192.168.0.235 "del C:\Users\Sednal\DOCKER\Vault\Vault_root\cert\vault_root.key"
      # Auto-unseal 
      ssh sednal@192.168.0.235 "del C:\Users\Sednal\DOCKER\Vault\Vault_auto_unseal\cert\vault_ssl_au.crt"
      ssh sednal@192.168.0.235 "del C:\Users\Sednal\DOCKER\Vault\Vault_auto_unseal\cert\vault_ssl_au.key"
      
      # Après suppression, copie des fichiers
      # Root
      scp  /home/sednal/cert_vault/vault_root/vault_root.crt sednal@192.168.0.235:DOCKER/Vault/Vault_root/cert
      scp  /home/sednal/cert_vault/vault_root/vault_root.key sednal@192.168.0.235:DOCKER/Vault/Vault_root/cert
      # Auto-unseal 
      scp  /home/sednal/cert_vault/vault_auto_unseal/vault_ssl_au.crt sednal@192.168.0.235:DOCKER/Vault/Vault_auto_unseal/cert
      scp  /home/sednal/cert_vault/vault_auto_unseal/vault_ssl_au.key sednal@192.168.0.235:DOCKER/Vault/Vault_auto_unseal/cert


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

---

## 4️⃣ Docker-compose et fichier de configuration vault

### 4.1) Docker-compose.yml

[DOC](https://ambar-thecloudgarage.medium.com/hashicorp-vault-with-docker-compose-0ea2ce1ca5ab) // [GITHUB-OFFICIEL](https://github.com/hashicorp/vault-action/blob/main/docker-compose.yml)

`=== Vault_Root ===`

Ici dans vsc edition de C:\Users\sednal\DOCKER\Vault\Vault_root\config\docker-compose.yml

            version: "3.8"
            services:
                vault-tls:
                    image: hashicorp/vault:latest
                    cap_add:
                      - IPC_LOCK 
                    hostname: vault
                    container_name: vault_container
                    environment:
                      VAULT_ADDR: "https://vault.sednal.lan:8200"
                      VAULT_API_ADDR: "https://vault.sednal.lan:8200"
                      VAULT_CACERT: "/vault/cert/vault.crt"
                    ports:
                      - 8200:8200
                    restart: always  
                    volumes:
                      - C:\Users\sednal\DOCKER\Vault\cert:/vault/cert:ro
                      - C:\Users\sednal\DOCKER\Vault\config:/vault/config:ro
                      - C:\Users\sednal\DOCKER\Vault\data:/vault/data:rw
                    command: server


 
 
Cette ligne est primordial :

            VAULT_CACERT: "/vault/cert/vault.crt""

Car certificat autosigné, et Vault ne le validera pas sinon.

---

`=== Vault_Auto_Unseal ===`

Ici dans vsc edition de C:\Users\sednal\DOCKER\Vault\Vault_auto_unseal\config\docker-compose.yml

      version: "3.8"
      services:
          vault-tls:
              image: hashicorp/vault:latest
              cap_add:
                - IPC_LOCK 
              hostname: vault
              container_name: vault_auto
              environment:
                VAULT_ADDR: "https://vault.sednal.lan:8100"
                VAULT_API_ADDR: "https://vault.sednal.lan:8100"
                VAULT_CACERT: "/vault/cert/vault_ssl_au.crt"
              ports:
                - 8100:8100
              restart: always  
              volumes:
                - C:\Users\sednal\DOCKER\Vault\Vault_auto_unseal\cert:/vault/cert:ro
                - C:\Users\sednal\DOCKER\Vault\Vault_auto_unseal\config:/vault/config:ro
                - C:\Users\sednal\DOCKER\Vault\Vault_auto_unseal\data:/vault/data:rw
              command: server

 
Cette ligne est primordial :

            VAULT_CACERT: "/vault/cert/vault_ssl_au.crt""

Car certificat autosigné, et Vault ne le validera pas sinon.


### 4.2) Fichier de configuration 

[DOC](https://ambar-thecloudgarage.medium.com/hashicorp-vault-with-docker-compose-0ea2ce1ca5ab)

`=== Vault_Root ===`

Ici dans vsc edition de C:\Users\sednal\DOCKER\Vault\Vault_root\config\vault.hcl







---

`=== Vault_Auto_Unseal ===`

Ici dans vsc edition de C:\Users\sednal\DOCKER\Vault\Vault_auto_unseal\config\vault.hcl    

      disable_mlock = true
      ui = true
      
      
      storage "raft" {
        path    = "/vault/data"
        node_id = "vault_auto_unseal"
      }
      
      listener "tcp" {
        address = "0.0.0.0:8100"
        tls_disable = "false"
        tls_cert_file = "/vault/cert/vault_ssl_au.crt"
        tls_key_file  = "/vault/cert/vault_ssl_au.key"
        tls_client_ca_file = "/vault/cert/vault_ssl_au.crt"
      }
      
      api_addr     = "https://vault.sednal.lan:8100"
      cluster_addr = "https://vault.sednal.lan:8101"

Cette ligne est primordial :

            tls_client_ca_file = "/vault/cert/vault.crt"

Car certificat autosigné, et Vault ne le validera pas sinon.


### 4.3) Création du 1er conteneur Vault 
- Créer en premier le Vault_auto_unseal           
          docker compose up -d

<img width="325" height="60" alt="image" src="https://github.com/user-attachments/assets/3c2adf55-ce24-4b59-a4d5-587c871ff157" />


- Vérification Réussite :

        docker logs vault_auto

Sortie attendue

<img width="1164" height="541" alt="image" src="https://github.com/user-attachments/assets/69790a7a-21fe-4970-9a7e-286716057fcd" />



- Initialisation Vault

        docker exec -it vault_auto /bin/sh
        vault operator init


⚠️ ATTENTION ⚠️ les unseal keys et root token n'appraitrons q'une seul fois, penser à les sauvegarder.
Ici chiffré avec Kleopatra, et stocker sur VPS et disque externe.

            / # vault operator init
            Unseal Key 1: [...]
            Unseal Key 2: [...]
            Unseal Key 3: [...]
            Unseal Key 4: [...]
            Unseal Key 5: [...]
            
            Initial Root Token:  [...]
            
            Vault initialized with 5 key shares and a key threshold of 3. Please securely
            distribute the key shares printed above. When the Vault is re-sealed,
            restarted, or stopped, you must supply at least 3 of these keys to unseal it
            before it can start servicing requests.
            
            Vault does not store the generated root key. Without at least 3 keys to
            reconstruct the root key, Vault will remain permanently sealed!
            
            It is possible to generate new unseal keys, provided you have a quorum of
            existing unseal keys shares. See "vault operator rekey" for more information.


- Entrer les commande suivante 3 fois
            
            vault operator unseal

- Jusqu'à obtenir :

<img width="555" height="367" alt="image" src="https://github.com/user-attachments/assets/3556cbfb-5537-46e5-ba38-40ed35069cf5" />


### 4.4) Récupération Token pour Vault_root

-Activer Transit
      
        vault secrets enable transit

Sortie attendue

<img width="519" height="38" alt="image" src="https://github.com/user-attachments/assets/b5e2b308-99fa-49e8-af61-8527be2e17bd" />


-Créer la clé
        
        vault write -force transit/keys/autounseal 

Sortie attendue

<img width="486" height="382" alt="image" src="https://github.com/user-attachments/assets/5b6927b2-b223-44ae-9ffd-0bc6e7647d32" />


-Créer la policy
       
        vault policy write autounseal -<<EOF
        path "transit/encrypt/autounseal" {
           capabilities = [ "update" ]
        }
        
        path "transit/decrypt/autounseal" {
           capabilities = [ "update" ]
        }
        EOF


Sortie attendue

<img width="381" height="193" alt="image" src="https://github.com/user-attachments/assets/440a58e0-a491-424f-8144-65a17a5aae64" />


-Créer le token limité
        
        vault token create -policy=vault-b-policy -no-parent


Sortie attendue

























      
