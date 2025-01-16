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
      ?
      
### Savoir ce que l'on peux consulter
      show => sh

### Elévation de privilége
      enable => en 

### Passer en mode configuration(terminal) + entrer pour avoir les option de configuration:
      configure 

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
        ip domain-name <domain name>

## VLAN  
### Créer un Vlan
      vlan <number>

## INTERFACES
### configuration UNE interfaces dans le menu de configuration
        interface fastEthernet <interface number>
### Configurer une étendu pour les interfaces 1 => 24
     interface range fastEthernet <0/1-24>   
### Empécher le Trunk sur une interface (en conf t et après avoir selectioné la/les interfaces)
### ⚠️Pensez à le faire sur fastEthernet et GigabitEthernet     
     switchport mode access     






























