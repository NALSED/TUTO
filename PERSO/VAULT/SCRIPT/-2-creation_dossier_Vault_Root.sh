#!/bin/bash
set -e  # Arrête si une commande échoue

# ===== Création utilisateur et groupe vault =====
# Créer le groupe (ignorer si existe déjà)
sudo groupadd vault 2>/dev/null || true

# Créer l'utilisateur système (ignorer si existe déjà)
sudo useradd -r -g vault -d /etc/Vault -s /bin/false vault 2>/dev/null || true

# Ajouter sednal au groupe
sudo usermod -aG vault sednal

# === Vault_Root ===
sudo mkdir -p /etc/Vault/Vault_Root/Cert/{public,private}
sudo mkdir -p /etc/Vault/Vault_Root/Config

# Droits
sudo chmod 775 /etc/Vault
sudo chmod 775 /etc/Vault/Vault_Root
sudo chmod 775 /etc/Vault/Vault_Root/Cert
sudo chmod 775 /etc/Vault/Vault_Root/Cert/public
sudo chmod 770 /etc/Vault/Vault_Root/Cert/private
sudo chmod 775 /etc/Vault/Vault_Root/Config

# Propriété
sudo chown -R vault:vault /etc/Vault/Vault_Root

# Héritage (setgid)
sudo chmod g+s /etc/Vault/Vault_Root/Cert/public
sudo chmod g+s /etc/Vault/Vault_Root/Cert/private

# === Script Renouvellement ===
sudo mkdir -p /etc/Vault_Script/Script_Renouvelement

# Permissions
sudo chmod 750 /etc/Vault_Script
sudo chmod 750 /etc/Vault_Script/Script_Renouvelement

# Propriétaire 
sudo chown -R sednal:vault /etc/Vault_Script

echo " Structure Vault_Root créée avec succès !"
echo "  IMPORTANT: Déconnectez-vous et reconnectez-vous pour que sednal soit dans le groupe vault"
