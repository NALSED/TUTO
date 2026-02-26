#!/bin/bash

# ===============================================================
# ========== CRÉATION ARBORESCENCE SSL — VPS 176.31.163.227 =====
# ===============================================================

set -e

# === Création de l'arborescence ===
mkdir -p /etc/vps/ssl/{ca,cert,keys}

# === Propriétaire et droits ===
chown debian:debian /etc/vps/ssl
chmod 755           /etc/vps/ssl

chown debian:debian /etc/vps/ssl/ca
chmod 755           /etc/vps/ssl/ca

chown debian:debian /etc/vps/ssl/cert
chmod 755           /etc/vps/ssl/cert

chown debian:debian /etc/vps/ssl/keys
chmod 755           /etc/vps/ssl/keys

echo "Arborescence VPS créée et droits appliqués "
