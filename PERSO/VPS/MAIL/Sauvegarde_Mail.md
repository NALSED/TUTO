# Sauvegarde du serveur mail (DMS + SoGo)

---

Procédure compléte de sauvegarde de la base de données et des mail depuis le `VPS 176.31.163.227`, via `PC ADMIN 192.168.0.235` sur le serveur de sauvegarde `BAREOS 192.168.0.240`

---

## `-1-` Principe

- Le Serveur DMS produit ses propres sauvegardes localement, puis les dépose sur `A:/save` du
PC Windows `192.168.0.235`. 

- Ce chemin étant déjà couvert par `Win_BackUp_FileSet_LAN`, la sauvegarde Bareos du dimanche les embarque
automatiquement vers le RAID10 du serveur `192.168.0.240`.

---

## `-2-` Schema

````
┌─────────────────────────────────────────────────────────────────┐
│  VPS  176.31.163.227          (allume 24/7)                     │
├─────────────────────────────────────────────────────────────────┤
│  02:30  quotidien                                               │
│    ├─ pg_dumpall du conteneur sogo-postgres                     │
│    ├─ tar.gz de ~/DMS  (174 Mo)                                 │
│    ├─ depot dans /home/debian/backup/                           │
│    └─ purge des archives de plus de 7 jours                     │
│                                                                 │
│  11:05  dimanche                                                │
│    └─ rsync /home/debian/backup/ ──────────┐                    │
└────────────────────────────────────────────┼────────────────────┘
                                             │ SSH
                                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  PC Windows  192.168.0.235    (WOL a 11:00)                     │
├─────────────────────────────────────────────────────────────────┤
│  A:/save/VPS_Mail/                                              │
│    deja inclus dans Win_BackUp_FileSet_LAN via A:/save          │
└────────────────────────────────────────────┬────────────────────┘
                                             │ Bareos FD
                                             ▼
┌─────────────────────────────────────────────────────────────────┐
│  Serveur Bareos  192.168.0.240   (WOL a 11:00)                  │
├─────────────────────────────────────────────────────────────────┤
│  12:10  Win_BackUp_Job_LAN  ->  RAID10 /var/lib/bareos/storage  │
│  12:15  Win_BackUp_Job_WAN  ->  VPS via tunnel 9203             │
└─────────────────────────────────────────────────────────────────┘
````

---

## `-3-` Prérequis — clé SSH du VPS sur le PC Admin `192.168.0.235`

### 3.1) Recuperer la cle publique du VPS

````
ssh debian@176.31.163.227 'cat ~/.ssh/id_ecdsa.pub'
````

### 3.2) L'autoriser sur Pc Admin `192.168.0.235`

- PowerShell en admin :

````
notepad C:\Users\sednal\.ssh\authorized_keys
````

### 3.3) Creer le dossier de depot

````
mkdir A:\save\VPS_Mail_BackUp
````

---

## `-4-` Script de sauvegarde quotidienne sur le VPS  `176.31.163.227`

- Créer le fichier
````
vim /home/debian/script_dms/backup_mail.sh
````

- Editer le fichier
````bash
#!/bin/bash
# ==========================================================
# Sauvegarde quotidienne du serveur mail (DMS + SoGo)
# Depot local : /home/debian/backup
# Retention   : 7 jours
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
tar czf "$DEST/dms_${DATE}.tar.gz" -C /home/debian/DMS

#Purge des archives trop anciennes ---
find "$DEST" -name "sogo_pgdump_*.sql.gz" -mtime +$RETENTION -delete
find "$DEST" -name "dms_*.tar.gz"         -mtime +$RETENTION -delete

# === 4) Journal ===
echo "$(date '+%F %T') sauvegarde OK" >> "$DEST/backup.log"
````

Rendre executable :

````
chmod +x /home/debian/backup_mail.sh
````

`[NOTE]` `pg_dumpall` evite d'avoir a connaitre le nom exact de la base SoGo et sauvegarde également les rôles et les mots de passe PostgreSQL.

---

## `-5-` Script de push depuis le VPS `176.31.163.227` => PC Admin `192.168.0.235`

Créer le fichier 
````
vim /home/debian/script_dms/push_mail.sh
````

- Editer
````bash
#!/bin/bash
# ==========================================================
# Envoi des sauvegardes vers le PC Windows 192.168.0.235
# Cible : A:/save/VPS_Mail  (inclus dans Win_BackUp_FileSet_LAN)
# ==========================================================

set -eu

SRC="/home/debian/backup/"
CIBLE="sednal@192.168.0.235"
DEST="A:/save/VPS_Mail/"

# Attendre que le PC soit joignable (WOL a 11:00, marge de 20 min)
for i in $(seq 1 40); do
    if ssh -o BatchMode=yes -o ConnectTimeout=5 "$CIBLE" "exit" 2>/dev/null; then
        break
    fi
    sleep 30
done

rsync -az --delete -e "ssh -o BatchMode=yes" "$SRC" "$CIBLE:$DEST"

echo "$(date '+%F %T') push OK" >> /home/debian/backup/backup.log
````

- Rendre executable :
````
chmod +x /home/debian/push_mail.sh
````

---

## `-6-` Taches cron sur le VPS `176.31.163.227`

````
crontab -e
````

````
# Sauvegarde quotidienne du serveur mail
30 2 * * * /home/debian/backup_mail.sh >> /home/debian/backup/cron.log 2>&1

# Envoi vers le PC Windows, le dimanche apres le WOL
5 7 * * 0 /home/debian/push_mail.sh >> /home/debian/backup/cron.log 2>&1
````

⚠️ `[ATTENTION]` ⚠️ 

Le VPS est en `Etc/UTC` alors que `192.168.0.240` et `192.168.0.241` sont en `Asia/Yerevan` (UTC+4). Les horaires du cron sont exprimes en **heure du
VPS** : `07:05 UTC` correspond a `11:05` heure Yerevan.

- Verifier la correspondance :
````
date; TZ=Asia/Yerevan date
````

---

## `-7-` Verification

### 7.1) Test manuel du dump

````
./backup_mail.sh
ls -lh /home/debian/backup/
````

### 7.2) Apres le premier dimanche, cote Bareos `192.168.0.240`

````
printf "list jobs\nquit\n" | sudo bconsole
````

Le `jobbytes` de `Win_BackUp_Job_LAN` doit avoir augmente d'environ 200 Mo.

### 7.3) Journaux du VPS `176.31.163.227`

````
tail -20 /home/debian/backup/backup.log
tail -40 /home/debian/backup/cron.log
````

---

## 8️⃣ Restauration

### 8.1) Recuperer les archives depuis Bareos `192.168.0.240` 

````
printf "restore client=win\nquit\n" | sudo bconsole
````

Selectionner les fichiers sous `A:/save/VPS_Mail/`.

### 8.2) Restaurer les bases SoGo `176.31.163.227`

````
gunzip -c sogo_pgdump_AAAA-MM-JJ.sql.gz | docker exec -i sogo-postgres psql -U postgres
````

### 8.3) Restaurer le dossier DMS `176.31.163.227`

````
docker compose -f /home/debian/DMS/compose.yml down
tar xzf dms_AAAA-MM-JJ.tar.gz -C /home/debian
docker compose -f /home/debian/DMS/compose.yml up -d
````
