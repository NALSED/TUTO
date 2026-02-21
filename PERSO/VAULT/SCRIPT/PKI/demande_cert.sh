#!/bin/bash

services=(proxmox pihole upsnap infra bareos-dir bareos-fd bareos-sd bareos postgresql vps cockpit)
base_pki="/etc/Vault/PKI"
domain=".sednal.lan"

set -e

path() {
    if [[ "$1" == "proxmox" ]]; then echo "Proxmox"
    elif [[ "$1" == "pihole" ]]; then echo "Pihole"
    elif [[ "$1" == "upsnap" ]]; then echo "Upsnap"
    elif [[ "$1" == "infra" ]]; then echo "Infra"
    elif [[ "$1" == bareos* ]]; then echo "Bareos"
    elif [[ "$1" == "postgresql" ]]; then echo "PostGreSQL"
    elif [[ "$1" == "vps" ]]; then echo "VPS"
    elif [[ "$1" == "cockpit" ]]; then echo "Cockpit"
    fi
}

# CA chain générée une seule fois
vault write -field=ca_chain PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA \
    common_name="ca-chain.sednal.lan" | sudo tee "$base_pki/Cert_CA/Root/ca_chain_rsa.crt" > /dev/null

vault write -field=ca_chain PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA \
    common_name="ca-chain.sednal.lan" | sudo tee  "$base_pki/Cert_CA/Root/ca_chain_ecdsa.crt" > /dev/null

