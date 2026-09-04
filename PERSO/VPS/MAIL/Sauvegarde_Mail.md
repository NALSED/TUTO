# Sauvegarde du serveur mail (DMS + SoGo)

---

Procédure compléte de sauvegarde de la base de données et des mail depuis le `VPS 176.31.163.227`, via `PC ADMIN 192.168.0.235` sur le serveur de sauvegarde `BAREOS 192.168.0.240`

---

## `-1-` Principe

- Le Serveur DMS produit ses propres sauvegardes localement, puis les dépose dans `F:/save/VPS_Mail_BackUp` du
PC Admin `192.168.0.235`.

- Ce chemin étant déjà couvert par `Win_BackUp_FileSet_LAN` via `F:/save`, la sauvegarde Bareos du dimanche les embarque
automatiquement vers le RAID10 du serveur `192.168.0.240`.

- Le VPS n'est **pas** déclaré comme client Bareos : aucun port 9102 à ouvrir, aucune ressource `Client` à créer côté Director.

---

## `-2-` === Schema ===

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
│  PC Admin  192.168.0.235      (WOL a 11:00)                     │
├─────────────────────────────────────────────────────────────────┤
│  F:/save/VPS_Mail_BackUp/                                       │
│    deja inclus dans Win_BackUp_FileSet_LAN via F:/save          │
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

- Ajouter la clé sur une nouvelle ligne :

````
# === VPS 176.31.163.227 ===
ecdsa-sha2-nistp256 AAAA... debian@vps-sednal
````

### 3.3) Creer le dossier de depot

````
mkdir F:\save\VPS_Mail_BackUp
````

### 3.4) Tester depuis le VPS `176.31.163.227`

````
ssh -o BatchMode=yes sednal@192.168.0.235 "echo OK"
````

---

## `-4-` Script de sauvegarde quotidienne sur le VPS  `176.31.163.227`

- Créer le dossier et le fichier

````
mkdir -p /home/debian/script_dms
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
tar czf "$DEST/dms_${DATE}.tar.gz" -C /home/debian DMS

# === Purge des archives trop anciennes ===
find "$DEST" -name "sogo_pgdump_*.sql.gz" -mtime +$RETENTION -delete
find "$DEST" -name "dms_*.tar.gz"         -mtime +$RETENTION -delete

# === Journal ===
echo "$(date '+%F %T') sauvegarde OK" >> "$DEST/backup.log"
````

- Rendre executable :

````
chmod +x /home/debian/script_dms/backup_mail.sh
````

`[NOTE]`

`pg_dumpall` evite d'avoir a connaitre le nom exact de la base SoGo et sauvegarde également les rôles et les mots de passe PostgreSQL.

⚠️ `[ATTENTION]` ⚠️

La syntaxe `tar -C /home/debian DMS` est impérative : `-C` change de répertoire, l'opérande `DMS` indique quoi archiver. Sans opérande, `tar` sort en erreur et `set -eu` interrompt le script.

---

## `-5-` Script de push depuis le VPS `176.31.163.227` => PC Admin `192.168.0.235`

- Créer le fichier

````
vim /home/debian/script_dms/push_mail.sh
````

- Editer

````bash
#!/bin/bash
# ==========================================================
# Envoi des sauvegardes vers le PC Admin 192.168.0.235
# Cible : F:/save/VPS_Mail_BackUp
#         (inclus dans Win_BackUp_FileSet_LAN via F:/save)
# ==========================================================

set -eu

SRC="/home/debian/backup/"
CIBLE="sednal@192.168.0.235"
DEST="F:/save/VPS_Mail_BackUp/"

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
chmod +x /home/debian/script_dms/push_mail.sh
````

`[NOTE]`

La boucle d'attente couvre le délai de démarrage de Windows après le WOL : 40 tentatives espacées de 30 s, soit 20 minutes.

`[NOTE]`

Si `rsync` n'est pas disponible côté Windows, remplacer la ligne `rsync` par :

````bash
scp -o BatchMode=yes "$SRC"* "$CIBLE:$DEST"
````

---

## `-6-` Taches cron sur le VPS `176.31.163.227`

````
crontab -e
````

````
# Sauvegarde quotidienne du serveur mail
30 2 * * * /home/debian/script_dms/backup_mail.sh >> /home/debian/backup/cron.log 2>&1

# Envoi vers le PC Admin, le dimanche apres le WOL
5 7 * * 0 /home/debian/script_dms/push_mail.sh >> /home/debian/backup/cron.log 2>&1
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
/home/debian/script_dms/backup_mail.sh
ls -lh /home/debian/backup/
````

### 7.2) Test manuel du push, PC Admin allumé

````
/home/debian/script_dms/push_mail.sh
````

- Vérifier côté Windows :

````
dir F:\save\VPS_Mail_BackUp
````

### 7.3) Apres le premier dimanche, cote Bareos `192.168.0.240`

````
printf "list jobs\nquit\n" | sudo bconsole
````

Le `jobbytes` de `Win_BackUp_Job_LAN` doit avoir augmente d'environ 200 Mo.

### 7.4) Journaux du VPS `176.31.163.227`

````
tail -20 /home/debian/backup/backup.log
tail -40 /home/debian/backup/cron.log
````

---

## `-8-` Restauration

### 8.1) Recuperer les archives depuis Bareos `192.168.0.240`

````
printf "restore client=win\nquit\n" | sudo bconsole
````

Selectionner les fichiers sous `F:/save/VPS_Mail_BackUp/`.

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

`[NOTE]`

L'archive contient le dossier `DMS` lui-même : l'extraire dans `/home/debian` recrée `/home/debian/DMS`.
