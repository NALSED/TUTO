#!/bin/bash

# ============================================================
# Script d'ajout d'un nouveau service PKI
# Remplir les variables ci-dessous avant exécution
# ============================================================

# === 1. Nom du service (ex: monservice) ===
service=""

# === 2. Algorithme : "rsa" | "ecdsa" | "dual" (RSA+ECDSA) ===
algo="rsa"

# === 3. Dossier sur Vault dans /etc/vault/pki/ (ex: monservice) ===
folder=""

# === 4. Cible SSH (ex: sednal@192.168.0.240) ===
cible=""

# === 5. Chemin de base sur la machine cible (ex: /etc/monservice/ssl) ===
base_dest=""

# === 6. Propriétaire fichiers sur la machine cible (ex: sednal:sednal) ===
owner=""

# === 7. Permission clé privée : F600 par défaut, F640 si service tiers (ex: postgresql) ===
perm_key="F600"

# ============================================================
base_pki="/etc/vault/pki"
domain=".sednal.lan"
base_ca="$base_pki/cert_ca/root"
base_inter="$base_pki/cert_ca/inter"

set -e



if [[ -z "$service" || -z "$folder" || -z "$cible" || -z "$base_dest" || -z "$owner" ]]; then
    echo "Erreur : toutes les variables doivent être remplies."
    exit 1
fi

cert="${service}${domain}"

if [[ "$algo" == "rsa" || "$algo" == "dual" ]]; then
    echo "=== Génération certificat RSA : $cert ==="
    result=$(vault write -format=json PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/rsa/${service}_rsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/rsa/${service}_rsa.key" > /dev/null
fi

if [[ "$algo" == "ecdsa" || "$algo" == "dual" ]]; then
    echo "=== Génération certificat ECDSA : $cert ==="
    result=$(vault write -format=json PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA common_name="$cert")
    echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/ecdsa/${service}_ecdsa.crt" > /dev/null
    echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/ecdsa/${service}_ecdsa.key" > /dev/null
fi

# Réappliquer les droits sur Vault
find "$base_pki/private/$folder" -type f -name "*.key" -exec chmod 600 {} \;
find "$base_pki/public/$folder"  -type f -name "*.crt" -exec chmod 644 {} \;
chown -R vault:vault "$base_pki/private/$folder" "$base_pki/public/$folder"

echo "=== Déploiement vers $cible ==="
ssh "$cible" "mkdir -p $base_dest/{ca,cert,keys}"

# CA
rsync -e ssh --no-p --chmod=F644 --chown="$owner" \
    "$base_ca/Sednal_Root_All.crt" \
    "$base_inter/Sednal_Inter_R-1.cert.pem" \
    "$base_inter/Sednal_Inter_E-1.cert.pem" \
    "$cible":"$base_dest/ca/"

if [[ "$algo" == "rsa" || "$algo" == "dual" ]]; then
    rsync -e ssh --no-p --chmod="$perm_key" --chown="$owner" \
        "$base_pki/private/$folder/rsa/${service}_rsa.key" \
        "$cible":"$base_dest/keys/"
    rsync -e ssh --no-p --chmod=F644 --chown="$owner" \
        "$base_pki/public/$folder/rsa/${service}_rsa.crt" \
        "$cible":"$base_dest/cert/"
fi

if [[ "$algo" == "ecdsa" || "$algo" == "dual" ]]; then
    rsync -e ssh --no-p --chmod="$perm_key" --chown="$owner" \
        "$base_pki/private/$folder/ecdsa/${service}_ecdsa.key" \
        "$cible":"$base_dest/keys/"
    rsync -e ssh --no-p --chmod=F644 --chown="$owner" \
        "$base_pki/public/$folder/ecdsa/${service}_ecdsa.crt" \
        "$cible":"$base_dest/cert/"
fi

echo "Service $service déployé avec succès sur $cible"
echo "⚠️  Penser à mettre à jour le store CA manuellement sur $cible :"
echo "    sudo cp $base_dest/ca/Sednal_Root_All.crt /usr/local/share/ca-certificates/"
echo "    sudo update-ca-certificates --fresh"


