#!/bin/bash
set -e  # Arrête si une commande échoue

# ===== Création utilisateur et groupe vault =====
# Créer le groupe (ignorer si existe déjà)
sudo groupadd vault 2>/dev/null || true

# Créer l'utilisateur système (ignorer si existe déjà)
sudo useradd -r -g vault -d /etc/Vault -s /bin/false vault 2>/dev/null || true

# Ajouter sednal au groupe
sudo usermod -aG vault sednal

# ===== Vault_Auto + CA =====

# === CA ===
sudo mkdir -p /etc/Vault/CA_Vault/Cert/{public,private}
sudo mkdir -p /etc/Vault/CA_Vault/Config

# Droits
sudo chmod 775 /etc/Vault
sudo chmod 775 /etc/Vault/CA_Vault
sudo chmod 775 /etc/Vault/CA_Vault/Cert
sudo chmod 775 /etc/Vault/CA_Vault/Cert/public
sudo chmod 770 /etc/Vault/CA_Vault/Cert/private
sudo chmod 775 /etc/Vault/CA_Vault/Config

# Propriété
sudo chown -R vault:vault /etc/Vault/CA_Vault

# Héritage (setgid)
sudo chmod g+s /etc/Vault/CA_Vault/Cert/public
sudo chmod g+s /etc/Vault/CA_Vault/Cert/private

# === Vault_Auto ===
sudo mkdir -p /etc/Vault/Vault_Auto/Cert/{public,private}
sudo mkdir -p /etc/Vault/Vault_Auto/Config

# Droits
sudo chmod 775 /etc/Vault/Vault_Auto
sudo chmod 775 /etc/Vault/Vault_Auto/Cert
sudo chmod 775 /etc/Vault/Vault_Auto/Cert/public
sudo chmod 770 /etc/Vault/Vault_Auto/Cert/private
sudo chmod 775 /etc/Vault/Vault_Auto/Config

# Propriété
sudo chown -R vault:vault /etc/Vault/Vault_Auto

# Héritage (setgid)
sudo chmod g+s /etc/Vault/Vault_Auto/Cert/public
sudo chmod g+s /etc/Vault/Vault_Auto/Cert/private

# === Script Renouvellement ===
sudo mkdir -p /etc/Vault_Script/Script_Renouvelement

# Permissions
sudo chmod 750 /etc/Vault_Script
sudo chmod 750 /etc/Vault_Script/Script_Renouvelement

# Propriétaire 
sudo chown -R sednal:vault /etc/Vault_Script

echo " Structure Vault_Auto créée avec succès !"
echo "  IMPORTANT: Déconnectez-vous et reconnectez-vous pour que "$USER" soit dans le groupe vault"
