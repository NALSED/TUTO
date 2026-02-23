# Arborescences SSL — Machines clientes PKI Sednal

---

## 192.168.0.239 — infra.sednal.lan (Apache2)

```
/etc/infra
├── CA
│   ├── Sednal_Root_All.crt
│   ├── ca_chain_rsa.crt
│   └── ca_chain_ecdsa.crt
│
├── Cert
│   ├── infra_rsa.crt
│   └── infra_ecdsa.crt
│
└── Keys
    ├── infra_rsa.key       (600 sednal:sednal)
    └── infra_ecdsa.key     (600 sednal:sednal)
```

**Config Apache2** `/etc/apache2/sites-available/default-ssl` :
```
SSLCertificateFile      /etc/infra/Cert/infra_rsa.crt
SSLCertificateKeyFile   /etc/infra/Keys/infra_rsa.key
SSLCertificateFile      /etc/infra/Cert/infra_ecdsa.crt
SSLCertificateKeyFile   /etc/infra/Keys/infra_ecdsa.key
```

**Point de distribution CRL** `/var/www/pki/` :
```
/var/www/pki
├── root_r.crl
├── root_e.crl
├── intermediate_r.crl
└── intermediate_e.crl
```

---

## 192.168.0.240 — bareos.sednal.lan (Bareos + PostgreSQL)

```
/etc/bareos/ssl
├── CA
│   └── Sednal_Root_All.crt                      (644 bareos:bareos)
│
├── Cert
│   ├── dir
│   │   └── bareos-dir_rsa.crt
│   ├── fd
│   │   └── bareos-fd_rsa.crt
│   ├── sd
│   │   ├── local
│   │   │   └── bareos-sd-local_rsa.crt
│   │   └── remote
│   │       └── bareos-sd-remote_rsa.crt
│   ├── web
│   │   └── bareos_rsa.crt
│   ├── post
│   │   └── postgresql_rsa.crt
│   └── client
│       ├── win
│       │   └── win_rsa.crt
│       └── lin
│           └── lin_rsa.crt
│
├── Keys
│   ├── dir
│   │   └── bareos-dir_rsa.key          (600 bareos:bareos)
│   ├── fd
│   │   └── bareos-fd_rsa.key           (600 bareos:bareos)
│   ├── sd
│   │   ├── local
│   │   │   └── bareos-sd-local_rsa.key (600 bareos:bareos)
│   │   └── remote
│   │       └── bareos-sd-remote_rsa.key(600 bareos:bareos)
│   ├── web
│   │   └── bareos_rsa.key              (600 bareos:bareos)
│   ├── post
│   │   └── postgresql_rsa.key          (640 bareos:bareos)
│   └── client
│       ├── win
│       │   └── win_rsa.key             (600 bareos:bareos)
│       └── lin
│           └── lin_rsa.key             (600 bareos:bareos)
│
└── web
    └── bareos_webui.pem    ← cat bareos_rsa.crt + bareos_rsa.key
                               (640 bareos:bareos)
```

**Groupes requis** :
```
sudo usermod -aG bareos sednal
sudo usermod -aG bareos postgres
```

**Config Bareos Director** `/etc/bareos/bareos-dir.d/director/bareos-dir.conf` :
```
TLS Certificate = /etc/bareos/ssl/Cert/dir/bareos-dir_rsa.crt
TLS Key         = /etc/bareos/ssl/Keys/dir/bareos-dir_rsa.key
TLS CA Certificate File = /etc/bareos/ssl/CA/Sednal_Root_All.crt
```

**Config PostgreSQL** `/etc/postgresql/18/main/postgresql.conf` :
```
ssl_cert_file = '/etc/bareos/ssl/Cert/post/postgresql_rsa.crt'
ssl_key_file  = '/etc/bareos/ssl/Keys/post/postgresql_rsa.key'
ssl_ca_file   = '/etc/bareos/ssl/CA/Sednal_Root_All.crt'
```

---

## 192.168.0.241 — pihole.sednal.lan (Pihole + Upsnap + Cockpit)

