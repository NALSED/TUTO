# Dans cette deuxiéme partie Réaliser plusieurs méthode de routage :


## SOMMAIRE :
### 1️⃣ `Router on a Stick`
### 2️⃣
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

#### Passer l'interface Gigabiteeternet 0/1 en Trunk
     saiph(config)#interface gigabitEthernet 0/1
     saiph(config-if)#switch mode trunk
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



 
 </details> 



















