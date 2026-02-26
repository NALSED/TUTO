#!/bin/bash

# ===============================================================
# ========== CRÉATION ARBORESCENCE SSL — INFRA 192.168.0.239 ====
# ===============================================================

set -e

# === Création de l'arborescence ===
mkdir -p /etc/infra/ssl/{ca,cert,keys}

# === Propriétaire ===
chown root:root     /etc/infra
chown root:root     /etc/infra/ssl
chown sednal:sednal /etc/infra/ssl/ca
chown sednal:sednal /etc/infra/ssl/cert
chown sednal:sednal /etc/infra/ssl/keys

# === Droits ===
chmod 755 /etc/infra
chmod 755 /etc/infra/ssl
chmod 755 /etc/infra/ssl/ca
chmod 755 /etc/infra/ssl/cert
chmod 755 /etc/infra/ssl/keys

echo "Arborescence Infra créée et droits appliqués"
