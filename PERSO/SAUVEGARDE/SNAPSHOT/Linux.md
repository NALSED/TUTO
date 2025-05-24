# Configuration Snapshot Linux

---

### Ce Tuto commence, avec RAID, PostGreSQL, Baros opérationel sur Serveur et Client  => [TUTO/Install et Conf](https://github.com/NALSED/TUTO/tree/main/PERSO/Bareos)

---

## `SOMMAIRE` : 

* ### 1️⃣ `Serveur Sauvegarde`

  * ### 1) Installation  

  * ### 2) Configuration 
   

---

* ### 2️⃣ `DNS 1`

  * ### 1) Installation 

  * ### 2) Configuration 
---

* ### 3️⃣ `DNS 2`

   * ### 1) Installation 
   
   * ### 2) Configuration 

---

* ### 4️⃣ `Serveur Web`

  * ### 1) Installation 

  * ### 2) Configuration
   
---
---



<details>
<summary>
<h2>
1️⃣ Serveur Sauvegarde
</h2>
</summary>

### Ce Tuto commence après l'intallation du client sur le rasberry-pi voir [ici](https://github.com/NALSED/TUTO/blob/main/PERSO/Bareos/-5-Installation-Client.md#2%EF%B8%8F%E2%83%A3-instalation-client-bareos-linux-1)
## ⚠️Syncronisation des montres!!
 	timedatectl set-timezone Asia/Yerevan
 
### 1.1) Instalation Logiciel
    apt install timeshift  
    apt install rsync 
    apt install cron
    

---

## 2) Configuration 


### 2.1) Installer le script dans /root
    nano /root/ScriptSnapshot.sh 

