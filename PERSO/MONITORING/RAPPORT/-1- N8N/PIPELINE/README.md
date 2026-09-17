# Pipeline notification + choix extinction 

---

## Cette partie détail la mise en place de chaque `node` séparément :

### **=== Ordre à suivre pour l’installation ===**

### `-1-` [Webhook](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/PIPELINE/NODE/-1-%20Webhook.md)

### `-2-` [192.168.0.235](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/PIPELINE/NODE/-2-%20192.168.0.235.md)

### `-3-` [IF](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/PIPELINE/NODE/-3-%20IF.md)

### `-4-` [SSH-true](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/PIPELINE/NODE/-4-%20true-SSH.md)

### `-5-` [SSH-false](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/PIPELINE/NODE/-5-%20false-SSH.md)

### `-6-` [192.168.0.240](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/PIPELINE/NODE/-6-%20192.168.0.240.md)

### `-7-` [IF](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/PIPELINE/NODE/-7-%20IF.md)

### `-8-` [SSH](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/PIPELINE/NODE/-8-%20SSH.md)

---

`[NOTE]`

- Le pipeline suivant a pour objectif de remplir les tâches suivantes :

   - À la fin des jobs Bareos programmés le dimanche, récupérer le statut du dernier job.
   - Notifier sur `192.168.0.235` (popup local) et sur Telegram, puis gérer l'extinction de `192.168.0.235` et de `192.168.0.240`.

- Le déclenchement ne vient pas de n8n : c'est un timer systemd sur `192.168.0.240` qui lance le script, lequel pousse le résultat sur le webhook => voir [-3- Scripts.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-3-%20Scripts.md)

