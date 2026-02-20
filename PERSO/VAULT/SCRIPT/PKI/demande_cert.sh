#!/bin/bash

services=(proxmox pihole upsnap infra bareos-dir bareos-fd bareos-sd bareos postgresql vps cockpit)
domain=".sednal.lan"
base="/etc/Vault/PKI"

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
    common_name="ca-chain.sednal.lan" > "$base/Cert_CA/Root/ca_chain_rsa.crt"

vault write -field=ca_chain PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA \
    common_name="ca-chain.sednal.lan" > "$base/Cert_CA/Root/ca_chain_ecdsa.crt"

for service in "${services[@]}"; do
    cert="${service}${domain}"
    folder=$(path "$service")

    echo "Renouvellement RSA : $cert → $folder"

    vault write -field=certificate PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA \
        common_name="$cert" \
        > "$base/public/$folder/Rsa/${service}_rsa.crt"

    vault write -field=private_key PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA \
        common_name="$cert" \
        > "$base/private/$folder/Rsa/${service}_rsa.key"

    echo "Renouvellement ECDSA : $cert → $folder"

    vault write -field=certificate PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA \
        common_name="$cert" \
        > "$base/public/$folder/Ecdsa/${service}_ecdsa.crt"

    vault write -field=private_key PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA \
        common_name="$cert" \
        > "$base/private/$folder/Ecdsa/${service}_ecdsa.key"

done

# INFRA
cible="sednal@192.168.0.239"
ssh "$cible" "mkdir -p /etc/infra/{Cert,Keys,CA}"

base_ca="/etc/Vault/PKI/Cert_CA/Root"
scp /etc/Vault/PKI/private/Infra/Rsa/infra_rsa.key "$cible":/etc/infra/Keys/
scp /etc/Vault/PKI/private/Infra/Ecdsa/infra_ecdsa.key "$cible":/etc/infra/Keys/
scp /etc/Vault/PKI/public/Infra/Rsa/infra_rsa.crt "$cible":/etc/infra/Cert/
scp /etc/Vault/PKI/public/Infra/Ecdsa/infra_ecdsa.crt "$cible":/etc/infra/Cert/
scp "$base_ca/Sednal_Root_All.crt" "$base_ca/ca_chain_rsa.crt" "$base_ca/ca_chain_ecdsa.crt" "$cible":/etc/infra/CA/

