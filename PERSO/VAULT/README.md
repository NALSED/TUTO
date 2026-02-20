# Arborécence Vault 192.168.0.238

vault.sednal.lan (192.168.0.238)
│
├── sys/
│   ├── auth/
│   │   ├── token/                   # Auth par token (défaut)
│   │   └── userpass/                # Auth par user/password
│   │
│   ├── mounts/                      # Moteurs de secrets montés
│   │   ├── PKI_Sednal_Root_RSA/
│   │   ├── PKI_Sednal_Root_ECDSA/
│   │   ├── PKI_Sednal_Inter_RSA/
│   │   ├── PKI_Sednal_Inter_ECDSA/
│   │   └── transit/                 # Auto-unseal
│   │
│   └── policies/
│       └── sednal-pki               # Policy PKI
│
├── transit/                         # Auto-unseal (sur 241)
│   └── keys/
│       └── vault-unseal-key         # Clé de déchiffrement unseal
│
├── PKI_Sednal_Root_RSA/
│   ├── ca                           # Certificat Root RSA
│   ├── crl                          # CRL Root RSA
│   ├── config/
│   │   ├── urls                     # issuing + crl_distribution_points
│   │   └── crl                      # auto_rebuild + enable_delta
│   ├── issuers/                     # Sednal_Root_R-1
│   └── root/
│       └── generate/internal        # Génération Root RSA
│
├── PKI_Sednal_Root_ECDSA/
│   ├── ca                           # Certificat Root ECDSA
│   ├── crl                          # CRL Root ECDSA
│   ├── config/
│   │   ├── urls
│   │   └── crl
│   ├── issuers/                     # Sednal_Root_E-1 + XS-1
│   ├── root/
│   │   └── generate/internal        # Génération Root ECDSA
│   └── intermediate/
│       ├── cross-sign               # Génération CSR cross-sign
│       └── set-signed               # Import cert croisé RSA→ECDSA
│
├── PKI_Sednal_Inter_RSA/
│   ├── ca                           # Certificat Inter RSA
│   ├── crl                          # CRL Inter RSA
│   ├── config/
│   │   ├── urls
│   │   └── crl
│   ├── issuers/                     # Sednal_Inter_R-1
│   ├── intermediate/
│   │   ├── generate/internal        # Génération CSR Inter RSA
│   │   └── set-signed               # Import cert signé par Root RSA
│   ├── roles/
│   │   └── Cert_Inter_RSA           # Rôle émission leaf RSA
│   └── issue/
│       └── Cert_Inter_RSA           # Emission certificats leaf RSA
│
└── PKI_Sednal_Inter_ECDSA/
    ├── ca                           # Certificat Inter ECDSA
    ├── crl                          # CRL Inter ECDSA
    ├── config/
    │   ├── urls
    │   └── crl
    ├── issuers/                     # Sednal_Inter_E-1
    ├── intermediate/
    │   ├── generate/internal        # Génération CSR Inter ECDSA
    │   └── set-signed               # Import cert signé par Root ECDSA
    ├── roles/
    │   └── Cert_Inter_ECDSA         # Rôle émission leaf ECDSA
    └── issue/
        └── Cert_Inter_ECDSA         # Emission certificats leaf ECDSA
