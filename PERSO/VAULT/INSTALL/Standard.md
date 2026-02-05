# `Installation Standard d'un serveur Vault`

### **1. Via wget**
### **2.Via apt**

---

## 1️⃣ `WGET` 
## 2️⃣ `APT`

---

### Comparaison : `apt` vs `wget`

| Fonction        | `wget`                       | `apt`                                  |
|-----------------|------------------------------|---------------------------------------|
| **Téléchargement**  | ✅ Télécharge un fichier depuis une URL | ✅ Télécharge un paquet depuis un dépôt |
| **Installation**    | ❌ Non, à faire manuellement | ✅ Automatique avec toutes les dépendances |
| **Dépendances**     | ❌ Non, il faut les gérer soi-même | ✅ Oui, gérées automatiquement          |
| **Mises à jour**    | ❌ Non                       | ✅ Oui, via `apt upgrade`               |
| **Architecture**    | ❌ Manuelle                  | ✅ Détectée et adaptée automatiquement  |
| **Usage typique**   | Télécharger des fichiers ou binaires spécifiques | Installer et maintenir des logiciels facilement |

**Résumé rapide :**  
- `wget` = juste pour **télécharger**.  
- `apt` = **télécharger, installer et mettre à jour** des logiciels avec gestion automatique des dépendances.


---

## 1️⃣ `WGET` 


### 4.1) Installation Vault ARM64

-1. `Installation`
         
          wget https://releases.hashicorp.com/vault/1.15.5/vault_1.15.5_linux_arm64.zip
          unzip vault_1.15.5_linux_arm64.zip
          sudo mv vault /usr/local/bin/
          vault --version

<img width="773" height="40" alt="image" src="https://github.com/user-attachments/assets/365638d0-1e46-4f63-a7c2-c0adf317a724" />

-2. `Créer l'utilisateur vault`

          sudo useradd --system --home /etc/vault --shell /bin/false vault

-3. Editer le fichier de configuation `/etc/Vault/Vault_Auto/Config/Vault_Auto.hcl`

          nano /etc/Vault/Vault_Auto/Config/Vault_Auto.hcl

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
            tls_cert_file      = [PATH = .crt]
            tls_key_file       = [PATH = .key]
            tls_client_ca_file = "[PATH = .crt]
          }
          
          api_addr     = "https://vault.sednal.lan:8100"
          cluster_addr = "https://vault.sednal.lan:8101"

-4. `Créer les répertoires et permissions`

          sudo mkdir -p /opt/vault/data
          sudo chown -R vault:vault /opt/vault
          sudo chown -R vault:vault /home/sednal/Vault/Vault_Auto/Cert
          sudo chown -R vault:vault /home/sednal/Vault/Vault_Auto/Config


-5. `Service`

          sudo nano /etc/systemd/system/vault.service

- Editer

          [Unit]
          Description=HashiCorp Vault - Vault Auto
          After=network-online.target
          
          [Service]
          User=vault
          ExecStart=/usr/local/bin/vault server -config=/etc/vault/Vault_Auto.hcl
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







---
 
## 2️⃣ `APT`

    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install vault



- Edition fichier .hcl
    sudo /etc/vault.d/vault.hcl


-congiguration mini sans certificat ssl

          disable_mlock = true
          ui = true
          
          storage "raft" {
            path    = "/opt/vault/data"
            node_id = "vault_auto"
          }
        
          api_addr     = "https://vault.sednal.lan:8100"
          cluster_addr = "https://vault.sednal.lan:8101"


  
- configuration mini avec configuration ssl ([création certificat](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/Auto_Unseal_Vault.md#2%EF%B8%8F%E2%83%A3-certificats) )

    
          disable_mlock = true
          ui = true
          
          storage "raft" {
            path    = "/opt/vault/data"
            node_id = "vault_auto"
          }
          
          listener "tcp" {
            address            = "0.0.0.0:8100"
            tls_disable        = false
            tls_cert_file      = [PATH = .crt]
            tls_key_file       = [PATH = .key]
            tls_client_ca_file = "[PATH = .crt]
          }
          
          api_addr     = "[ADDRESS]:8101" # exemple https://vault.sednal.lan:8101 ou 192.168.0.241:8101
          cluster_addr = "[ADDRESS]:8101"



---


