# `Installation standard et Mise en place de l'Auto-unseal.`

---

Ce tutotriel à pour objectif : 

-1. La mise en place de certificat ssl pour que les serveur Vault soit en https,
-2. Le renouvelement automatique de ces certificats via systemd
-3. L'installation standard de vault en version ARM64 et AMD64.
-4. La configuration et la mise en place de l'aut-unseal via transit secret a

---
### 1️⃣ `Infra` [Accés rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/Auto_Unseal_Vault.md#1%EF%B8%8F%E2%83%A3-infra)
### 2️⃣ `Certificats` [Accés rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/Auto_Unseal_Vault.md#2%EF%B8%8F%E2%83%A3-certificats) 
### 3️⃣ `Renouvelement` [Accés rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/Auto_Unseal_Vault.md#3%EF%B8%8F%E2%83%A3-renouvelement)
### 4️⃣ `Installation` [Accés rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/Auto_Unseal_Vault.md#4%EF%B8%8F%E2%83%A3-installation)
### 5️⃣ `Configuration` [Accés rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/Auto_Unseal_Vault.md#5%EF%B8%8F%E2%83%A3-configuration)




---

## 1️⃣ `Infra`


#### 🥼 LAB 🥼

| IP               | Machine        | Détails RAM / CPU                | OS        |
|-----------------|----------------|---------------------------------|-----------|
| 192.168.0.241   | Raspberry Pi 4 | RAM: 1 GB<br>Processeur: ARM Cortex-A72 | Debian 13 |
| 192.168.0.238   | VM (VirtualBox)| RAM: 4 GB<br>Processeur: 2 cœurs     | Debian 13 |

---

### === SCHEMA ===
```
     === 192.168.0.241 ===                              === 192.168.0.238 ===
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

### Ordre de déploiement

```
1) Démarrer Vault A         
2) Init + Unseal Vault A     → vault operator init / unseal
3) Activer Transit sur A     → vault secrets enable transit
4) Créer la clé              → vault write transit/keys/autounseal
5) Créer policy + token      → pour autoriser Vault B
6) Démarrer Vault B          
```

- Prérequis

   -Pouvoir faire tourner Vault A 24h/24h ici => raspbery-pi 192.168.0.241
   - openssl /gnupg / sudo 
   - kleopatra (chiffrement GPG des clé vault)
   - DNS Resolver, Ici Pfsense.

- Optionelle :
   - VSC comme éditeur de texte.
   - ⚠️ Des commandes ssh sont présente,pour créer des connections ssh sans mdp. [VOIR ICI](https://github.com/NALSED/TUTO/blob/main/PERSO/SSH/Multi_OS.md#ubuntu---ubuntu)

---

=== PATH 192.168.0.241:8100===

     /etc/Vault
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
        └── Vault_Auto/   
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


-1. Créer les dossiers via les scripts.

#### [Script déploiement dossier](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/-1-creation_dossier_Vault_Auto_CA.sh) ⬆️


=== PATH 192.168.0.238:8200===

      /etc/Vault
        | 
        └── Vault_Root/       
           |              
           ├── Cert/
           |   ├── public/
           |   |   ├── CA.crt
           |   |   └── Vault_Root.crt
           |   |
           |   └── private/
           |       └── Vault_Root.key    
           | 
           └── Config/
               ├── Vault_Root.hcl 
               └── Vault_Root.cnf  

-1. Créer les dossiers via les scripts.

#### [Script déploiement dossier](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/-2-creation_dossier_Vault_Root.sh) ⬆️


-2. Déclarer `FQDN` dans Pfsense

<img width="1144" height="81" alt="image" src="https://github.com/user-attachments/assets/3124aa98-3ae9-4bec-b408-064408dff0d3" />

`[NOTE]` ici `vault.sednal.lan` = Vault_Root, et `vault.sednal.lan` = Vault_Auto.

---
---

## 2️⃣ `Certificats`

**-1. Création CA et certificat sur 192.168.0.241**

**-2. Création CA et certificat sur 192.168.0.238** 

**-3. Sécurisation fichier**

**-4. Déploiement des certificat avec renouvellement automatique via systemd**


 `Vault_Auto` (192.168.0.241) sera toujours traiter en premier et `Vault_Root` (192.168.0.238) en second pour respecter l'ordre de mise en place de `l'Auto-Unseal`.

---

**-1. Création CA et certificats sur `192.168.0.241:8100`** 

- Fichier de configuration .cnf

`=== CA ===`

       sudo nano /etc/Vault/CA_Vault/Config/CA_Vault.cnf

-Editer
          
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

