#!/bin/bash
set -e   # Arrête le script immédiatement si une commande échoue

generation(){
    # Génération clé privée + CSR
    openssl req -newkey rsa:4096 \
        -keyout /etc/Vault/Vault_Root/Cert/private/Vault_Root.key \
        -out /etc/Vault/Vault_Root/Cert/public/Vault_Root.csr \
        -nodes \
        -config /etc/Vault/Vault_Root/Config/Vault_Root.cnf

    # Signature du certificat par la CA
    openssl x509 -req \
        -in /etc/Vault/Vault_Root/Cert/public/Vault_Root.csr \
        -CA /etc/Vault/CA_Vault/Cert/public/CA.crt \
        -CAkey /etc/Vault/CA_Vault/Cert/private/CA.key \
        -CAserial /etc/Vault/CA_Vault/Cert/public/CA.srl \
        -out /etc/Vault/Vault_Root/Cert/public/Vault_Root.crt \
        -days 365 \
        -sha256 \
        -extfile /etc/Vault/Vault_Root/Config/Vault_Root.cnf \
        -extensions req_ext

    # Suppression du CSR
    rm -f /etc/Vault/Vault_Root/Cert/public/Vault_Root.csr

    # Permissions finales
    chmod 640 /etc/Vault/Vault_Root/Cert/private/Vault_Root.key
    chmod 644 /etc/Vault/Vault_Root/Cert/public/Vault_Root.crt
}

# ===================================

# Test si le CSR existe
if [ -f "/etc/Vault/Vault_Root/Cert/public/Vault_Root.csr" ]; then
    rm -f /etc/Vault/Vault_Root/Cert/public/Vault_Root.csr
fi

# Nettoyage des anciens fichiers
rm -f /etc/Vault/Vault_Root/Cert/public/Vault_Root.crt
rm -f /etc/Vault/Vault_Root/Cert/private/Vault_Root.key

# Génération des nouveaux certificats
generation
