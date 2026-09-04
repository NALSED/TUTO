# Installation de security onion sur un VM dédié.

---

### 📝 VM :
* ### 30 GB Ram
* ### 10 Coeurs
* ### 440 GB dédiés 
* ### Deux cartes réseau :
   * ### 1) Accès par `pont` // Sans mode de promiscuité
   * ### 2) Réseau `interne` // type d'interface : `Intel PRO/1000 T Server` // mode promiscuité : Allow All

--- 
## Pendant l'install : 

### [DOC](https://docs.securityonion.net/en/2.4/first-time-users.html) de Security Onion.

### 1) choisir `STANDALONE`
![image](https://github.com/user-attachments/assets/e58f16cc-cb9c-41bd-9842-dff9369b265d)

### 2) Choisir la bonne interface réseau (ici pour le management), doit pouvoir accéder à internet don bridge, vérifier sur VB les adresses MAC pour être sur.
![image](https://github.com/user-attachments/assets/0448502b-0807-4ca6-a825-f347fb260593)

### 3) Choisir DHCP, ⚠️MAIS penser à réserver l'adresse dans le pool du serveur!
![image](https://github.com/user-attachments/assets/660c14c6-92b6-46f8-9966-e10c0183b688)

### 4) Entrer Password et login (mail, même fictif)
### Il seront demandé comme identifiant pour la connexion en WebUi
### ⚠️ clavier en qwerty.
![image](https://github.com/user-attachments/assets/9ee748b6-8755-4cc9-b0ec-1d5c539f812a)

![image](https://github.com/user-attachments/assets/3383be53-de43-4b3e-9f81-166a32e9c521)

### Lors de la connexion aucun traffic sur le réseau

### WebUi
![image](https://github.com/user-attachments/assets/7dc21442-8c65-44ae-bd6e-ad71b149ded1)




