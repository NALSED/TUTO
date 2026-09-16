## Pipeline notification + extinction (Bareos)

---

`[NOTE]`

- Le pipeline suivant à pour objectif de remplir les taches suivantes:  

   - À la fin des jobs Bareos programmés le dimanche.
   - Récupèration du statut, notification sur `192.168.0.235` (popup local) et sur Telegram (`235` et `240` indépendamment), gestion de l'extinction.

---
### -1- Workflow principal (Schedule Trigger, dimanche)

-1- SSH → `192.168.0.240` : récupération du statut du **dernier job** (script bconsole - Voir [-3- Scripts.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-3-%20Scripts.md)

-2- IF : statut `T`/`W` (OK) → message succès ; sinon → message erreur

   - Les deux branches continuent vers la proposition d'extinction : seul le texte du message change

-3- SSH → `192.168.0.235` (fire-and-forget, ne bloque pas le workflow) : lance le popup local existant - Voir [-3- Scripts.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-3-%20Scripts.md)

-4- Telegram — Send and Wait for Response : "Éteindre ce poste (235) ?"

-5- IF sur l'approbation → `OUI` extinction immédiate de `235` / `NON` annulation du timer du popup

-6- Telegram — Send and Wait for Response : "Éteindre Bareos-Server (240) ?"

-7- IF sur l'approbation → `OUI` extinction immédiate de `240` / `NON` rien, le cron de 19h prend le relais

#### Config node Telegram (x2 — un pour 235, un pour 240)
- Resource : `Message`
- Operation : `Send and Wait for Response`
- Chat ID : `<ton ID Telegram>`
- Response Type : `Approval`
- Type of Approval : `Approve and Disapprove`
- Limit Wait Time : `5` minutes

#### Comportement du timeout 
````
{{ $json.data?.approved !== true }}
````

`true` => branche extinction (Approve explicite OU timeout)

`false` => branche annulation : SSH `192.168.0.235` `shutdown /a` 

`[NOTE]`

- Le timeout ne déclenche aucune extinction : sur `235` le popup local éteint déjà tout seul après 300 s, sur `240` le cron de 19h prend le relais

#### Actions d'extinction

- Branche `235` / `OUI` : SSH `192.168.0.235`
````
shutdown /s /t 0
````

#### Actions d'extinction


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
### -3- Limites connues

- Le popup local (`235`) et le node Telegram (`235`) sont indépendants, sans synchronisation : le premier canal qui répond l'emporte en pratique, mais rien n'empêche les deux de déclencher un `shutdown` en parallèle (sans conséquence réelle)


