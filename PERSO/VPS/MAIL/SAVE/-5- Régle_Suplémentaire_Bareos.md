
## `-5-` Récapitulatif des régles suplémentaire dans Bareos.

---

## Règle sudo pour le `bareos-dir`

- `RunBeforeJob` est exécuté par bareos-dir, sous l'utilisateur `bareos`. 

- La clé SSH autorisée sur le VPS étant celle de `sednal`, le script doit être lancé sous cette identit

- `- 5.1` Ouvrir le fichier sudoers.d
````
sudo visudo -f /etc/sudoers.d/bareos-pull
````

- `- 5.2` Éditer
````
bareos ALL=(sednal) NOPASSWD: /home/sednal/pull_mail.sh
````

- `- 5.3` Tester
````
sudo -u bareos sudo -u sednal /home/sednal/pull_mail.sh
ls -lh /home/sednal/VPS_Mail_BackUp/
cat /home/sednal/logs/pull_mail.log
````

---

##  Configuration Bareos supplémentaire

- Le fichier suivant on été modifié pour répondre aux besoin de la sauvegarde.

`- 5.4` Modifier le fichier
````
vim /etc/bareos/bareos-dir.d/fileset/Lin_BackUp_FileSet_LAN.conf
````


`- 5.5` Création du fichier
````
vim /etc/bareos/bareos-dir.d/fileset/Lin_BackUp_FileSet_WAN.conf
````

⚠️ `[ATTENTION]` ⚠️

Sans ce FileSet dédié, `Lin_BackUp_Job_WAN` renverrait les sauvegardes du VPS
`sur le VPS lui-même` : aucun intérêt en hors-site, et volume transféré doublé.

`- 5.6` Création du fichier

````
vim /etc/bareos/bareos-dir.d/job/Lin_BackUp_Job_LAN.conf
````
