## Pipeline notification + extinction (Bareos)

---

`[NOTE]`

- Le pipeline suivant a pour objectif de remplir les tâches suivantes :

   - À la fin des jobs Bareos programmés le dimanche, récupérer le statut du dernier job.
   - Notifier sur `192.168.0.235` (popup local) et sur Telegram, puis gérer l'extinction de `235` et de `240`.

- Le déclenchement ne vient pas de n8n : c'est un timer systemd sur `192.168.0.240` qui lance le script, lequel pousse le résultat sur le webhook — voir [-3- Scripts.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-3-%20Scripts.md)

---
### -1- Workflow principal (Webhook)

-1- Webhook — reçoit le statut poussé en HTTPS par `192.168.0.240`

-2- Telegram — Send and Wait for Response : extinction de `235`

-3- IF sur l'approbation → `OUI` extinction immédiate de `235` / `NON` annulation du timer du popup

-4- Telegram — Send and Wait for Response : extinction de `240`

-5- IF sur l'approbation → `OUI` extinction immédiate de `240` / `NON` rien, le cron de 19h prend le relais

---
