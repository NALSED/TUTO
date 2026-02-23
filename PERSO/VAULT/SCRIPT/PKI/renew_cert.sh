#!/bin/bash

# Services RSA + ECDSA
services_dual=(proxmox pihole upsnap infra vps cockpit)
# Services RSA uniquement (Bareos)
services_rsa=(bareos-dir bareos-fd bareos-sd-local bareos-sd-remote bareos win lin postgresql)
base_pki="/etc/Vault/PKI"
domain=".sednal.lan"

set -e

path() {
    if [[ "$1" == "proxmox" ]]; then echo "Proxmox"
    elif [[ "$1" == "pihole" ]]; then echo "Pihole"
    elif [[ "$1" == "upsnap" ]]; then echo "Upsnap"
    elif [[ "$1" == "infra" ]]; then echo "Infra"
    elif [[ "$1" == bareos* ]]; then echo "Bareos"
    elif [[ "$1" == "win" ]]; then echo "Bareos"
    elif [[ "$1" == "lin" ]]; then echo "Bareos"
    elif [[ "$1" == "postgresql" ]]; then echo "PostGreSQL"
    elif [[ "$1" == "vps" ]]; then echo "VPS"
    elif [[ "$1" == "cockpit" ]]; then echo "Cockpit"
    fi
}

