# Mise en place de l'Auto-unseal pour Vault.

---

## Installation compléte et configuration démarrage de Vault via Auto-unseal
---

---
## === SCHEMA ===

# Vault Auto-Unseal — Architecture

```
     === 192.168.0.241 ===                              === 192.168.0.235 ===
┌─────────────────────────────┐                    ┌─────────────────────────────┐
│          VAULT A            │                    │          VAULT B            │
│         Vault_Auto          │                    │         Vault_root          │
│                             │                    │                             │
│       Key Provider          │                    |        Auto-Unseal          │ 
│                             │                    │                             │
│  Port   : 8100              │   1 encrypt ───>   │  Port   : 8200              │
│  Storage: raft              │   2 decrypt <───   │  Storage: raft              │
│  Transit: activé            │                    │  Seal   : transit → Vault A │
│  Unseal : manuel            │                    │  Token  : env var           │
│  Dispo : 24/24              │                    │  Unseal : automatique       │
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
#### 1.2) Pouvoir faire tourner Vault A 24h/24h ici => raspbery-pi 192.168.0.241
#### 1.3) kleopatra (chiffrement GPG)
#### 1.4) DNS Resolver, Ici Pfsense.
#### 1.5) optionelle : VSC pour créer les Docker compose et autre fichier de documentation.

             === PATH 192.168.0.241:8100===
            /home/sednal/Vault/
             |
             ├── CA_Vault/
             |   |
             |   ├── Cert/
             |   |   ├── public/
             |   |   |       └── CA.crt
             |   |   |
             |   |   └── private/
             │   |       └── CA.key   
             |   | 
             |   └── Config/
             |       └── CA_Vault.cnf
             | 
             ├── Vault_Root/       
             |   |              
             |   ├── Cert/
             |   |   ├── public/
             |   |   |   ├── CA.crt
             |   |   |   └── Vault_Root.crt
             |   |   |
             |   |   └── private/
             │   |       └── Vault_Root.key    
             |   | 
             |   └── Config/
             |       └── Vault_Root.cnf         
             |
             └── Vault_Auto/   
                 | 
                 ├── data/
                 |
                 ├── Cert/
                 |   ├── public/
                 |   |   ├── CA.crt                
                 |   |   └── Vault_Auto.crt
                 |   |
                 |   └── private/
                 │       └── Vault_Auto.key
                 |
                 └── Config/
                         ├── Vault_Auto.hcl   
                         └── Vault_Auto.cnf


<details>
<summary>
<h2>
Script Dossier 
</h2>
</summary>

          #!/bin/bash
          
          # CA
          mkdir -p /home/sednal/Vault/CA_Vault/Cert public private
          mkdir /home/sednal/Vault/CA_Vault/Config
          
          #Vault_Root
          mkdir -p /home/sednal/Vault/Vault_Root/Cert public private
          mkdir /home/sednal/Vault/Vault_Root/Config
          
          #Vault_Auto
          mkdir -p /home/sednal/Vault/Vaukt_Auto/Cert public private
          mkdir /home/sednal/Vault/Vault_Root/Config

</details>


---

            === PATH 192.168.0.235:8200===
            C:\Users\sednal\vault\
            |
            ├──docker-compose.yml
            | 
            ├── certs\
            |   ├── CA.crt
            |   ├── Vault_Root.crt
            │   └── Vault_Root.key
            |
            └── config\
                └── Vault.hcl
                 

            === WSL ===
            /mnt/c/Users/sednal/DOCKER/Vault
            | 
            ├── docker-compose.yml
            ├── certs\
            |   ├── CA.crt
            |   ├── Vault_Root.crt
            │   └── Vault_Root.key
            |
            └── config\
                └── Vault.hcl

---
---

## 2️⃣ Déclarer FQDN dans Pfsense
ServicesDNS => ResolverGeneral => Settings => Host Overrides

<img width="1149" height="72" alt="image" src="https://github.com/user-attachments/assets/90c43b89-ce69-486f-a474-e0444ddc6ec8" />


---
---

## 3️⃣ Création du certificat SSL de Vault + Renouvellement

### 3.1) Les fichiers de configuration certificat

=== Vault_Root === 

      nano /home/sednal/Vault/Vault_Root/Config/Vault_Root.cnf
      
        [ req ]
        default_bits       = 4096
        prompt             = no
        default_md         = sha256
        req_extensions     = req_ext
        distinguished_name = dn
        
        [ dn ]
        CN = vault.sednal.lan
        
        [ req_ext ]
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

## Section [dn]
- **CN = vault.sednal.lan** → Common Name (nom du serveur)

## Section [req_ext]
- **subjectAltName = @alt_names** → Noms alternatifs pour le certificat
- **keyUsage = critical, digitalSignature, keyEncipherment**
  - `critical` → Extension obligatoire
  - `digitalSignature` → Peut signer (authentification TLS)
  - `keyEncipherment` → Peut chiffrer des clés (sessions HTTPS)
- **extendedKeyUsage = serverAuth** → Usage : serveur web/API uniquement
- **basicConstraints = critical, CA:FALSE** → N'est PAS une autorité de certification


</details>


=== Vault_Auto ===

        nano /home/sednal/Vault/Vault_Auto/Config/Vault_Auto.cnf

        [ req ]
        default_bits       = 4096
        prompt             = no
        default_md         = sha256
        req_extensions     = req_ext
        distinguished_name = dn
        
        [ dn ]
        CN = vault_2.sednal.lan
        
        [ req_ext ]
        subjectAltName = @alt_names
        keyUsage = critical, digitalSignature, keyEncipherment
        extendedKeyUsage = serverAuth
        basicConstraints = critical, CA:FALSE
        
        [ alt_names ]
        DNS.1 = vault_2.sednal.lan
        DNS.2 = localhost 


=== CA ===

        nano /home/sednal/Vault/CA_Vault/Config/CA_Vault.cnf
 
        [ req ]
        default_bits       = 4096
        prompt             = no
        default_md         = sha256
        distinguished_name = dn
        x509_extensions    = v3_ca
        
        [ dn ]
        CN = Sednal-CA
        
        [ v3_ca ]
        basicConstraints = critical, CA:TRUE
        keyUsage = critical, keyCertSign, cRLSign
        subjectKeyIdentifier = hash

---

### 3.2) Création CA

- Dans Génération  /home/sednal/Vault/CA.key et CA.crt  => Pour plus de claretée et copier le certificat après.
          openssl req -x509 -newkey rsa:4096 -keyout CA.key -out CA.crt -days 3650 -nodes -config /home/sednal/Vault/CA_Vault/Config/CA_Vault.cnf

<img width="450" height="41" alt="image" src="https://github.com/user-attachments/assets/1f1b545a-6378-4ee5-919a-408e367cb539" />

- Copier les certificat dans les dossiers :

      cp CA.crt /home/sednal/Vault/Vault_Root/Cert/public/
      cp CA.crt /home/sednal/Vault/Vault_Auto/Cert/public/
      mv CA.crt /home/sednal/Vault/CA_Vault/Cert/public/
      mv CA.key /home/sednal/Vault/CA_Vault/Cert/private

---

### 3.3) Création CSR + Certificats + cles => Vault_Root et Vault_Auto

`=== Vault_Root ===`

- Clé + CSR
    
          openssl req -newkey rsa:4096 -keyout /home/sednal/Vault/Vault_Root/Cert/private/Vault_Root.key -out /home/sednal/Vault/Vault_Root/Cert/private/Vault.csr -nodes -config /home/sednal/Vault/Vault_Root/Config/Vault_Root.cnf


- Certificat signé par CA

          openssl x509 -req -in /home/sednal/Vault/Vault_Root/Cert/private/Vault.csr -CA /home/sednal/Vault/Vault_Root/Cert/public/CA.crt -CAkey /home/sednal/Vault/CA_Vault/Cert/private/CA.key -CAcreateserial -out /home/sednal/Vault/Vault_Root/Cert/public/Vault_Root.crt -days 365 -extfile /home/sednal/Vault/Vault_Root/Config/Vault_Root.cnf -extensions req_ext


<details>
<summary>
<h2>
=== Détails Commandes ===
</h2>
</summary>

          openssl req -newkey rsa:4096 -keyout [KEY .key] -out vault_a.csr -nodes -config [CONFIGURATION-SERVICE .cnf]
          openssl x509 -req -in [CSR-SERVICE] -CA [CERTIF CA .crt] -CAkey   [KEY CA .key] -CAcreateserial -out  [CERTIF-SIGNE-SERVICE] -days 3650 -extfile [CONFIGURATION-SERVICE .cnf] -extensions req_ext


</details>


`=== Vault_Auto ===`

- Clé + CSR

          openssl req -newkey rsa:4096 -keyout /home/sednal/Vault/Vault_Auto/Cert/private/Vault_Auto.key -out /home/sednal/Vault/Vault_Auto/Cert/private/Vault_Auto.csr -nodes -passout pass: -config /home/sednal/Vault/Vault_Auto/Config/Vault_Auto.cnf


- Certificat signé par CA


          openssl x509 -req -in /home/sednal/Vault/Vault_Auto/Cert/private/Vaul_Auto.csr -CA /home/sednal/Vault/Vault_Auto/Cert/public/CA.crt -CAkey /home/sednal/Vault/CA_Vault/Cert/private/CA.key -CAcreateserial -out /home/sednal/Vault/Vault_Auto/Cert/public/Vault_Auto.crt -days 365 -extfile /home/sednal/Vault/Vault_Auto/Config/Vault_Auto.cnf -extensions req_ext

### === Sécuriser ===

          rm -f /home/sednal/Vault/Vault_Root/Cert/private/Vault.csr
          rm -f /home/sednal/Vault/Vault_Auto/Cert/private/Vault_Auto.csr

### 3.4) Création d'un renouvelement automatique via script + systemd

#### Script qui créé une clé et un certificat puis les copie dans le bon dossier sur Win 11

`EDITION`
      
       sudo nano /home/sednal/Vault/Script/renew_vault_ssl.sh

`SCRIPT`      
      
      #!/bin/bash
      set -e   # Arrête le script immédiatement si une commande échoue

      # === Vault_Root ===
      rm -f /home/sednal/Vault/Vault_Root/Cert/public/Vault_Root.crt 
      rm -f /home/sednal/Vault/Vault_Root/Cert/private/Vault_Root.key
      
      # === Vault_Auto ===
      rm -f /home/sednal/Vault/Vault_Auto/Cert/public/Vault_Auto.crt
      rm -f /home/sednal/Vault/Vault_Auto/Cert/private/Vault_Auto.key
      
      # Génération certificat

      # === Vault_Root ===
      # - Clé + CSR
    
     openssl req -newkey rsa:4096 -keyout /home/sednal/Vault/Vault_Root/Cert/private/Vault_Root.key -out /home/sednal/Vault/Vault_Root/Cert/private/Vault.csr -nodes -config /home/sednal/Vault/Vault_Root/Config/Vault_Root.cnf

     # === Vault_Root ===
     # - Certificat signé par CA
     openssl x509 -req -in /home/sednal/Vault/Vault_Root/Cert/private/Vault.csr -CA /home/sednal/Vault/Vault_Root/Cert/public/CA.crt -CAkey /home/sednal/Vault/CA_Vault/Cert/private/CA.key -CAcreateserial -out /home/sednal/Vault/Vault_Root/Cert/public/Vault_Root.crt -days 365 -extfile /home/sednal/Vault/Vault_Root/Config/Vault_Root.cnf -extensions req_ext

     # === Vault_Auto ===
     # - Clé + CSR

     openssl req -newkey rsa:4096 -keyout /home/sednal/Vault/Vault_Auto/Cert/private/Vault_Auto.key -out /home/sednal/Vault/Vault_Auto/Cert/private/Vault_Auto.csr -nodes -passout pass: -config /home/sednal/Vault/Vault_Auto/Config/Vault_Auto.cnf

    # === Vault_Auto ===
    # - Certificat signé par CA

     openssl x509 -req -in /home/sednal/Vault/Vault_Auto/Cert/private/Vault_Auto.csr -CA /home/sednal/Vault/Vault_Auto/Cert/public/CA.crt -CAkey /home/sednal/Vault/CA_Vault/Cert/private/CA.key -CAcreateserial -out /home/sednal/Vault/Vault_Auto/Cert/public/Vault_Auto.crt -days 365 -extfile /home/sednal/Vault/Vault_Auto/Config/Vault_Auto.cnf -extensions req_ext

       rm -f /home/sednal/Vault/Vault_Root/Cert/private/Vault.csr
       rm -f /home/sednal/Vault/Vault_Auto/Cert/private/Vault_Auto.csr
      # Supprime les fichiers sur Win 11
      # === Vault_Root ===
      ssh sednal@192.168.0.235 "del C:\Users\Sednal\DOCKER\Vault\Vault_Root\Cert\Vault_Root.crt"
      ssh sednal@192.168.0.235 "del C:\Users\Sednal\DOCKER\Vault\Vault_Root\Cert\Vault_Root.key"

      
      # Après suppression, copie des fichiers
      # === Vault_Root ===
      scp /home/sednal/Vault/Vault_Root/Cert/public/Vault_Root.crt sednal@192.168.0.235:DOCKER/Vault/Vault_Root/Cert
      scp /home/sednal/Vault/Vault_Root/Cert/private/Vault_Root.key sednal@192.168.0.235:DOCKER/Vault/Vault_Root/Cert



`EXECUTION`     
      
      sudo chmod +x /home/sednal/Vault/Script/renew_vault_ssl.sh
      
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


<img width="1263" height="561" alt="image" src="https://github.com/user-attachments/assets/d952d25a-bf5f-440d-81d0-2718adcc5266" />


---

## 4️⃣ Installation et configuration de Vault sur 192.168.0.241 et 192.168.0.235


- 192.168.0.241 => Installation Vault ARM64
- 192.168.0.235 => Docker-compose.yml

---

### 4.1) Installation Vault ARM6

`=== Vault_Auto ===`

- 1. `Installation`
          wget https://releases.hashicorp.com/vault/1.15.5/vault_1.15.5_linux_arm64.zip
          unzip vault_1.15.5_linux_arm64.zip
          sudo mv vault /usr/local/bin/
          vault --version

<img width="773" height="40" alt="image" src="https://github.com/user-attachments/assets/365638d0-1e46-4f63-a7c2-c0adf317a724" />

- 2. `Créer l'utilisateur vault`

          sudo useradd --system --home /etc/vault --shell /bin/false vault

