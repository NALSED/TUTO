# Descriptif des différents scripts

---

````
ajout_service.sh => ``
demande_cert.sh => ``
deploiement_ca.sh => `En cas d'echec de ajout_service.sh` Combiner demande_cert.sh + deploiement_ca.sh pour un déploiement total
push-crl.sh => `Poussé des CRL sur serveur Web => 192.168.0.239`
renew_cert.sh => `Renouvelement des Certificats `

DEPLOIEMENT_ARBO => `Déploiement de toutes les arborécence pour tous les services`
   ├── deploiement_vault.sh
   ├── deploiement_bareos.sh
   ├── deploiement_dns.sh
   ├── deploiement_infra.sh
   ├── deploiement_proxmox.sh
   └── deploiement_vps.sh
````
