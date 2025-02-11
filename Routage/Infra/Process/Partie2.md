# Dans cette deuxiéme partie Réaliser plusieurs méthode de routage :


## SOMMAIRE :
### 1️⃣ `Router on a Stick`
### 2️⃣ `Routage avec switch N3`
### 3️⃣
### 4️⃣
### 5️⃣

***
***

 <details>
<summary>
<h2>
:arrow_forward: 1️⃣ Router on a Stick  
</h2>
</summary>

 #### Cette méthode consiste à subdiviser l'interface physique d'un routeur en plusieurs sous interfaces logiques. Cette méthode peut être utilisée quand l'équipement à disposition ne possède pas suffisement d'interfaces physiques pour servir de passerelle par défaut à tous les VLANs de l'infrastructure.

### Préparation du Lab

#### 1.1 ) Nous repartons de la sauvegarde vidéo 18, nettoyage de l'infra:
* Les interfaces Gigabytes des trois switchs sont libérés, nettoyés et éteints.
*Le mode trunk est reconstitué via les ports FastEthernet corespondant
* les PC retrouvent leurs Vlan

#### 1.2) Le test sera réalisé avec un switch 4331( se ne sera pas la solution retenu)

#### 1.3) Configurer le routeur Routeur3

#### Passer l'interface Gigabiteeternet 0/1 en Trunk (sur saiph)
     saiph(config)#interface gigabitEthernet 0/1
     saiph(config-if)#switchport mode trunk
     saiph(config-if)#no switchport access vlan 3000
     saiph(config-if)#no shutdown 

#### 1.4) Créer le routage inter Vlan
#### On réalise ça avec un routeur On a Stick:
     Router#  conf t

#### 1.5) Division de l'interface Gigabiteethernet 0/0/1
     Router(config-if)#interface gigabitEthernet 0/0/1.10

#### 1.6) On lui applique le protocole `iE802.1Q` et on tag le Vlan
      Router(config-subif)#encapsulation dot1Q 10 
   
#### On répéte l'opération pour le Vlan 20,30,40

#### 1.7) Appliquer des adresse IP aux Interfaces créer précédement
      Router(config)#interface gigabitEthernet 0/0/1.10
      Router(config-subif)#ip address 10.10.10.254 255.255.255.0

#### On répéte l'opération pour le Vlan 20,30,40
#### Copie de la config
     Router(config-subif)#do wr

### ⚠️Tout les Vlan doivent être déclarer sur tous les switchs, sinon ça ne fontionne pas!!⚠️
### Si l'on oubli des Vlans en raport avec la division on a stick impossible de se connecter.
### ⚠️Panne possible sur saiph vvlan non déclaré, juste vvlan 10 les autres non donc pas de routage possible......



 
 </details> 


***
***


<details>
<summary>
<h2>
:arrow_forward: 2️⃣ `Routage avec switch N3`<details> 
</h2>
</summary>


#### Ici utilisation d'un switch de niveau 3 afin de réaliser un routage pour notre réseau.

#### Switch utilisé sur cisco 3650 24PS

#### 2.1) Ajouter les modules d'alimentation
![image](https://github.com/user-attachments/assets/4bda0f2e-c3ca-42de-ac29-cb1f2676f545)

#### 2.2) Changer de nom et Sécuriser le switch en éteignant les interfaces GigabitEtehrnet 
         Switch(config)#hostname rigel
         rigel>en
         rigel#conf t
         rigel(config)#interface range gigabitEthernet 1/0/1-24 
         rigel(config-if-range)#shutdown
         rigel(config)#interface range gigabitEthernet 1/1/1-4 
         rigel(config-if-range)#shutdown 

#### 2.3) Activer le routage sur le switch 
        rigel(config)#ip routing


#### 2.4) Création des Vlan
        rigel(config-vlan)#name DIR
        rigel(config-vlan)#ex
        rigel(config)#vlan 20
        rigel(config-vlan)#name FIN
        rigel(config-vlan)#EX
        rigel(config)#VLAN 30
        rigel(config-vlan)#name MARK
        rigel(config-vlan)#ex
        rigel(config)#vlan 40
        rigel(config-vlan)#name PROD
        rigel(config-vlan)#ex

#### 2.5) Donner des adresses au Vlan
        rigel#conf t
        rigel(config)#interface vlan 10
        rigel(config-if)#ip address 10.10.10.254 255.255.255.0
        rigel(config-if)#ex
        rigel(config)#interface vlan 20
        rigel(config-if)#ip address 10.20.20.254 255.255.255.0
        rigel(config-if)#ex
        rigel(config)#interface vlan 30
        rigel(config-if)#ip address 10.30.30.254 255.255.255.0
        rigel(config-if)#ex
        rigel(config)#interface vlan 40
        rigel(config-if)#ip address 10.40.40.254 255.255.255.0
        rigel(config-if)#ex
        rigel(config)#do wr


## CHANGEMENT DES INTERFACES DES SWITCH

### `SAIPH`

#### 2.6) Eteindre et sécuriser interface FastEthernet0/23 et interface FastEthernet0/24

           interface FastEthernet0/23
           switchport access vlan 3000
           switchport mode access
           shutdown
           !
           interface FastEthernet0/24
           switchport access vlan 3000
           switchport mode access
           shutdown


#### 2.7) changer le configuration de interface GigabitEthernet0/1 et interface GigabitEthernet0/2
          interface GigabitEthernet0/1
          switchport access vlan 3000
          switchport mode access
          shutdown
          !
          interface GigabitEthernet0/2
          switchport mode trunk

### ALNILAM

#### 2.8)  Configuration de interface FastEthernet0/24,interface GigabitEthernet0/2
         interface FastEthernet0/24
         switchport access vlan 3000
         switchport mode access
         shutdown

         interface GigabitEthernet0/2
         switchport mode trunk
         !

### AINITAK 

#### 2.9)  Configuration de interface FastEthernet0/23,interface GigabitEthernet0/2

         interface FastEthernet0/23
         switchport access vlan 3000
         switchport mode access
         shutdown

         interface GigabitEthernet0/2
         switchport mode trunk

#### 2.10) Relier le switch N3 avec les switch N2

![image](https://github.com/user-attachments/assets/a90db12a-04e1-4e15-b367-259eb8bce20e)

#### 2.11) Passer les interfaces de Rigel en Trunk
            rigel(config)#interface range gigabitEthernet 1/0/1-3
            rigel(config-if-range)#switchport mode trunk 
            rigel(config-if-range)#no shutdown

##### ⚠️Les differentes machines peuvent communiquer




















































</details>















