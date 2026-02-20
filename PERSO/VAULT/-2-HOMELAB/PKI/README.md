## Convention de nomage

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
bareos-dir_ecdsa   → Bareos Director ECDSA
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
│  vault_2.sednal.lan       │   │  │  WEB — 192.168.0.239          │   │
│  upsnap.sednal.lan        │   │  │  infra.sednal.lan             │   │
│                           │   │  │  Rôle : Apache2               │   │
│  Rôle :                   │   │  │  Certs : infra RSA+ECDSA      │   │
│  • DNS Pihole + Unbound   │   │  └───────────────────────────────┘   │
│  • Vault Keys Provider    │   │                                      │
│  • Apache2 CRL :80        │   │  ┌───────────────────────────────┐   │
│  • Bareos FD              │   │  │  SAUVEGARDE — 192.168.0.240   │   │
│  • Cockpit + Upsnap       │   │  │  bareos.sednal.lan            │   │
│                           │   │  │  Rôle : Bareos DIR/SD/FD/Web  │   │
│  /var/www/pki/            │   │  │         PostgreSQL            │   │
│  ├── root_r.crl           │   │  │  Certs : bareos/postgresql    │   │
│  ├── root_e.crl           │   │  │          RSA+ECDSA            │   │
│  ├── intermediate_r.crl   │   │  └───────────────────────────────┘   │
│  └── intermediate_e.crl   │   │                                      │
│                           │   │  ┌───────────────────────────────┐   │
└───────────────────────────┘   │  │  PROXMOX — 192.168.0.242      │   │
             ^                  │  │  proxmox.sednal.lan           │   │
             │ Consulte CRL     │  │  Rôle : Hyperviseur VMs/CTs   │   │
             └──────────────────┤  │  Certs : proxmox RSA+ECDSA    │   │
                                │  └───────────────────────────────┘   │
                                │                                      │
                                │  ┌───────────────────────────────┐   │
                                │  │  VPS — 176.31.163.227         │   │
                                │  │  Rôle : Bareos FD/SD distant  │   │
                                │  │  Certs : vps RSA+ECDSA        │   │
                                │  └───────────────────────────────┘   │
                                └──────────────────────────────────────┘

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

| Machine | IP | Certs |
|---|---|---|
| infra.sednal.lan | 192.168.0.239 | infra RSA+ECDSA |
| bareos.sednal.lan | 192.168.0.240 | dir / sd / fd / web / postgresql RSA+ECDSA |
| pihole.sednal.lan | 192.168.0.241 | pihole / upsnap / cockpit RSA+ECDSA |
| proxmox.sednal.lan | 192.168.0.242 | proxmox RSA+ECDSA |
| VPS | 176.31.163.227 | vps RSA+ECDSA |
| Toutes machines | — | Sednal_Root_All.crt dans store système |


---

# Arborécences

