#!/bin/bash

# ===============================================================
# ========== CRÉATION ARBORESCENCE SSL — VPS 176.31.163.227 =====
# ===============================================================

set -e

# === Création de l'arborescence ===
mkdir -p /etc/ssl/{CA,Cert,Keys}

# === Propriétaire et droits ===
chown debian:debian /etc/ssl/CA
chmod 775           /etc/ssl/CA

chown debian:debian /etc/ssl/Cert
chmod 775           /etc/ssl/Cert

chown debian:debian /etc/ssl/Keys
chmod 775           /etc/ssl/Keys

echo "Arborescence VPS créée et droits appliqués "
