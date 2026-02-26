#!/bin/bash

# ===============================================================
# ========== CRÉATION ARBORESCENCE PKI — VAULT 192.168.0.238 ====
# ===============================================================
# Pour ajouter un service : l'ajouter dans la liste services[]
# ===============================================================

base="/etc/vault/pki"

services=(bareos cockpit infra pihole postgresql proxmox upsnap vps)

set -e

# sednal dans le groupe vault
usermod -aG vault sednal

# === Création de l'arborescence ===
for s in "${services[@]}"; do
    mkdir -p "$base/private/$s"/{rsa,ecdsa}
    mkdir -p "$base/public/$s"/{rsa,ecdsa}
done

mkdir -p "$base"/cert_ca/{inter,root,csr}
mkdir -p "$base"/config/policy

# === Propriétaire ===
chown -R vault:vault "$base"

# === Droits ===
chmod 750 "$base"

find "$base/private" -type d -exec chmod 700 {} \;
find "$base/public"  -type d -exec chmod 755 {} \;

chmod 755 "$base/cert_ca"
chmod 755 "$base/cert_ca/inter"
chmod 755 "$base/cert_ca/root"
chmod 700 "$base/cert_ca/csr"

echo "Arborescence Vault créée et droits appliqués "