- Génération du CA

       openssl req -x509 -newkey rsa:4096 -keyout  /etc/Vault/CA_Vault/Cert/private/CA.key -out /etc/Vault/CA_Vault/Cert/public/CA.crt -days 3650 -nodes -config /etc/Vault/CA_Vault/Config/CA_Vault.cnf

---

- Copier les certificat dans les dossiers :

sur 192.168.0.241

       scp /etc/Vault/CA_Vault/Cert/public/CA.crt sednal@192.168.0.238:~/

et sur 192.168.0.238

      sudo mv ~/CA.crt /etc/Vault/Vault_Root/Cert/public/
---

`=== Vault_Auto ===`

=> Fichier de configuration [1]

        sudo nano /etc/Vault/Vault_Auto/Config/Vault_Auto.cnf

-Editer

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
    IP.1 = 192.168.0.241
    IP.2 = 127.0.0.1

`-1. Clé + CSR`

          openssl req -newkey rsa:4096 \
            -keyout /etc/Vault/Vault_Auto/Cert/private/Vault_Auto.key \
            -out /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr \
            -nodes -passout pass: \
            -config /etc/Vault/Vault_Auto/Config/Vault_Auto.cnf

=> Fichier de configuration [2]

       nano /etc/Vault/Vault_Auto/Config/Vault_Auto_ext.cnf

-Editer

          [v3_req]
          subjectAltName     = @alt_names
          basicConstraints   = critical, CA:FALSE
          keyUsage           = critical, digitalSignature, keyEncipherment
          extendedKeyUsage   = serverAuth
          
          [ alt_names ]
          DNS.1 = vault_2.sednal.lan
          DNS.2 = localhost
          IP.1  = 192.168.0.241
          IP.2  = 127.0.0.1


`-2. Certificat signé par CA`

              openssl x509 -req \
            -in /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr \
            -CA /etc/Vault/CA_Vault/Cert/public/CA.crt \
            -CAkey /etc/Vault/CA_Vault/Cert/private/CA.key \
            -CAcreateserial \
            -out /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.crt \
            -days 365 \
            -sha256 \
            -extfile /etc/Vault/Vault_Auto/Config/Vault_Auto_ext.cnf \
            -extensions v3_req

- Suppression CSR (Pour renouvelement)

   sudo rm -f /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr
   
---
        
**-2. Certificat sur `192.168.0.238:8200`** 

`=== Vault_Root ===`

=> Fichier de configuration [1]

   sudo nano /etc/Vault/Vault_Root/Config/Vault_Root.cnf

-Editer

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
    DNS.1 = vault.sednal.lan
    DNS.2 = localhost
    IP.1 = 192.168.0.238
    IP.2 = 127.0.0.1

`-1. Clé + CSR`

          openssl req -newkey rsa:4096 \
            -keyout /etc/Vault/Vault_Root/Cert/private/Vault_Root.key \
            -out /etc/Vault/Vault_Root/Cert/public/Vault_Root.csr \
            -nodes \
            -config /etc/Vault/Vault_Root/Config/Vault_Root.cnf

=> Fichier de configuration [2]

       sudo nano /etc/Vault/Vault_Root/Config/Vault_Root_ext.cnf

-Editer

    [v3_req]
    subjectAltName     = @alt_names
    basicConstraints   = critical, CA:FALSE
    keyUsage           = critical, digitalSignature, keyEncipherment
    extendedKeyUsage   = serverAuth
          
    [ alt_names ]
    DNS.1 = vault.sednal.lan
    DNS.2 = localhost
    IP.1  = 192.168.0.238
    IP.2  = 127.0.0.1

`-2. Certificat signé par CA`

              openssl x509 -req \
            -in /etc/Vault/Vault_Root/Cert/public/Vault_Root.csr \
            -CA /etc/Vault/Vault_Root/Cert/public/CA.crt \
            -CAkey /etc/Vault/Vault_Root/Cert/private/CA.key \
            -CAcreateserial \
            -out /etc/Vault/Vault_Root/Cert/public/Vault_Root.crt \
            -days 365 \
            -sha256 \
            -extfile /etc/Vault/Vault_Root/Config/Vault_Root_ext.cnf \
            -extensions v3_req


- Suppression CSR (Pour renouvelement)

    sudo rm -f /etc/Vault/Vault_Root/Cert/public/Vault_Root.csr

---

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


**-3. Sécuriser => propriété, droits sur les fichiers créés**



- ### `192.168.0.241`


  `=== CA ==`

- CA.key

      sudo chmod 640 /etc/Vault/CA_Vault/Cert/private/CA.key
      sudo chown vault:vault /etc/Vault/CA_Vault/Cert/private/CA.key