```
/etc/ssl
├── CA
│   ├── Sednal_Root_All.crt
│   ├── ca_chain_rsa.crt
│   └── ca_chain_ecdsa.crt
│
├── Pihole                           (RSA uniquement)
│   ├── Cert
│   │   └── pihole_rsa.crt
│   └── Keys
│       └── pihole_rsa.key          (600 sednal:sednal)
│
├── Upsnap                           (RSA uniquement)
│   ├── Cert
│   │   └── upsnap_rsa.crt
│   └── Keys
│       └── upsnap_rsa.key          (600 sednal:sednal)
│
└── Cockpit                          (RSA + ECDSA)
    ├── Cert
    │   ├── cockpit_rsa.crt
    │   └── cockpit_ecdsa.crt
    └── Keys
        ├── cockpit_rsa.key         (600 sednal:sednal)
        └── cockpit_ecdsa.key       (600 sednal:sednal)
```

**Cockpit — fichiers PEM déployés** `/etc/cockpit/ws-certs.d/` :
```
/etc/cockpit/ws-certs.d
├── cockpit.cert    ← cat cockpit_rsa.crt + cockpit_rsa.key
│                      (640 root:cockpit-ws)
└── cockpit_ecdsa.cert  ← cat cockpit_ecdsa.crt + cockpit_ecdsa.key
                           (640 root:cockpit-ws)
```

**Config Pihole** `/etc/pihole/pihole.toml` (section `[webserver]`) :
```
ssl_cert = "/etc/ssl/Pihole/Cert/pihole_rsa.crt"
ssl_key  = "/etc/ssl/Pihole/Keys/pihole_rsa.key"
```

**Config Upsnap** `/etc/upsnap/config.env` :
```
UPSNAP_SSL_CERT=/etc/ssl/Upsnap/Cert/upsnap_rsa.crt
UPSNAP_SSL_KEY=/etc/ssl/Upsnap/Keys/upsnap_rsa.key
```

---

## 192.168.0.242 — proxmox.sednal.lan (Proxmox)

```
/etc/ssl/proxmox
├── CA
│   ├── Sednal_Root_All.crt
│   ├── ca_chain_rsa.crt
│   └── ca_chain_ecdsa.crt
│
├── Cert
│   ├── proxmox_rsa.crt
│   └── proxmox_ecdsa.crt
│
└── Keys
    ├── proxmox_rsa.key             (600 root:root)
    └── proxmox_ecdsa.key           (600 root:root)
```

**Déploiement vers Proxmox** (copié dans les chemins natifs PVE) :
```
/etc/pve/local
├── pve-ssl.pem   ← proxmox_rsa.crt
└── pve-ssl.key   ← proxmox_rsa.key
```

**SSH** : `root@192.168.0.242`

---

## 176.31.163.227 — VPS (Bareos SD remote)

```
/etc/ssl
├── CA
│   └── Sednal_Root_All.crt
│
├── Cert
│   └── vps_rsa.crt
│
└── Keys
    └── vps_rsa.key                 (600 debian:debian)
```

**Config Bareos SD Remote** `/etc/bareos/bareos-sd.d/storage/Remote-Sd.conf` :
```
TLS Certificate = /etc/ssl/Cert/vps_rsa.crt
TLS Key         = /etc/ssl/Keys/vps_rsa.key
TLS CA Certificate File = /etc/ssl/CA/Sednal_Root_All.crt
```

**Config Director-Sd** `/etc/bareos/bareos-sd.d/director/bareos-dir.conf` :
```
TLS Certificate = /etc/ssl/Cert/vps_rsa.crt
TLS Key         = /etc/ssl/Keys/vps_rsa.key
TLS CA Certificate File = /etc/ssl/CA/Sednal_Root_All.crt
TLS Verify Peer = yes
TLS Allowed CN  = "bareos.sednal.lan"
```

**SSH** : `debian@176.31.163.227`

---

## Récapitulatif des droits

| Chemin | Droits | Propriétaire |
|---|---|---|
| Clés privées (standard) | 600 | selon service |
| Clé privée PostgreSQL | 640 | bareos:bareos |
| Certificats publics | 644 | selon service |
| PEM WebUI Bareos | 640 | bareos:bareos |
| PEM Cockpit | 640 | root:cockpit-ws |
| Dossiers private Vault | 700 | vault:vault |
| Dossiers public Vault | 755 | vault:vault |
| /var/www/pki/ | 755 | sednal:sednal |
