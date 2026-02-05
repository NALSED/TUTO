#!/bin/bash

# ===== Vault_Auto + CA =====

# === CA ===
sudo mkdir -p /etc/Vault/CA_Vault/Cert/{public,private}
sudo mkdir /etc/Vault/CA_Vault/Config

#droits
chmod 775 /etc/Vault
chmod 775 /etc/Vault/CA_Vault
chmod 775 /etc/Vault/CA_Vault/Cert
chmod 775 /etc/Vault/CA_Vault/Cert/public
chmod 770 /etc/Vault/CA_Vault/Cert/private

# propriété
chown vault:vault /etc/Vault
chown vault:vault /etc/Vault/CA_Vault
chown vault:vault /etc/Vault/CA_Vault/Cert
chown vault:vault /etc/Vault/CA_Vault/Cert/public
chown vault:vault /etc/Vault/CA_Vault/Cert/private

# Héritage
chmod g+s /etc/Vault/CA_Vault/Cert/public
chmod g+s /etc/Vault/CA_Vault/Cert/private


# === Vault_Auto ===

sudo mkdir -p /etc/Vault/Vault_Auto/Cert/{public,private}
sudo mkdir /etc/Vault/Vault_Auto/Config

#droits
chmod 775 /etc/Vault
chmod 775 /etc/Vault/Vault_Auto
chmod 775 /etc/Vault/Vault_Auto/Cert
chmod 775 /etc/Vault/Vault_Auto/Cert/public
chmod 770 /etc/Vault/Vault_Auto/Cert/private

# propriété
chown vault:vault /etc/Vault
chown vault:vault /etc/Vault/Vault_Auto
chown vault:vault /etc/Vault/Vault_Auto/Cert
chown vault:vault /etc/Vault/Vault_Auto/Cert/public
chown vault:vault /etc/Vault/Vault_Auto/Cert/private

# Héritage
chmod g+s /etc/Vault/Vault_Auto/Cert/public
chmod g+s /etc/Vault/Vault_Auto/Cert/private
