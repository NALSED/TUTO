
# Scripts PKI — Descriptif

---

```
ajout_service.sh          Ajout d'un service après déploiement initial
demande_cert.sh           Demande initiale de tous les certificats
renew_cert.sh             Renouvellement des certificats
deploy_ca.sh              Déploiement des CA uniquement
                          ⚠ En cas d'échec de demande_cert.sh :
                            renew_cert.sh + deploy_ca.sh = déploiement complet
push-crl.sh               Push des CRL vers le serveur Web (192.168.0.239)

DEPLOIEMENT_ARBO          Création des arborescences — à exécuter sur chaque machine
├── deploiement_vault.sh      → vault.sednal.lan
├── deploiement_infra.sh      → infra.sednal.lan
├── deploiement_bareos.sh     → bareos.sednal.lan
├── deploiement_dns.sh        → pihole.sednal.lan
├── deploiement_proxmox.sh    → proxmox.sednal.lan
└── deploiement_vps.sh        → VPS 176.31.163.227
```
