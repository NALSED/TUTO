## SSH => 192.168.0.240

---

Commande SSH exécutépour eteindre 192.168.0.240

---


- Commande SSH d'annulation d'extinction de 192.168.0.240 =>  exécuté si `IF true`

---

`[NOTE]`

Credential => `SSH Private Key account`

`[NOTE]`

Credential => créer un **nouveau** credential SSH (ne pas réutiliser celui de `.235`) :

- Host : `192.168.0.240`
- Port : `22`
- Username : `sednal`
- Private Key : celle du VPS


### `-2-` Parameters 

`- 2.1` Resource : `Command`

`- 2.2` Operation : `Execute`

`- 2.3` Command : 
````
sudo /sbin/shutdown now
````

`- 2.4` Working Directory :
````
/
````
