## Implementation et Gestion Backup `DMS` et `PostGreSQL`

---
Cette Partie montre la sauvegarde de la base de donnée ainsi que les mails de `DMS`.

````
┌──────────────────────────────────────────────────────────────────┐
│  VPS  176.31.163.227                            (allumé 24/7)    │
├──────────────────────────────────────────────────────────────────┤
│  02:30 UTC quotidien — backup_mail.sh                            │
│    ├─ pg_dumpall du conteneur sogo-postgres                      │
│    ├─ tar.gz de ~/DMS                          (~174 Mo)         │
│    ├─ dépôt dans /home/debian/backup/                            │
│    └─ purge des archives de plus de 7 jours                      │
└─────────────────────────────▲────────────────────────────────────┘
                              │ rsync over SSH (240 tire)
                              │ sortant, port 22, aucune ouverture
┌─────────────────────────────┴────────────────────────────────────┐
│  Bareos  192.168.0.240                        (WOL 11:00)        │
├──────────────────────────────────────────────────────────────────┤
│  12:00  Lin_BackUp_Job_LAN                                       │
│    ├─ RunBeforeJob : pull_mail.sh                                │
│    │    rsync VPS:/home/debian/backup/                           │
│    │       -> /home/sednal/VPS_Mail_BackUp/                      │
│    └─ sauvegarde du FileSet, VPS_Mail_BackUp inclus              │
│                                                                  │
│         -> RAID10  /var/lib/bareos/storage                       │
└──────────────────────────────────────────────────────────────────┘
````
---

`SOMMAIRE`

-1- `Principes` => [Lien]()

-2- `Prérequis` => [Lien]() 

-3- `Script sauvegarde sur VPS` => [Lien]()

-4- `Script rapatriement sur serveur de sauvegarde` => [Lien]()

-5- `Configuration supplémentaire de Bareos` => [Lien]()

-6- `Vérification` => [Lien]()

-7- `Restauration` => [Lien]()

