#!/bin/bash

# ===============================================================
# ========== CRÉATION ARBORESCENCE SSL — PROXMOX 192.168.0.242 ==
# ===============================================================

set -e

# === Création de l'arborescence ===
mkdir -p /etc/proxmox/ssl/{ca,cert,keys}

# === Propriétaire et droits ===
chown root:root /etc/proxmox/ssl
chmod 755       /etc/proxmox/ssl

chown root:root /etc/proxmox/ssl/ca
chmod 755       /etc/proxmox/ssl/ca

chown root:root /etc/proxmox/ssl/cert
chmod 755       /etc/proxmox/ssl/cert

chown root:root /etc/proxmox/ssl/keys
chmod 755       /etc/proxmox/ssl/keys

echo "Arborescence Proxmox créée et droits appliqués "
