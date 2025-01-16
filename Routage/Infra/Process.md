# Procédé  afin de gérer/ sécuriser l'infra
***
## SOMMAIRE

### 1️⃣`Sécurisation du Switch`
### 2️⃣``
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

#### 1.3) Création d'un Vlan exotique(afin de retarder un attaquant évantuel, quiu chercherai à accéder à l'infra via les interfaces)
        saiph(config)#vlan 399

#### 1.4) Passer les Interfaces en mode access(pour éviter qu'elles ne se fassent négocier en mode trunck) 
        saiph(config-if)#interface range fastEthernet 0/1-24

![image](https://github.com/user-attachments/assets/5cb509b3-912b-4173-906f-cb5687907e79)

#### 1.5) Déplacer les interfaces sur le Vlan 399 créer précédement (en conf t interface)
       saiph(config-if)#switchport access vlan 399

![image](https://github.com/user-attachments/assets/aba67810-14e0-4a7d-ae8e-7736462ec0eb)

#### Et si on regarde la running config =>

![image](https://github.com/user-attachments/assets/0737aa01-ea9a-4b23-bf24-464d404b6ee8)



























