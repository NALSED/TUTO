#!/bin/bash

# ===== Création utilisateur et groupe vault

# Créer le groupe
sudo groupadd vault

# Créer l'utilisateur système
sudo useradd -r -g vault -d /etc/Vault -s /bin/false vault

# Ajouter sednal au groupe
sudo usermod -aG vault sednal


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

# === Script Renouvelement ===

# Création du répertoire
sudo mkdir -p /etc/Vault_Script/Script_Renouvelement

# Permissions
sudo chmod 750 /etc/Vault_Script
sudo chmod 750 /etc/Vault_Script/Script_Renouvelement

# Propriétaire 
sudo chown sednal:vault /etc/Vault_Script
sudo chown sednal:vault /etc/Vault_Script/Script_Renouvelement





