# Instalation de la solution Plex

---

### Ce tuto détaillera l'instalation de la solution plex. Afin de créer une platforme multimedia, utilisation du partage `NFS` pour lecture des fichier par Plex et partage `SMB` pour transfert fichier depuis la machine Admin (PC) => Plex (Debian).


---

## 1️⃣ `Installation +Configuration NFS`
## 2️⃣ `Installation +Configuration Plex`
## 3️⃣ `Installation +Configuration SMB`

---
--- 

## 1️⃣ `Installation +Configuration NFS`

### 1.1) Instalation protocole NFS:
      sudo apt update
      sudo apt-get -y install nfs-kernel-server

### 1.2) Demarage du systeme
     sudo systemctl enable nfs-server.service
     sudo systemctl status nfs-server.service

### 1.3) Resultat attendu 
![image](https://github.com/user-attachments/assets/3e33b628-b5b6-483b-9243-38ebf82fa892)

### 1.4) Créer Dossier plex et Changer les permissions sur la partage
### Utilisation du partage /home/sednal (créer durant la partion du disque pour bareos)
      sudo mkdir /home/sednal/Plex/Film
      sudo chown nobody:nogroup /home/sednal/Plex/Film
      sudo chmod 755 /home/sednal/Plex/Film

![image](https://github.com/user-attachments/assets/4b1d0080-35d9-44a7-9f38-d8304b374fb2)

### 1.5) Edition partage NFS
### Pour déclarer les partages NFS, edition du fichier /etc/exports
      sudo nano /etc/exports
      /home/sednal/Plex/Film 192.168.0.141/24(rw,sync,anonuid=65534,anongid=65534,no_subtree_check)

<details>
<summary>
<h2>
explication ligne /etc/exports
</h2>
</summary>

/mnt/plex/plexmedia  : le chemin local du dossier à partager
192.168.0.141/24 : l'adresse IP ou le réseau à autoriser, si vous souhaitez autoriser seulement une adresse IP spécifique, précisez cette adresse IP
() : les options pour le partage
rw : partage accessible en lecture et écriture, à remplacer par "ro" pour la lecture seule
sync : écrire les données et les vérifier avant de répondre à la requête suivante : plus lent, mais plus fiable vis-à-vis des corruptions de données. L'autre mode est "async".
anonuid : ID de l'utilisateur à utiliser pour les connexions anonymes (65534 = nobody)
anongid : ID du groupe à utiliser pour les connexions anonymes (65534 = nogroup)
no_subtree_check : désactiver la vérification des sous-dossiers, recommandé pour des raisons de fiabilité

</details>

### 1.6) Appliquer la configuration
     sudo exportfs -a

### Vérifier les partages:
      sudo showmount -e 192.168.0.141

### Resultat Attendu
![image](https://github.com/user-attachments/assets/2d2f25d3-4ff9-4278-9868-ccf4dece874b)

---

## 2️⃣ `Installation +Configuration Plex`

### 2.1) Créer le Dossier d'instalation
       mkdir Plex
       cd Plex

### 2.2) Télécgargement 
      wget https://downloads.plex.tv/plex-media-server-new/1.41.0.8994-f2c27da23/debian/plexmediaserver_1.41.0.8994-f2c27da23_amd64.deb

### 2.3) Instalation 
      dpkg -i plexmediaserver_1.41.0.8994-f2c27da23_amd64.deb

### 2.4) Se connecter via l'URL.
      http://192.168.0.141:32400/web

### 2.5) Ajouter la bibliothéque
![image](https://github.com/user-attachments/assets/275fb583-2a78-41e9-929e-bf089970b60c)


---

## 3️⃣ `Installation +Configuration SMB`

# [VOIR](https://github.com/NALSED/TUTO/blob/main/PERSO/LINUX/SYSTEM/Dossier_partag%C3%A9_win_linux.md)

## ⚠️ Partage NFS Bibliothéque PLEX sur WEBUI et SMB doivent être le même dossier!
### ICI /mnt/plex/plexmedia

### 3.1) Utilistaion du Script
          #!/bin/bash

          # Variable en fontion des besoins
          MOTDEPASSE=""
          UTILISATEUR=""
    
          # MAJ
          sudo apt update && sudo apt upgrade

          # Instal samba
          sudo apt-get install -y samba

          # Démarre samba au démarage
          sudo systemctl enable smbd

          # Créer le partage dans le fichier de conf de samba ? SI PBM remplacer users = $UTILISATEUR => users = nom d'utilisateur sans la variable
          sudo echo -e "[partage] \ncomment = Partage de données\npath = /mnt/plex/plexmedia\nguest ok = no\nread only = no\nbrowseable = yes\nvalid users = $UTILISATEUR" | sudo tee -a /etc/samba/smb.conf 

          # Redémare SMB
          sudo systemctl restart smbd

          # Créer un MDP pour l'utilisateur 
          sudo sudo echo -e "$MOTDEPASSE\n$MOTDEPASSE" | sudo smbpasswd -a $UTILISATEUR

          # Autorise cet utilisateur à utiliser Samba
          sudo smbpasswd -e $UTILISATEUR 

 ### 3.2) Connection     
 ### Entrer IP serveur dans la barre de recherche Windows:           
![image](https://github.com/user-attachments/assets/787e01be-08ae-4de5-9a14-423e81544337)









