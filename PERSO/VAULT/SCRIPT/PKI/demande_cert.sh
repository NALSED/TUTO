#!/bin/bash

# ============================================================
# Tous les services — RSA + ECDSA
# Pour ajouter un service : l'ajouter dans services[]
# ============================================================
services=(bareos-dir bareos-fd bareos-sd-local bareos-sd-remote bareos win lin postgresql pihole upsnap cockpit proxmox infra vps)
# ============================================================
base_pki="/etc/vault/pki"
domain=".sednal.lan"

set -e

path() {
    if [[ "$1" == bareos* || "$1" == "bareos" || "$1" == "win" || "$1" == "lin" ]]; then echo "bareos"
    else echo "$1"
    fi
}

# === RSA + ECDSA pour tous les services ===
for service in "${services[@]}"; do
    cert="${service}${domain}"
    folder=$(path "$service")

    result=$(vault write -format=json PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/rsa/${service}_rsa.crt" > /dev/null
    sudo chmod 644 "$base_pki/public/$folder/rsa/${service}_rsa.crt"
    echo "$result" | jq -r '.data.private_key' | sudo tee "$base_pki/private/$folder/rsa/${service}_rsa.key" > /dev/null
    sudo chmod 640 "$base_pki/private/$folder/rsa/${service}_rsa.key"

    result=$(vault write -format=json PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/ecdsa/${service}_ecdsa.crt" > /dev/null
    sudo chmod 644 "$base_pki/public/$folder/ecdsa/${service}_ecdsa.crt"
    echo "$result" | jq -r '.data.private_key' | sudo tee "$base_pki/private/$folder/ecdsa/${service}_ecdsa.key" > /dev/null
    sudo chmod 640 "$base_pki/private/$folder/ecdsa/${service}_ecdsa.key"
done

# Réappliquer propriétaire vault sur tous les fichiers générés
sudo chown -R vault:vault "$base_pki/private" "$base_pki/public"

base_ca="$base_pki/cert_ca/root"
base_inter="$base_pki/cert_ca/inter"

# ===== INFRA =====
cible="sednal@192.168.0.239"
base_infra="/etc/infra/ssl"

ssh "$cible" "mkdir -p $base_infra/{ca,cert,keys}"

rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":"$base_infra/ca/"
rsync -e ssh --no-p --chmod=F640 --chown=sednal:sednal \
    "$base_pki/private/infra/rsa/infra_rsa.key" \
    "$base_pki/private/infra/ecdsa/infra_ecdsa.key" \
    "$cible":"$base_infra/keys/"
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/infra/rsa/infra_rsa.crt" \
    "$base_pki/public/infra/ecdsa/infra_ecdsa.crt" \
    "$cible":"$base_infra/cert/"

# ===== BAREOS =====
cible="sednal@192.168.0.240"
base_bareos="/etc/bareos/ssl"

ssh "$cible" "mkdir -p $base_bareos/{ca,keys/{dir,sd/{local,remote},fd,web,post,client/{win,lin}},cert/{dir,sd/{local,remote},fd,web,post,client/{win,lin}},web}"

# CA
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":"$base_bareos/ca/"

# DIR — RSA + ECDSA
rsync -e ssh --no-p --chmod=F640 --chown=bareos:bareos \
    "$base_pki/private/bareos/rsa/bareos-dir_rsa.key" \
    "$base_pki/private/bareos/ecdsa/bareos-dir_ecdsa.key" \
    "$cible":"$base_bareos/keys/dir/"
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/bareos/rsa/bareos-dir_rsa.crt" \
    "$base_pki/public/bareos/ecdsa/bareos-dir_ecdsa.crt" \
    "$cible":"$base_bareos/cert/dir/"

# SD LOCAL — RSA + ECDSA
rsync -e ssh --no-p --chmod=F640 --chown=bareos:bareos \
    "$base_pki/private/bareos/rsa/bareos-sd-local_rsa.key" \
    "$base_pki/private/bareos/ecdsa/bareos-sd-local_ecdsa.key" \
    "$cible":"$base_bareos/keys/sd/local/"
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/bareos/rsa/bareos-sd-local_rsa.crt" \
    "$base_pki/public/bareos/ecdsa/bareos-sd-local_ecdsa.crt" \
    "$cible":"$base_bareos/cert/sd/local/"

# SD REMOTE — RSA + ECDSA
rsync -e ssh --no-p --chmod=F640 --chown=bareos:bareos \
    "$base_pki/private/bareos/rsa/bareos-sd-remote_rsa.key" \
    "$base_pki/private/bareos/ecdsa/bareos-sd-remote_ecdsa.key" \
    "$cible":"$base_bareos/keys/sd/remote/"
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/bareos/rsa/bareos-sd-remote_rsa.crt" \
    "$base_pki/public/bareos/ecdsa/bareos-sd-remote_ecdsa.crt" \
    "$cible":"$base_bareos/cert/sd/remote/"

# FD — RSA + ECDSA
rsync -e ssh --no-p --chmod=F640 --chown=bareos:bareos \
    "$base_pki/private/bareos/rsa/bareos-fd_rsa.key" \
    "$base_pki/private/bareos/ecdsa/bareos-fd_ecdsa.key" \
    "$cible":"$base_bareos/keys/fd/"
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/bareos/rsa/bareos-fd_rsa.crt" \
    "$base_pki/public/bareos/ecdsa/bareos-fd_ecdsa.crt" \
    "$cible":"$base_bareos/cert/fd/"

# WEBUI — RSA + ECDSA
rsync -e ssh --no-p --chmod=F640 --chown=bareos:bareos \
    "$base_pki/private/bareos/rsa/bareos_rsa.key" \
    "$base_pki/private/bareos/ecdsa/bareos_ecdsa.key" \
    "$cible":"$base_bareos/keys/web/"
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/bareos/rsa/bareos_rsa.crt" \
    "$base_pki/public/bareos/ecdsa/bareos_ecdsa.crt" \
    "$cible":"$base_bareos/cert/web/"

# POSTGRESQL — RSA + ECDSA (F640)
rsync -e ssh --no-p --chmod=F640 --chown=bareos:bareos \
    "$base_pki/private/postgresql/rsa/postgresql_rsa.key" \
    "$base_pki/private/postgresql/ecdsa/postgresql_ecdsa.key" \
    "$cible":"$base_bareos/keys/post/"
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/postgresql/rsa/postgresql_rsa.crt" \
    "$base_pki/public/postgresql/ecdsa/postgresql_ecdsa.crt" \
    "$cible":"$base_bareos/cert/post/"

# CLIENT WIN — RSA + ECDSA
rsync -e ssh --no-p --chmod=F640 --chown=bareos:bareos \
    "$base_pki/private/bareos/rsa/win_rsa.key" \
    "$base_pki/private/bareos/ecdsa/win_ecdsa.key" \
    "$cible":"$base_bareos/keys/client/win/"
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/bareos/rsa/win_rsa.crt" \
    "$base_pki/public/bareos/ecdsa/win_ecdsa.crt" \
    "$cible":"$base_bareos/cert/client/win/"

# CLIENT LIN — RSA + ECDSA
rsync -e ssh --no-p --chmod=F640 --chown=bareos:bareos \
    "$base_pki/private/bareos/rsa/lin_rsa.key" \
    "$base_pki/private/bareos/ecdsa/lin_ecdsa.key" \
    "$cible":"$base_bareos/keys/client/lin/"
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/bareos/rsa/lin_rsa.crt" \
    "$base_pki/public/bareos/ecdsa/lin_ecdsa.crt" \
    "$cible":"$base_bareos/cert/client/lin/"

# ===== DNS (pihole.sednal.lan) =====
cible="sednal@192.168.0.241"

# Pihole
ssh "$cible" "mkdir -p /etc/pihole/ssl/{ca,cert,keys}"
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":/etc/pihole/ssl/ca/
rsync -e ssh --no-p --chmod=F640 --chown=sednal:sednal \
    "$base_pki/private/pihole/rsa/pihole_rsa.key" \
    "$base_pki/private/pihole/ecdsa/pihole_ecdsa.key" \
    "$cible":/etc/pihole/ssl/keys/
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/pihole/rsa/pihole_rsa.crt" \
    "$base_pki/public/pihole/ecdsa/pihole_ecdsa.crt" \
    "$cible":/etc/pihole/ssl/cert/

# Upsnap
ssh "$cible" "mkdir -p /etc/upsnap/ssl/{ca,cert,keys}"
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":/etc/upsnap/ssl/ca/
rsync -e ssh --no-p --chmod=F640 --chown=sednal:sednal \
    "$base_pki/private/upsnap/rsa/upsnap_rsa.key" \
    "$base_pki/private/upsnap/ecdsa/upsnap_ecdsa.key" \
    "$cible":/etc/upsnap/ssl/keys/
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/upsnap/rsa/upsnap_rsa.crt" \
    "$base_pki/public/upsnap/ecdsa/upsnap_ecdsa.crt" \
    "$cible":/etc/upsnap/ssl/cert/

# Cockpit
ssh "$cible" "mkdir -p /etc/cockpit/ssl/{ca,cert,keys}"
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":/etc/cockpit/ssl/ca/
rsync -e ssh --no-p --chmod=F640 --chown=sednal:sednal \
    "$base_pki/private/cockpit/rsa/cockpit_rsa.key" \
    "$base_pki/private/cockpit/ecdsa/cockpit_ecdsa.key" \
    "$cible":/etc/cockpit/ssl/keys/
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/cockpit/rsa/cockpit_rsa.crt" \
    "$base_pki/public/cockpit/ecdsa/cockpit_ecdsa.crt" \
    "$cible":/etc/cockpit/ssl/cert/

# ===== PROXMOX =====
cible="root@192.168.0.242"
base_proxmox="/etc/proxmox/ssl"

ssh "$cible" "mkdir -p $base_proxmox/{ca,cert,keys}"

rsync -e ssh --no-p --chmod=F644 --chown=root:root \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":"$base_proxmox/ca/"
rsync -e ssh --no-p --chmod=F640 --chown=root:root \
    "$base_pki/private/proxmox/rsa/proxmox_rsa.key" \
    "$base_pki/private/proxmox/ecdsa/proxmox_ecdsa.key" \
    "$cible":"$base_proxmox/keys/"
rsync -e ssh --no-p --chmod=F644 --chown=root:root \
    "$base_pki/public/proxmox/rsa/proxmox_rsa.crt" \
    "$base_pki/public/proxmox/ecdsa/proxmox_ecdsa.crt" \
    "$cible":"$base_proxmox/cert/"

# ===== VPS =====
cible="debian@176.31.163.227"
base_vps="/etc/vps/ssl"

ssh "$cible" "mkdir -p $base_vps/{ca,cert,keys}"

rsync -e ssh --no-p --chmod=F644 --chown=debian:debian \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":"$base_vps/ca/"
rsync -e ssh --no-p --chmod=F640 --chown=debian:debian \
    "$base_pki/private/vps/rsa/vps_rsa.key" \
    "$base_pki/private/vps/ecdsa/vps_ecdsa.key" \
    "$cible":"$base_vps/keys/"
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian \
    "$base_pki/public/vps/rsa/vps_rsa.crt" \
    "$base_pki/public/vps/ecdsa/vps_ecdsa.crt" \
    "$cible":"$base_vps/cert/"
