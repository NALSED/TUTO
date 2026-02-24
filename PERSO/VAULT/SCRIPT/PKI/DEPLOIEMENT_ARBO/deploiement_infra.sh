#!/bin/bash

# ===============================================================
# ========== CRÉATION ARBORESCENCE SSL — INFRA 192.168.0.239 ====
# ===============================================================

set -e

# === Création de l'arborescence ===
mkdir -p /etc/infra/{CA,Cert,Keys}

# === Propriétaire ===
chown root:root   /etc/infra
chown sednal:sednal /etc/infra/CA
chown sednal:sednal /etc/infra/Cert
chown sednal:sednal /etc/infra/Keys

# === Droits ===
chmod 755 /etc/infra
chmod 755 /etc/infra/CA
chmod 755 /etc/infra/Cert
chmod 755 /etc/infra/Keys

echo "Arborescence Infra créée et droits appliqués"
