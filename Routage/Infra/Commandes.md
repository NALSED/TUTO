# Listes de commande 

#### [Liste commandes cisco](https://fr.slideshare.net/slideshow/lexiquedecommandesciscopdfbarryfrench/267668238)

### Cette liste à pour but de gérer/sécuriser une infrastructure.

***
### niveau de configuration :
                  
* `Utilisateur`  
* `Privilégié`    
* `configuration` 
               
***

## Les commande suivante sont réalisé sur un Switch de niveau 2:

# 1 `Recherche + priviléges+filtre`


## En Utilisateur + privilégié

### Savoir ce que l'on peux faire avec la commande 
      saiph>?
      
### Savoir ce que l'on peux consulter
      saiph>show => sh

### Elévation de privilége
     saiph>enable => en 
     saiph#

### Passer en mode configuration(terminal) + entrer pour avoir les option de configuration:
     saiph#configure 
     saiph(config)#

![image](https://github.com/user-attachments/assets/315a820d-a652-4c49-a605-f8f88856df2b)

### Voir la configuration actuel

        show running-config

### Voir la configuration au démarage

        show startup-config

### Sauvegarger la conf actuel
        copy running-config startup-config => cp run start => wr


### Voir l'état des interfaces
        show ip interfaces brief => sh ip int br

## FILTRES : 
        show <arguments> | include/exclude <arguments>

***
***
# 2 `Configuration + Création`

### Rentrer le switch dans un domaine en (#conf ter)
      saiph(config)#ip domain-name <domain name>

***

## VLAN  
### Créer un Vlan
       saiph(config)#vlan <number>

### Suprimmer un Vlan/interface vlan 100
       saiph(config)#no vlan <number>
       saiph(config)#no interface vlan <number>

### Changer le nom d'un Vlan
        saiph(config)#vlan 99     
        saiph(config-vlan)#name admin

### 



***
## INTERFACES
### configuration UNE interfaces dans le menu de configuration
        saiph(config)#interface fastEthernet <interface number>
        saiph(config-if)#

### Configurer une étendu pour les interfaces 1 => 24
     saiph(config-if)#interface range fastEthernet <0/1-24>   
     saiph(config-if-range)#

### Empécher le Trunk sur une interface (en conf t et après avoir selectioné la/les interfaces)
### ⚠️Pensez à le faire sur fastEthernet et GigabitEthernet     
     saiph(config-if)#switchport mode access     

### Déplacer une/des interfaces sur un Vlan
      saiph(config-if-range)#switchport access vlan 399

### Créer et Attribuer un Vlan à une interface
      saiph(config)#interface fastEthernet 0/4
      saiph(config-if)#switchport access vlan 10


























