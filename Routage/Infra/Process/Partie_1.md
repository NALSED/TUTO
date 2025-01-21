# Procédé  afin de gérer/ sécuriser l'infra
***
## SOMMAIRE

## I Partie 1
### 1️⃣`Sécurisation du Switch`
### 2️⃣`Vlan administration et IP`
### 3️⃣`SSH et Sécurité`
### 4️⃣`Création des Vlan`
### 5️⃣`Trunk et basulement Vlan`
### 6️⃣``
### 7️⃣``
### 8️⃣``





***
***
<details>
<summary>
<h2>
:arrow_forward: 1️⃣`Sécurisation du Switch`
</h2>
</summary>


#### C'est un mauvaise pratique d'avoir tout les port sur le même Vlan, comme dans la configuration par defaut.

#### 1.1) Changer son nom 
      saiph#hostname <name>

#### 1.2) Rentrer le switch sur un domaine, le domaine sert entre autre à créer des clé SSH
         saiph(config)#ip domain-name stars.local

#### 1.3) Création d'un Vlan exotique et le fermer administrativement(afin de retarder un attaquant évantuel, qui chercherai à accéder à l'infra via les interfaces)
        saiph(config)#vlan 3000
        saiph(config) shutdown

#### 1.4) Passer les Interfaces en mode access(pour éviter qu'elles ne se fassent négocier en mode trunck) 
        saiph(config-if)#interface range fastEthernet 0/1-24

![image](https://github.com/user-attachments/assets/5cb509b3-912b-4173-906f-cb5687907e79)

#### 1.5) Déplacer les interfaces sur le Vlan 3000 créer précédement 
       saiph(config-if)#switchport access vlan 3000
    

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

</details>


***
<details>
<summary>
<h2>
:arrow_forward: 2️⃣`Vlan administration et IP` 
</h2>
</summary>
      
#### 2.1) Création du Vlan Admin
            saiph#conf ter
            saiph(config)#vlan 100
            saiph(config-vlan)#name <NAME> (NET)

### 2.2) Donner une IP au Vlan 100
            saiph(config-if)#ip address (10.100.100.252 255.255.255.248)

### 2.3) Renseigner le default gateway
            saiph(config)# interface vlan 100
            saiph(config-if)#ip default-gateway gateway(10.100.100.254)


### 2.4) Copier running-config => startup-config 
            saiph#copy running-config startup-config

### Vérif:
![image](https://github.com/user-attachments/assets/9fb0bd7a-d3af-4060-aab7-25e1c705f13a)

![image](https://github.com/user-attachments/assets/0bd2acf3-c617-41c2-8513-ba72ec8c49eb)

</details>

***

<details>
<summary>
<h2>
:arrow_forward: 3️⃣`SSH et Sécurité VTY`
</h2>
</summary>

### 3.1) Sécuriser la connection => enable
### Le mot de passe ne sera plus en claire dans run/start-config
            saiph(config)#service password-encryption 


### Créer le MDP ici (131213)
            saiph(config)# enable secret <MDP>
![image](https://github.com/user-attachments/assets/5293facc-62c0-49b2-a877-e22dabcd6fb1)

### 3.2) `SSH`

### 3.2.1) Créer un utilisateur et mot de passe ici (131213)
            saiph(config)#username admin1 sercret <MDP>

![image](https://github.com/user-attachments/assets/6bda7cbf-25ad-4a05-8af1-93c3e4578dfa)

### 3.2.2) Création ssh
            saiph(config)#ip ssh version 2

### 3.2.3) MDP
            saiph(config)#crypto key generate rsa => 2048 bit

### 3.2.4) Time out
            saiph(config)#ip ssh time-out 120 => en secondes .. ⚠️

### 3.2.5) Configurer le nombre de tentatives de connection
            saiph(config)#ip ssh authentication-retries 3

![image](https://github.com/user-attachments/assets/e9124b0b-5ecb-46ec-a527-df0120d4f6f8)


### 3.3) `VTY et Line Console`

### La bonne pratique est de configurer au moins 3 lignes, afin de pouvoir se connecter à distance (1), en même temps qu'un autre admin (2), et un troisiéme lignes de secours (3).
### Et configuration des interfaces consoles afin de les rendre impossible sans MDP.

![image](https://github.com/user-attachments/assets/28455763-60f9-4c46-ba0d-8cc76a1cdc72)

### 3.3.1) Configuration `Line Console` ⏫ 
### Rentrer dans ça conf
                 saiph(config)#line console 0

### Utiliser un login local (ici admin1)
                 saiph(config-line)#login local

### Mettre un time out sur cette interface(si une utilisation inactive prolongué est détecté la session est fermé)
                 saiph(config-line)#exec-timeout 3 => en minutes

### ⚠️Maintenant si on se connect avec le cable bleu sur le switch un login et un MDP sera demandé.

### 3.2.2) `VTY`
### Ici configuration du nombre de lignes dédiées à la gestion à distance du switch

### Selectionner la/les ligne(s)
             saiph(config)# line vty 0 2                 

### Accées par user local
            saiph(config-line)# login local

### Time out ⚠️en minutes
            saiph(config-line)# exec-timeout 5

### Quel protocol passe par VTY en input => ICI SSH
            saiph(config-line)# transport input ssh

### Qu'on ne puisse faire que du ssh  
            saiph(config-line)# transport output none

### Sécuriser les autre line VTY (pas de connection)
            saiph(config)#line vty 3 15
            saiph(config-line)#no login

![image](https://github.com/user-attachments/assets/cb0ef47f-69d6-45e0-b27e-4fd22aefa992)


            saiph#copy running-config startup-config

</details>


***

<details>
<summary>
<h2>
:arrow_forward: 4️⃣`Création des Vlan  
</h2>
</summary>

### ⚠️Ici un deuxiéme switch est configuré en copiant la configuration de saiph
#### 4.1) Brancher PC1 (FastEthernet 0/1) et PC2  (FastEthernet 0/2) sur alnilam
#### 4.2) Renseigner les IP des interfaces 
![image](https://github.com/user-attachments/assets/452b3aaa-676c-4c16-aa01-e97ca8f1bf96)
* #### PC1 10.10.10.1 255.255.255.0
* #### PC2 10.10.10.2 255.255.255.0

#### 4.3) Créer les Vlan 10 et Vlan 20
            alnilam(config)#vlan 10
            alnilam(config)#vlan 20

#### 4.4) Déplacer les interfaces sur les bon Vlan ici :
#### * fast ethernet 0/1-2 => vlan10
               alnilam#conf ter   
               alnilam(config)#interface rangefastEthernet 0/1-2
               alnilam(config-if_range)# switchport access vlan 10

#### * fast ethernet 0/13 => vlan12
               alnilam#conf ter   
               alnilam(config)#interface rangefastEthernet 0/13
               alnilam(config-if)# switchport access vlan 20
               alnilam(config-if)#no shutdown

</details>


















