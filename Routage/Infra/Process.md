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
      hostname <name>

#### 1.2) Rentrer le switch sur un domaine, le domaine sert entre autre à créer des clé SSH
         ip domain-name stars.local

#### 1.3) Création d'un Vlan exotique(afin de retarder un attaquant évantuel, quiu chercherai à accéder à l'infra via les interfaces)
        vlan 399

#### 1.4) Passer les Interfaces en mode access(pour éviter qu'elles ne se fassent négocier en mode trunck) 
        interface range fastEthernet 0/1-24

![image](https://github.com/user-attachments/assets/5cb509b3-912b-4173-906f-cb5687907e79)































