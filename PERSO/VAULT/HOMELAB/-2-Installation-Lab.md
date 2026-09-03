# Lab pour Vault V2 et Installation

---

## **SOMMAIRE**

- 1 `Lab`

- 2 `Installation Vault`

- 3 ``

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

### 💾 -2- `Installation Vault` 💾

[SOURCE](https://developer.hashicorp.com/vault/install#linux)

- Installation `dépendances`
````
sudo yum install -y yum-utils
````

- Ajout `Repo` Vault
````
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
````

- Installation `Vault`
````
sudo yum -y install vault
````