### 2.2) Le script     
         #!/bin/bash

          SNAPSHOT_DIR="/timeshift/snapshots"

          # Supprimer tous les anciens snapshots
          sudo rm -rf "${SNAPSHOT_DIR}"/*

          # Créer un nouveau snapshot
          sudo timeshift --create --scripted

### 2.3) Droit
    chmod +x ScriptSnapshot.sh

### 2.4) Executer le Script
    ./ScriptSnapshot.sh

### 2.5) Dans l'utilisateur sednal créer le dossier du tranfert vers Bareos

      mkdir SnapshotSave

### 2.6) Configurer Cron DANS root
      crontab -e

### 2.6.1) Choisir l'éditeur => 1
### si erreur
      select-editor # et changer

### 2.6.2) 

		10 2 1 2,6,10 * /root/ScriptSnapshot.sh

### 2.6.3) Copie Snapshot
		
		40 2 1 2,6,10 * rsync -a /timeshift/snapshots /home/sednal/TotalDNS1/SnapshotSave/


### 📝 FICHIER CRON COMPLET
![image](https://github.com/user-attachments/assets/151c708f-ea54-43ec-aaae-e8bf6d11568e)

## 2.7) Changer le dossier de sauvegarde de timeshift:
### Actuelement timeshift utilise md0 (RAID1).
### Je veux que se soit Bareos qui orchestre les transferts sur différents support pour plus de cohérence et de clarté.

### Créer le dossier de reception des snapshot
	sudo mkdir -p /timeshift/snapshots

### Spécifier à timeshift d'utiliser /dev/sdb1 pour stocker les snapshots
	sudo timeshift --snapshot-device /dev/sdb1

### Choisir type de sauvegarde rsync
	sudo timeshift --rsync

### Lancer un test
	timeshift --create

### C'est OK
![image](https://github.com/user-attachments/assets/a1948098-9b81-4c83-bd76-fabb21e7b9dc)
	



</details>
---

<details>
<summary>
<h2>
2️⃣ DNS 1
</h2>
</summary>

### Ce Tuto commence après l'intallation du client sur le rasberry-pi voir [ici](https://github.com/NALSED/TUTO/blob/main/PERSO/Bareos/-5-Installation-Client.md#2%EF%B8%8F%E2%83%A3-instalation-client-bareos-linux-1)
## ⚠️Syncronisation des montres!!
 	timedatectl set-timezone Asia/Yerevan
 
### 1.1) Instalation Logiciel
    apt install timeshift  
    apt install rsync 
    apt install cron
    

---

## 2) Configuration 


### 2.1) Installer le script dans /root
    nano /root/ScriptSnapshot.sh 

### 2.2) Le script     
         #!/bin/bash

          SNAPSHOT_DIR="/timeshift/snapshots"

          # Supprimer tous les anciens snapshots
          sudo rm -rf "${SNAPSHOT_DIR}"/*

          # Créer un nouveau snapshot
          sudo timeshift --create --scripted

### 2.3) Droit
    chmod +x ScriptSnapshot.sh

### 2.4) Executer le Script
    ./ScriptSnapshot.sh

### 2.5) Dans l'utilisateur sednal créer le dossier du tranfert vers Bareos

      mkdir SnapshotDNS1

### 2.6) Configurer Cron DANS root
      crontab -e

### 2.6.1) Choisir l'éditeur => 1
### si erreur
      select-editor # et changer

### 2.6.2) Snapshot
		10 2 1 2,6,10 * /root/ScriptSnapshot.sh

### 2.6.3) Copie Snapshot
		
		40 2 1 2,6,10 * rsync -a /timeshift/snapshots /home/sednal/TotalDNS1/SnapshotDNS1/



### 📝 FICHIER CRON COMPLET
![image](https://github.com/user-attachments/assets/32fdbc2c-f8c0-4f14-8dc1-55b037b30b3f)




</details>

---

<details>
<summary>
<h2>
2️⃣ DNS 2
</h2>
</summary>

## 1) Installation 

### 1.1) Instalation Logiciel
    apt install timeshift  
    apt install rsync
    apt install sudo 
    apt install cron
    
### 1.2 Mettre sednal dans sudo 
      su -
      usermod -aG sudo sednal


---





## 2) Configuration 


### 2.1) Installer le script dans /root
    nano /root/ScriptSnapshot.sh 

### 2.2) Le script     
         #!/bin/bash

          SNAPSHOT_DIR="/timeshift/snapshots"

          # Supprimer tous les anciens snapshots
          sudo rm -rf "${SNAPSHOT_DIR}"/*

          # Créer un nouveau snapshot
          sudo timeshift --create --scripted

### 2.3) Droit
    chmod +x ScriptSnapshot.sh

### 2.4) Executer le Script
    ./ScriptSnapshot.sh

### 2.5) Dans l'utilisateur sednal créer les dossier du tranfert
      mkdir TotalDNS2
      cd TotalDNS2
      mkdir BackupDNS2
      mkdir SnapshotDNS2

### 2.6) Configurer Cron
      crontab -e

### 2.6.1) Choisir l'éditeur => 1
### si erreur
      select-editor # et changer

### 2.6.2) Snapshot
		10 2 1 2,6,10 * /root/ScriptSnapshot.sh >> /var/log/snapshotdns2.log 2>&1

		

### 2.6.3) Copie Snapshot
		
		40 2 1 2,6,10 * rsync -a /timeshift/snapshot/ /home/sednal/TotalDNS2/SnapshotDNS2/ >> /var/log/rsyncsnapshotdns2.log 2>&1
		

### 📝 FICHIER CRON COMPLET
![image](https://github.com/user-attachments/assets/afeeddac-854f-4d5f-a5bb-872bfdc43997)



### La copie des dossier Snapshot et Backup sont réalisé [ici](https://github.com/NALSED/TUTO/blob/main/PERSO/SAUVEGARDE/BACKUP/Linux.md#copier-sur-dns1)

### ⚠️ UN DOSSIER IDENTIQUE A CELUI DE DNS2 DOIT ETRE CREER SUR DNS1
### Sur DNS1
     chown -R sednal:sednal /home/sednal/TotalDNS2
     chmod -R u+rwX /home/sednal/TotalDNS2

### Sans ça les copies Rsync ne fontionnerons pas...

</details>

---

<details>
<summary>
<h2>
4️⃣ Serveur Web
</h2>
</summary>

## 1) Installation 

### 1.1) Instalation Logiciel
    apt install timeshift  
    apt install rsync
    apt install cron
    

---





## 2) Configuration 


### 2.1) Installer le script dans /root
    nano /root/ScriptSnapshot.sh 

### 2.2) Le script     
         #!/bin/bash

          SNAPSHOT_DIR="/timeshift/snapshots"

          # Supprimer tous les anciens snapshots
          sudo rm -rf "${SNAPSHOT_DIR}"/*

          # Créer un nouveau snapshot
          sudo timeshift --create --scripted

### 2.3) Droit
    chmod +x ScriptSnapshot.sh

### 2.4) Executer le Script
    ./ScriptSnapshot.sh

### 2.5) Dans l'utilisateur sednal créer les dossier du tranfert
      mkdir TotalWeb
      cd TotalWeb
      mkdir BackupWeb
      mkdir SnapshotWeb

### 2.6) Configurer Cron
      crontab -e

### 2.6.1) Choisir l'éditeur => 1
### si erreur
      select-editor # et changer

### 2.6.2) Snapshot
		50 09 * * 0 /root/ScriptSnapshot.sh

### 2.6.3) Copie Snapshot
		
		30 10 * * 0 rsync -a /timeshift/snapshot/ /home/sednal/TotalDNS2/SnapshotWeb/

### 📝 FICHIER CRON COMPLET
![image](https://github.com/user-attachments/assets/01ed377f-4060-4b3b-81c0-88889bd9eb43)



### La copie des dossier Snapshot et Backup sont réalisé [ici](https://github.com/NALSED/TUTO/blob/main/PERSO/SAUVEGARDE/BACKUP/Linux.md#copier-sur-dns1)

### ⚠️ UN DOSSIER IDENTIQUE A CELUI DE WEB DOIT ETRE CREER SUR DNS1
### Sur DNS1
     chown -R sednal:sednal /home/sednal/TotalWeb
     chmod -R u+rwX /home/sednal/TotalWeb

### Sans ça les copies Rsync ne fontionnerons pas...



















</details>

