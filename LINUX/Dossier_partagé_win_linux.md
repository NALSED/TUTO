# Création de dossier partager entre linux et windows via smb

---

## 1️⃣ Installer SAMBA
## 2️⃣ Configurer le partage
## 3️⃣ Créer utilisateur et groupe de partage
## 4️⃣ Créer dossier de partage
## 5️⃣ Accéder au partage
## 6️⃣ Si ufw
## 7️⃣ Script mise en place
---
---

## 1️⃣ Installer SAMBA
    sudo apt update && sudo apt upgrade
    apt-get install -y samba
    smbd --version # Version
    systemctl status smbd # Status
    systemctl enable smbd # Autoriser Samba

---

## 2️⃣ Configurer le partage
    nano /etc/samba/smb.conf

#### Ajouter les lignes suivantes au fichier

      [partage]
     comment = Partage de données
     path = <CHEMIN> ici /home/<USER>/Documents/partage2
     guest ok = no
     read only = no
     browseable = yes
     valid users = @partage


> [partage] : sert à spécifier le nom du partage entre "[]", c'est le nom qui devra être utilisé pour accéder au partage
>
> comment : description du partage
>
> path : chemin vers le dossier à partager, sur le serveur
>
> guest ok : accès invité au partage (par défaut "no"). Si vous décidez d'activer cette option, vous devez configurer l'option "guest account" qui par défaut prend la valeur "nobody".
>
> read only : partage accessible uniquement en lecture seule (yes ou no)
>
> browseable : le partage doit-il être visible ou masqué si on liste les partages du serveur avec un hôte distant (découverte réseau). La valeur "yes" permet de le rendre visible.
>
> valid users : spécifier les utilisateurs ou les groupes qui ont les droits d'accès au partage (les droits sur le système de fichiers doivent être cohérents vis-à-vis de cette autorisation). On précise un utilisateur avec son identifiant et un groupe avec son identifiant précédé du caractère "@". Pour indiquer plusieurs valeurs, séparez-les par une virgule.

        systemctl restart smbd




## 3️⃣ Créer utilisateur et groupe du partage OU utiliser un utilisateur existant

### 3.1) Créaation

        adduser <USER> # Créer utilisateur , j'utilisea un user déjà présent

>Pour que l'utilisateur puisse se connecter au partage, il faut l'autoriser dans Samba, en plus de la création au sein du système Linux.
>
>Pour cela, il faut utiliser la commande "smbpasswd" pour déclarer l'utilisateur et lui créer un mot de >passe Samba (ce dernier pouvant être différent du mot de passe du compte sur le système).

        smbpasswd -a <USER> ⬆️

        groupadd <GROUPE> #Créer le groupe partage et ajouter l'utilisateur créer précédement
        gpasswd -a <USER><GROUPE>


### 3.2) Utiliser les même commande ⬆️ avec l'utilisateur voulu.

---

## 4️⃣ Créer dossier de partage

#### TUTO [BELGINUX](https://belginux.com/creer-un-partage-samba/)
    mkdir <CHEMIN DECLARER DANS LE FICHIER DE CONF DE SAMBA> # Ici /home/<USER>/Documents/partage2
    sudo chmod -R 777 <CHEMIN>

#### TUTO [IT](https://www.it-connect.fr/serveur-de-fichiers-debian-installer-et-configurer-samba-4/)
    chgrp -R partage <CHEMIN> # Attribuer le groupe "partage" comme groupe propriétaire de ce dossier
    chmod -R g+rw /srv/partage/ # Ajouter les droits de lecture/écriture à ce groupe sur ce dossier
    ls -l /srv/ # Vérif



---

## 5️⃣ Accéder au partage

#### Entrer l'ip de la machine, avec les identifiant créer via smb.

---

## 6️⃣ Si ufw

#### Si ufw est installer sur la machine 

    sudo ufw allow 139
    sudo ufw allow 445
    sudo ufw allow samba


---

## 7️⃣ Script mise en place


        #!/bin/bash

        MOTDEPASSE=""
        UTILISATEUR=""

        sudo apt update && sudo apt upgrade

        sudo apt-get install -y samba

        sudo systemctl enable smbd

        sudo echo -e "[partage] \ncomment = Partage de données\npath = /home/$UTILISATEUR/Documents/Partage\nguest ok = no\nread only = no\nbrowseable = yes\nvalid users = practoxx" | sudo tee -a /etc/samba/smb.conf 

        sudo systemctl restart smbd

        sudo sudo echo -e "$MOTDEPASSE\n$MOTDEPASSE" | sudo smbpasswd -a $UTILISATEUR

        sudo smbpasswd -e $UTILISATEUR 

        sudo mkdir /home/$UTILISATEUR/Documents/Partage

        sudo chmod -R 777 /home/$UTILISATEUR/Documents/Partage











