# Création d'une infrastructure réseau
## Description du projet :
Mise en place d'une infrastructure système et réseau composée des éléments suivants :
- Un routeur de bordure de zone sous Linux permettant aux réseaux locaux d'atteindre internet.
- Un routeur inter-LANs sous Linux permettant aux différents LANs de communiquer entre eux selon la politique de contrôle de flux.
- Les protocoles suivant seront implémentés (NAT, RIP, DHCP, IPv4, IPv6).
- Différents clients seront répartis dans les LANs.## 📖 Sommaire :

### 1️⃣ `Shéma synoptique`
### 2️⃣ `Configuration Routage`
### 3️⃣ `Régles NAT et Route`
### 4️⃣ ``
### 5️⃣ ``
### 6️⃣ ``
### 7️⃣ ``
### 8️⃣ ``
### 9️⃣ ``
### 🔟 ``

## 1️⃣ 📒`Shéma synoptique`

***
***
![t](https://github-production-user-asset-6210df.s3.amazonaws.com/182364873/392114909-5bbe9964-2f54-4747-979a-a7e1e963e271.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20250102%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250102T141055Z&X-Amz-Expires=300&X-Amz-Signature=942f1009c489fdc5ba2603589656cd5e82f828ea99bb81698ee90c0edb141a68&X-Amz-SignedHeaders=host)

## 2️⃣ `Configuration Network et Routage`
***
***
* ###  Network Client 
#### mettre le client sur le Vlan souhaité (avec la carte réseau de VB)  
![image](https://github.com/user-attachments/assets/3d9a4080-a353-4dc2-a992-ae0db6f44f09)
***
* ###  Network R-EDGE*
### ✏️ IP Static et DHCP
          nano /etc/network/interfaces
![image](https://github.com/user-attachments/assets/fb526709-5242-4ae6-824e-fb9e7f260630)
* ###  Routage R-EDGE
### ✏️ configuration du routage persistant
        nano /etc/sysctl.conf
![image](https://github.com/user-attachments/assets/5852c7e9-9c6c-41ee-aea1-2e2abd10f51f)
       
	      systemctl restart networking.service
***
* ###  Routage R-INTER
### ✏️ configuration du routage persistant
![image](https://github.com/user-attachments/assets/cecd2cc4-17cc-44ac-a651-64e5af86bb41)
* ###  Network R-INTER
### 🖥️ Activer les 4 cartes réseaux sur VB
### ✏️ IP Static  
![image](https://github.com/user-attachments/assets/e44fad4c-eeaf-4047-8cc9-e0cb4f5e14cf)
### ✏️ Carte réseaux
![image](https://github.com/user-attachments/assets/7958fc66-4b44-4e2a-8083-abb14e3bfcbd)

***
***

## 3️⃣ `Régles NAT`
***
* ### EDITION :

* ###  R-EDGE
		nft add table ip table_NAT		
* #### `nft add table ip` : création de la table
* #### `table_NAT` : Nom de la table
		nft add chain ip table_NAT chain_postrouting { type nat hook postrouting priority 0\; }
* #### `nft add chain ip` : création de la chaine
* #### `table_NAT` : la chaine est créer dans la table_NAT
* #### `chain_postrouting` : Nom de la chaine
* #### `type nat hook postrouting priority 0\;``: Type et priotité de la chaine 
		nft add rule table_NAT chain_postrouting 	ip saddr 10.0.99.252/30 oif enp0s8 snat 192.168.10.11
								ip saddr 10.0.0.0/22 oif "enp0s8" snat to 192.168.0.104

* #### `nft add rule table_NAT chain_postrouting` : création de la régle
* #### `ip saddr 10.0.99.252/30` : addresse ip source
* #### `oif enp0s8 snat 192.168.10.11` : adresse de sortie
* #### Ajout d'une second régle NAT afin de pouvoir connecter les clients à internet

![image](https://github.com/user-attachments/assets/f8f05654-d6e0-4a68-81c0-9aadcb91c50a)

    
* ## SAUVEGARDE :

  		nft list table ip table_NAT > table_NAT.nft
		nano table_NAT.nft
![image](https://github.com/user-attachments/assets/60b52b7e-0c70-48cb-ab26-57b07ed9757a)
***
* ### ACTIVATION AU DEMARAGE :
* ### Sur R-EDGE sur l'interface en DHCP	
  		nano /etc/network/interfaces 
* ### Ajouter la ligne 

		pre-up nft -f /root/table_NAT.nft
***
### Si l'on ajoute la route suivante => /etc/network/interfaces
		
  		up ip route add 10.0.0.0/22 via 10.0.99.253
### Le ping depuis le cliens fontionne depuis 10.0.1.1 => 8.8.8.8
***
***













