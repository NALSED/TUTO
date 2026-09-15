## Pipeline notification + extinction (Bareos)

---

`[NOTE]`

- Le pipeline suivant à pour objectif de remplir les taches suivantes:  

   - À la fin des jobs Bareos programmés le dimanche.
   - Récupèration du statut, notification sur `192.168.0.235` (popup local) et sur Telegram (`235` et `240` indépendamment), gestion de l'extinction.

---
### -1- Workflow principal (Schedule Trigger, dimanche)

-1- SSH → `192.168.0.240` : récupération du statut du job (script bconsole - Voir [Recuperation-data-bareos.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/Recuperation-data-bareos.md)

-2- IF : statut `T`/`W` (OK) → message succès ; sinon → message erreur

-3- SSH → `192.168.0.235` (fire-and-forget, ne bloque pas le workflow) : lance le popup local existant - Voir [Recuperation-data-bareos.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/Recuperation-data-bareos.md)

-4- Telegram — Send and Wait for Response : "Éteindre ce poste (235) ?"

-5- IF sur l'approbation → extinction de `235`

-6- Telegram — Send and Wait for Response : "Éteindre Bareos-Server (240) ?"

-7- IF sur l'approbation → extinction de `240`

#### Config node Telegram (x2 — un pour 235, un pour 240)
- Resource : `Message`
- Operation : `Send and Wait for Response`
- Chat ID : `<ton ID Telegram>`
- Response Type : `Approval`
- Type of Approval : `Approve and Disapprove`
- Limit Wait Time : `5` minutes

#### Comportement du timeout 
````
{{ $json.data?.approved !== false }}
````
`true` → branche extinction (Approve explicite OU timeout)
`false` → branche annulation : SSH `192.168.0.235` `shutdown /a` (uniquement si "Decline" est cliqué — annule une extinction que le popup local aurait pu programmer)

#### Actions d'extinction
- Branche `235` (`true`) : SSH `192.168.0.235` →
````
shutdown /s /t 300
````
- Branche `240` (`true`) : SSH `192.168.0.240` →
````
shutdown -h now
````

---
### -2- Workflow séparé, permanent (annulation)

Tourne en continu, indépendant du workflow principal — permet d'annuler l'extinction de `235` à tout moment.

-1- Telegram Trigger — Updates : `Message`

-2- IF : `{{$json.message.chat.id}}` = `<ton ID Telegram>` **ET** `{{$json.message.text}}` contient `annuler`

-3- SSH → `192.168.0.235` →
````
shutdown /a
````

---
### -3- Limites connues

- Le popup local (`235`) et le node Telegram (`235`) sont indépendants, sans synchronisation : le premier canal qui répond l'emporte en pratique, mais rien n'empêche les deux de déclencher un `shutdown` en parallèle (sans conséquence réelle)
- `240` n'a pas de popup local, uniquement Telegram
