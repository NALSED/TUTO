
# Arborescences

## **Vault : 192.168.0.238**

```
/etc/Vault
└── PKI
    │
    ├── Config
    │   └── Policy
    │       └── Policy_PKI.hcl
    │
    ├── private
    │   ├── Bareos
    │   │   ├── Rsa
    │   │   │   ├── bareos-dir_rsa.key
    │   │   │   ├── bareos-fd_rsa.key
    │   │   │   ├── bareos-sd-local_rsa.key
    │   │   │   ├── bareos-sd-remote_rsa.key
    │   │   │   ├── bareos_rsa.key
    │   │   │   ├── win_rsa.key
    │   │   │   └── lin_rsa.key
    │   │   └── Ecdsa
    │   │       (vide — Bareos RSA uniquement)
    │   │
    │   ├── Infra
    │   │   ├── Rsa
    │   │   │   └── infra_rsa.key
    │   │   └── Ecdsa
    │   │       └── infra_ecdsa.key
    │   │
    │   ├── Pihole
    │   │   └── Rsa
    │   │       └── pihole_rsa.key
    │   │
    │   ├── Upsnap
    │   │   └── Rsa
    │   │       └── upsnap_rsa.key
    │   │
    │   ├── Cockpit
    │   │   ├── Rsa
    │   │   │   └── cockpit_rsa.key
    │   │   └── Ecdsa
    │   │       └── cockpit_ecdsa.key
    │   │
    │   ├── Proxmox
    │   │   ├── Rsa
    │   │   │   └── proxmox_rsa.key
    │   │   └── Ecdsa
    │   │       └── proxmox_ecdsa.key
    │   │
    │   ├── PostGreSQL
    │   │   └── Rsa
    │   │       └── postgresql_rsa.key
    │   │
    │   └── VPS
    │       └── Rsa
    │           └── vps_rsa.key
    │
    ├── public
    │   ├── Bareos
    │   │   ├── Rsa
    │   │   │   ├── bareos-dir_rsa.crt
    │   │   │   ├── bareos-fd_rsa.crt
    │   │   │   ├── bareos-sd-local_rsa.crt
    │   │   │   ├── bareos-sd-remote_rsa.crt
    │   │   │   ├── bareos_rsa.crt
    │   │   │   ├── win_rsa.crt
    │   │   │   └── lin_rsa.crt
    │   │   └── Ecdsa
    │   │       (vide — Bareos RSA uniquement)
    │   │
    │   ├── Infra
    │   │   ├── Rsa
    │   │   │   └── infra_rsa.crt
    │   │   └── Ecdsa
    │   │       └── infra_ecdsa.crt
    │   │
    │   ├── Pihole
    │   │   └── Rsa
    │   │       └── pihole_rsa.crt
    │   │
    │   ├── Upsnap
    │   │   └── Rsa
    │   │       └── upsnap_rsa.crt
    │   │
    │   ├── Cockpit
    │   │   ├── Rsa
    │   │   │   └── cockpit_rsa.crt
    │   │   └── Ecdsa
    │   │       └── cockpit_ecdsa.crt
    │   │
    │   ├── Proxmox
    │   │   ├── Rsa
    │   │   │   └── proxmox_rsa.crt
    │   │   └── Ecdsa
    │   │       └── proxmox_ecdsa.crt
    │   │
    │   ├── PostGreSQL
    │   │   └── Rsa
    │   │       └── postgresql_rsa.crt
    │   │
    │   └── VPS
    │       └── Rsa
    │           └── vps_rsa.crt
    │
    └── Cert_CA
        ├── Inter
        │   ├── Sednal_Inter_R-1.cert.pem
        │   └── Sednal_Inter_E-1.cert.pem
        │
        ├── Root
        │   ├── Sednal_Root_R-1.crt
        │   ├── Sednal_Root_E-1.crt
        │   ├── Sednal_Root_XS-1.crt
        │   ├── Sednal_Root_All.crt    ← cat XS-1 + R-1 + E-1
        │   ├── ca_chain_rsa.crt
        │   └── ca_chain_ecdsa.crt
        │
        └── CSR
            ├── cross_e1.csr
            ├── Sednal_Inter_R-1.csr
            └── Sednal_Inter_E-1.csr
```

---

## Structure Vault (moteurs PKI)

```
vault.sednal.lan (192.168.0.238)
│
├── sys/
│   ├── auth/
│   │   ├── token/                   # Auth par token (défaut)
│   │   └── userpass/                # Auth par user/password
│   │
│   ├── mounts/
│   │   ├── PKI_Sednal_Root_RSA/
│   │   ├── PKI_Sednal_Root_ECDSA/
│   │   ├── PKI_Sednal_Inter_RSA/
│   │   ├── PKI_Sednal_Inter_ECDSA/
│   │   └── transit/                 # Auto-unseal
│   │
│   └── policies/
│       └── sednal-pki
│
├── transit/
│   └── keys/
│       └── vault-unseal-key
│
├── PKI_Sednal_Root_RSA/
│   ├── ca
│   ├── crl
│   ├── config/
│   │   ├── urls                     # issuing + crl_distribution_points
│   │   └── crl                      # auto_rebuild + enable_delta
│   ├── issuers/                     # Sednal_Root_R-1
│   └── root/generate/internal
│
├── PKI_Sednal_Root_ECDSA/
│   ├── ca
│   ├── crl
│   ├── config/urls + crl
│   ├── issuers/                     # Sednal_Root_E-1 + XS-1
│   ├── root/generate/internal
│   └── intermediate/
│       ├── cross-sign
│       └── set-signed
│
├── PKI_Sednal_Inter_RSA/
│   ├── ca
│   ├── crl
│   ├── config/urls + crl
│   ├── issuers/                     # Sednal_Inter_R-1
│   ├── intermediate/
│   │   ├── generate/internal
│   │   └── set-signed
│   ├── roles/Cert_Inter_RSA
│   └── issue/Cert_Inter_RSA
│
└── PKI_Sednal_Inter_ECDSA/
    ├── ca
    ├── crl
    ├── config/urls + crl
    ├── issuers/                     # Sednal_Inter_E-1
    ├── intermediate/
    │   ├── generate/internal
    │   └── set-signed
    ├── roles/Cert_Inter_ECDSA
    └── issue/Cert_Inter_ECDSA
```
