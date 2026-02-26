# Arborescences SSL — Machines clientes PKI Sednal

---

## 192.168.0.239 — infra.sednal.lan (Apache2)

```
/etc/infra/ssl
├── ca
│   ├── Sednal_Root_All.crt
│   ├── Sednal_Inter_R-1.cert.pem
│   └── Sednal_Inter_E-1.cert.pem
│
├── cert
│   ├── infra_rsa.crt
│   └── infra_ecdsa.crt
│
└── keys
    ├── infra_rsa.key       (600 sednal:sednal)
    └── infra_ecdsa.key     (600 sednal:sednal)
```

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
├── ca
│   ├── Sednal_Root_All.crt                      (644 bareos:bareos)
│   ├── Sednal_Inter_R-1.cert.pem
│   └── Sednal_Inter_E-1.cert.pem
│
├── cert
│   ├── dir
│   │   ├── bareos-dir_rsa.crt
│   │   └── bareos-dir_ecdsa.crt
│   ├── fd
│   │   ├── bareos-fd_rsa.crt
│   │   └── bareos-fd_ecdsa.crt
│   ├── sd
│   │   ├── local
│   │   │   ├── bareos-sd-local_rsa.crt
│   │   │   └── bareos-sd-local_ecdsa.crt
│   │   └── remote
│   │       ├── bareos-sd-remote_rsa.crt
│   │       └── bareos-sd-remote_ecdsa.crt
│   ├── web
│   │   ├── bareos_rsa.crt
│   │   └── bareos_ecdsa.crt
│   ├── post
│   │   ├── postgresql_rsa.crt
│   │   └── postgresql_ecdsa.crt
│   └── client
│       ├── win
│       │   ├── win_rsa.crt
│       │   └── win_ecdsa.crt
│       └── lin
│           ├── lin_rsa.crt
│           └── lin_ecdsa.crt
│
├── keys
│   ├── dir
│   │   ├── bareos-dir_rsa.key          (600 bareos:bareos)
│   │   └── bareos-dir_ecdsa.key        (600 bareos:bareos)
│   ├── fd
│   │   ├── bareos-fd_rsa.key           (600 bareos:bareos)
│   │   └── bareos-fd_ecdsa.key         (600 bareos:bareos)
│   ├── sd
│   │   ├── local
│   │   │   ├── bareos-sd-local_rsa.key (600 bareos:bareos)
│   │   │   └── bareos-sd-local_ecdsa.key (600 bareos:bareos)
│   │   └── remote
│   │       ├── bareos-sd-remote_rsa.key(600 bareos:bareos)
│   │       └── bareos-sd-remote_ecdsa.key(600 bareos:bareos)
│   ├── web
│   │   ├── bareos_rsa.key              (600 bareos:bareos)
│   │   └── bareos_ecdsa.key            (600 bareos:bareos)
│   ├── post
│   │   ├── postgresql_rsa.key          (640 bareos:bareos)
│   │   └── postgresql_ecdsa.key        (640 bareos:bareos)
│   └── client
│       ├── win
│       │   ├── win_rsa.key             (600 bareos:bareos)
│       │   └── win_ecdsa.key           (600 bareos:bareos)
│       └── lin
│           ├── lin_rsa.key             (600 bareos:bareos)
│           └── lin_ecdsa.key           (600 bareos:bareos)
│
└── web
    └── bareos_webui.pem    ← cat bareos_rsa.crt + bareos_rsa.key
                               (640 bareos:bareos)
```

---

## 192.168.0.241 — pihole.sednal.lan (Pihole + Upsnap + Cockpit)

```
/etc/pihole/ssl
├── ca
│   ├── Sednal_Root_All.crt
│   ├── Sednal_Inter_R-1.cert.pem
│   └── Sednal_Inter_E-1.cert.pem
├── cert
│   ├── pihole_rsa.crt
│   └── pihole_ecdsa.crt
└── keys
    ├── pihole_rsa.key      (600 sednal:sednal)
    └── pihole_ecdsa.key    (600 sednal:sednal)

/etc/upsnap/ssl
├── ca
│   ├── Sednal_Root_All.crt
│   ├── Sednal_Inter_R-1.cert.pem
│   └── Sednal_Inter_E-1.cert.pem
├── cert
│   ├── upsnap_rsa.crt
│   └── upsnap_ecdsa.crt
└── keys
    ├── upsnap_rsa.key      (600 sednal:sednal)
    └── upsnap_ecdsa.key    (600 sednal:sednal)

/etc/cockpit/ssl
├── ca
│   ├── Sednal_Root_All.crt
│   ├── Sednal_Inter_R-1.cert.pem
│   └── Sednal_Inter_E-1.cert.pem
├── cert
│   ├── cockpit_rsa.crt
│   └── cockpit_ecdsa.crt
└── keys
    ├── cockpit_rsa.key     (600 sednal:sednal)
    └── cockpit_ecdsa.key   (600 sednal:sednal)
```

---

## 192.168.0.242 — proxmox.sednal.lan (Proxmox)

```
/etc/proxmox/ssl
├── ca
│   ├── Sednal_Root_All.crt
│   ├── Sednal_Inter_R-1.cert.pem
│   └── Sednal_Inter_E-1.cert.pem
│
├── cert
│   ├── proxmox_rsa.crt
│   └── proxmox_ecdsa.crt
│
└── keys
    ├── proxmox_rsa.key             (600 root:root)
    └── proxmox_ecdsa.key           (600 root:root)
```


---

## 176.31.163.227 — VPS (Bareos SD remote)

```
/etc/vps/ssl
├── ca
│   ├── Sednal_Root_All.crt
│   ├── Sednal_Inter_R-1.cert.pem
│   └── Sednal_Inter_E-1.cert.pem
│
├── cert
│   ├── vps_rsa.crt
│   └── vps_ecdsa.crt
│
└── keys
    ├── vps_rsa.key                 (600 debian:debian)
    └── vps_ecdsa.key               (600 debian:debian)
```


---

