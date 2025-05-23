# Configuration Snapshot Linux

---

### Ce Tuto commence, avec RAID, PostGreSQL, Baros opérationel sur Serveur et Client  => [TUTO/Install et Conf](https://github.com/NALSED/TUTO/tree/main/PERSO/Bareos)

---

## `SOMMAIRE` : 

* ### 1️⃣ `Serveur Sauvegarde`

   

---

* ### 2️⃣ `DNS 1`

  * ### 1) Installation de 

   * ### 2) Configuration 
---

* ### 3️⃣ `DNS 2`

   * ### 1) Installation 
   
   * ### 2) Configuration 

---

* ### 4️⃣ `Serveur Web`

  * ### 1) Installation de Timeshift

  * ### 2) Configuration Timeshift
   
---
---



<details>
<summary>
<h2>
1️⃣ Serveur Sauvegarde
</h2>
</summary>

</details>
---

<details>
<summary>
<h2>
2️⃣ DNS 1
</h2>
</summary>

### Ce Tuto commence après l'intallation du client sur le rasberry-pi voir [ici](https://github.com/NALSED/TUTO/blob/main/PERSO/Bareos/-5-Installation-Client.md#2%EF%B8%8F%E2%83%A3-instalation-client-bareos-linux-1)




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
		00 10 * * 0 /root/ScriptSnapshot.sh

### 2.6.3) Copie Snapshot
		
		40 10 * * 0 rsync -a /timeshift/snapshot/ /home/sednal/TotalDNS2/SnapshotDNS2/

### 📝 FICHIER CRON COMPLET
![image](https://github.com/user-attachments/assets/a6f24d16-91c9-4039-b474-84b7a9287638)

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

### 1) Installation de Timeshift


---

### 2) Configuration Timeshift




















</details>

