#!/bin/bash



# Vault_Root.crt

sudo chmod 644 /etc/Vault/Vault_Root/Cert/public/Vault_Root.crt
sudo chown vault:vault /etc/Vault/Vault_Root/Cert/public/Vault_Root.crt


# Vault_Root.csr

sudo chmod 644 /etc/Vault/Vault_Root/Cert/public/Vault_Root.csr
sudo chown vault:vault /etc/Vault/Vault_Root/Cert/public/Vault_Root.csr


# Vault_Root.key 

sudo chmod 640 /etc/Vault/Vault_Root/Cert/private/Vault_Root.key
sudo chown vault:vault /etc/Vault/Vault_Root/Cert/private/Vault_Root.key


