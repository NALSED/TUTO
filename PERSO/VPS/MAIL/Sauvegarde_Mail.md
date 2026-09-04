# Sauvegarde du serveur mail (DMS + SoGo)

---

Sauvegarde de la base de données et des mails du `VPS 176.31.163.227` vers le
serveur de sauvegarde `BAREOS 192.168.0.240`.

---

## `-1-` Principe

- Le VPS produit ses propres sauvegardes localement, chaque nuit.

- Le serveur Bareos les rapatrie juste avant sa sauvegarde du dimanche, via un
`RunBeforeJob` du job `Lin_BackUp_Job_LAN`.

- Le dossier de dépôt `/home/sednal/VPS_Mail_BackUp` est inclus dans
`Lin_BackUp_FileSet_LAN`, il part donc sur le RAID10 dans la foulée.

⚠️ `[ATTENTION]` ⚠️

Le sens du transfert est imposé par le réseau : le VPS ne peut pas joindre une
adresse privée du LAN. C'est `192.168.0.240` qui sort vers le VPS sur le port 22,
sans redirection à créer sur pfSense.

Le VPS n'est **pas** déclaré comme client Bareos : aucun port 9102 à ouvrir,
aucune ressource `Client` à créer côté Director.

---

## `-2-` === Schema ===

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

## `-3-` Prérequis

### 3.1) Clé SSH de `sednal@192.168.0.240` autorisée sur le VPS

````
ssh -o BatchMode=yes debian@176.31.163.227 "hostname"
````

**Sortie attendue**

````
vps-sednal
````

### 3.2) `rsync` présent des deux côtés en `192.168.0.240` et `176.31.163.227`

- Verification 
````
which rsync
````

- Le cas échéant
````
sudo apt install -y rsync
````

---

## `-4-` Script de sauvegarde quotidienne sur le VPS `176.31.163.227`

- Créer les dossiers et le fichier

````
mkdir -p /home/debian/script_dms /home/debian/backup
vim /home/debian/script_dms/backup_mail.sh
````

- Éditer

````bash
#!/bin/bash
# ==========================================================
# Sauvegarde quotidienne du serveur mail (DMS + SoGo)
# Dépôt local : /home/debian/backup
# Rétention   : 7 jours
# ==========================================================

set -eu

DEST="/home/debian/backup"
DATE=$(date +%F)
RETENTION=7

mkdir -p "$DEST"

# === Dump de toutes les bases PostgreSQL de SoGo ===
docker exec sogo-postgres pg_dumpall -U postgres \
    | gzip > "$DEST/sogo_pgdump_${DATE}.sql.gz"

# === Archive du dossier DMS (mails + configuration) ===
tar czf "$DEST/dms_${DATE}.tar.gz" -C /home/debian DMS

# === Purge des archives trop anciennes ===
find "$DEST" -name "sogo_pgdump_*.sql.gz" -mtime +$RETENTION -delete
find "$DEST" -name "dms_*.tar.gz"         -mtime +$RETENTION -delete

# === Journal ===
echo "$(date '+%F %T') sauvegarde OK" >> "$DEST/backup.log"
````

- Rendre exécutable
````
chmod +x /home/debian/script_dms/backup_mail.sh
````

`[NOTE]`

`pg_dumpall` évite d'avoir à connaître le nom exact de la base SoGo et sauvegarde
également les rôles et les mots de passe PostgreSQL.

---

## `-5-` Tâche cron sur le VPS `176.31.163.227`

````
crontab -e
````

- Éditer
````
# Sauvegarde quotidienne du serveur mail
30 2 * * * /home/debian/script_dms/backup_mail.sh >> /home/debian/script_dms/cron.log 2>&1
````

`[NOTE]`

Le fichier `cron.log` est placé hors de `/home/debian/backup/` : ce dossier est synchronisé avec `--delete` vers le serveur Bareos.

---

## `-6-` Script de rapatriement sur Bareos `192.168.0.240`

- Créer les dossiers et le fichier
````
mkdir -p /home/sednal/VPS_Mail_BackUp /home/sednal/logs
vim /home/sednal/pull_mail.sh
````

- Éditer

````bash
#!/bin/bash
# ==========================================================
# Rapatriement des sauvegardes mail depuis le VPS
# Lancé par RunBeforeJob de Lin_BackUp_Job_LAN
# Sortie toujours 0 : un échec ne doit pas annuler la sauvegarde
# ==========================================================

SRC="debian@176.31.163.227:/home/debian/backup/"
DEST="/home/sednal/VPS_Mail_BackUp/"
LOG="/home/sednal/logs/pull_mail.log"

mkdir -p "$DEST" "$(dirname "$LOG")"

if rsync -az --delete --timeout=120 \
        -e "ssh -o BatchMode=yes -o ConnectTimeout=15" \
        "$SRC" "$DEST" >> "$LOG" 2>&1
then
    echo "$(date '+%F %T') pull OK - $(du -sh "$DEST" | cut -f1)" >> "$LOG"
    echo "Rapatriement des sauvegardes mail : OK"
else
    echo "$(date '+%F %T') pull ECHEC" >> "$LOG"
    echo "ATTENTION : rapatriement en echec, les donnees du VPS peuvent etre anciennes"
fi

exit 0
````

- Droits
````
chmod +x /home/sednal/pull_mail.sh
sudo chown root:root /home/sednal/pull_mail.sh
sudo chmod 755 /home/sednal/pull_mail.sh
````

`[NOTE]`

Le script sort systématiquement en code 0. Si le VPS est injoignable, la sauvegarde
se poursuit avec les archives de la semaine précédente et un avertissement apparaît
dans le journal du job.

`[NOTE]`

Le journal `pull_mail.log` est placé **hors** du dossier synchronisé, sinon
`rsync --delete` l'effacerait à chaque passage.

