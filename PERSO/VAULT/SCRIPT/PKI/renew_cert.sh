#!/bin/bash
# =============================================================================
# 02_vault_renew_certs.sh — Renouvellement des certificats depuis Vault PKI
# Exécuté sur le serveur Vault Via systemd
# =============================================================================
set -euo pipefail

SERVICES=(proxmox pihole upsnap infra bareos-dir bareos-fd bareos-sd bareos postgresql vps cockpit)
DOMAIN=".sednal.lan"
BASE="/etc/Vault/PKI"
BASE_CA="$BASE/Cert_CA/Root"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# ---------------------------------------------------------------------------
# Fonction : chemin du dossier pour chaque service
# ---------------------------------------------------------------------------
get_folder() {
    case "$1" in
        proxmox)    echo "Proxmox"    ;;
        pihole)     echo "Pihole"     ;;
        upsnap)     echo "Upsnap"     ;;
        infra)      echo "Infra"      ;;
        bareos*)    echo "Bareos"     ;;
        postgresql) echo "PostGreSQL" ;;
        vps)        echo "VPS"        ;;
        cockpit)    echo "Cockpit"    ;;
        *) echo "Unknown" ;;
    esac
}

# --------------------------------------------
# Fonction : émettre un certificat via Vault 
# --------------------------------------------
issue_cert() {
    local pki="$1"
    local role="$2"
    local cn="$3"
    local out_crt="$4"
    local out_key="$5"

    local json="$TMP/cert_$$.json"

    vault write -format=json "${pki}/issue/${role}" \
        common_name="$cn" > "$json"

    jq -r '.data.certificate' "$json" | sudo tee "$out_crt" > /dev/null
    jq -r '.data.private_key' "$json" | sudo tee "$out_key" > /dev/null

    sudo chmod 644 "$out_crt"
    sudo chmod 600 "$out_key"
}

# ---------------------------------------------------------------------------
# Renouvellement des certificats finaux
# ---------------------------------------------------------------------------
echo "=== Renouvellement des certificats ==="

for service in "${SERVICES[@]}"; do
    cn="${service}${DOMAIN}"
    folder=$(get_folder "$service")

    echo "--- RSA   : $cn → $folder ---"
    issue_cert \
        "PKI_Sednal_Inter_RSA" "Cert_Inter_RSA" "$cn" \
        "$BASE/public/$folder/Rsa/${service}_rsa.crt" \
        "$BASE/private/$folder/Rsa/${service}_rsa.key"

    echo "--- ECDSA : $cn → $folder ---"
    issue_cert \
        "PKI_Sednal_Inter_ECDSA" "Cert_Inter_ECDSA" "$cn" \
        "$BASE/public/$folder/Ecdsa/${service}_ecdsa.crt" \
        "$BASE/private/$folder/Ecdsa/${service}_ecdsa.key"
done

# Droits globaux sur le stockage Vault
sudo find "$BASE/private" -type f -name "*.key" -exec chmod 600 {} \;
sudo find "$BASE/public"  -type f -name "*.crt" -exec chmod 644 {} \;
sudo chown -R vault:vault "$BASE"

# ---------------------------------------------------------------------------
# Déploiement — INFRA (192.168.0.239)
# ---------------------------------------------------------------------------
echo "=== Déploiement INFRA ==="
CIBLE="sednal@192.168.0.239"

ssh "$CIBLE" "rm -f /etc/infra/Keys/* /etc/infra/Cert/* /etc/infra/CA/*"

rsync -e ssh --no-p --chmod=F600 "$BASE/private/Infra/Rsa/infra_rsa.key"    "$CIBLE:/etc/infra/Keys/"
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Infra/Ecdsa/infra_ecdsa.key" "$CIBLE:/etc/infra/Keys/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Infra/Rsa/infra_rsa.crt"      "$CIBLE:/etc/infra/Cert/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Infra/Ecdsa/infra_ecdsa.crt"  "$CIBLE:/etc/infra/Cert/"
rsync -e ssh --no-p --chmod=F644 \
    "$BASE_CA/Sednal_Root_All.crt" \
    "$BASE_CA/ca_chain_rsa.crt" \
    "$BASE_CA/ca_chain_ecdsa.crt" \
    "$CIBLE:/etc/infra/CA/"

ssh "$CIBLE" "chown -R sednal:sednal /etc/infra/"

ssh "$CIBLE" "cp /etc/infra/CA/Sednal_Root_All.crt \
                  /etc/infra/CA/ca_chain_rsa.crt \
                  /etc/infra/CA/ca_chain_ecdsa.crt \
                  /usr/local/share/ca-certificates/ \
              && sudo update-ca-certificates --fresh"