-3. Editer le fichier de configuation `/home/sednal/Vault_Auto/Config/Vault_Auto.hcl`

          nano /home/sednal/Vault_Auto/Config/Vault_Auto.hcl

- Editer

          disable_mlock = true
          ui = true
          
          storage "raft" {
            path    = "/opt/vault/data"
            node_id = "vault_auto"
          }
          
          listener "tcp" {
            address            = "0.0.0.0:8100"
            tls_disable        = false
            tls_cert_file      = "/home/sednal/Vault/Vault_Auto/Cert/public/Vault_Auto.crt"
            tls_key_file       = "/home/sednal/Vault/Vault_Auto/Cert/private/Vault_Auto.key"
            tls_client_ca_file = "/home/sednal/Vault/Vault_Auto/Cert/public/CA.crt"
          }
          
          api_addr     = "https://vault.sednal.lan:8100"
          cluster_addr = "https://vault.sednal.lan:8101"

- 4. `Créer les répertoires et permissions`

          sudo mkdir -p /opt/vault/data
          sudo chown -R vault:vault /opt/vault
          sudo chown -R vault:vault /home/sednal/Vault/Vault_Auto/Cert
          sudo chown -R vault:vault /home/sednal/Vault/Vault_Auto/Config
          sudo chown -R vault:vault /home/sednal/Vault/Vault_Auto/data

