#!/bin/bash

# === AJOUTER === Nom Service
services=()

# === AJOUTER === Cible Certificats
cible=""

# === AJOUTER === Dossier de destination sur la machine cible
base_service="/etc/"

# Variable à ne pas toucher
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

# === GENERATION CERTIFICATS ===
for svc in "${services[@]}"; do
    cert="${svc}${domain}"
    folder=$(path "$svc")

    mkdir -p "$base_pki"/{private,public}/"$folder"/{Rsa,Ecdsa}

    echo "Génération RSA : $cert => $folder"
    result=$(vault write -format=json PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Rsa/${svc}_rsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Rsa/${svc}_rsa.key" > /dev/null

    echo "Génération ECDSA : $cert => $folder"
    result=$(vault write -format=json PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Ecdsa/${svc}_ecdsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Ecdsa/${svc}_ecdsa.key" > /dev/null
done

# Réappliquer les droits sur Vault
find "$base_pki/private" -type f -name "*.key" -exec chmod 600 {} \;
find "$base_pki/public"  -type f -name "*.crt" -exec chmod 644 {} \;
chown -R vault:vault "$base_pki"

# === DEPLOIEMENT ===
for svc in "${services[@]}"; do
    folder=$(path "$svc")

    ssh "$cible" "mkdir -p $base_service/{Cert,Keys,CA}"

    rsync -e ssh --no-p --chmod=F600 --chown=sednal:sednal \
        "$base_pki/private/$folder/Rsa/${svc}_rsa.key" \
        "$base_pki/private/$folder/Ecdsa/${svc}_ecdsa.key" \
        "$cible":"$base_service/Keys/"

    rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
        "$base_pki/public/$folder/Rsa/${svc}_rsa.crt" \
        "$base_pki/public/$folder/Ecdsa/${svc}_ecdsa.crt" \
        "$cible":"$base_service/Cert/"
done

# CA
base_ca="$base_pki/Cert_CA/Root"
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_ca/ca_chain_rsa.crt" \
    "$base_ca/ca_chain_ecdsa.crt" \
    "$cible":"$base_service/CA/"

ssh "$cible" "sudo cp $base_service/CA/Sednal_Root_All.crt /usr/local/share/ca-certificates/"
ssh "$cible" "sudo update-ca-certificates --fresh"
