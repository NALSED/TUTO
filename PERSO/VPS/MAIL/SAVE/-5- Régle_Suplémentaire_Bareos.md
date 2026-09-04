
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

- `- 5.4` Modifier le fichier
````
/etc/bareos/bareos-dir.d/fileset/Lin_BackUp_FileSet_LAN.conf
````


### 8.2) /etc/bareos/bareos-dir.d/fileset/`Lin_BackUp_FileSet_WAN.conf`


⚠️ `[ATTENTION]` ⚠️

Sans ce FileSet dédié, `Lin_BackUp_Job_WAN` renverrait les sauvegardes du VPS
**sur le VPS lui-même** : aucun intérêt en hors-site, et volume transféré doublé.

- Basculer le job WAN dessus

````
sudo sed -i 's/FileSet = Lin_BackUp_FileSet_LAN/FileSet = Lin_BackUp_FileSet_WAN/' \
    /etc/bareos/bareos-dir.d/job/Lin_BackUp_Job_WAN.conf
````

### 8.3) /etc/bareos/bareos-dir.d/job/`Lin_BackUp_Job_LAN.conf`

````
Job {
      Name = Lin_BackUp_Job_LAN
      Type = Backup
      Client = lin
      FileSet = Lin_BackUp_FileSet_LAN
      Schedule = Lin_Schedule_LAN
      Storage = Storage_Local
      Pool = Lin_BackUp_Pool_LAN
      Messages = Standard
      Priority = 10
      RunBeforeJob = "/usr/bin/sudo -u sednal /home/sednal/pull_mail.sh"
      }
````

### 8.4) Contrôle et rechargement

````
sudo bareos-dir -t -f
printf "reload\nshow job=Lin_BackUp_Job_LAN\nquit\n" | sudo bconsole
````