- CA.crt

       sudo chmod 644 /etc/Vault/CA_Vault/Cert/public/CA.crt
       sudo chown vault:vault /etc/Vault/CA_Vault/Cert/public/CA.crt

`=== Vault_Auto ===`

- Vault_Auto.crt
  
       sudo chmod 644 /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.crt
       sudo chown vault:vault /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.crt

- Vault_Auto.csr
  
       sudo chmod 644 /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr
       sudo chown vault:vault /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr

- Vault_Auto.key 
  
       sudo chmod 640 /etc/Vault/Vault_Auto/Cert/private/Vault_Auto.key
       sudo chown vault:vault /etc/Vault/Vault_Auto/Cert/private/Vault_Auto.key



[Script](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/-3-securisation_Vault_Auto_CA.sh)

---

- ### `192.168.0.238`

       sudo usermod -aG vault sednal

`=== Vault_Root ===`

- Vault_Root.crt

       sudo chmod 644 /etc/Vault/Vault_Root/Cert/public/Vault_Root.crt
       sudo chown vault:vault /etc/Vault/Vault_Root/Cert/public/Vault_Root.crt


- Vault_Root.csr

       sudo chmod 644 /etc/Vault/Vault_Root/Cert/public/Vault_Root.csr
       sudo chown vault:vault /etc/Vault/Vault_Root/Cert/public/Vault_Root.csr


- Vault_Root.key 

       sudo chmod 640 /etc/Vault/Vault_Root/Cert/private/Vault_Root.key
       sudo chown vault:vault /etc/Vault/Vault_Root/Cert/private/Vault_Root.key

[Script](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/-4-securisation_Vault_Root.sh)


---

## 3️⃣ `Renouvelement` 

       sudo nano /etc/Vault_Script/Script_Renouvelement/renew_vault_ssl.sh

-Editer

 [Script de renouvelement automatique 192.168.0.241](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/-5-renouvelement_Vault_Auto.sh)

[Script de renouvelement automatique 192.168.0.238](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/-6-renouvelement_Vault_root.sh)


- Le rendre exécutable     
      
      sudo chmod +x /etc/Vault_Script/Script_Renouvelement/renew_vault_ssl.sh

- Appliquer les permission

       sudo chown sednal:vault /etc/Vault_Script/Script_Renouvelement/renew_vault_ssl.sh 

      
**Inscription exécution du Script => Systemd :**


-1. `=== SERVICE ===`

      sudo nano /etc/systemd/system/renew_vault_ssl.service 


---

      
    [Unit]
    Description=Renouvellement cerficats SSL Vault
    After=network.target
    RefuseManualStart=yes
    
    [Service]
    Type=oneshot
    ExecStart=/etc/Vault_Script/Script_Renouvelement/renew_vault_ssl.sh
    User=sednal
    Group=vault
    ExecStartPost=-/usr/bin/systemctl restart vault.service
  
    [Install]
    WantedBy=multi-user.target


---

-2. `=== TIMER ===` 
     
     sudo nano /etc/systemd/system/renew_vault_ssl.timer 

---

    [Unit]
    Description=Renouvellement du certificat tous les 330 jours
    Requires=renew_vault_ssl.service
      
    [Timer]
    OnUnitActiveSec=330d
    Persistent=true
      
    [Install]
    WantedBy=timers.target


-3. Démarrage 

  
      
       sudo systemctl daemon-reload 

---

       sudo systemctl enable renew_vault_ssl.timer 
       sudo systemctl start renew_vault_ssl.timer

---

[NOTE] Ici, le service n'est pas actif, car s'il était activé, le script serait exécuté et les certificats seraient renouvelés, ce qui entraînerait des différences entre les deux machines.  
Le service sera déclenché par le timer.

`TEST`

<img width="1002" height="190" alt="image" src="https://github.com/user-attachments/assets/a118d420-3519-4115-aba3-ae3e33a5e4a0" />


## 4️⃣ `Installation` 

-1. Choix d'installation