for service in "${services[@]}"; do
    cert="${service}${domain}"
    folder=$(path "$service")

    # RSA - un seul appel
    result=$(vault write -format=json PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Rsa/${service}_rsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key' | sudo tee "$base_pki/private/$folder/Rsa/${service}_rsa.key" > /dev/null

    # ECDSA - un seul appel
    result=$(vault write -format=json PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Ecdsa/${service}_ecdsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key' | sudo tee "$base_pki/private/$folder/Ecdsa/${service}_ecdsa.key" > /dev/null

done

# ===== INFRA =====

# Cible 192.168.0.239 pour SSH
cible="sednal@192.168.0.239"

# Certificats sur 192.168.0.239
base_infra="/etc/infra"
# Certificats Root et Inter sur 192.168.0.238
base_ca="$base_pki/Cert_CA/Root"

# Création Arborécence
ssh "$cible" "mkdir -p $base_infra/{Cert,Keys,CA}"

# Copie via rsync avec changement de droit en propiétaire

# Keys 
rsync -e ssh --no-p --chmod=F600 --chown=sednal:sednal \
    "$base_pki/private/Infra/Rsa/infra_rsa.key" "$cible":"$base_infra/Keys"
rsync -e ssh --no-p --chmod=F600 --chown=sednal:sednal \
    "$base_pki/private/Infra/Ecdsa/infra_ecdsa.key" "$cible":"$base_infra/Keys"

# Cert Services
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/Infra/Rsa/infra_rsa.crt" "$cible":"$base_infra/Cert"
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/Infra/Ecdsa/infra_ecdsa.crt" "$cible":"$base_infra/Cert"

# Certs CA et Inter
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_ca/ca_chain_rsa.crt" \
    "$base_ca/ca_chain_ecdsa.crt" \
    "$cible":"$base_infra/CA"

# Mise en place Certif CA => /ca-certificates
ssh "$cible" "sudo cp $base_infra/CA/Sednal_Root_All.crt /usr/local/share/ca-certificates/"

# Refresh => /ca-certificates
ssh "$cible" "sudo update-ca-certificates --fresh"

# ===== BAREOS =====

# Cible 192.168.0.240 pour SSH
cible="sednal@192.168.0.240"

# Certificats sur 192.168.0.240
base_bareos="/etc/bareos/ssl"
# Certificats Root et Inter sur 192.168.0.238
base_ca="$base_pki/Cert_CA/Root"

# Création Arborécence
ssh "$cible" "mkdir -p $base_bareos/{CA,Keys/{dir,sd,fd,web,post},Cert/{dir,sd,fd,web,post}}"

# CA
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_ca/ca_chain_rsa.crt" \
    "$base_ca/ca_chain_ecdsa.crt" \
    "$cible":"$base_bareos"/CA/

# BAREOS DIR
rsync -e ssh --no-p --chmod=F600 --chown=bareos:bareos \
    "$base_pki/private/Bareos/Rsa/bareos-dir_rsa.key" \
    "$base_pki/private/Bareos/Ecdsa/bareos-dir_ecdsa.key" \
    "$cible":"$base_bareos"/Keys/dir/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/Bareos/Rsa/bareos-dir_rsa.crt" \
    "$base_pki/public/Bareos/Ecdsa/bareos-dir_ecdsa.crt" \
    "$cible":"$base_bareos"/Cert/dir/

# BAREOS SD
rsync -e ssh --no-p --chmod=F600 --chown=bareos:bareos \
    "$base_pki/private/Bareos/Rsa/bareos-sd_rsa.key" \
    "$base_pki/private/Bareos/Ecdsa/bareos-sd_ecdsa.key" \
    "$cible":"$base_bareos"/Keys/sd/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/Bareos/Rsa/bareos-sd_rsa.crt" \
    "$base_pki/public/Bareos/Ecdsa/bareos-sd_ecdsa.crt" \
    "$cible":"$base_bareos"/Cert/sd/

# BAREOS FD
rsync -e ssh --no-p --chmod=F600 --chown=bareos:bareos \
    "$base_pki/private/Bareos/Rsa/bareos-fd_rsa.key" \
    "$base_pki/private/Bareos/Ecdsa/bareos-fd_ecdsa.key" \
    "$cible":"$base_bareos"/Keys/fd/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/Bareos/Rsa/bareos-fd_rsa.crt" \
    "$base_pki/public/Bareos/Ecdsa/bareos-fd_ecdsa.crt" \
    "$cible":"$base_bareos"/Cert/fd/

# BAREOS WEBUI
rsync -e ssh --no-p --chmod=F600 --chown=bareos:bareos \
    "$base_pki/private/Bareos/Rsa/bareos_rsa.key" \
    "$base_pki/private/Bareos/Ecdsa/bareos_ecdsa.key" \
    "$cible":"$base_bareos"/Keys/web/
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos \
    "$base_pki/public/Bareos/Rsa/bareos_rsa.crt" \
    "$base_pki/public/Bareos/Ecdsa/bareos_ecdsa.crt" \
    "$cible":"$base_bareos"/Cert/web/

# POSTGRESQL
rsync -e ssh --no-p --chmod=F640 --chown=postgres:postgres \
    "$base_pki/private/PostGreSQL/Rsa/postgresql_rsa.key" \
    "$base_pki/private/PostGreSQL/Ecdsa/postgresql_ecdsa.key" \
    "$cible":"$base_bareos"/Keys/post/
rsync -e ssh --no-p --chmod=F644 --chown=postgres:postgres \
    "$base_pki/public/PostGreSQL/Rsa/postgresql_rsa.crt" \
    "$base_pki/public/PostGreSQL/Ecdsa/postgresql_ecdsa.crt" \
    "$cible":"$base_bareos"/Cert/post/

# Mise en place Certif CA => /ca-certificates
ssh "$cible" "sudo cp $base_bareos/CA/Sednal_Root_All.crt /usr/local/share/ca-certificates/"

# Refresh => /ca-certificates
ssh "$cible" "sudo update-ca-certificates --fresh"

# ===== PI (Pihole + Upsnap + Cockpit) =====

# Cible 192.168.0.241 pour SSH
cible="sednal@192.168.0.241"

# Certificats sur 192.168.0.241
base_pi="/etc/ssl"
# Certificats Root et Inter sur 192.168.0.238
base_ca="$base_pki/Cert_CA/Root"

# Création Arborescence
ssh "$cible" "mkdir -p $base_pi/{CA,Pihole/{Cert,Keys},Upsnap/{Cert,Keys},Cockpit/{Cert,Keys}}"

# CA
rsync -e ssh --no-p --chmod=F644 --chown=root:root \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_ca/ca_chain_rsa.crt" \
    "$base_ca/ca_chain_ecdsa.crt" \
    "$cible":"$base_pi"/CA/

# Pihole
rsync -e ssh --no-p --chmod=F600 --chown=sednal:sednal \
    "$base_pki/private/Pihole/Rsa/pihole_rsa.key" \
    "$base_pki/private/Pihole/Ecdsa/pihole_ecdsa.key" \
    "$cible":"$base_pi"/Pihole/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/Pihole/Rsa/pihole_rsa.crt" \
    "$base_pki/public/Pihole/Ecdsa/pihole_ecdsa.crt" \
    "$cible":"$base_pi"/Pihole/Cert/

# Upsnap
rsync -e ssh --no-p --chmod=F600 --chown=sednal:sednal \
    "$base_pki/private/Upsnap/Rsa/upsnap_rsa.key" \
    "$base_pki/private/Upsnap/Ecdsa/upsnap_ecdsa.key" \
    "$cible":"$base_pi"/Upsnap/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/Upsnap/Rsa/upsnap_rsa.crt" \
    "$base_pki/public/Upsnap/Ecdsa/upsnap_ecdsa.crt" \
    "$cible":"$base_pi"/Upsnap/Cert/

# Cockpit
rsync -e ssh --no-p --chmod=F600 --chown=sednal:sednal \
    "$base_pki/private/Cockpit/Rsa/cockpit_rsa.key" \
    "$base_pki/private/Cockpit/Ecdsa/cockpit_ecdsa.key" \
    "$cible":"$base_pi"/Cockpit/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_pki/public/Cockpit/Rsa/cockpit_rsa.crt" \
    "$base_pki/public/Cockpit/Ecdsa/cockpit_ecdsa.crt" \
    "$cible":"$base_pi"/Cockpit/Cert/

# Mise en place Certif CA => /ca-certificates
ssh "$cible" "sudo cp $base_pi/CA/Sednal_Root_All.crt /usr/local/share/ca-certificates/"

# Refresh => /ca-certificates
ssh "$cible" "sudo update-ca-certificates --fresh"


# ===== PROXMOX =====

# Cible 192.168.0.242 pour SSH
cible="sednal@192.168.0.242"

# Certificats sur 192.168.0.242
base_proxmox="/etc/ssl/proxmox"
# Certificats Root et Inter sur 192.168.0.238
base_ca="$base_pki/Cert_CA/Root"

# Création Arborescence
ssh "$cible" "mkdir -p $base_proxmox/{CA,Cert,Keys}"

# CA
rsync -e ssh --no-p --chmod=F644 --chown=root:root \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_ca/ca_chain_rsa.crt" \
    "$base_ca/ca_chain_ecdsa.crt" \
    "$cible":"$base_proxmox"/CA/

# Proxmox
rsync -e ssh --no-p --chmod=F600 --chown=root:root \
    "$base_pki/private/Proxmox/Rsa/proxmox_rsa.key" \
    "$base_pki/private/Proxmox/Ecdsa/proxmox_ecdsa.key" \
    "$cible":"$base_proxmox"/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=root:root \
    "$base_pki/public/Proxmox/Rsa/proxmox_rsa.crt" \
    "$base_pki/public/Proxmox/Ecdsa/proxmox_ecdsa.crt" \
    "$cible":"$base_proxmox"/Cert/

# Mise en place Certif CA => /ca-certificates
ssh "$cible" "sudo cp $base_proxmox/CA/Sednal_Root_All.crt /usr/local/share/ca-certificates/"

# Refresh => /ca-certificates
ssh "$cible" "sudo update-ca-certificates --fresh"


# ===== VPS =====

# Cible 176.31.163.227 pour SSH
cible="debian@176.31.163.227"

# Certificats sur 176.31.163.227
base_vps="/etc/ssl"
# Certificats Root et Inter sur 192.168.0.238
base_ca="$base_pki/Cert_CA/Root"

# Création Arborescence
ssh "$cible" "mkdir -p $base_vps/{CA,Cert,Keys}"

# CA
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_ca/ca_chain_rsa.crt" \
    "$base_ca/ca_chain_ecdsa.crt" \
    "$cible":"$base_vps"/CA/

# VPS
rsync -e ssh --no-p --chmod=F600 --chown=debian:debian \
    "$base_pki/private/VPS/Rsa/vps_rsa.key" \
    "$base_pki/private/VPS/Ecdsa/vps_ecdsa.key" \
    "$cible":"$base_vps"/Keys/
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian \
    "$base_pki/public/VPS/Rsa/vps_rsa.crt" \
    "$base_pki/public/VPS/Ecdsa/vps_ecdsa.crt" \
    "$cible":"$base_vps"/Cert/

# Mise en place Certif CA => /ca-certificates
ssh "$cible" "sudo cp $base_vps/CA/Sednal_Root_All.crt /usr/local/share/ca-certificates/"

# Refresh => /ca-certificates
ssh "$cible" "sudo update-ca-certificates --fresh"

