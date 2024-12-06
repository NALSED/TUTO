### 1️⃣ Configurer le machines ⏬
---
---
#### Ici le labo :
* ### `CLILX01 Debian 12` 
|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|enp0s3 |10.0.0.10/24|fd44:1571:cc8b::11/64|
* ### `CLILX02 Debian 12` 
|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|enp0s3 |10.0.0.11/24|fd44:1571:cc8b::10/64|
* ### `R0_LX Debian 12`
|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|enp0s3 |10.0.0.1/24|fd44:1571:cc8b::10/64|
|enp0s8|192.168.0.250/24|fd44:35a8:39d8:192::250/64|
|enp0s9|dhcp|dhcp|
### 2️⃣ Configurer le routage 
* #### Voir l'état d'IP fordwarding ⚠️être en root
      sysctl net.ipv4.ip_forward
#### = > net.ipv4.ip_forward = 0 Donc désactivé
##### (L'activation et la désactivation de l'IP forwarding, en IPv4 comme en IPv6, s'effectue dans les fichiers "/proc" du système. Il s'agit de "/proc/sys/net/ipv4/ip_forward" pour l'IPv4 et "/proc/sys/net/ipv6/conf/all/forwarding" pour IPv6.)
### 3️⃣ Activation permanante de l'IP forwarding.
     nano /etc/sysctl.conf     
#### Décomenter les deux lignes :
`net.ipv4.ip_forward=1`
`net.ipv6.conf.all.forwarding=1`
![ad1](https://github.com/user-attachments/assets/2233142b-2309-494e-89fe-dcf6c24b2995)
#### Recharger la configuration pour que les changements prennent effet immédiatement :      
     sysctl -p /etc/sysctl.conf     
![ad1](https://github.com/user-attachments/assets/6ea480a1-5c6f-469b-a158-c621107e03e5)
### 4️⃣ Renseigner la Gateway
* #### Chez `CLILX 01 et 02` => 10.0.0.1
       systemctl restart networking
#### Et c'est un bingo
![ad1](https://github.com/user-attachments/assets/7ab616ff-b498-4208-a324-e95dd85ef147)
### 5️⃣ Ajout routeur R1 et R2/ CLILX03 et CLILX04
 ### `R0`
#### 1️⃣ Network
![ad1](https://github.com/user-attachments/assets/fb2d91b3-539c-4c83-ac80-a25e406b98ae)
#### 2️⃣ IP forwarding
![ad1](https://github.com/user-attachments/assets/dc4811d5-38dd-4324-b669-33db8e2b9c86)
* ### `R1`
#### 1️⃣ Network
![ad1](https://github.com/user-attachments/assets/d7eeaeb6-1890-476b-b7cf-3a68eb8b0187)
#### 2️⃣ IP forwarding
![ad1](https://github.com/user-attachments/assets/dc4811d5-38dd-4324-b669-33db8e2b9c86)
* #### `R2`
#### 1️⃣ Network
#### 2️⃣ IP forwarding
![ad1](https://github.com/user-attachments/assets/e968e7b1-d2bb-447f-bce0-6af3025a1e91)
* #### `CLILX03`
#### 1️⃣ Network



* #### `CLILX04`
#### 1️⃣ Network



### 6️⃣ PING



