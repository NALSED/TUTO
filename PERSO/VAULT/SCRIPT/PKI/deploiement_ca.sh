#!/bin/bash

# ===============================================================
# ========== SCRIPT DE DÉPLOIEMENT DES CA UNIQUEMENT ============
# ===============================================================
# Pousse Root All, ca_chain RSA et ECDSA vers tous les services.
# À utiliser après renouvellement des CA ou premier déploiement.
# Le store système (/usr/local/share/ca-certificates/) est mis
# à jour manuellement sur chaque machine.
# ===============================================================

base_pki="/etc/Vault/PKI"
base_ca="$base_pki/Cert_CA/Root"

set -e

echo "=== Déploiement CA vers tous les services ==="

# ===== INFRA =====
echo "→ infra.sednal.lan"
cible="sednal@infra.sednal.lan"
base_infra="/etc/infra"

ssh "$cible" "mkdir -p $base_infra/CA"
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_ca/ca_chain_rsa.crt" \
    "$base_ca/ca_chain_ecdsa.crt" \
    "$cible":"$base_infra/CA/"

# ===== BAREOS =====
echo "→ bareos.sednal.lan"
cible="sednal@bareos.sednal.lan"
base_bareos="/etc/bareos/ssl"

ssh "$cible" "mkdir -p $base_bareos/CA"
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_ca/Sednal_Root_All.crt" \
    "$cible":"$base_bareos/CA/"

# ===== PI =====
echo "→ pihole.sednal.lan"
cible="sednal@pihole.sednal.lan"
base_pi="/etc/ssl"

ssh "$cible" "mkdir -p $base_pi/CA"
rsync -e ssh --no-p --chmod=F644 --chown=root:root \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_ca/ca_chain_rsa.crt" \
    "$base_ca/ca_chain_ecdsa.crt" \
    "$cible":"$base_pi/CA/"

# ===== PROXMOX =====
echo "→ proxmox.sednal.lan"
cible="root@proxmox.sednal.lan"
base_proxmox="/etc/ssl/proxmox"

ssh "$cible" "mkdir -p $base_proxmox/CA"
rsync -e ssh --no-p --chmod=F644 --chown=root:root \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_ca/ca_chain_rsa.crt" \
    "$base_ca/ca_chain_ecdsa.crt" \
    "$cible":"$base_proxmox/CA/"

# ===== VPS =====
echo "→ VPS 176.31.163.227"
cible="debian@176.31.163.227"
base_vps="/etc/ssl"

ssh "$cible" "mkdir -p $base_vps/CA"
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian \
    "$base_ca/Sednal_Root_All.crt" \
    "$cible":"$base_vps/CA/"

echo -e "\nDéploiement CA OK "
echo "    Mettre à jour le store système manuellement sur chaque machine :"
echo "    sudo cp <base>/CA/Sednal_Root_All.crt /usr/local/share/ca-certificates/"
echo "    sudo update-ca-certificates --fresh"
