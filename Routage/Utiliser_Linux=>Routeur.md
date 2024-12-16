### 1️⃣ `Configurer le machines` ⏬
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
### 2️⃣ `Configurer le routage`
* #### Voir l'état d'IP fordwarding ⚠️être en root
      sysctl net.ipv4.ip_forward
#### = > net.ipv4.ip_forward = 0 Donc désactivé
##### (L'activation et la désactivation de l'IP forwarding, en IPv4 comme en IPv6, s'effectue dans les fichiers "/proc" du système. Il s'agit de "/proc/sys/net/ipv4/ip_forward" pour l'IPv4 et "/proc/sys/net/ipv6/conf/all/forwarding" pour IPv6.)
### 3️⃣ `Activation permanante de l'IP forwarding`
     nano /etc/sysctl.conf     
#### Décomenter les deux lignes :
`net.ipv4.ip_forward=1`
`net.ipv6.conf.all.forwarding=1`
![ad1](https://github.com/user-attachments/assets/2233142b-2309-494e-89fe-dcf6c24b2995)
#### Recharger la configuration pour que les changements prennent effet immédiatement :      
     sysctl -p /etc/sysctl.conf     
![ad1](https://github.com/user-attachments/assets/6ea480a1-5c6f-469b-a158-c621107e03e5)
### 4️⃣ `Renseigner la Gateway`
* #### Chez `CLILX 01 et 02` => 10.0.0.1
       systemctl restart networking
### 5️⃣ `Ajout de Client et routeur`
* ### `CLILX03 Debian 12` 
|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|enp0s3 |10.0.1.12/24|fd88:1320:a66f:1::12/64|
* ### `CLILX04 Debian 12` 
|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|enp0s3 |10.0.2.13/24|fd1d:53c6:6dae:2::13/64|
* ### `R1_LX Debian 12`
|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|enp0s3 |10.0.1.1/24|fd35:e225:65cf:192::251/64|
|enp0s8|dhcp|dhcp|
|enp0s9|192.168.0.250/24|fdd1:e40a:c2fc:1::1/64|
* ### `R2_LX Debian 12`
|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|enp0s3 |10.0.2.1/24|fd79:f27e:a64c:192::252/64|
|enp0s8|dhcp|dhcp|
|enp0s9|192.168.0.250/24|fd09:7bcc:9a0f:2::1/64|
### 6️⃣ `Captures et Résultats`

* ### `R0_LX Debian 12`

![R0](https://github.com/user-attachments/assets/e088ceb3-3d0b-48b5-b0ce-d2da82513462)

* ### `R1_LX Debian 12`

![R1](https://github.com/user-attachments/assets/e75f52d2-fe07-4917-8ef2-f3e529f62d67)

* ### `R2_LX Debian 12`

![R2](https://github.com/user-attachments/assets/55185767-89e9-4a15-9c9d-abe6eb96b498)

`CLILX01 Debian 12` ➡️ `CLILX04 Debian 12`

![CLI1](https://github.com/user-attachments/assets/85d1456d-f78e-4ef5-888c-a96b229eb6f5)

`CLILX02 Debian 12` ➡️ `CLILX03 Debian 12`

![CLI2](https://github.com/user-attachments/assets/e9ab6555-3f01-4889-8bc8-9c5a87ecf4cf)






















