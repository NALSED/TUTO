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

# IP `192.168.0.141`

---

## I) Programation et Réalisation du Snapshot
## II Sauvegarde sur serveur Bareos


---
---

## `I) Programation et Réalisation du Snapshot`

### Ce Tuto commence après l'intallation du client sur le rasberry-pi voir [ici](https://github.com/NALSED/TUTO/blob/main/PERSO/Bareos/-5-Installation-Client.md#2%EF%B8%8F%E2%83%A3-instalation-client-bareos-linux-1)
### Il traitera de l'installation des différents paquets nécéssaire à la programmation ainsi que la réaalisation de snapshot systeme du serveur de sauvegarde. 


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

### 2.3) Droit + type de sauvegarde
    chmod +x ScriptSnapshot.sh
    timeshift --rsync

### 2.4) Executer le Script
    ./ScriptSnapshot.sh

### 2.5) Dans l'utilisateur sednal créer le dossier du tranfert vers Bareos

      mkdir SnapshotSave

### 2.6) Configurer Cron DANS root
      crontab -e

### 2.6.1) Choisir l'éditeur => 1
### si erreur
      select-editor # et changer

### 2.6.2) Execution script => snapshot

		10 2 1 2,6,10 * /root/ScriptSnapshot.sh

### 2.6.3) Copie Snapshot
		
		40 2 1 2,6,10 * rsync -a /timeshift/snapshots /home/sednal/SnapshotSave/


### 📝 FICHIER CRON COMPLET
![image](https://github.com/user-attachments/assets/151c708f-ea54-43ec-aaae-e8bf6d11568e)

### Explication 40 2 1 2,6,10 * => À 02h40 le 1er en février, juin et octobre.



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

 ---
 ---

 ## II `Sauvegarde sur serveur Bareos.`

### 1) Client /etc/bareos/bareos-dir.d/client/bareos-fd.conf

	Client {
  		Name = bareos-fd
  	Description = "Client resource of the Director itself."
  	Address = localhost
  	Password = "ovLMok3+oAco4yStWjc7IDCdll89/ecfz3vhXEconEoB"          # password for FileDaemon
		}

---

### 2) Pool FULL un par mois /etc/bareos/bareos-dir.d/pool/poolsavesnap.conf

		Pool {
        		Name = poolsavesnap
        		Pool Type = Backup
       		 	Recycle = yes
        		AutoPrune = yes

    		# Garder les volumes (Full et Incrémentaux) pendant 60 jours
    		Volume Retention = 60 days

    		# Un volume peut être utilisé pendant 30 jours
        		Volume Use Duration = 30 days

    		# Maximum de 12 volumes
        		Maximum Volumes = 12

    		# 1 job par volume
        		Maximum Volume Jobs = 1

    		# Format du label des volumes
        		Label Format = SnapSave-
    		}

---

### 3 ) FileSet /etc/bareos/bareos-dir.d/fileset/filesavesnap.conf
	FileSet {
                # Nom du FileSet
                Name = filesavesnap


                # A inclure pour la sauvegarde
                Include {

                        Options {

                                # Utilise MD5 pour vérifier les fichiers
                                signature = MD5

                                # Ne met pas à jour l'horodatage des fichiers
                                noatime = yes

				}

                                File = "/home/sednal/SnapshotSave/"
                                }
		}

---

### 4) Schedule /etc/bareos/bareos-dir.d/schedule/schsavesnap.conf

 	Schedule {
                Name = schsavesnap

                        # Full chaque 1er dimanche du mois
                        Run = Full 1st sun at 12:00

                        # Incrémental les autres dimanches
                        Run = Incremental 2nd-5th sun at 12:00
                }

---

### 5) Storage /etc/bareos/bareos-dir.d/storage/storsavebsnap.conf


		 Storage {
      Name = storsavesnap
      Address = 192.168.0.141                # N.B. Use a fully qualified name here (do not use "localhost" here).
      Password = "ZsjQIPmoToPcOM7NSAXu5R84VyRSsD68osZfCHCdu+D/"
      Device = SNAP
      Media Type = File
    			}


---

### 6) Job /etc/bareos/bareos-dir.d/job/jobsavesnap.conf



</details>

---

<details>
<summary>
<h2>
2️⃣ DNS 1
</h2>
</summary>


# IP `192.168.0.241`

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
		
		40 2 1 2,6,10 * rsync -a /timeshift/snapshots /home/sednal/SnapshotDNS1/



### 📝 FICHIER CRON COMPLET
![image](https://github.com/user-attachments/assets/df06349d-0b8d-4b59-8fb5-74edfecba319)





</details>

---

<details>
<summary>
<h2>
2️⃣ DNS 2
</h2>
</summary>

# IP `192.168.0.210`

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
![image](https://github.com/user-attachments/assets/6063f19e-3ea3-40d8-bafa-29f79ca7dfda)





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


# IP `192.168.0.122`

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

