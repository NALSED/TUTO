#!/bin/bash
set -e   # Arrête le script immédiatement si une commande échoue

generation(){
    # Génération clé privée + CSR
    openssl req -newkey rsa:4096 \
        -keyout /etc/Vault/Vault_Auto/Cert/private/Vault_Auto.key \
        -out /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr \
        -nodes \
        -config /etc/Vault/Vault_Auto/Config/Vault_Auto.cnf

    # Signature du certificat par la CA
    openssl x509 -req \
        -in /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr \
        -CA /etc/Vault/CA_Vault/Cert/public/CA.crt \
        -CAkey /etc/Vault/CA_Vault/Cert/private/CA.key \
        -CAserial /etc/Vault/CA_Vault/Cert/public/CA.srl \
        -out /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.crt \
        -days 365 \
        -sha256 \
        -extfile /etc/Vault/Vault_Auto/Config/Vault_Auto.cnf \
        -extensions req_ext

    # Suppression du CSR
    rm -f /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr

    # Permissions finales
    chmod 640 /etc/Vault/Vault_Auto/Cert/private/Vault_Auto.key
    chmod 644 /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.crt
}

# ===================================

# Test si le CSR existe
if [ -f "/etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr" ]; then
    rm -f /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.csr
fi

# Nettoyage des anciens fichiers
rm -f /etc/Vault/Vault_Auto/Cert/public/Vault_Auto.crt
rm -f /etc/Vault/Vault_Auto/Cert/private/Vault_Auto.key

# Génération des nouveaux certificats
generation