**- 192.168.0.241 => Installation Vault ARM64**

 **1. Déploiement via** [apt](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/INSTALL/Standard.md#2%EF%B8%8F%E2%83%A3-apt-1) 

`Avantages`
- **Installation facile** : Utilise les commandes classiques de `apt` pour installer Vault rapidement.
- **Dépendances gérées** : `apt` gère les dépendances pour vous, ce qui facilite le processus d'installation.
- **Mises à jour automatiques** : Avec `apt`, Vault peut recevoir des mises à jour de sécurité et des améliorations automatiquement.

`Inconvénients`
- **Version plus ancienne** : Les dépôts officiels peuvent ne pas proposer la dernière version de Vault.
- **Pas de contrôle sur la version** : Vous pouvez être limité à la version stable disponible dans les dépôts, même si une version plus récente est disponible ailleurs.
  
 **2. Déploiement via** [wget](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/INSTALL/Standard.md#1%EF%B8%8F%E2%83%A3-wget-1)

`Avantages`
- **Dernière version** : Vous pouvez télécharger directement la dernière version de Vault depuis le site officiel de HashiCorp, garantissant ainsi que vous avez la version la plus récente.
- **Plus de contrôle** : Vous avez un contrôle total sur la version et la source du binaire.

`Inconvénients`
- **Mises à jour manuelles** : Les mises à jour de Vault doivent être effectuées manuellement (téléchargement et remplacement des binaires).
- **Dépendances manuelles** : Vous devrez peut-être gérer vous-même certaines dépendances (par exemple, l'installation de `unzip` si vous téléchargez un fichier ZIP).
- **Installation plus complexe** : Nécessite de suivre plusieurs étapes pour décompresser le binaire et le déplacer dans un répertoire accessible.


-2. fichier de configuration .hcl

- Pour information, à implémenter durant l'installation

         disable_mlock = true
         ui = true
               
         storage "raft" {
         path    = "/opt/vault/data"
         node_id = "vault_auto"
         }
               
         listener "tcp" {
         address            = "0.0.0.0:8100"
         tls_disable        = false
         tls_cert_file      = "/etc/Vault/Vault_Auto/Cert/public/Vault_Auto.crt"
         tls_key_file       = "/etc/Vault/Vault_Auto/Cert/private/Vault_Auto.key"
         tls_client_ca_file = "/etc/Vault/CA_Vault/Cert/public/CA.crt"
         }
             
         api_addr     = "https://vault_2.sednal.lan:8100"
         cluster_addr = "https://vault_2.sednal.lan:8101"

---


**- 192.168.0.238 => Installation Vault AMD64**


-1. Choix d'installation

 **1. Déploiement via** [apt](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/INSTALL/Standard.md#2%EF%B8%8F%E2%83%A3-apt-1) 

`Avantages`
- **Installation facile** : Utilise les commandes classiques de `apt` pour installer Vault rapidement.
- **Dépendances gérées** : `apt` gère les dépendances pour vous, ce qui facilite le processus d'installation.
- **Mises à jour automatiques** : Avec `apt`, Vault peut recevoir des mises à jour de sécurité et des améliorations automatiquement.

`Inconvénients`
- **Version plus ancienne** : Les dépôts officiels peuvent ne pas proposer la dernière version de Vault.
- **Pas de contrôle sur la version** : Vous pouvez être limité à la version stable disponible dans les dépôts, même si une version plus récente est disponible ailleurs.
  
 **2. Déploiement via** [wget](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/INSTALL/Standard.md#1%EF%B8%8F%E2%83%A3-wget-1)

`Avantages`
- **Dernière version** : Vous pouvez télécharger directement la dernière version de Vault depuis le site officiel de HashiCorp, garantissant ainsi que vous avez la version la plus récente.
- **Plus de contrôle** : Vous avez un contrôle total sur la version et la source du binaire.

`Inconvénients`
- **Mises à jour manuelles** : Les mises à jour de Vault doivent être effectuées manuellement (téléchargement et remplacement des binaires).
- **Dépendances manuelles** : Vous devrez peut-être gérer vous-même certaines dépendances (par exemple, l'installation de `unzip` si vous téléchargez un fichier ZIP).
- **Installation plus complexe** : Nécessite de suivre plusieurs étapes pour décompresser le binaire et le déplacer dans un répertoire accessible.

-2. fichier de configuration .hcl


- Pour information, à implémenter durant l'installation

          disable_mlock = true
          ui = true
          
          storage "raft" {
            path    = "/opt/vault/data"
            node_id = "vault_root"
          }
          
          listener "tcp" {
            address            = "0.0.0.0:8200"
            tls_disable        = false
            tls_cert_file      = "/etc/Vault/Vault_Root/Cert/public/Vault_Root.crt"
            tls_key_file       = "/etc/Vault/Vault_Root/Cert/private/Vault_Root.key"
            tls_client_ca_file = "/etc/Vault/Vault_Root/Cert/public/CA.crt"
          }

          seal "transit" {
            address         = "https://vault_2.sednal.lan:8100"
            token           = "[TOKEN]"
            key_name        = "autounseal"
            mount_path      = "transit/"
            disable_renewal = "false"
            tls_ca_cert     = "/etc/Vault/Vault_Root/Cert/public/CA.crt"
          }

          api_addr     = "https://vault.sednal.lan:8200"
          cluster_addr = "https://vault.sednal.lan:8201"
  
---

## 5️⃣ `Configuration` 

⚠️ ATTENTION bien respecter l'ordre de déploiement ⚠️

**=== 192.168.0.241 ===**

-1. Suite à l'intallation le fichier /etc/vault.d/vault.hcl à été édité pour la configuration de 192.168.0.241.
-2. redemmarage dun service vault, pour prise en compte des changement, inscription des variables d'environement dans  /usr/local/share/ca-certificates/ et ~/.bashrc
-3. Autorisation du transit + création de la politique auto-unseal et token sur 192.168.0.241.

**=== 192.168.0.238 ===**

-1. Suite à l'intallation le fichier /etc/vault.d/vault.hcl à été édité pour la configuration de 192.168.0.238.
-2. Inscription des variables d'environement dans  /usr/local/share/ca-certificates/ et ~/.bashrc
-3. Utiliser les commandes vault pour initialiser le serveur

---

**=== 192.168.0.241 ===**

-1. Redemarrer et tester vault 

     sudo systemctl restart vault.service
     sudo systemctl status vault.service

<img width="800" height="206" alt="image" src="https://github.com/user-attachments/assets/82a854db-1e70-4745-954d-a6a892573d83" />


-2. Pour éviter d'entrer les variables  `export VAULT_CACERT='/etc/Vault/CA_Vault/Cert/public/CA.crt'` et `export VAULT_ADDR='https://vault_2.sednal.lan:8100'` à chaque connection.

`=== VAULT_CACERT ===`

- Copier le certificat dans l'emplacement standard et recommandé

          sudo cp /etc/Vault/CA_Vault/Cert/public/CA.crt /usr/local/share/ca-certificates/Sednal-CA.crt

- Rafraîchir

          sudo update-ca-certificates --fresh

`=== VAULT_ADDR ===`

- Ouvrir le fichier de configuration bash

     nano ~/.bashrc

- A la fin ajouter
     
      # === Variables Vault ===
      export VAULT_ADDR='https://vault_2.sednal.lan:8100'

- Rafraîchir

      source ~/.bashrc


---

-3. Initialiser Vault

      vault operator init

⚠️ ATTENTION ⚠️ les unseal keys et root token n'appraitrons q'une seul fois, penser à les sauvegarder.
Ici chiffré avec Kleopatra, et stocker sur VPS et disque externe.

-4. Entrer les commande suivante 3 fois
            
            vault operator unseal

- Jusqu'à obtenir :

<img width="552" height="399" alt="image" src="https://github.com/user-attachments/assets/a966c5ea-7b28-4396-b365-8af6027926c9" />


-5. Se loger

     vault login

- Entrer le root token

-Sortie      

<img width="687" height="252" alt="image" src="https://github.com/user-attachments/assets/bcd8e46c-5739-4881-8632-4b472f1390e6" />

- 6 Configuration Auto-Unseal

- Activer Transit
      
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
        
        vault token create -policy=autounseal

---


**=== 192.168.0.238 ===**


-1. Editer le fichier de configuration ci dessus ⬆️

-2. -2. Pour éviter d'entrer les variables  `export VAULT_CACERT='/etc/Vault/Vault_Root/Cert/public/CA.crt'` et `export VAULT_ADDR='https://vault.sednal.lan:8200'` à chaque connection.

`=== VAULT_CACERT ===`

- Copier le certificat dans l'emplacement standard et recommandé

          sudo cp /etc/Vault/Vault_Root/Cert/public/CA.crt /usr/local/share/ca-certificates/Sednal-CA.crt

- Rafraîchir

          sudo update-ca-certificates --fresh


`=== VAULT_ADDR ===`

- Ouvrir le fichier de configuration bash

     nano ~/.bashrc

- A la fin ajouter
     
      # === Variables Vault ===
      export VAULT_ADDR='https://vault.sednal.lan:8200'

- Rafraîchir

      source ~/.bashrc


-3. initialiser Vault

       vault operator init

⚠️ ATTENTION ⚠️ les unseal keys et root token n'appraitrons q'une seul fois, penser à les sauvegarder.

- Juste après initialisation

<img width="569" height="404" alt="image" src="https://github.com/user-attachments/assets/687a75f7-552b-4d69-8cbc-2d7653201d49" />


-4. Login
      
       vault login


<img width="696" height="330" alt="image" src="https://github.com/user-attachments/assets/2eb05ce2-3276-4ea9-ae39-520d45eaa9fc" />



:sparkler: 