# === RSA + ECDSA ===
for service in "${services_dual[@]}"; do
    cert="${service}${domain}"
    folder=$(path "$service")

    echo "Renouvellement RSA : $cert → $folder"
    result=$(vault write -format=json PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Rsa/${service}_rsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Rsa/${service}_rsa.key" > /dev/null

    echo "Renouvellement ECDSA : $cert → $folder"
    result=$(vault write -format=json PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Ecdsa/${service}_ecdsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Ecdsa/${service}_ecdsa.key" > /dev/null
done

# === RSA UNIQUEMENT (Bareos) ===
for service in "${services_rsa[@]}"; do
    cert="${service}${domain}"
    folder=$(path "$service")

    echo "Renouvellement RSA : $cert → $folder"
    result=$(vault write -format=json PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Rsa/${service}_rsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Rsa/${service}_rsa.key" > /dev/null
done

# Réappliquer les droits sur Vault
find "$base_pki/private" -type f -name "*.key" -exec chmod 600 {} \;
find "$base_pki/public"  -type f -name "*.crt" -exec chmod 644 {} \;
chown -R vault:vault "$base_pki"

# ===== INFRA =====
cible="sednal@192.168.0.239"
base_infra="/etc/infra"

ssh "$cible" "rm -f $base_infra/Keys/* $base_infra/Cert/*"

rsync -e ssh --no-p --chmod=F600 --chown=sednal:sednal \
    "$base_pki/private/Infra/Rsa/infra_rsa.key" \
    "$base_pki/private/Infra/Ecdsa/infra_ecdsa.key" \
    "$cible":"$base_infra/Keys/"
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/Infra/Rsa/infra_rsa.crt" \
    "$base_pki/public/Infra/Ecdsa/infra_ecdsa.crt" \
    "$cible":"$base_infra/Cert/"

# ===== BAREOS =====
cible="sednal@192.168.0.240"
base_bareos="/etc/bareos/ssl"

ssh "$cible" "rm -f $base_bareos/Keys/dir/* $base_bareos/Cert/dir/*
              rm -f $base_bareos/Keys/sd/local/* $base_bareos/Cert/sd/local/*
              rm -f $base_bareos/Keys/sd/remote/* $base_bareos/Cert/sd/remote/*
              rm -f $base_bareos/Keys/fd/* $base_bareos/Cert/fd/*
              rm -f $base_bareos/Keys/web/* $base_bareos/Cert/web/*
              rm -f $base_bareos/Keys/post/* $base_bareos/Cert/post/*
              rm -f $base_bareos/Keys/client/win/* $base_bareos/Cert/client/win/*
              rm -f $base_bareos/Keys/client/lin/* $base_bareos/Cert/client/lin/*"

# DIR
rsync -e ssh --no-p --chmod=F600 --chown=bareos:bareos \
    "$base_pki/private/Bareos/Rsa/bareos-dir_rsa.key" \
    "$cible":"$base_bareos"/Keys/dir/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/Bareos/Rsa/bareos-dir_rsa.crt" \
    "$cible":"$base_bareos"/Cert/dir/

# SD LOCAL
rsync -e ssh --no-p --chmod=F600 --chown=bareos:bareos \
    "$base_pki/private/Bareos/Rsa/bareos-sd-local_rsa.key" \
    "$cible":"$base_bareos"/Keys/sd/local/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/Bareos/Rsa/bareos-sd-local_rsa.crt" \
    "$cible":"$base_bareos"/Cert/sd/local/

# SD REMOTE
rsync -e ssh --no-p --chmod=F600 --chown=bareos:bareos \
    "$base_pki/private/Bareos/Rsa/bareos-sd-remote_rsa.key" \
    "$cible":"$base_bareos"/Keys/sd/remote/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/Bareos/Rsa/bareos-sd-remote_rsa.crt" \
    "$cible":"$base_bareos"/Cert/sd/remote/

# FD
rsync -e ssh --no-p --chmod=F600 --chown=bareos:bareos \
    "$base_pki/private/Bareos/Rsa/bareos-fd_rsa.key" \
    "$cible":"$base_bareos"/Keys/fd/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/Bareos/Rsa/bareos-fd_rsa.crt" \
    "$cible":"$base_bareos"/Cert/fd/

# WEBUI
rsync -e ssh --no-p --chmod=F600 --chown=bareos:bareos \
    "$base_pki/private/Bareos/Rsa/bareos_rsa.key" \
    "$cible":"$base_bareos"/Keys/web/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/Bareos/Rsa/bareos_rsa.crt" \
    "$cible":"$base_bareos"/Cert/web/

# POSTGRESQL
rsync -e ssh --no-p --chmod=F640 --chown=bareos:bareos \
    "$base_pki/private/PostGreSQL/Rsa/postgresql_rsa.key" \
    "$cible":"$base_bareos"/Keys/post/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/PostGreSQL/Rsa/postgresql_rsa.crt" \
    "$cible":"$base_bareos"/Cert/post/

# CLIENT WIN
rsync -e ssh --no-p --chmod=F600 --chown=bareos:bareos \
    "$base_pki/private/Bareos/Rsa/win_rsa.key" \
    "$cible":"$base_bareos"/Keys/client/win/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/Bareos/Rsa/win_rsa.crt" \
    "$cible":"$base_bareos"/Cert/client/win/

# CLIENT LIN
rsync -e ssh --no-p --chmod=F600 --chown=bareos:bareos \
    "$base_pki/private/Bareos/Rsa/lin_rsa.key" \
    "$cible":"$base_bareos"/Keys/client/lin/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/Bareos/Rsa/lin_rsa.crt" \
    "$cible":"$base_bareos"/Cert/client/lin/

# ===== PI =====
cible="sednal@192.168.0.241"
base_pi="/etc/ssl"

ssh "$cible" "rm -f $base_pi/Pihole/Keys/* $base_pi/Pihole/Cert/*
              rm -f $base_pi/Upsnap/Keys/* $base_pi/Upsnap/Cert/*
              rm -f $base_pi/Cockpit/Keys/* $base_pi/Cockpit/Cert/*"

rsync -e ssh --no-p --chmod=F600 --chown=sednal:sednal \
    "$base_pki/private/Pihole/Rsa/pihole_rsa.key" \
    "$base_pki/private/Pihole/Ecdsa/pihole_ecdsa.key" \
    "$cible":"$base_pi"/Pihole/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/Pihole/Rsa/pihole_rsa.crt" \
    "$base_pki/public/Pihole/Ecdsa/pihole_ecdsa.crt" \
    "$cible":"$base_pi"/Pihole/Cert/

rsync -e ssh --no-p --chmod=F600 --chown=sednal:sednal \
    "$base_pki/private/Upsnap/Rsa/upsnap_rsa.key" \
    "$base_pki/private/Upsnap/Ecdsa/upsnap_ecdsa.key" \
    "$cible":"$base_pi"/Upsnap/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/Upsnap/Rsa/upsnap_rsa.crt" \
    "$base_pki/public/Upsnap/Ecdsa/upsnap_ecdsa.crt" \
    "$cible":"$base_pi"/Upsnap/Cert/

rsync -e ssh --no-p --chmod=F600 --chown=sednal:sednal \
    "$base_pki/private/Cockpit/Rsa/cockpit_rsa.key" \
    "$base_pki/private/Cockpit/Ecdsa/cockpit_ecdsa.key" \
    "$cible":"$base_pi"/Cockpit/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/Cockpit/Rsa/cockpit_rsa.crt" \
    "$base_pki/public/Cockpit/Ecdsa/cockpit_ecdsa.crt" \
    "$cible":"$base_pi"/Cockpit/Cert/

# ===== PROXMOX =====
cible="root@192.168.0.242"
base_proxmox="/etc/ssl/proxmox"

ssh "$cible" "rm -f $base_proxmox/Keys/* $base_proxmox/Cert/*"

rsync -e ssh --no-p --chmod=F600 --chown=root:root \
    "$base_pki/private/Proxmox/Rsa/proxmox_rsa.key" \
    "$base_pki/private/Proxmox/Ecdsa/proxmox_ecdsa.key" \
    "$cible":"$base_proxmox"/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=root:root \
    "$base_pki/public/Proxmox/Rsa/proxmox_rsa.crt" \
    "$base_pki/public/Proxmox/Ecdsa/proxmox_ecdsa.crt" \
    "$cible":"$base_proxmox"/Cert/

# ===== VPS =====
cible="debian@176.31.163.227"
base_vps="/etc/ssl"

ssh "$cible" "rm -f $base_vps/Keys/* $base_vps/Cert/*"

rsync -e ssh --no-p --chmod=F600 --chown=debian:debian \
    "$base_pki/private/VPS/Rsa/vps_rsa.key" \
    "$cible":"$base_vps"/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian \
    "$base_pki/public/VPS/Rsa/vps_rsa.crt" \
    "$cible":"$base_vps"/Cert/
