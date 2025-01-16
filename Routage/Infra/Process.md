      # Procédé  afin de gérer/ sécuriser l'infra
***
## SOMMAIRE

### 1️⃣`Sécurisation du Switch`
### 2️⃣`Vlan administration et IP`
### 3️⃣``
### 4️⃣``
### 5️⃣``
### 6️⃣``
### 7️⃣``
### 8️⃣``

***
***

### 1️⃣`Sécurisation du Switch`

#### I)
#### C'est un mauvaise pratique d'avoir tout les port sur le même Vlan, comme dans la configuration par defaut.
#### 1.1) Changer son nom grace
      saiph#hostname <name>

#### 1.2) Rentrer le switch sur un domaine, le domaine sert entre autre à créer des clé SSH
         saiph(config)#ip domain-name stars.local

#### 1.3) Création d'un Vlan exotique et le fermer administrativement(afin de retarder un attaquant évantuel, qui chercherai à accéder à l'infra via les interfaces)
        saiph(config)#vlan 399
        saiph(config) shutdown

#### 1.4) Passer les Interfaces en mode access(pour éviter qu'elles ne se fassent négocier en mode trunck) 
        saiph(config-if)#interface range fastEthernet 0/1-24

![image](https://github.com/user-attachments/assets/5cb509b3-912b-4173-906f-cb5687907e79)

#### 1.5) Déplacer les interfaces sur le Vlan 399 créer précédement 
       saiph(config-if)#switchport access vlan 399
    

![image](https://github.com/user-attachments/assets/aba67810-14e0-4a7d-ae8e-7736462ec0eb)

#### Et si on regarde la running config =>

![image](https://github.com/user-attachments/assets/0737aa01-ea9a-4b23-bf24-464d404b6ee8)

### 1.6 ) Eteindre administrativement les interfaces fast Ethernet et Gigabit
            saiph#conf t
            saiph(config)#interface range fastEthernet 0/1-24 
            saiph(config-if-range)#shutdown
            saiph(config)#interface range gigabitEthernet 0/1-2
            saiph(config-if-range)#shutdown

![image](https://github.com/user-attachments/assets/bb3be8f8-51b1-4cfb-abf9-0e5c92ed274e)


***
***

### 2️⃣`Vlan administration et IP`

#### 2.1) Création du Vlan Admin
            saiph#conf ter
            saiph(config)#vlan 99
            saiph(config-vlan)#name admin

### 2.2) Donner une IP au Vlan 99
            saiph(config-if)#ip address

### 2.3) Renseigner le default gateway
            ip default-gateway 192.168.99.254


### 2.4) Copier running-config => startup-config 
            saiph#copy running-config startup-config

### Vérif:
![image](https://github.com/user-attachments/assets/9fb0bd7a-d3af-4060-aab7-25e1c705f13a)

![image](https://github.com/user-attachments/assets/0bd2acf3-c617-41c2-8513-ba72ec8c49eb)
































