# ---------------------------------------------------------------------------
# Déploiement — BAREOS (192.168.0.240)
# ---------------------------------------------------------------------------
echo "=== Déploiement BAREOS ==="
CIBLE="sednal@192.168.0.240"
BSSL="/etc/bareos/ssl"

ssh "$CIBLE" "rm -f $BSSL/key/*/* $BSSL/cert/*/* $BSSL/CA/*"

# CA
rsync -e ssh --no-p --chmod=F644 \
    "$BASE_CA/Sednal_Root_All.crt" \
    "$BASE_CA/ca_chain_rsa.crt" \
    "$BASE_CA/ca_chain_ecdsa.crt" \
    "$CIBLE:$BSSL/CA/"

# bareos-dir
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Bareos/Rsa/bareos-dir_rsa.key"     "$CIBLE:$BSSL/key/dir/"
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Bareos/Ecdsa/bareos-dir_ecdsa.key" "$CIBLE:$BSSL/key/dir/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Bareos/Rsa/bareos-dir_rsa.crt"      "$CIBLE:$BSSL/cert/dir/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Bareos/Ecdsa/bareos-dir_ecdsa.crt"  "$CIBLE:$BSSL/cert/dir/"

# bareos-sd
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Bareos/Rsa/bareos-sd_rsa.key"      "$CIBLE:$BSSL/key/sd/"
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Bareos/Ecdsa/bareos-sd_ecdsa.key"  "$CIBLE:$BSSL/key/sd/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Bareos/Rsa/bareos-sd_rsa.crt"       "$CIBLE:$BSSL/cert/sd/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Bareos/Ecdsa/bareos-sd_ecdsa.crt"   "$CIBLE:$BSSL/cert/sd/"

# bareos-fd
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Bareos/Rsa/bareos-fd_rsa.key"      "$CIBLE:$BSSL/key/fd/"
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Bareos/Ecdsa/bareos-fd_ecdsa.key"  "$CIBLE:$BSSL/key/fd/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Bareos/Rsa/bareos-fd_rsa.crt"       "$CIBLE:$BSSL/cert/fd/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Bareos/Ecdsa/bareos-fd_ecdsa.crt"   "$CIBLE:$BSSL/cert/fd/"

# bareos web
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Bareos/Rsa/bareos_rsa.key"         "$CIBLE:$BSSL/key/web/"
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Bareos/Ecdsa/bareos_ecdsa.key"     "$CIBLE:$BSSL/key/web/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Bareos/Rsa/bareos_rsa.crt"          "$CIBLE:$BSSL/cert/web/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Bareos/Ecdsa/bareos_ecdsa.crt"      "$CIBLE:$BSSL/cert/web/"

# postgresql (bareos:bareos — postgres doit être dans le groupe bareos)
rsync -e ssh --no-p --chmod=F600 "$BASE/private/PostGreSQL/Rsa/postgresql_rsa.key"     "$CIBLE:$BSSL/key/post/"
rsync -e ssh --no-p --chmod=F600 "$BASE/private/PostGreSQL/Ecdsa/postgresql_ecdsa.key" "$CIBLE:$BSSL/key/post/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/PostGreSQL/Rsa/postgresql_rsa.crt"      "$CIBLE:$BSSL/cert/post/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/PostGreSQL/Ecdsa/postgresql_ecdsa.crt"  "$CIBLE:$BSSL/cert/post/"

ssh "$CIBLE" "chown -R bareos:bareos $BSSL/"

# ---------------------------------------------------------------------------
# Déploiement — PI : Pihole + Upsnap + Cockpit (192.168.0.241)
# ---------------------------------------------------------------------------
echo "=== Déploiement PI ==="
CIBLE="sednal@192.168.0.241"

ssh "$CIBLE" "rm -f /etc/ssl/Pihole/Keys/* /etc/ssl/Pihole/Cert/* \
                    /etc/ssl/Upsnap/Keys/* /etc/ssl/Upsnap/Cert/* \
                    /etc/ssl/Cockpit/Keys/* /etc/ssl/Cockpit/Cert/* \
                    /etc/ssl/CA/*"

# CA
rsync -e ssh --no-p --chmod=F644 \
    "$BASE_CA/Sednal_Root_All.crt" \
    "$BASE_CA/ca_chain_rsa.crt" \
    "$BASE_CA/ca_chain_ecdsa.crt" \
    "$CIBLE:/etc/ssl/CA/"

# Pihole
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Pihole/Rsa/pihole_rsa.key"     "$CIBLE:/etc/ssl/Pihole/Keys/"
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Pihole/Ecdsa/pihole_ecdsa.key" "$CIBLE:/etc/ssl/Pihole/Keys/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Pihole/Rsa/pihole_rsa.crt"      "$CIBLE:/etc/ssl/Pihole/Cert/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Pihole/Ecdsa/pihole_ecdsa.crt"  "$CIBLE:/etc/ssl/Pihole/Cert/"

