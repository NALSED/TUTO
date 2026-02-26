#!/bin/bash

# ===============================================================
# ========== SCRIPT DE DÉPLOIEMENT DES CA UNIQUEMENT ============
# ===============================================================
# Pousse Sednal_Root_All.crt (Root + Inter RSA + Root + Inter ECDSA) vers tous les services.
# À utiliser après renouvellement des CA ou premier déploiement.
# Le store système (/usr/local/share/ca-certificates/) est mis
# à jour manuellement sur chaque machine.
# ===============================================================

base_pki="/etc/vault/pki"
base_ca="$base_pki/cert_ca/root"
base_inter="$base_pki/cert_ca/inter"

set -e

echo "=== Déploiement CA vers tous les services ==="

# ===== INFRA =====
echo "→ infra.sednal.lan"
cible="sednal@infra.sednal.lan"

ssh "$cible" "mkdir -p /etc/infra/ssl/ca"
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":/etc/infra/ssl/ca/

# ===== BAREOS =====
echo "→ bareos.sednal.lan"
cible="sednal@bareos.sednal.lan"

ssh "$cible" "mkdir -p /etc/bareos/ssl/ca"
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":/etc/bareos/ssl/ca/

# ===== DNS =====
echo "→ pihole.sednal.lan"
cible="sednal@pihole.sednal.lan"

for svc in pihole upsnap cockpit; do
    ssh "$cible" "mkdir -p /etc/$svc/ssl/ca"
    rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
        "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
        "$cible":/etc/"$svc"/ssl/ca/
done

# ===== PROXMOX =====
echo "→ proxmox.sednal.lan"
cible="root@proxmox.sednal.lan"

ssh "$cible" "mkdir -p /etc/proxmox/ssl/ca"
rsync -e ssh --no-p --chmod=F644 --chown=root:root \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":/etc/proxmox/ssl/ca/

# ===== VPS =====
echo "→ VPS 176.31.163.227"
cible="debian@176.31.163.227"

ssh "$cible" "mkdir -p /etc/vps/ssl/ca"
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":/etc/vps/ssl/ca/

echo -e "\nDéploiement CA OK "
echo "    Mettre à jour le store système manuellement sur chaque machine :"
echo "    sudo cp <base>/ssl/ca/Sednal_Root_All.crt /usr/local/share/ca-certificates/"
echo "    sudo update-ca-certificates --fresh"
