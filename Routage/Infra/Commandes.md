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

### Pour faire apparaitre plusieur lignes
        show <argument> | include/exclude <argument>


***
***
# 2 `Configuration + Création`

### Rentrer le switch dans un domaine en (#conf ter)
      saiph(config)#ip domain-name <domain name>

***

## `VLAN`  
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
## `INTERFACES`
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

***
***
## `Mot de passe`



### Avec un mot de passe chiffré:
            saiph(config)#enable algorithm-type sha-256 secret <motDePasse> 
### impossible ici sha-256 n'est pas implémenté sur IOS

### Activer le criptage du mot de passe(invisible dans run/start-conf)
            saiph(config)#service password-encrytion
            saiph(config)#enable password salut => le mot de passe ne sera plus en claire 
### Pour activer/désactiver des privilége en fontion du poste de la personne qui se connect
            saiph(config)#enable secret level ?
                 <1-15>  Level number
### Chiffre bas = privilége bas [DOC CISCO](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/security/d1/sec-d1-xe-3se-3650-cr-book/sec-d1-xe-3se-3850-cr-book_chapter_010.pdf)
















