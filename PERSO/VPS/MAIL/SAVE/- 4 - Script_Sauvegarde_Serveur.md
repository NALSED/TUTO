## `-4-` Script de rapatriement sur Bareos `192.168.0.240`

- `- 4.1` Créer les dossiers et le fichier
````
mkdir -p /home/sednal/VPS_Mail_BackUp /home/sednal/logs
vim /home/sednal/pull_mail.sh
````

- `- 4.2` Éditer

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

- `- 4.3` Droits
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
