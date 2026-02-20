#!/bin/bash

base="/etc/Vault/PKI"

# sednal dans le groupe vault
usermod -aG vault sednal

# === Création de l'arborescence ===

mkdir -p "$base"
mkdir -p "$base/Config/Policy"
mkdir -p "$base"/{private,public}/{Bareos,Infra,Pihole,Proxmox,Upsnap,PostGreSQL,Cockpit,Vps}/{Rsa,Ecdsa}
mkdir -p "$base/Cert_CA"/{Inter,Root,CSR}

# === Propriétaire ===
chown -R vault:vault "$base"

# === Droits dossiers ===
chmod 750 "$base"

# Config/
chmod 750 "$base/Config"
chmod 750 "$base/Config/Policy"

# private/
chmod 700 "$base/private"
chmod 700 "$base/private/Bareos"
chmod 700 "$base/private/Bareos/Rsa"
chmod 700 "$base/private/Bareos/Ecdsa"
chmod 700 "$base/private/Infra"
chmod 700 "$base/private/Infra/Rsa"
chmod 700 "$base/private/Infra/Ecdsa"
chmod 700 "$base/private/Pihole"
chmod 700 "$base/private/Pihole/Rsa"
chmod 700 "$base/private/Pihole/Ecdsa"
chmod 700 "$base/private/Proxmox"
chmod 700 "$base/private/Proxmox/Rsa"
chmod 700 "$base/private/Proxmox/Ecdsa"
chmod 700 "$base/private/Upsnap"
chmod 700 "$base/private/Upsnap/Rsa"
chmod 700 "$base/private/Upsnap/Ecdsa"
chmod 700 "$base/private/PostGreSQL"
chmod 700 "$base/private/PostGreSQL/Rsa"
chmod 700 "$base/private/PostGreSQL/Ecdsa"
chmod 700 "$base/private/Cockpit"
chmod 700 "$base/private/Cockpit/Rsa"
chmod 700 "$base/private/Cockpit/Ecdsa"
chmod 700 "$base/private/Vps"
chmod 700 "$base/private/Vps/Rsa"
chmod 700 "$base/private/Vps/Ecdsa"

# public/
chmod 755 "$base/public"
chmod 755 "$base/public/Bareos"
chmod 755 "$base/public/Bareos/Rsa"
chmod 755 "$base/public/Bareos/Ecdsa"
chmod 755 "$base/public/Infra"
chmod 755 "$base/public/Infra/Rsa"
chmod 755 "$base/public/Infra/Ecdsa"
chmod 755 "$base/public/Pihole"
chmod 755 "$base/public/Pihole/Rsa"
chmod 755 "$base/public/Pihole/Ecdsa"
chmod 755 "$base/public/Proxmox"
chmod 755 "$base/public/Proxmox/Rsa"
chmod 755 "$base/public/Proxmox/Ecdsa"
chmod 755 "$base/public/Upsnap"
chmod 755 "$base/public/Upsnap/Rsa"
chmod 755 "$base/public/Upsnap/Ecdsa"
chmod 755 "$base/public/PostGreSQL"
chmod 755 "$base/public/PostGreSQL/Rsa"
chmod 755 "$base/public/PostGreSQL/Ecdsa"
chmod 755 "$base/public/Cockpit"
chmod 755 "$base/public/Cockpit/Rsa"
chmod 755 "$base/public/Cockpit/Ecdsa"
chmod 755 "$base/public/Vps"
chmod 755 "$base/public/Vps/Rsa"
chmod 755 "$base/public/Vps/Ecdsa"

# Cert_CA/
chmod 755 "$base/Cert_CA"
chmod 755 "$base/Cert_CA/Inter"
chmod 755 "$base/Cert_CA/Root"
chmod 700 "$base/Cert_CA/CSR"

echo "Arborescence créée et droits appliqués ✅"
