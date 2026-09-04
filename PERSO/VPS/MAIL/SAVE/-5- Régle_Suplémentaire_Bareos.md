## `-5-` Récapitulatif des règles supplémentaires dans Bareos

---

### `- 5.1` Ouvrir le fichier sudoers.d

````
sudo visudo -f /etc/sudoers.d/bareos-pull
````

### `- 5.2` Éditer

````
bareos ALL=(sednal) NOPASSWD: /home/sednal/pull_mail.sh
````

`[NOTE]`

`RunBeforeJob` est exécuté par le Director sous l'utilisateur `bareos`.
La clé SSH autorisée sur le VPS étant celle de `sednal`, le script doit être lancé
sous cette identité via `sudo`. Une clé dédiée à `bareos` serait une alternative,
mais la règle sudo a été retenue.

### `- 5.3` Tester

````
sudo -u bareos sudo -u sednal /home/sednal/pull_mail.sh
ls -lh /home/sednal/VPS_Mail_BackUp/
cat /home/sednal/logs/pull_mail.log
````

---

### `- 5.4` Modifier le FileSet LAN

````
vim /etc/bareos/bareos-dir.d/fileset/Lin_BackUp_FileSet_LAN.conf
````

Ajout de la ligne :

````
File = "/home/sednal/VPS_Mail_BackUp"
````

### `- 5.5` Créer le FileSet WAN

````
vim /etc/bareos/bareos-dir.d/fileset/Lin_BackUp_FileSet_WAN.conf
````

⚠️ `[ATTENTION]` ⚠️

Sans ce FileSet dédié, `Lin_BackUp_Job_WAN` renverrait les sauvegardes du VPS
`sur le VPS lui-même` : aucun intérêt en hors-site, et volume transféré multiplié
par 4000 (117 Mo au lieu de 28 Ko).

### `- 5.6` Modifier le job LAN

````
vim /etc/bareos/bareos-dir.d/job/Lin_BackUp_Job_LAN.conf
````

Ajout de la ligne :

````
RunBeforeJob = "/usr/bin/sudo -u sednal /home/sednal/pull_mail.sh"
````
