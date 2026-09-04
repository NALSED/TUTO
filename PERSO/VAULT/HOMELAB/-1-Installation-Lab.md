# Lab pour Vault V2 et Installation

---

## **SOMMAIRE**

- 1 `Lab`

- 2 `Installation Vault`

- 3 `Initialisation Vault`

---
---

### 🥼 -1- `Lab` 🥼

- Vault PKI sera installé sur une VM dédié, via VirtualBox sur l'hôte 192.168.0.235.

**=== Vault ===**

- Nom : `Vault-PKI`
- OS : `RHEL10`
- IP : `192.168.0.238`
- RAM : `10Go`
- CPU : `4 core`
- Disk : `50Go`
- System logger à RedHat

---
---

### 💾 -2- `Installation Vault` 💾

[SOURCE](https://developer.hashicorp.com/vault/install#linux)

- 2.1 `Installation `dépendances`
````
sudo yum install -y yum-utils
````

- 2.2 Ajout `Repo` Vault
````
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
````

- 2.3 Installation `Vault`
````
sudo yum -y install vault
````

---
--- 

### ⚙️ -3- Initialisation Vault  ⚙️


- 3.1 ` Certificats SSL pour Vault`

- Création dossier
````
sudo mkdir -p /opt/vault/tls /opt/vault/data
````

- Création certificats
````
sudo openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
  -keyout /opt/vault/tls/vault.key \
  -out    /opt/vault/tls/vault.crt \
  -subj "/CN=vault.sednal.lan" \
  -addext "subjectAltName=DNS:vault.sednal.lan,IP:192.168.0.238,IP:127.0.0.1" \
  -addext "keyUsage=critical,digitalSignature,keyEncipherment" \
  -addext "extendedKeyUsage=serverAuth"
````

- Droits et SElinux
````
sudo chown -R vault:vault /opt/vault
sudo chmod 700 /opt/vault/data
sudo chmod 640 /opt/vault/tls/vault.key
sudo chmod 644 /opt/vault/tls/vault.crt
sudo restorecon -Rv /opt/vault
````

- 3.2 `Editer fichier de configuration Vault`
````
sudo vim /etc/vault.d/vault.hcl
````

- Éditer
````
ui            = true
disable_mlock = true

storage "raft" {
  path    = "/opt/vault/data"
  node_id = "vault-1"
}

listener "tcp" {
  address         = "0.0.0.0:8100"
  tls_disable     = false
  tls_cert_file   = "/opt/vault/tls/vault.crt"
  tls_key_file    = "/opt/vault/tls/vault.key"
  tls_min_version = "tls12"
}

api_addr     = "https://vault.sednal.lan:8100"
cluster_addr = "https://vault.sednal.lan:8101"
````

- 3.3 `Firewall et Service`
````
sudo firewall-cmd --permanent --add-port=8100/tcp --add-port=8101/tcp
sudo firewall-cmd --reload
sudo systemctl enable --now vault
````

- `3.4 Certificat lisible par l'utilisateur courant`

`[NOTE]`

`/opt/vault/tls` est en 700 vault:vault : le client Vault lancé en utilisateur normal
ne peut pas lire le certificat. Passer par `sudo` ne fonctionne pas non plus,
les variables d'environnement étant perdues.

````
sudo mkdir -p /etc/ssl/nalsed
sudo install -m 644 /opt/vault/tls/vault.crt /etc/ssl/nalsed/vault-bootstrap.crt
````


- `3.5 Initialisation`
````
export VAULT_ADDR=https://vault.sednal.lan:8100
export VAULT_CACERT=/etc/ssl/nalsed/vault-bootstrap.crt
vault operator init
vault operator unseal # 3 fois
vault login
````

`[NOTE]`

Inscrire les variable `VAULT_ADDR` et `VAULT_CACERT` à .bashrc pour le pas avoir à les retaper à chaque connexion.

- Éditer
````
sudo vim $HOME/.bashrc
````

- Inscrire
````
export VAULT_ADDR=https://vault.sednal.lan:8100
export VAULT_CACERT=/etc/ssl/nalsed/vault-bootstrap.crt
```` 

- Raffréchir
````
source ~/.bashrc
````