---

## `-7-` Règle sudo pour le Director sur `192.168.0.240`

`RunBeforeJob` est exécuté par le Director, sous l'utilisateur `bareos`. 

La clé SSH autorisée sur le VPS étant celle de `sednal`, le script doit être lancé sous cette identité.

````
sudo visudo -f /etc/sudoers.d/bareos-pull
````

- Éditer
````
bareos ALL=(sednal) NOPASSWD: /home/sednal/pull_mail.sh
````

- Tester
````
sudo -u bareos sudo -u sednal /home/sednal/pull_mail.sh
ls -lh /home/sednal/VPS_Mail_BackUp/
cat /home/sednal/logs/pull_mail.log
````

---

## `-8-` Configuration Bareos sur `192.168.0.240`

### 8.1) /etc/bareos/bareos-dir.d/fileset/`Lin_BackUp_FileSet_LAN.conf`

````
FileSet {
    # Nom du FileSet
    Name = Lin_BackUp_FileSet_LAN
    Include {
        Options {
            signature = SHA256
            noatime = yes
        }
        File = "/etc/bareos"
        File = "/home/sednal/.ssh"
        File = "/home/sednal/.psql_history"
        File = "/home/sednal/VPS_Mail_BackUp"
    }
    Exclude {
        File = "/etc/bareos/.bash_logout"
        File = "/home/sednal/.bconsole_history"
        File = "/home/sednal/.lesshst"
        File = "/home/sednal/.profile"
        File = "/home/sednal/.vscode-server"
        File = "/home/sednal/.bash_history"
        File = "/home/sednal/.bashrc"
        File = "/home/sednal/.cache"
        File = "/home/sednal/.cache.dotnet"
        File = "/home/sednal/.sudo_as_admin_successful"
        File = "/home/sednal/.wget-hsts"
    }
}
````

### 8.2) /etc/bareos/bareos-dir.d/fileset/`Lin_BackUp_FileSet_WAN.conf`
````
FileSet {
    # Nom du FileSet
    Name = Lin_BackUp_FileSet_WAN
    Include {
        Options {
            signature = SHA256
            noatime = yes
        }
        File = "/etc/bareos"
        File = "/home/sednal/.ssh"
        File = "/home/sednal/.psql_history"
    }
    Exclude {
        File = "/etc/bareos/.bash_logout"
        File = "/home/sednal/.bconsole_history"
        File = "/home/sednal/.lesshst"
        File = "/home/sednal/.profile"
        File = "/home/sednal/.vscode-server"
        File = "/home/sednal/.bash_history"
        File = "/home/sednal/.bashrc"
        File = "/home/sednal/.cache"
        File = "/home/sednal/.cache.dotnet"
        File = "/home/sednal/.sudo_as_admin_successful"
        File = "/home/sednal/.wget-hsts"
    }
}
````

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

---

## `-9-` Vérification

### 9.1) Test du dump sur le VPS `176.31.163.227`

````
/home/debian/script_dms/backup_mail.sh
ls -lh /home/debian/backup/
````

### 9.2) Test complet du job sur `192.168.0.240`

````
printf "run job=Lin_BackUp_Job_LAN level=Full yes\nquit\n" | sudo bconsole
sleep 30
printf "list jobs\nmessages\nquit\n" | sudo bconsole
````

**RESULTAT ATTENDU**

Le journal du job contient :
````
Rapatriement des sauvegardes mail : OK
````

Et `jobbytes` passe de quelques dizaines de Ko à environ 1,3 Go.

### 9.3) Journaux

````
ls -lh /home/sednal/VPS_Mail_BackUp/
cat /home/sednal/logs/pull_mail.log
ssh debian@176.31.163.227 "tail -20 /home/debian/backup/backup.log"
````

---

## `-10-` Restauration

### 10.1) Récupérer les archives depuis Bareos `192.168.0.240`

````
printf "restore client=lin\nquit\n" | sudo bconsole
````

Sélectionner les fichiers sous `/home/sednal/VPS_Mail_BackUp/`.

### 10.2) Transférer vers le VPS `176.31.163.227`

````
scp /home/sednal/VPS_Mail_BackUp/dms_AAAA-MM-JJ.tar.gz \
    /home/sednal/VPS_Mail_BackUp/sogo_pgdump_AAAA-MM-JJ.sql.gz \
    debian@176.31.163.227:/home/debian/
````

### 10.3) Restaurer les bases SoGo

````
gunzip -c sogo_pgdump_AAAA-MM-JJ.sql.gz | docker exec -i sogo-postgres psql -U postgres
````

### 10.4) Restaurer le dossier DMS

````
docker compose -f /home/debian/DMS/compose.yml down
tar xzf dms_AAAA-MM-JJ.tar.gz -C /home/debian
docker compose -f /home/debian/DMS/compose.yml up -d
````

`[NOTE]`

L'archive contient le dossier `DMS` lui-même : l'extraire dans `/home/debian`
recrée `/home/debian/DMS`.

---

## `-11-` Limites connues

- Le dossier `/home/sednal/VPS_Mail_BackUp` n'est **pas** envoyé en hors-site :
l'envoyer sur le VPS, d'où il provient, n'apporterait aucune protection. Le RAID10
de `192.168.0.240` est le seul dépôt.

- Les archives sont en clair sur les deux disques. Le transfert est chiffré par SSH,
mais `sogo_pgdump_*.sql.gz` contient les hachages de mots de passe PostgreSQL et
`dms_*.tar.gz` contient les mails.

- Les archives rapatriées datent au plus du matin même (cron VPS à 02:30 UTC).

- Volume : 7 jours de rétention à ~180 Mo par jeu, soit ~1,3 Go rapatriés chaque
dimanche.