- 5. `Service`

          sudo nano /etc/systemd/system/vault.service

- Editer

          [Unit]
          Description=HashiCorp Vault - Vault Auto
          After=network-online.target
          
          [Service]
          User=vault
          ExecStart=/usr/local/bin/vault server -config=/etc/vault/vault_auto.hcl
          ExecReload=/bin/kill --signal HUP $MAINPID
          KillMode=process
          Restart=on-failure
          LimitNOFILE=65536
          
          [Install]
          WantedBy=multi-user.target

- Autoriser et demarrer le service

          sudo systemctl daemon-reload
          sudo systemctl enable vault
          sudo systemctl start vault
          sudo systemctl status vault


<img width="1168" height="380" alt="image" src="https://github.com/user-attachments/assets/53fb6064-b6d3-42f7-a319-4fac4ccd3000" />

### 4.2)  configuration de Vault










- Initialisation Vault
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




















### 4.3) Fichier de configuration 

[DOC](https://ambar-thecloudgarage.medium.com/hashicorp-vault-with-docker-compose-0ea2ce1ca5ab)

`=== Vault_Root ===`

Ici dans vsc edition de C:\Users\sednal\DOCKER\Vault\Vault_root\config\vault.hcl
### Docker-compose.yml

[DOC](https://ambar-thecloudgarage.medium.com/hashicorp-vault-with-docker-compose-0ea2ce1ca5ab) // [GITHUB-OFFICIEL](https://github.com/hashicorp/vault-action/blob/main/docker-compose.yml)

`=== Vault_Root ===`

Ici dans vsc edition de C:\Users\sednal\DOCKER\Vault\Vault_Root\Config\docker-compose.yml

            version: "3.8"
            services:
                vault-tls:
                    image: hashicorp/vault:latest
                    cap_add:
                      - IPC_LOCK 
                    hostname: vault
                    container_name: vault_root
                    environment:
                      VAULT_ADDR: "https://vault.sednal.lan:8200"
                      VAULT_API_ADDR: "https://vault.sednal.lan:8200"
                      VAULT_TOKEN_TRANSIT: ""
                    ports:
                      - 8200:8200
                    restart: always  
                    volumes:
                      - C:\Users\sednal\DOCKER\Vault\Vault_Root\Cert:/vault/cert:ro
                      - C:\Users\sednal\DOCKER\Vault\Vault_Root\Config:/vault/config:ro
                      - C:\Users\sednal\DOCKER\Vault\Vault_Root\data:/vault/data:rw
                    command: server








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

<img width="1062" height="293" alt="image" src="https://github.com/user-attachments/assets/63650e5c-ef03-4233-b6c9-04e3012b137e" />




















      