# Upsnap
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Upsnap/Rsa/upsnap_rsa.key"     "$CIBLE:/etc/ssl/Upsnap/Keys/"
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Upsnap/Ecdsa/upsnap_ecdsa.key" "$CIBLE:/etc/ssl/Upsnap/Keys/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Upsnap/Rsa/upsnap_rsa.crt"      "$CIBLE:/etc/ssl/Upsnap/Cert/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Upsnap/Ecdsa/upsnap_ecdsa.crt"  "$CIBLE:/etc/ssl/Upsnap/Cert/"

# Cockpit
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Cockpit/Rsa/cockpit_rsa.key"     "$CIBLE:/etc/ssl/Cockpit/Keys/"
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Cockpit/Ecdsa/cockpit_ecdsa.key" "$CIBLE:/etc/ssl/Cockpit/Keys/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Cockpit/Rsa/cockpit_rsa.crt"      "$CIBLE:/etc/ssl/Cockpit/Cert/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Cockpit/Ecdsa/cockpit_ecdsa.crt"  "$CIBLE:/etc/ssl/Cockpit/Cert/"

# chown uniquement sur les sous-dossiers concernés
ssh "$CIBLE" "
    chown -R sednal:sednal /etc/ssl/Pihole/
    chown -R sednal:sednal /etc/ssl/Upsnap/
    chown -R sednal:sednal /etc/ssl/Cockpit/
    chown -R root:root     /etc/ssl/CA/
"

ssh "$CIBLE" "cp /etc/ssl/CA/Sednal_Root_All.crt \
                  /etc/ssl/CA/ca_chain_rsa.crt \
                  /etc/ssl/CA/ca_chain_ecdsa.crt \
                  /usr/local/share/ca-certificates/ \
              && sudo update-ca-certificates --fresh"

# ---------------------------------------------------------------------------
# Déploiement — PROXMOX (192.168.0.242)
# ---------------------------------------------------------------------------
echo "=== Déploiement PROXMOX ==="
CIBLE="sednal@192.168.0.242"

ssh "$CIBLE" "rm -f /etc/ssl/proxmox/Keys/* /etc/ssl/proxmox/Cert/* /etc/ssl/proxmox/CA/*"

rsync -e ssh --no-p --chmod=F644 \
    "$BASE_CA/Sednal_Root_All.crt" \
    "$BASE_CA/ca_chain_rsa.crt" \
    "$BASE_CA/ca_chain_ecdsa.crt" \
    "$CIBLE:/etc/ssl/proxmox/CA/"

rsync -e ssh --no-p --chmod=F600 "$BASE/private/Proxmox/Rsa/proxmox_rsa.key"     "$CIBLE:/etc/ssl/proxmox/Keys/"
rsync -e ssh --no-p --chmod=F600 "$BASE/private/Proxmox/Ecdsa/proxmox_ecdsa.key" "$CIBLE:/etc/ssl/proxmox/Keys/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Proxmox/Rsa/proxmox_rsa.crt"      "$CIBLE:/etc/ssl/proxmox/Cert/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/Proxmox/Ecdsa/proxmox_ecdsa.crt"  "$CIBLE:/etc/ssl/proxmox/Cert/"

ssh "$CIBLE" "chown -R root:root /etc/ssl/proxmox/"

# ---------------------------------------------------------------------------
# Déploiement — VPS (176.31.163.227)
# ---------------------------------------------------------------------------
echo "=== Déploiement VPS ==="
CIBLE="debian@176.31.163.227"

ssh "$CIBLE" "rm -f /etc/ssl/vps/Keys/* /etc/ssl/vps/Cert/* /etc/ssl/vps/CA/*"

rsync -e ssh --no-p --chmod=F644 \
    "$BASE_CA/Sednal_Root_All.crt" \
    "$BASE_CA/ca_chain_rsa.crt" \
    "$BASE_CA/ca_chain_ecdsa.crt" \
    "$CIBLE:/etc/ssl/vps/CA/"

rsync -e ssh --no-p --chmod=F600 "$BASE/private/VPS/Rsa/vps_rsa.key"      "$CIBLE:/etc/ssl/vps/Keys/"
rsync -e ssh --no-p --chmod=F600 "$BASE/private/VPS/Ecdsa/vps_ecdsa.key"  "$CIBLE:/etc/ssl/vps/Keys/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/VPS/Rsa/vps_rsa.crt"       "$CIBLE:/etc/ssl/vps/Cert/"
rsync -e ssh --no-p --chmod=F644 "$BASE/public/VPS/Ecdsa/vps_ecdsa.crt"   "$CIBLE:/etc/ssl/vps/Cert/"

ssh "$CIBLE" "chown -R debian:debian /etc/ssl/vps/"

echo "=== Renouvellement et déploiement terminés ==="
