# Copier la configuration d'un switch
## ⚠️SI un/des Vlan on une adresse IP dédié penser à créer le Vlan existant sur le switch d'origine et lui attribuer un IP, ICI le Vlan 100 NET avec une IP n'a pas suivit la config.
## A vérifier mais ce qui n'est pas présent dans la startup/running config, n'est pas copié!!
***

## SOMMAIRE 
### 1️⃣ `copier la configuration`
### 2️⃣ `importer le config`

***
***
### 1️⃣ `copier la configuration`
### 1.1)
#### 🔵 Voir la configuration
        saiph# show startup-config       
#### 🔴 Puis copier depuis hostname => 🟢 end
![image](https://github.com/user-attachments/assets/1d216bed-3521-4342-9b06-d95b6ee1da9d)

![image](https://github.com/user-attachments/assets/44432357-55fb-43bd-88ea-b0b2379e9a91)
 ### 1.2)
#### Se rendre dans texte editor du PC de conf => copy
![image](https://github.com/user-attachments/assets/c81a1f9f-a3c5-45cd-8dc0-c9eb1a28d104)

### 1.3) (optionnel)
#### Si besoin faire les modification => ICI IP et NAME

#### saiph => alnilam
#### ip address 10.100.100.252 255.255.255.248 => ip address 10.100.100.251 255.255.255.248

### 2️⃣ `importer le config`
### se rendre dans le menu de configuration du nouveau routeur
        Switch>en
        Switch#conf ter
        Enter configuration commands, one per line.  End with CNTL/Z.
        Switch(config)#
### copier depuis le fichier texte =>  Switch(config)#
        alnilam#copy running-config startup-config

![image](https://github.com/user-attachments/assets/204d14c6-a428-4b21-bd85-67386093b33a)


























