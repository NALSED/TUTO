## Commande SSH pour `false`

--

- Commande SSH d'annulation d'extinction de 192.168.0.235 =>  exécuté si `IF false`

---

`[NOTE]`

Credential => `SSH Private Key account`

### `-1-` Parameters 

`- 2.1` Resource : `Command`

`- 2.2` Operation : `Execute`

`- 2.3` Command : 
````
shutdown /a
````

`- 2.4` Working Directory :
````
C:\Windows
````

`- 2.5` Onglet `Settings` => activer **Continue On Fail**

`[NOTE]`

- `shutdown /a` sort en erreur `1116` si aucune extinction n'est en attente. C'est le cas le plus fréquent — sans `Continue On Fail`, le workflow s'arrête et la question pour `240` n'est jamais posée


---

## `-3-` Raccordement

- Les **deux** nodes SSH, `true` et `false`, doivent être reliés à l'entrée du node Telegram `192.168.0.240`


## **FIN DE CONFIGURATION**

<img width="1361" height="481" alt="image" src="https://github.com/user-attachments/assets/9e71575e-576a-4adf-9423-aa7539793314" />


