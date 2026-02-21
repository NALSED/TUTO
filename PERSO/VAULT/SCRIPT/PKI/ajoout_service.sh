#!/bin/bash

# Tableau des services en minuscule
services=()

# Ou l'on va copier les certificat : Format => user@IP
cible=""

# Variable à ne pas toucher
base_pki="/etc/Vault/PKI"
domain=".sednal.lan"

set -e

path() {
    local svc="$1"
    echo "${svc^}"
}

# === RENOUVELLEMENT CERTIFICATS ===
for svc in "${services[@]}"; do
    cert="${svc}${domain}"
    folder=$(path "$svc")

    mkdir -p "$base_pki"/{private,public}/"$folder"/{Rsa,Ecdsa}

    echo "Renouvellement RSA : $cert => $folder"
    result=$(vault write -format=json PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Rsa/${svc}_rsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Rsa/${svc}_rsa.key" > /dev/null

    echo "Renouvellement ECDSA : $cert => $folder"
    result=$(vault write -format=json PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Ecdsa/${svc}_ecdsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Ecdsa/${svc}_ecdsa.key" > /dev/null

done

# Réappliquer les droits sur Vault
find "$base_pki/private" -type f -name "*.key" -exec chmod 600 {} \;
find "$base_pki/public"  -type f -name "*.crt" -exec chmod 644 {} \;
chown -R vault:vault "$base_pki"

# ===== INFRA =====

base_service_1="/etc/$svc"

ssh "$cible" "mkdir -p $base_service_1/{Cert,Keys,CA}"

rsync -e ssh --no-p --chmod=F600 --chown=sednal:sednal \
    "$base_service_1/private/Infra/Rsa/infra_rsa.key" \
    "$base_service_1/private/Infra/Ecdsa/infra_ecdsa.key" \
    "$cible":"$base_service_1/Keys/"

rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal \
    "$base_service_1/public/Infra/Rsa/infra_rsa.crt" \
    "$base_service_1/public/Infra/Ecdsa/infra_ecdsa.crt" \
    "$cible":"$base_service_1/Cert/"
