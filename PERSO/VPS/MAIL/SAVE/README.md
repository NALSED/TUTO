## Implémentation et gestion du backup `DMS` et `PostGreSQL`

---

Cette partie montre la sauvegarde de la base de données ainsi que les mails de `DMS`.

````
┌──────────────────────────────────────────────────────────────────┐
│  VPS  176.31.163.227                            (allumé 24/7)    │
├──────────────────────────────────────────────────────────────────┤
│  02:30 UTC quotidien — backup_mail.sh   (cron root)              │
│    ├─ pg_dumpall -U sogo du conteneur sogo-postgres              │
│    ├─ tar.gz de ~/DMS                          (~117 Mo)         │
│    ├─ dépôt dans /home/debian/backup/                            │
│    └─ purge des archives de plus de 7 jours                      │
└─────────────────────────────▲────────────────────────────────────┘
                              │ rsync over SSH (240 tire)
                              │ sortant, port 22, aucune ouverture
┌─────────────────────────────┴────────────────────────────────────┐
│  Bareos  192.168.0.240                        (WOL 12:00)        │
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

-1- `Principes` => [Lien](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/SAVE/-1-%20Principes.md)

-2- `Prérequis` => [Lien](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/SAVE/-2-%20Pr%C3%A9requis.md)

-3- `Script sauvegarde sur VPS` => [Lien](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/SAVE/-3-%20Script_sauvegarde_sur_VPS.md)

-4- `Script rapatriement sur serveur de sauvegarde` => [Lien](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/SAVE/-4-%20Script_Sauvegarde_Serveur.md)

-5- `Configuration supplémentaire de Bareos` => [Lien](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/SAVE/-5-%20R%C3%A9gle_Supl%C3%A9mentaire_Bareos.md)

-6- `Vérification` => [Lien](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/SAVE/-6-%20V%C3%A9rification.md)

-7- `Restauration` => [Lien](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/SAVE/-7-%20Restauration.md)
