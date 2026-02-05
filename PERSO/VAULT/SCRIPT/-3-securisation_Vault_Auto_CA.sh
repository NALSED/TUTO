#!/bin/bash

# === Vault_Auto + CA ===

- Vault_Auto.crt
sudo chmod 644 /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.crt
sudo chown vault:vault /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.crt

- Vault_Auto.csr 
sudo chmod 644 /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr
sudo chown vault:vault /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr

- Vault_Auto.key - Corriger (déjà dans private/)
sudo chmod 640 /etc/Vault/Vault_Auto/Cert/private/Vault_Auto.key
sudo chown vault:vault /etc/Vault/Vault_Auto/Cert/private/Vault_Auto.key

- CA.key
sudo chmod 600 /etc/Vault/CA_Vault/Cert/private/CA.key
sudo chown vault:vault /etc/Vault/CA_Vault/Cert/private/CA.key

- CA.crt
sudo chmod 644 /etc/Vault/CA_Vault/Cert/public/CA.crt
sudo chown vault:vault /etc/Vault/CA_Vault/Cert/public/CA.crt

- CA.srl 
sudo chmod 644 /etc/Vault/CA_Vault/Cert/public/CA.srl
sudo chown vault:vault /etc/Vault/CA_Vault/Cert/public/CA.srl
