## `-3-` Script de sauvegarde quotidienne sur le VPS `176.31.163.227`

`- 3.1` Créer les dossiers et le fichier
````
mkdir -p /home/debian/script_dms /home/debian/backup
vim /home/debian/script_dms/backup_mail.sh
````

- `- 3.2` Éditer

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

`- 3.3` Tâche cron sur le VPS `176.31.163.227`
````
crontab -e
````

`- 3.4` Éditer
````
# Sauvegarde quotidienne du serveur mail
30 2 * * * /home/debian/script_dms/backup_mail.sh >> /home/debian/script_dms/cron.log 2>&1
````

`[NOTE]`

Le fichier `cron.log` est placé hors de `/home/debian/backup/` : ce dossier est synchronisé avec `--delete` vers le serveur Bareos.

---
