# Création d'une infrastructure réseau
## Description du projet :
Mise en place d'une infrastructure système et réseau composée des éléments suivants :
- Un routeur de bordure de zone sous Linux permettant aux réseaux locaux d'atteindre internet.
- Un routeur inter-LANs sous Linux permettant aux différents LANs de communiquer entre eux selon la politique de contrôle de flux.
- Les protocoles suivant seront implémentés (NAT, RIP, DHCP, IPv4, IPv6).
- Différents clients seront répartis dans les LANs.
## 📖 Sommaire :
### 1️⃣ `Shéma synoptique`
### 2️⃣ `Lab`
### 3️⃣ `Configuration Routage`
### 4️⃣ `Régles NAT`
### 5️⃣ ``
### 6️⃣ ``
### 7️⃣ ``
### 8️⃣ ``
### 9️⃣ ``
### 🔟 ``
---
## 1️⃣ 📒`Shéma synoptique`

![t](https://github-production-user-asset-6210df.s3.amazonaws.com/182364873/392114909-5bbe9964-2f54-4747-979a-a7e1e963e271.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20250102%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250102T141055Z&X-Amz-Expires=300&X-Amz-Signature=942f1009c489fdc5ba2603589656cd5e82f828ea99bb81698ee90c0edb141a68&X-Amz-SignedHeaders=host)

## 2️⃣ `Lab`
- **Router R-EDGE (Linux Debian 12.8.0) :**
	- 1 CPU (par défaut)
  	- RAM (entre 512 Mo et 1024 Mo suffisant)
	- ROM (par défaut)
	- 2 cartes réseaux (l'une en Bridge ou en NAT, l'autre en réseau interne)
  - **Router R-INTER (Linux Debian 12.8.0) :**
	- CPU (par défaut)
  	- RAM (entre 512 Mo et 1024 Mo suffisant)
	- ROM (par défaut)
	- 1 carte réseau (en réseau interne)
  - **Clients (Windows 10 Pro)**
	- 1 CPU (par défaut)
  	- RAM (2048 Mo)
	- ROM (50 Go)
	- 1 carte réseau (en réseau interne)
### Utiliser la description du lab pour l'instalation des machines
## ⚠️Dans ce labo nous utiliserons SSH pour passer d'un routeur à l'autre
## 3️⃣ `Configuration Network et Routage`
#### * Network Client 
### mettre le client sur le même Vlan que le réseau du routeur( intnet 2 pour le routeur donc intnet pour le Client)  
![image](https://github.com/user-attachments/assets/3d9a4080-a353-4dc2-a992-ae0db6f44f09)
___
___
* ####  Network R-EDGE
### ✏️ IP Static et DHCP
          nano /etc/network/interfaces
![image](https://github.com/user-attachments/assets/fb526709-5242-4ae6-824e-fb9e7f260630)
* ####  Routage R-EDGE 
### ✏️ configuration du routage persistant
        nano /etc/sysclt.conf
![image](https://github.com/user-attachments/assets/5852c7e9-9c6c-41ee-aea1-2e2abd10f51f)
        systemctl restart networking
___
___
* ####  Routage R-INTER
### ✏️ configuration du routage persistant
![image](https://github.com/user-attachments/assets/cecd2cc4-17cc-44ac-a651-64e5af86bb41)
* ####  Network R-INTER
### 🖥️ Activer les 4 cartes réseaux sur VB
### ✏️ IP Static  
![image](https://github.com/user-attachments/assets/e44fad4c-eeaf-4047-8cc9-e0cb4f5e14cf)
### ✏️ Carte réseaux
![image](https://github.com/user-attachments/assets/7958fc66-4b44-4e2a-8083-abb14e3bfcbd)

## 4️⃣ `Régles NAT`
* ### EDITION :
___
* ###  R-EDGE
		nft add table ip table_NAT		
* #### `nft add table ip` : création de la table
* #### `table_NAT` : Nom de la table
		nft add chain ip table_NAT chain_postrouting { type nat hook postrouting priority 0\; }
* #### `nft add chain ip` : création de la chaine
* #### `table_NAT` : la chaine est créer dans la table_NAT
* #### `chain_postrouting` : Nom de la chaine
* #### `type nat hook postrouting priority 0\;``: Type et priotité de la chaine 
		nft add rule table_NAT chain_postrouting ip saddr 10.0.99.252/30 oif enp0s8 snat 192.168.10.11
* #### `nft add rule table_NAT chain_postrouting` : création de la régle
* #### `ip saddr 10.0.99.252/30` : addresse ip source
* #### `oif enp0s8 snat 192.168.10.11` : adresse de sortie
* ## SAUVEGARDE :
___
  		nft list table ip table_NAT > table_NAT.nft
		nano table_NAT.nft
![image](https://github.com/user-attachments/assets/60b52b7e-0c70-48cb-ab26-57b07ed9757a)
* ### ACTIVATION AU DEMARAGE :
___
* ### Sur R-EDGE dans l'interface en DHCP	
  		nano /etc/network/interfaces 
* ### Ajouter la ligne 
	pre-up nft -f /root/table_NAT.nft	
![image](https://github.com/user-attachments/assets/a8f1eff4-0bba-4ced-a651-c250249c0434)
















