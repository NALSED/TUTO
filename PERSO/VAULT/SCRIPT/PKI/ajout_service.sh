#!/bin/bash

# Tableau des services en minuscule
services=()

# Où l'on va copier les certificats : Format => user@IP
cible=""

# Dossier de destination sur la machine cible (exemple /etc/bareos)
base_service="/etc/"

# Variable à ne pas toucher
base_pki="/etc/Vault/PKI"
domain=".sednal.lan"

set -e

path() {
    local svc="$1"
    echo "${svc^}"
}

# === GENERATION CERTIFICATS ===
for svc in "${services[@]}"; do
    cert="${svc}${domain}"
    folder=$(path "$svc")

    # Chemin par defaut sur 192.168.0.238 : /etc/Vault/PKI/ Nom du service avec une majuscule 
    mkdir -p "$base_pki"/{private,public}/"$folder"/{Rsa,Ecdsa}

    # Génération RSA
    echo "Génération RSA : $cert => $folder"
    result=$(vault write -format=json PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Rsa/${svc}_rsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Rsa/${svc}_rsa.key" > /dev/null

    # Génération ECDSA
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
     
     # Chemin par defaut : /etc/[NOM SERVICE]/
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