ssh "$cible" "
    chmod 600 /etc/infra/Keys/*
    chmod 644 /etc/infra/Cert/*
    chmod 644 /etc/infra/CA/*
    chown -R sednal:sednal /etc/infra/
"

# BAREOS
cible="sednal@192.168.0.240"
base2="/etc/Vault/PKI"
base="/etc/bareos/ssl"

ssh "$cible" "mkdir -p /etc/bareos/ssl/{CA,key/{dir,sd,fd,web,post},cert/{dir,sd,fd,web,post}}"

scp "$base2/Cert_CA/Root/Sednal_Root_All.crt" "$cible:$base/CA/"
scp "$base2/Cert_CA/Root/ca_chain_rsa.crt"    "$cible:$base/CA/"
scp "$base2/Cert_CA/Root/ca_chain_ecdsa.crt"  "$cible:$base/CA/"

scp "$base2/private/Bareos/Rsa/bareos-dir_rsa.key"    "$cible:$base/key/dir/"
scp "$base2/private/Bareos/Ecdsa/bareos-dir_ecdsa.key" "$cible:$base/key/dir/"
scp "$base2/public/Bareos/Rsa/bareos-dir_rsa.crt"      "$cible:$base/cert/dir/"
scp "$base2/public/Bareos/Ecdsa/bareos-dir_ecdsa.crt"  "$cible:$base/cert/dir/"

scp "$base2/private/Bareos/Rsa/bareos-sd_rsa.key"     "$cible:$base/key/sd/"
scp "$base2/private/Bareos/Ecdsa/bareos-sd_ecdsa.key"  "$cible:$base/key/sd/"
scp "$base2/public/Bareos/Rsa/bareos-sd_rsa.crt"       "$cible:$base/cert/sd/"
scp "$base2/public/Bareos/Ecdsa/bareos-sd_ecdsa.crt"   "$cible:$base/cert/sd/"

scp "$base2/private/Bareos/Rsa/bareos-fd_rsa.key"     "$cible:$base/key/fd/"
scp "$base2/private/Bareos/Ecdsa/bareos-fd_ecdsa.key"  "$cible:$base/key/fd/"
scp "$base2/public/Bareos/Rsa/bareos-fd_rsa.crt"       "$cible:$base/cert/fd/"
scp "$base2/public/Bareos/Ecdsa/bareos-fd_ecdsa.crt"   "$cible:$base/cert/fd/"

scp "$base2/private/Bareos/Rsa/bareos_rsa.key"        "$cible:$base/key/web/"
scp "$base2/private/Bareos/Ecdsa/bareos_ecdsa.key"     "$cible:$base/key/web/"
scp "$base2/public/Bareos/Rsa/bareos_rsa.crt"          "$cible:$base/cert/web/"
scp "$base2/public/Bareos/Ecdsa/bareos_ecdsa.crt"      "$cible:$base/cert/web/"

scp "$base2/private/PostGreSQL/Rsa/postgresql_rsa.key"    "$cible:$base/key/post/"
scp "$base2/private/PostGreSQL/Ecdsa/postgresql_ecdsa.key" "$cible:$base/key/post/"
scp "$base2/public/PostGreSQL/Rsa/postgresql_rsa.crt"      "$cible:$base/cert/post/"
scp "$base2/public/PostGreSQL/Ecdsa/postgresql_ecdsa.crt"  "$cible:$base/cert/post/"

ssh "$cible" "
    chmod 600 $base/key/*/*
    chmod 644 $base/cert/*/*
    chmod 644 $base/CA/*
    chown -R bareos:bareos $base/
"

# PI (Pihole + Upsnap + Cockpit)
cible="sednal@192.168.0.241"
base_ca="$base2/Cert_CA/Root"

ssh "$cible" "mkdir -p /etc/ssl/{CA,Pihole/{Cert,Keys},Upsnap/{Cert,Keys},Cockpit/{Cert,Keys}}"

scp "$base_ca/Sednal_Root_All.crt" "$base_ca/ca_chain_rsa.crt" "$base_ca/ca_chain_ecdsa.crt" "$cible:/etc/ssl/CA/"

scp "$base2/private/Pihole/Rsa/pihole_rsa.key"    "$cible:/etc/ssl/Pihole/Keys/"
scp "$base2/private/Pihole/Ecdsa/pihole_ecdsa.key" "$cible:/etc/ssl/Pihole/Keys/"
scp "$base2/public/Pihole/Rsa/pihole_rsa.crt"      "$cible:/etc/ssl/Pihole/Cert/"
scp "$base2/public/Pihole/Ecdsa/pihole_ecdsa.crt"  "$cible:/etc/ssl/Pihole/Cert/"

scp "$base2/private/Upsnap/Rsa/upsnap_rsa.key"    "$cible:/etc/ssl/Upsnap/Keys/"
scp "$base2/private/Upsnap/Ecdsa/upsnap_ecdsa.key" "$cible:/etc/ssl/Upsnap/Keys/"
scp "$base2/public/Upsnap/Rsa/upsnap_rsa.crt"      "$cible:/etc/ssl/Upsnap/Cert/"
scp "$base2/public/Upsnap/Ecdsa/upsnap_ecdsa.crt"  "$cible:/etc/ssl/Upsnap/Cert/"

scp "$base2/private/Cockpit/Rsa/cockpit_rsa.key"    "$cible:/etc/ssl/Cockpit/Keys/"
scp "$base2/private/Cockpit/Ecdsa/cockpit_ecdsa.key" "$cible:/etc/ssl/Cockpit/Keys/"
scp "$base2/public/Cockpit/Rsa/cockpit_rsa.crt"      "$cible:/etc/ssl/Cockpit/Cert/"
scp "$base2/public/Cockpit/Ecdsa/cockpit_ecdsa.crt"  "$cible:/etc/ssl/Cockpit/Cert/"

ssh "$cible" "
    chmod 600 /etc/ssl/Pihole/Keys/*
    chmod 600 /etc/ssl/Upsnap/Keys/*
    chmod 600 /etc/ssl/Cockpit/Keys/*
    chmod 644 /etc/ssl/Pihole/Cert/*
    chmod 644 /etc/ssl/Upsnap/Cert/*
    chmod 644 /etc/ssl/Cockpit/Cert/*
    chmod 644 /etc/ssl/CA/*
    chown -R sednal:sednal /etc/ssl/
"

# PROXMOX
cible="sednal@192.168.0.242"

ssh "$cible" "mkdir -p /etc/ssl/proxmox/{CA,Cert,Keys}"

scp "$base_ca/Sednal_Root_All.crt" "$base_ca/ca_chain_rsa.crt" "$base_ca/ca_chain_ecdsa.crt" "$cible:/etc/ssl/proxmox/CA/"

scp "$base2/private/Proxmox/Rsa/proxmox_rsa.key"    "$cible:/etc/ssl/proxmox/Keys/"
scp "$base2/private/Proxmox/Ecdsa/proxmox_ecdsa.key" "$cible:/etc/ssl/proxmox/Keys/"
scp "$base2/public/Proxmox/Rsa/proxmox_rsa.crt"      "$cible:/etc/ssl/proxmox/Cert/"
scp "$base2/public/Proxmox/Ecdsa/proxmox_ecdsa.crt"  "$cible:/etc/ssl/proxmox/Cert/"

ssh "$cible" "
    chmod 600 /etc/ssl/proxmox/Keys/*
    chmod 644 /etc/ssl/proxmox/Cert/*
    chmod 644 /etc/ssl/proxmox/CA/*
    chown -R root:root /etc/ssl/proxmox/
"

# VPS
cible="debian@176.31.163.227"

ssh "$cible" "mkdir -p /etc/ssl/{Cert,Keys,CA}"

scp "$base2/private/VPS/Rsa/vps_rsa.key"     "$cible:/etc/ssl/Keys/"
scp "$base2/private/VPS/Ecdsa/vps_ecdsa.key"  "$cible:/etc/ssl/Keys/"
scp "$base2/public/VPS/Rsa/vps_rsa.crt"       "$cible:/etc/ssl/Cert/"
scp "$base2/public/VPS/Ecdsa/vps_ecdsa.crt"   "$cible:/etc/ssl/Cert/"
scp "$base_ca/Sednal_Root_All.crt" "$base_ca/ca_chain_rsa.crt" "$base_ca/ca_chain_ecdsa.crt" "$cible:/etc/ssl/CA/"

ssh "$cible" "
    chmod 600 /etc/ssl/Keys/*
    chmod 644 /etc/ssl/Cert/*
    chmod 644 /etc/ssl/CA/*
    chown -R debian:debian /etc/ssl/
"
