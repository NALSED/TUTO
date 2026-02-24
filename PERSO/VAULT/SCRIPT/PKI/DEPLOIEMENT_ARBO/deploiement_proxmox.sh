#!/bin/bash

# ===============================================================
# ========== CRÉATION ARBORESCENCE SSL — PROXMOX 192.168.0.242 ==
# ===============================================================

set -e

# === Création de l'arborescence ===
mkdir -p /etc/ssl/proxmox/{CA,Cert,Keys}

# === Propriétaire et droits ===
chown root:root /etc/ssl/proxmox
chmod 755       /etc/ssl/proxmox

chown root:root /etc/ssl/proxmox/CA
chmod 755       /etc/ssl/proxmox/CA

chown root:root /etc/ssl/proxmox/Cert
chmod 755       /etc/ssl/proxmox/Cert

chown root:root /etc/ssl/proxmox/Keys
chmod 755       /etc/ssl/proxmox/Keys

echo "Arborescence Proxmox créée et droits appliqués ✅"
