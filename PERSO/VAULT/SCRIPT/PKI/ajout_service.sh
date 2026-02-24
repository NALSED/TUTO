#!/bin/bash

# ============================================================
# Script d'ajout d'un nouveau service PKI
# Remplir les variables ci-dessous avant exécution
# !!! Ajouter le service dans renew_cert.sh après exécution !!!

# ============================================================

# === 1. Nom du service (ex: monservice) ===
service=""

# === 2. Algorithme : "dual" (RSA+ECDSA) ou "rsa" (RSA uniquement) ===
algo="rsa"

# === 3. Dossier sur Vault (ex: MonService) ===
folder=""

# === 4. Cible SSH (ex: sednal@monservice.sednal.lan) ===
cible=""

# === 5. Chemin de base sur la machine cible (ex: /etc/monservice/ssl) ===
base_dest=""

# === 6. Propriétaire fichiers sur la machine cible (ex: sednal:sednal) ===
owner=""

# === 7. Permission clé privée : F600 par défaut, F640 si service tiers (ex: postgresql) ===
perm_key="F600"

# ============================================================
base_pki="/etc/Vault/PKI"
domain=".sednal.lan"
base_ca="$base_pki/Cert_CA/Root"

set -e

echo "Vérification prérequis..."
echo "- reload_ssl.sh présent sur $cible ?"
echo "- sudoers configuré sur $cible ?"
echo "- Dossiers SSL créés sur $cible ?"
echo "- Dossiers Vault créés pour $folder ?"
echo ""
read -p "Tout est en ordre ? (y/n) " choix

while true; do

    if [[ "$choix" =~ ^[yY]$ ]]; then

        if [[ -z "$service" || -z "$folder" || -z "$cible" || -z "$base_dest" || -z "$owner" ]]; then
            echo "Erreur : toutes les variables doivent être remplies."
            exit 1
        fi

        cert="${service}${domain}"

        echo "=== Génération certificat RSA : $cert ==="
        result=$(vault write -format=json PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA common_name="$cert")
        echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Rsa/${service}_rsa.crt" > /dev/null
        echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Rsa/${service}_rsa.key" > /dev/null
        sudo chown vault:vault "$base_pki/public/$folder/Rsa/${service}_rsa.crt"
        sudo chown vault:vault "$base_pki/private/$folder/Rsa/${service}_rsa.key"

        if [[ "$algo" == "dual" ]]; then
            echo "=== Génération certificat ECDSA : $cert ==="
            result=$(vault write -format=json PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA common_name="$cert")
            echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Ecdsa/${service}_ecdsa.crt" > /dev/null
            echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Ecdsa/${service}_ecdsa.key" > /dev/null
            sudo chown vault:vault "$base_pki/public/$folder/Ecdsa/${service}_ecdsa.crt"
            sudo chown vault:vault "$base_pki/private/$folder/Ecdsa/${service}_ecdsa.key"
        fi

        # Droits Vault
        sudo chmod 644 "$base_pki/public/$folder/Rsa/${service}_rsa.crt"
        sudo chmod 600 "$base_pki/private/$folder/Rsa/${service}_rsa.key"

        echo "=== Déploiement vers $cible ==="
        ssh "$cible" "mkdir -p $base_dest/{CA,Cert,Keys}"

        # CA
        rsync -e ssh --no-p --chmod=F644 --chown="$owner" \
            "$base_ca/Sednal_Root_All.crt" \
            "$base_ca/ca_chain_rsa.crt" \
            "$base_ca/ca_chain_ecdsa.crt" \
            "$cible":"$base_dest/CA/"

        # Clé + cert RSA
        rsync -e ssh --no-p --chmod="$perm_key" --chown="$owner" \
            "$base_pki/private/$folder/Rsa/${service}_rsa.key" \
            "$cible":"$base_dest/Keys/"
        rsync -e ssh --no-p --chmod=F644 --chown="$owner" \
            "$base_pki/public/$folder/Rsa/${service}_rsa.crt" \
            "$cible":"$base_dest/Cert/"

        if [[ "$algo" == "dual" ]]; then
            # Clé + cert ECDSA
            rsync -e ssh --no-p --chmod="$perm_key" --chown="$owner" \
                "$base_pki/private/$folder/Ecdsa/${service}_ecdsa.key" \
                "$cible":"$base_dest/Keys/"
            rsync -e ssh --no-p --chmod=F644 --chown="$owner" \
                "$base_pki/public/$folder/Ecdsa/${service}_ecdsa.crt" \
                "$cible":"$base_dest/Cert/"
        fi

        # Mise à jour CA système via reload_ssl.sh
        ssh "$cible" "sudo /usr/local/bin/reload_ssl.sh"

        echo ""
        echo "Service $service déployé avec succès sur $cible "
        echo ""
        echo "    Ne pas oublier :"
        echo "    1. Configurer SSL dans le service"
        echo "    2. Redémarrer le service manuellement"
        echo "    3. Ajouter $service dans renew_cert.sh"
        break

    elif [[ "$choix" =~ ^[nN]$ ]]; then
        echo "Abandon."
        exit 1
    else
        echo "Choix invalide, y ou n."
        read -p "Tout est en ordre ? (y/n) " choix
    fi

done
