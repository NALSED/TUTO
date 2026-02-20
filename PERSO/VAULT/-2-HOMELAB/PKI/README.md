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

## Flux PKI

```
Vault 238
   │
   ├── Génère Root RSA + Root ECDSA
   ├── Cross-sign ECDSA par RSA → cert XS
   ├── Génère Inter RSA + Inter ECDSA
   ├── Génère certs leaf par service
   │
   ├── Push CRL → 241 /var/www/pki/  (cron 24h)
   │
   └── SCP certs → chaque machine    (script déploiement)
          └── rm anciens → copy nouveaux → chmod/chown → reload service

241 Apache2 :80
   └── Sert /crl/* ← consulté automatiquement par tous les clients TLS
```

---

## Certificats par machine

| Machine | IP | Certs |
|---|---|---|
| infra.sednal.lan | 192.168.0.239 | infra RSA+ECDSA |
| bareos.sednal.lan | 192.168.0.240 | dir / sd / fd / web / postgresql RSA+ECDSA |
| pihole.sednal.lan | 192.168.0.241 | pihole / upsnap / cockpit RSA+ECDSA |
| proxmox.sednal.lan | 192.168.0.242 | proxmox RSA+ECDSA |
| VPS | 176.31.163.227 | bareos-fd RSA+ECDSA |
| Toutes machines | — | Sednal_Root_All.crt dans store système |