## **Vault : 192.168.0.238**
```
# ARBORECENCE FICHIER
/etc/Vault
├── PKI
   │
   ├── Config
   │     └── Policy
   │    
   ├── private
   │   ├── Bareos
   │   │   ├── Rsa
   │   │   │   ├── bareos-dir_rsa.key
   │   │   │   ├── bareos-fd_rsa.key
   │   │   │   ├── bareos-sd_rsa.key
   │   │   │   └── bareos_rsa.key
   │   │   └── Ecdsa
   │   │       ├── bareos-dir_ecdsa.key
   │   │       ├── bareos-fd_ecdsa.key
   │   │       ├── bareos-sd_ecdsa.key
   │   │       └── bareos_ecdsa.key
   │   │
   │   ├── Infra
   │   │   ├── Rsa
   │   │   │   └── infra_rsa.key
   │   │   └── Ecdsa
   │   │       └── infra_ecdsa.key
   │   │
   │   ├── Pihole
   │   │   ├── Rsa
   │   │   │   └── pihole_rsa.key
   │   │   └── Ecdsa
   │   │       └── pihole_ecdsa.key
   │   │
   │   ├── Proxmox
   │   │   ├── Rsa
   │   │   │   └── proxmox_rsa.key
   │   │   └── Ecdsa
   │   │       └── proxmox_ecdsa.key
   │   │
   │   ├── PostGreSQL
   │   │   ├── Rsa
   │   │   │   └── postgresql_rsa.key
   │   │   └── Ecdsa
   │   │        └── postgresql_ecdsa.key
   │   ├── VPS
   │   │   ├── Rsa
   │   │   │   └── vps_rsa.key
   │   │   └── Ecdsa
   │   │        └── vps_ecdsa.key 
   │   ├── Cockpit
   │   │   ├── Rsa
   │   │   │   └── cockpit_rsa.key
   │   │   └── Ecdsa
   │   │        └── cockpit_ecdsa.key 
   │   │  
   │   │
   │   └── Upsnap
   │       ├── Rsa
   │       │   └── upsnap_rsa.key
   │       └── Ecdsa
   │           └── upsnap_ecdsa.key
   │
   ├── public
   │   ├── Bareos
   │   │   ├── Rsa
   │   │   │   ├── bareos-dir_rsa.crt
   │   │   │   ├── bareos-fd_rsa.crt
   │   │   │   ├── bareos-sd_rsa.crt
   │   │   │   └── bareos_rsa.crt
   │   │   └── Ecdsa
   │   │       ├── bareos-dir_ecdsa.crt
   │   │       ├── bareos-fd_ecdsa.crt
   │   │       ├── bareos-sd_ecdsa.crt
   │   │       └── bareos_ecdsa.crt
   │   │
   │   ├── Infra
   │   │   ├── Rsa
   │   │   │   └── infra_rsa.crt
   │   │   └── Ecdsa
   │   │       └── infra_ecdsa.crt
   │   │
   │   ├── Pihole
   │   │   ├── Rsa
   │   │   │   └── pihole_rsa.crt
   │   │   └── Ecdsa
   │   │       └── pihole_ecdsa.crt
   │   │
   │   ├── Proxmox
   │   │   ├── Rsa
   │   │   │   └── proxmox_rsa.crt
   │   │   └── Ecdsa
   │   │       └── proxmox_ecdsa.crt
   │   │
   │   ├── PostGreSQL
   │   │   ├── Rsa
   │   │   │   └── postgresql_rsa.crt
   │   │   └── Ecdsa
   │   │        └── postgresql_ecdsa.crt
   │   │
   │   ├── Cockpit
   │   │   ├── Rsa
   │   │   │   └── cockpit_rsa.crt
   │   │   └── Ecdsa
   │   │        └── cockpit_ecdsa.crt 
   │   ├── VPS
   │   │   ├── Rsa
   │   │   │   └── vps_rsa.crt
   │   │   └── Ecdsa
   │   │        └── vps_ecdsa.crt 
   │   └── Upsnap
   │       ├── Rsa
   │       │   └── upsnap_rsa.crt
   │       └── Ecdsa
   │           └── upsnap_ecdsa.crt
   │
   └── Cert_CA
          ├── Inter 
          │    ├── Sednal_Inter_E-1.cert.pem
          │    └── Sednal_Inter_R-1.cert.pem
          │
          ├── Root
          │      ├── Sednal_Root_R-1.crt
          │      ├── Sednal_Root_E-1.crt
          │      ├── Sednal_Root_XS_1.crt
          │      ├── Sednal_Root_All.crt => Sednal_Root_R-1.crt + Sednal_Root_E-1.crt + Sednal_Root_XS_1.crt
          │      ├── ca_chain_rsa.crt
          │      └── ca_chain_ecdsa.crt   
          │  
          └── CSR
                ├── cross_e1.csr
                ├── Sednal_Inter_R-1.csr
                └── Sednal_Inter_E-1.csr

```
