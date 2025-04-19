# Création de dossier partager entre linux et windows via smb

---

## 1️⃣ Installer SAMBA
## 2️⃣ Configurer le partage
## 3️⃣ Créer utilisateur et groupe de partage
## 4️⃣ Créer dossier de partage
## 5️⃣ Accéder au partage

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
     path = /srv/partage
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




## 3️⃣ Créer utilisateur et groupe du partage

        adduser <USER> # Créer utilisateur , j'utilisea un user déjà présent

>Pour que l'utilisateur puisse se connecter au partage, il faut l'autoriser dans Samba, en plus de la création au sein du système Linux.
>
>Pour cela, il faut utiliser la commande "smbpasswd" pour déclarer l'utilisateur et lui créer un mot de >passe Samba (ce dernier pouvant être différent du mot de passe du compte sur le système).

        smbpasswd -a <USER> ⬆️

        groupadd <GROUPE> #Créer le groupe partage et ajouter l'utilisateur créer précédement
        gpasswd -a <USER><GROUPE>

---

## 4️⃣ Créer dossier de partage

    mkdir <CHEMIN DECLARER DANS LE FICHIER DE CONF DE SAMBA> # Ici /home/practoxx/Documents
    chgrp -R partage <CHEMIN> # Attribuer le groupe "partage" comme groupe propriétaire de ce dossier
    chmod -R g+rw /srv/partage/ # Ajouter les droits de lecture/écriture à ce groupe sur ce dossier
    ls -l /srv/ # Vérif



---

## 5️⃣ Accéder au partage
























