# Arborescences SSL — Dossiers par machine (droits réels)

---

## 192.168.0.238 — vault.sednal.lan

```
/etc/Vault/PKI/                              [drwxr-x--- vault:vault]
├── Config/                                  [drwxr-x--- vault:vault]
│   └── Policy/                              [drwxr-x--- vault:vault]
├── Cert_CA/                                 [drwxr-xr-x vault:vault]
│   ├── CSR/                                 [drwx------ vault:vault]
│   ├── Inter/                               [drwxr-xr-x vault:vault]
│   └── Root/                                [drwxr-xr-x vault:vault]
├── private/                                 [drwx------ vault:vault]
│   ├── Bareos/                              [drwx------ vault:vault]
│   │   ├── Ecdsa/                           [drwx------ vault:vault]
│   │   └── Rsa/                             [drwx------ vault:vault]
│   ├── Cockpit/                             [drwx------ vault:vault]
│   │   ├── Ecdsa/                           [drwx------ vault:vault]
│   │   └── Rsa/                             [drwx------ vault:vault]
│   ├── Infra/                               [drwx------ vault:vault]
│   │   ├── Ecdsa/                           [drwx------ vault:vault]
│   │   └── Rsa/                             [drwx------ vault:vault]
│   ├── Pihole/                              [drwx------ vault:vault]
│   │   └── Rsa/                             [drwx------ vault:vault]
│   ├── PostGreSQL/                          [drwx------ vault:vault]
│   │   └── Rsa/                             [drwx------ vault:vault]
│   ├── Proxmox/                             [drwx------ vault:vault]
│   │   ├── Ecdsa/                           [drwx------ vault:vault]
│   │   └── Rsa/                             [drwx------ vault:vault]
│   ├── Upsnap/                              [drwx------ vault:vault]
│   │   └── Rsa/                             [drwx------ vault:vault]
│   └── VPS/                                 [drwx------ vault:vault]
│       └── Rsa/                             [drwx------ vault:vault]
└── public/                                  [drwxr-xr-x vault:vault]
    ├── Bareos/                              [drwxr-xr-x vault:vault]
    │   ├── Ecdsa/                           [drwxr-xr-x vault:vault]
    │   └── Rsa/                             [drwxr-xr-x vault:vault]
    ├── Cockpit/                             [drwxr-xr-x vault:vault]
    │   ├── Ecdsa/                           [drwxr-xr-x vault:vault]
    │   └── Rsa/                             [drwxr-xr-x vault:vault]
    ├── Infra/                               [drwxr-xr-x vault:vault]
    │   ├── Ecdsa/                           [drwxr-xr-x vault:vault]
    │   └── Rsa/                             [drwxr-xr-x vault:vault]
    ├── Pihole/                              [drwxr-xr-x vault:vault]
    │   └── Rsa/                             [drwxr-xr-x vault:vault]
    ├── PostGreSQL/                          [drwxr-xr-x vault:vault]
    │   └── Rsa/                             [drwxr-xr-x vault:vault]
    ├── Proxmox/                             [drwxr-xr-x vault:vault]
    │   ├── Ecdsa/                           [drwxr-xr-x vault:vault]
    │   └── Rsa/                             [drwxr-xr-x vault:vault]
    ├── Upsnap/                              [drwxr-xr-x vault:vault]
    │   └── Rsa/                             [drwxr-xr-x vault:vault]
    └── VPS/                                 [drwxr-xr-x vault:vault]
        └── Rsa/                             [drwxr-xr-x vault:vault]
```

---

## 192.168.0.239 — infra.sednal.lan

```
/etc/infra/                                  [drwxr-xr-x root:root]
├── CA/                                      [drwxr-xr-x sednal:sednal]
├── Cert/                                    [drwxr-xr-x sednal:sednal]
└── Keys/                                    [drwxr-xr-x sednal:sednal]
```

---

## 192.168.0.240 — bareos.sednal.lan

```
/etc/bareos/ssl/                             [drwxrwsr-x bareos:bareos]  ← setgid
├── CA/                                      [drwxrwsr-x bareos:bareos]
├── Cert/                                    [drwxrwsr-x bareos:bareos]
│   ├── client/                              [drwxrwsr-x bareos:bareos]
│   │   ├── lin/                             [drwxrwsr-x bareos:bareos]
│   │   └── win/                             [drwxrwsr-x bareos:bareos]
│   ├── dir/                                 [drwxrwsr-x bareos:bareos]
│   ├── fd/                                  [drwxrwsr-x bareos:bareos]
│   ├── post/                                [drwxrwsr-x bareos:bareos]
│   ├── sd/                                  [drwxrwsr-x bareos:bareos]   
│   │   ├── local/                           [drwxrwsr-x bareos:bareos]
│   │   └── remote/                          [drwxrwsr-x bareos:bareos]
│   └── web/                                 [drwxrwsr-x bareos:bareos]
└── Keys/                                    [drwxrwsr-x bareos:bareos]
    ├── client/                              [drwxrwsr-x bareos:bareos]
    │   ├── lin/                             [drwxrwsr-x bareos:bareos]
    │   └── win/                             [drwxrwsr-x bareos:bareos]
    ├── dir/                                 [drwxrwsr-x bareos:bareos]
    ├── fd/                                  [drwxrwsr-x bareos:bareos]
    ├── post/                                [drwxrwsr-x bareos:bareos]
    ├── sd/                                  [drwxrwsr-x bareos:bareos]
    │   ├── local/                           [drwxrwsr-x bareos:bareos]
    │   └── remote/                          [drwxrwsr-x bareos:bareos]
    └── web/                                 [drwxrwsr-x bareos:bareos]
```

`⚠️ setgid (s) sur tous les dossiers : les fichiers créés héritent automatiquement du groupe bareos`

---

## 192.168.0.241 — pihole.sednal.lan

```
/etc/ssl/                                    [drwxr-xr-x root:root]
├── CA/                                      [drwxr-xr-x sednal:sednal]
├── Cockpit/                                 [drwxr-xr-x root:root]
│   ├── Cert/                                [drwxr-xr-x sednal:sednal]
│   └── Keys/                                [drwxr-xr-x sednal:sednal]
├── Pihole/                                  [drwxr-xr-x root:root]
│   ├── Cert/                                [drwxr-xr-x sednal:sednal]
│   └── Keys/                                [drwxr-xr-x sednal:sednal]
└── Upsnap/                                  [drwxr-xr-x root:root]
    ├── Cert/                                [drwxr-xr-x sednal:sednal]
    └── Keys/                                [drwxr-xr-x sednal:sednal]
```

---

## 192.168.0.242 — proxmox.sednal.lan

```
/etc/ssl/proxmox/                            [drwxr-xr-x root:root]
├── CA/                                      [drwxr-xr-x root:root]
├── Cert/                                    [drwxr-xr-x root:root]
└── Keys/                                    [drwxr-xr-x root:root]
```

---

## 176.31.163.227 — VPS

```
/etc/ssl/                                    [drwxr-xr-x root:root]
├── CA/                                      [drwxrwxr-x debian:debian]
├── Cert/                                    [drwxrwxr-x debian:debian]
└── Keys/                                    [drwxrwxr-x debian:debian]
```
