## Commande SSH

---

- Commande `executé` si `IF true`

---

### `-1-` Connect to SSH Password

`- 1.1` Passer de `Password` => `Private Key`

`- 1.2` Host : `localhost`
 
`- 1.3` Port : 22

`- 1.4` Username : `debian`

`- 1.5` Private Key : Celle du VPS

=> `Save`

### `-2-` Parameters 

`- 2.1` Resource : `Command`

`- 2.2` Operation : `Execute`

`- 2.3` Command !!! Prod !!! Changer la commande sinon à chaque test l'ordinateur s'éteint :
````
shutdown /s /t 0
````

- Ici pour `test`, comme ça on peux annuler le `shutdown` avec `shutdown /a`
````
shutdown /s /t 600
````

`- 2.4` Working Directory :
````
C:\Windows
````

## **FIN DE CONFIGURATION**

<img width="1332" height="410" alt="image" src="https://github.com/user-attachments/assets/43b77495-c932-4129-a42c-021d72433d15" />

