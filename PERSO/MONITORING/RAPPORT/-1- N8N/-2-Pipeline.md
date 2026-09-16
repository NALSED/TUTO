## Pipeline notification + extinction (Bareos)

---

`[NOTE]`

- Le pipeline suivant a pour objectif de remplir les tâches suivantes :

   - À la fin des jobs Bareos programmés le dimanche, récupérer le statut du dernier job.
   - Notifier sur `192.168.0.235` (popup local) et sur Telegram, puis gérer l'extinction de `235` et de `240`.

- Le déclenchement ne vient pas de n8n : c'est un timer systemd sur `192.168.0.240` qui lance le script, lequel pousse le résultat sur le webhook — voir [-3- Scripts.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-3-%20Scripts.md)

- Le popup local de `235` est lancé par ce même script, pas par n8n

- Les deux demandes d'extinction sont **séquentielles** : celle de `240` ne part qu'une fois celle de `235` résolue

---
### -1- Workflow principal (Webhook)

-1- Webhook — reçoit le statut poussé en HTTPS par `192.168.0.240`

-2- Telegram — Send and Wait for Response : extinction de `235`

-3- IF sur l'approbation → `OUI` extinction immédiate de `235` / `NON` annulation du timer du popup

-4- Telegram — Send and Wait for Response : extinction de `240`

-5- IF sur l'approbation → `OUI` extinction immédiate de `240` / `NON` rien, le cron de 19h prend le relais

`[NOTE]`

- Il n'y a pas d'IF sur le statut de la sauvegarde : le script a déjà choisi le texte du message selon le couple `LEVEL` / `STATUS` et l'envoie dans le payload. Succès comme échec, l'extinction est proposée

#### Config node Webhook
````
HTTP Method    : POST
Path           : <chaine-aleatoire-longue>
Authentication : Header Auth
Respond        : Immediately
````

- Credential `Header Auth` :
````
Name  : X-Bareos-Token
Value : <token aléatoire long>
````

- URL de production :
````
https://n8n.nalsed.fr/webhook/<chaine-aleatoire-longue>
````

- URL de test, active uniquement quand le workflow tourne en mode manuel :
````
https://n8n.nalsed.fr/webhook-test/<chaine-aleatoire-longue>
````

- Corps envoyé par le script :
````
{ "level": "I", "status": "T", "text": "=== Bareos [ 192.168.0.240 ] ===\n🟢 Sauvegarde ..." }
````

`[NOTE]`

- `Respond : Immediately` est impératif. En `When Last Node Finishes`, le `curl` du script resterait bloqué jusqu'à la fin des deux attentes Telegram, soit plus de 10 minutes

- Le chemin aléatoire **et** le header d'authentification : sans les deux, n'importe qui peut déclencher le pipeline d'extinction

- Derrière Caddy, si l'URL affichée dans le node n'est pas la bonne, ajouter `WEBHOOK_URL=https://n8n.nalsed.fr/` au `compose.yml` — voir [-1- Install-n8n.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/-1-%20Install-n8n.md)

#### Config node Telegram (x2 — un pour 235, un pour 240)
- Resource : `Message`
- Operation : `Send and Wait for Response`
- Chat ID : `<ton ID Telegram>`
- Response Type : `Approval`
- Type of Approval : `Approve and Disapprove`
- Limit Wait Time : `5` minutes

- Texte du message `235`, repris du payload :
````
{{ $('Webhook').item.json.body.text }}
````

- Texte du message `240` :
````
Souhaitez-vous éteindre [ 192.168.0.240 ] ?
````

`[NOTE]`

- `$json.body.text` ne fonctionne que dans le node **immédiatement après** le Webhook. Plus loin dans le workflow, référencer le node source explicitement avec `$('Webhook')`

#### Comportement du timeout
````
{{ $json.data?.approved == true }}
````

`true` => Approve explicite uniquement => branche extinction

`false` => Disapprove OU timeout => branche `NON`

`[NOTE]`

- Le timeout ne déclenche aucune extinction : sur `235` le popup local éteint déjà tout seul après 300 s, sur `240` le cron de 19h prend le relais

#### Actions d'extinction

- Branche `235` / `OUI` : SSH `192.168.0.235`
````
shutdown /s /t 0
````

- Branche `235` / `NON` : SSH `192.168.0.235` — coupe le timer de 300 s lancé par le popup
````
shutdown /a
````

`[NOTE]`

- `shutdown /a` renvoie l'erreur `1116` si aucune extinction n'est en attente. Activer `Continue On Fail` sur ce node SSH pour que le workflow ne casse pas

- Branche `240` / `OUI` : SSH `192.168.0.240`
````
shutdown -h now
````

- Branche `240` / `NON` : aucune action, extinction laissée au cron de 19h

---
### -2- Workflow séparé, permanent (annulation)

Tourne en continu, indépendant du workflow principal — permet d'annuler l'extinction de `235` à tout moment.

-1- Telegram Trigger — Updates : `Message`

-2- IF : `{{$json.message.chat.id}}` = `<ton ID Telegram>` **ET** `{{$json.message.text}}` contient `annuler`

-3- SSH → `192.168.0.235`
````
shutdown /a
````

---
