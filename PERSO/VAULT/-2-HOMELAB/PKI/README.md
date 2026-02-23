## Convention de nommage

 > ### {émetteur} _ {role} _ {algo} - {génération}

```
=== CA ===
Sednal_Root_R-1    → Root CA RSA          gen 1
Sednal_Root_E-1    → Root CA ECDSA        gen 1
Sednal_Root_XS-1   → Cross-sign           gen 1
Sednal_Inter_R-1   → Intermediate RSA     gen 1
Sednal_Inter_E-1   → Intermediate ECDSA   gen 1
```

```
=== LEAF ===
proxmox_rsa        → Proxmox RSA
proxmox_ecdsa      → Proxmox ECDSA
bareos-dir_rsa     → Bareos Director RSA
...

R = RSA  |  E = ECDSA  |  XS = Cross-Sign
```


# Plan de Flux PKI — Sednal

```
┌──────────────────────────────────────────────────────────────────────┐
│  VAULT ADMIN — 192.168.0.238 — vault.sednal.lan                      │
│                                                                      │
│  Rôle : Génération Root CA / Inter CA / Certs leaf / CRL             │
│  PKI  : PKI_Sednal_Root_RSA   | PKI_Sednal_Root_ECDSA               │
│         PKI_Sednal_Inter_RSA  | PKI_Sednal_Inter_ECDSA              │
└──────────┬───────────────────────────────────────┬───────────────────┘
           │                                       │
           │ * Push CRL (cron 24h)                 │ * SCP certs + clés
           │ * SCP certs + clés                    │ * Renouvellement
           │ * Renouvellement                      │
           v                                       v
┌───────────────────────────┐   ┌──────────────────────────────────────┐
│  PI — 192.168.0.241       │   │                                      │
│  pihole.sednal.lan        │   │  ┌───────────────────────────────┐   │
│  upsnap.sednal.lan        │   │  │  WEB — 192.168.0.239          │   │
│                           │   │  │  infra.sednal.lan             │   │
│  Rôle :                   │   │  │  Rôle : Apache2               │   │
│  • DNS Pihole + Unbound   │   │  │  Certs : infra RSA+ECDSA      │   │
│  • Vault Keys Provider    │   │  └───────────────────────────────┘   │
│  • Bareos FD              │   │                                      │
│  • Cockpit + Upsnap       │   │  ┌───────────────────────────────┐   │
│                           │   │  │  SAUVEGARDE — 192.168.0.240   │   │
│  Certs :                  │   │  │  bareos.sednal.lan            │   │
│  • pihole  RSA            │   │  │  Rôle : Bareos DIR/SD/FD/Web  │   │
│  • upsnap  RSA            │   │  │         PostgreSQL            │   │
│  • cockpit RSA+ECDSA      │   │  │  Certs : RSA uniquement       │   │
│                           │   │  └───────────────────────────────┘   │
└───────────────────────────┘   │                                      │
             ^                  │  ┌───────────────────────────────┐   │
             │ Consulte CRL     │  │  PROXMOX — 192.168.0.242      │   │
             │                  │  │  proxmox.sednal.lan           │   │
┌────────────┴──────────────┐   │  │  Rôle : Hyperviseur VMs/CTs   │   │
│  CRL — 192.168.0.239      │   │  │  Certs : proxmox RSA+ECDSA    │   │
│  infra.sednal.lan :80     │   │  └───────────────────────────────┘   │
│                           │   │                                      │
│  /var/www/pki/            │   │  ┌───────────────────────────────┐   │
│  ├── root_r.crl           │   │  │  VPS — 176.31.163.227         │   │
│  ├── root_e.crl           │   │  │  Rôle : Bareos SD distant     │   │
│  ├── intermediate_r.crl   │   │  │  Certs : vps RSA uniquement   │   │
│  └── intermediate_e.crl   │   │  └───────────────────────────────┘   │
└───────────────────────────┘   └──────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────┐
│  ADMIN PC — 192.168.0.235                                            │
│  Rôle : Administration Vault / Docker / WSL                          │
│  Store : Sednal_Root_All.crt installé                                │
└──────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────┐
│  FIREWALL — 192.168.0.1 — Pfsense                                    │
│  Rôle : DNS-1 / DHCP / Gateway                                       │
│  Store : Sednal_Root_All.crt installé                                │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Certificats par machine

| Machine | IP | Algorithme | Certs |
|---|---|---|---|
| infra.sednal.lan | 192.168.0.239 | RSA + ECDSA | infra |
| bareos.sednal.lan | 192.168.0.240 | RSA uniquement | dir / sd-local / sd-remote / fd / web / postgresql |
| pihole.sednal.lan | 192.168.0.241 | RSA uniquement | pihole / upsnap |
| pihole.sednal.lan | 192.168.0.241 | RSA + ECDSA | cockpit |
| proxmox.sednal.lan | 192.168.0.242 | RSA + ECDSA | proxmox |
| VPS | 176.31.163.227 | RSA uniquement | vps |
| Toutes machines | — | — | Sednal_Root_All.crt dans store système |

---

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
