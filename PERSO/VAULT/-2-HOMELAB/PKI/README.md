## Convention de nommage

 > ### {émetteur} _ {role} _ {algo} - {génération}

```
=== CA ===
Sednal_Root_R-1    → Root CA RSA          1
Sednal_Root_E-1    → Root CA ECDSA        1
Sednal_Inter_R-1   → Intermediate RSA     1
Sednal_Inter_E-1   → Intermediate ECDSA   1
```

```
=== LEAF ===
proxmox_rsa        → Proxmox RSA
proxmox_ecdsa      → Proxmox ECDSA
```


R = RSA  |  E = ECDSA  



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
└──────────────────────────────────────────────────────────────────────┘
```
