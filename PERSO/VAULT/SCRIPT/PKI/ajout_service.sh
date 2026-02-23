#!/bin/bash

# ============================================================
# Script d'ajout d'un nouveau service PKI
# Remplir les variables ci-dessous avant exécution
#!!! Ajouter Le Service dans le script renew_cert.sh !!!
# L'utilisateur sednal doit pouvoir exécuter les commandes suivantes, sans sudo en ssh:
# - /usr/sbin/update-ca-certificates
# - /bin/cp
# - /usr/bin/rm
#
# -Ajouter les lignes
#sednal ALL=(ALL) NOPASSWD: /usr/sbin/update-ca-certificates
#sednal ALL=(ALL) NOPASSWD: /bin/cp
#sednal ALL=(ALL) NOPASSWD: /usr/bin/rm
#
# Dans la machine cible.
# ============================================================

# === 1. Nom du service (ex: monservice) ===
service=""

# === 2. Algorithme : "dual" (RSA+ECDSA) ou "rsa" (RSA uniquement) ===
algo="rsa"

# === 3. Dossier sur Vault (ex: MonService) ===
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
base_pki="/etc/Vault/PKI"
domain=".sednal.lan"
base_ca="$base_pki/Cert_CA/Root"

set -e

echo -e "Avez vous ajouté les ligne suivante dans la machine cible\n" 
echo -e "sednal ALL=(ALL) NOPASSWD: /usr/sbin/update-ca-certificates"
echo -e "sednal ALL=(ALL) NOPASSWD: /bin/cp"
echo -e "sednal ALL=(ALL) NOPASSWD: /usr/bin/rm"


read -p "Veuillez choisir y/n" choix_sudo

while true; do
    
    if  [[ "$choix_sudo" =~ ^[yY]$ ]]; then

        if [[ -z "$service" || -z "$folder" || -z "$cible" || -z "$base_dest" || -z "$owner" ]]; then
            echo "Erreur : toutes les variables doivent être remplies."
            exit 1
        fi

        cert="${service}${domain}"

        echo "=== Génération certificat RSA : $cert ==="
        result=$(vault write -format=json PKI_Sednal_Inter_RSA/issue/Cert_Inter_RSA common_name="$cert")
        echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Rsa/${service}_rsa.crt" > /dev/null
        echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Rsa/${service}_rsa.key" > /dev/null

        if [[ "$algo" == "dual" ]]; then
            echo "=== Génération certificat ECDSA : $cert ==="
            result=$(vault write -format=json PKI_Sednal_Inter_ECDSA/issue/Cert_Inter_ECDSA common_name="$cert")
            echo "$result" | jq -r '.data.certificate' | sudo tee "$base_pki/public/$folder/Ecdsa/${service}_ecdsa.crt" > /dev/null
            echo "$result" | jq -r '.data.private_key'  | sudo tee "$base_pki/private/$folder/Ecdsa/${service}_ecdsa.key" > /dev/null
        fi

        # Réappliquer les droits sur Vault
        find "$base_pki/private/$folder" -type f -name "*.key" -exec chmod 600 {} \;
        find "$base_pki/public/$folder"  -type f -name "*.crt" -exec chmod 644 {} \;
        chown -R vault:vault "$base_pki/private/$folder" "$base_pki/public/$folder"

        echo "=== Déploiement vers $cible ==="
        ssh "$cible" "mkdir -p $base_dest/{CA,Cert,Keys}"

        # CA
        rsync -e ssh --no-p --chmod=F644 --chown="$owner" \
            "$base_ca/Sednal_Root_All.crt" \
            "$base_ca/ca_chain_rsa.crt" \
            "$base_ca/ca_chain_ecdsa.crt" \
            "$cible":"$base_dest/CA/"

        # Clé privée RSA
        rsync -e ssh --no-p --chmod="$perm_key" --chown="$owner" \
            "$base_pki/private/$folder/Rsa/${service}_rsa.key" \
            "$cible":"$base_dest/Keys/"

        # Certificat RSA
        rsync -e ssh --no-p --chmod=F644 --chown="$owner" \
            "$base_pki/public/$folder/Rsa/${service}_rsa.crt" \
            "$cible":"$base_dest/Cert/"

        if [[ "$algo" == "dual" ]]; then
            # Clé privée ECDSA
            rsync -e ssh --no-p --chmod="$perm_key" --chown="$owner" \
                "$base_pki/private/$folder/Ecdsa/${service}_ecdsa.key" \
                "$cible":"$base_dest/Keys/"

            # Certificat ECDSA
            rsync -e ssh --no-p --chmod=F644 --chown="$owner" \
                "$base_pki/public/$folder/Ecdsa/${service}_ecdsa.crt" \
                "$cible":"$base_dest/Cert/"
        fi

        # Installation CA système
        ssh "$cible" "sudo cp $base_dest/CA/Sednal_Root_All.crt /usr/local/share/ca-certificates/"
        ssh "$cible" "sudo update-ca-certificates --fresh"

        echo "Service $service déployé avec succès sur $cible"
        
    elif [[ "$choix_sudo" =~ ^[nN]$ ]]; then
        echo -e "Le script va quitter"
        sleep 2
        exit 1
    else
        echo -e "Choix invalide Veuillez choisir entre y ou n"
    fi
done        
