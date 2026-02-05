#!/bin/bash

# === Vault_Root ===

sudo mkdir -p /etc/Vault/Vault_Root/Cert/{public,private}
sudo mkdir /etc/Vault/Vault_Root/Config


#droits
chmod 775 /etc/Vault
chmod 775 /etc/Vault/Vault_Root
chmod 775 /etc/Vault/Vault_Root/Cert
chmod 775 /etc/Vault/Vault_Root/Cert/public
chmod 770 /etc/Vault/Vault_Root/Cert/private

# propriété
chown vault:vault /etc/Vault
chown vault:vault /etc/Vault/Vault_Root
chown vault:vault /etc/Vault/Vault_Root/Cert
chown vault:vault /etc/Vault/Vault_Root/Cert/public
chown vault:vault /etc/Vau

# Héritage
chmod g+s /etc/Vault/Vault_Root/Cert/public
chmod g+s /etc/Vault/Vault_Root/Cert/private

# === Script Renouvelement ===

# Création du répertoire
sudo mkdir -p /etc/Vault_Script/Script_Renouvelement

# Permissions
sudo chmod 750 /etc/Vault_Script
sudo chmod 750 /etc/Vault_Script/Script_Renouvelement

# Propriétaire 
sudo chown sednal:vault /etc/Vault_Script
sudo chown sednal:vault /etc/Vault_Script/Script_Renouvelement
