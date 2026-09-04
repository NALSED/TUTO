## `-3-` Script de sauvegarde quotidienne sur le VPS `176.31.163.227`

---

### `- 3.1` Créer les dossiers et le fichier

````
mkdir -p /root/script_dms /home/debian/backup
vim /root/script_dms/backup_mail.sh
````

⚠️ `[ATTENTION]` ⚠️

Le script doit tourner **en root**, et non sous l'utilisateur `debian`.
Sous `debian`, l'accès au socket Docker est refusé
(`permission denied while trying to connect to the docker API`) et `tar` échoue
sur `mail-state/spool-postfix` et `mail-logs`.
Le script est donc placé dans `/root/script_dms/` en mode `700`, et sa tâche cron
est celle de root.

### `- 3.2` Éditer

````bash
#!/bin/bash
# ==========================================================
# Sauvegarde quotidienne du serveur mail (DMS + SoGo)
# Doit tourner en root : acces au socket Docker et a mail-state
# Depot : /home/debian/backup   (lisible par 240 en rsync)
# Retention : 7 jours
# ==========================================================

set -euo pipefail

DEST="/home/debian/backup"
DATE=$(date +%F)
RETENTION=7

mkdir -p "$DEST"

# === Dump de toutes les bases PostgreSQL de SoGo ===
docker exec sogo-postgres pg_dumpall -U sogo \
    | gzip > "$DEST/sogo_pgdump_${DATE}.sql.gz"

# === Controle : un dump vide ou minuscule est un echec ===
if [ "$(stat -c%s "$DEST/sogo_pgdump_${DATE}.sql.gz")" -lt 1024 ]; then
    echo "$(date '+%F %T') ECHEC : dump PostgreSQL vide" >> "$DEST/backup.log"
    exit 1
fi

# === Archive du dossier DMS (mails + configuration) ===
tar czf "$DEST/dms_${DATE}.tar.gz" \
    --exclude='DMS/Mail_Server/docker-data/dms/mail-state/spool-postfix/pid' \
    --exclude='DMS/Mail_Server/docker-data/dms/mail-state/lib-postfix/master.lock' \
    --warning=no-file-changed --warning=no-file-removed \
    -C /home/debian DMS || [ $? -eq 1 ]

# === Purge des archives trop anciennes ===
find "$DEST" -name "sogo_pgdump_*.sql.gz" -mtime +$RETENTION -delete
find "$DEST" -name "dms_*.tar.gz"         -mtime +$RETENTION -delete

# === Droits pour le rapatriement depuis 192.168.0.240 ===
chown -R debian:debian "$DEST"
chmod 640 "$DEST"/*.gz

# === Journal ===
echo "$(date '+%F %T') sauvegarde OK" >> "$DEST/backup.log"
````

### `- 3.3` Rendre exécutable

````
chmod 700 /root/script_dms/backup_mail.sh
````

`[NOTE]`

`pg_dumpall` évite d'avoir à connaître le nom exact de la base SoGo et sauvegarde
également les rôles et les mots de passe PostgreSQL.

⚠️ `[ATTENTION]` ⚠️

L'utilisateur PostgreSQL est `sogo`, et non `postgres`. Le conteneur
`sogo-postgres` est lancé avec `POSTGRES_USER=sogo` et `POSTGRES_DB=sogo`.
Avec `-U postgres`, le dump échoue sur `FATAL: role "postgres" does not exist`.

⚠️ `[ATTENTION]` ⚠️

`set -euo pipefail` et non `set -eu` : sans `pipefail`, l'échec de `pg_dumpall`
dans le pipe vers `gzip` est masqué, le script sort en code 0 et laisse un
fichier vide. Le contrôle de taille (moins de 1024 octets) journalise l'échec
et sort en code 1.

`[NOTE]`

Les exclusions `tar` et la neutralisation du code retour sont nécessaires :
`spool-postfix/pid` et `lib-postfix/master.lock` sont volatils, et les sockets
Unix génèrent des avertissements `socket ignored`. Le code retour 1 de `tar` est
normal ici et ne doit pas faire échouer le script.

`[NOTE]`

Le dépôt reste `/home/debian/backup`. Le `chown -R debian:debian` suivi du
`chmod 640` en fin de script permet à `sednal@192.168.0.240` de lire les archives
en rsync.

---

### `- 3.4` Tâche cron root sur le VPS `176.31.163.227`

````
sudo crontab -e
````

### `- 3.5` Éditer

````
# Sauvegarde quotidienne du serveur mail
30 2 * * * /root/script_dms/backup_mail.sh >> /root/script_dms/cron.log 2>&1
````

`[NOTE]`

Le fichier `cron.log` est placé hors de `/home/debian/backup/` : ce dossier est
synchronisé avec `--delete` vers le serveur Bareos, le journal y serait effacé à
chaque passage.
