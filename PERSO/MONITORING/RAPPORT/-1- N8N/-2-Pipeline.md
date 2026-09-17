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

# === Configuration n8n ===

## `-1-` `Webhook`

`- 1.1` En haut à droite `Create wrokflow` => `+` => `Webhook`

`- 1.2` Configuration node Webhook :

- HTTP Method    : POST

- Path           : !!! Doit être le même "URL_N8N=" que dans le [recup-status-bareos.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-3-%20Scripts.md#-1--script-de-r%C3%A9cup%C3%A9ration-du-statut-1921680240) !!!

- Authentication : Header Auth

- Respond        : Immediately

- Credential for `Header Auth` :

   - Name  : Bareos-Token

   - Value :!!! Doit être le même "TOKEN_N8N=" que dans le [recup-status-bareos.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-3-%20Scripts.md#-1--script-de-r%C3%A9cup%C3%A9ration-du-statut-1921680240) !!!


`[NOTE]`

- Derrière Caddy, si l'URL affichée dans le node n'est pas la bonne, ajouter `WEBHOOK_URL=https://n8n.nalsed.fr/` au `compose.yml` — voir [-1- Install-n8n.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/-1-%20Install-n8n.md)


- **FIN DE CONFIGURATION**

<img width="363" height="228" alt="image" src="https://github.com/user-attachments/assets/9858f638-2a3e-4722-a9f8-5a6d91ce1797" />


---

## `-2-` Config node Telegram 

`[NOTE]`

- A réaliser pour `192.168.0.235` et `192.1658.0.240`

### **=== 192.168.0.235 ===**

- `- 2.1` `+` => `Telegram` => `MESSAGE ACTIONS` =>  `Send and Wait for Response` :

   - credential : `Telegram account`

   - Resultat attendu avec le `TOKEN` de `@BotFather`

   <img width="960" height="265" alt="image" src="https://github.com/user-attachments/assets/36e2e407-a99b-4dd1-9273-eb9843380f73" />


   - Chat ID : `<!!! ID USER !!!>` Ici [Procédure Telegram](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-4-%20Procedure-Telegram.md) pour `Token` et `ID`

   - Message :
   ````
   {{ $('Webhook').item.json.body.text }}
   ````
   
   - Response Type : `Approval`

   - Approval Options : `Approve and Disapprove`

   - Limit Wait Time : `5` minutes

### ===> [SCREEN-192.168.0.235](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-6-SCREEN.md#configuration-node-telegram-1921680235) <===

`- 2.2` Tester le node : `Execute step`

- Le message doit arriver ET `Approved` doit renvoyer une URL n8n



- **FIN DE CONFIGURATION**

<img width="507" height="191" alt="image" src="https://github.com/user-attachments/assets/177d3734-4c7d-40e4-9e36-4b98b7414dcd" />

---

### **=== 192.168.0.240 ===**

`- 2.3` `+` => `Telegram` => `MESSAGE ACTIONS` =>  `Send and Wait for Response` :

 - credential : `Telegram account`

 - Chat ID : `<!!! ID USER !!!>` Ici [Procédure Telegram](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-4-%20Procedure-Telegram.md) pour `Token` et `ID`

 - Message :
````
{{ $('Webhook').item.json.body.text }}
````
   
 - Response Type : `Approval`

 - Approval Options : `Approve and Disapprove`

 - Limit Wait Time : `5` minutes

### ===> [SCREEN-192.168.0.240](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-6-SCREEN.md#configuration-node-telegram-1921680240) <===


`- 2.4` Tester le node : `Execute step`

- Le message doit arriver ET `Approved` doit renvoyer une URL n8n

- **FIN DE CONFIGURATION**

<img width="755" height="194" alt="image" src="https://github.com/user-attachments/assets/cf57336b-6d01-427f-813d-a130cd89967b" />
























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
sudo /sbin/shutdown -h now
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
