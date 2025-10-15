# `Installation et configuration de Bareos sur Debian 12`

---

### Ce tuto à pour but de présenter la mise en place d'un `RAID 1`, la configuration de `PostgreSQL` et l'installation de `Bareos`.`

---

## 1️⃣ `Raid1`
## 2️⃣ `PostgreSQL`
## 3️⃣ `Bareos`

---
---

<details>
<summary>
<h2>
1️⃣ Raid1
</h2>
</summary>

[TUTO](https://www.justegeek.fr/tuto-creer-raid-logiciel-mdadm-debian/)

## ✏️ Petit point sur le RAID Logiciel ou Matériel (ici nous ferons un RAID logiciel)

### :open_file_folder: `Logiciel` 
### Administré par un logiciel au niveau du BIOS, installé sur un système d'exploitation

### :computer: `Matériel`
### Un contrôleur RAID gère et exécute toutes les tâches liées au RAID indépendamment du système d'exploitation.

---

## I) `Vérification des disques(Inutile sur VM)`
## II) `Préparation des disques`
## III) `Création du RAID 1`
## IV) `Création du point de montage`

---
---

## `I) Vérification des disques(Inutile sur VM)`

### 1.1) Installer l'outil de vérif (smatmontools)
    sudo apt update && apt upgrade
    sudo apt-get install smartmontools

### 1.2) lister les disques
    lsblk

### Ici la vérification se portera sur `sdb` et `sdc`
![image](https://github.com/user-attachments/assets/58305804-b5f4-47dc-8157-d3ba28c7c189)

### 1.3) Vérification
    sudo smartctl -t short /dev/sdX # Remplacer X par le bon disques

### 1.4) Résultat 
    sudo smartctl -l selftest /dev/sdX # Remplacer X par le bon disques
### Résultat attendu => « Completed without error »

---
---

## `II) Préparation des disques`

### 2.1) Ici utilisation de gdisk pour faire du GPT (fdisk => MBR)
    gdisk /dev/sdX

### 2.2) Dans gdisk en achainement des commandes 

* ### `o` pour créer une nouvelle table de partition GPT puis sur Entrée (confirmer avec Y et Entrée)

* ### On appuie sur `n` pour créer une nouvelle partition. Pour le numéro de partition, laissez par défaut. Pour ma part, c’est 1 puisque mes disques ne contiennent pas d’autres partitions. Il y a de fortes chances pour que ce soit la même chose chez vous.

* ### Pour le choix du `First Sector`, laissez le `choix par défaut`. Cela devrait vous créer une partition à partir du secteur `2048`.

* ### Idem pour le `last secto`, laissez par `défaut`.

* ### Pour le `code de la partition`, entrez `fd00` cela correspond à Linux RAID

* ### Appuyez sur `w` pour enregistrer les changements et quitter gdisk (confirmer avec Y et Entrée)


## `III) Création du RAID 1 (avec mdadm)`

### 1.1) Vérification des partitions créer 
    mdadm -E /dev/sd[b-c]

### Sortie attendu:
![image](https://github.com/user-attachments/assets/b5399c69-c9df-4ce5-a502-09edc9660b08)

### 1.2) Création de la grapper RAID :
    mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sd[b-c]1

### 📝 Explication

* ### /dev/mdX : correspondant au nom de la grappe

* ### –level=Y : indique que je souhaite créer un RAID Y (ici 1 => mirroring)

* ### –raid-devices=Z : indique le nombre de disques qui vont composer mon RAID (ici Z = 2)

* ### /dev/sd[b-c]1 : indique les disque sur lesquels réaliser le RAID ici sdb1 et sdc1

### 1.3) Controler l''avancement
    cat /proc/mdstat
![image](https://github.com/user-attachments/assets/2aa527ae-7c04-4186-ad3e-e4d1a16d570e)

### 1.4) Création d’un système de fichiers sur la grappe RAID
   mkfs.ext4 /dev/md0
   
![image](https://github.com/user-attachments/assets/40661d37-4e2d-4022-a035-86f087754079)



## `IV) Création du point de montage`

### 4.1) récupérer les UUID
    blkid

### 4.2) Monter et créer un dossier de point de montage
    mount /dev/md0 /mnt/backup
    mkdir /mnt/backup
    

### 4.3) Création du point de montage dans fstab (avec l'UUID du dispositif de bloc contenant le système de fichiers, le périphérique RAID /dev/md127, et non pas ceux des membres RAID (/dev/sda1, /dev/sdb1).)
    nano /etc/fstab
![image](https://github.com/user-attachments/assets/7805236e-8dbc-4d73-ac8e-421497a7fe8f)



### 4.5) Sauvegarde de la configuration du RAID

### Copie l'ancienne config avant édition
    cp /etc/mdadm/mdadm.conf /etc/mdadm/mdadm.conf.old 

### Redirige la sortie vers le ficher de conf 
    mdadm --detail --scan >> /etc/mdadm/mdadm.conf 

![image](https://github.com/user-attachments/assets/597dfa61-1af9-4050-95c4-c6c888b3defc)


### MAJ initramfs
    update-initramfs -u -k all

>Un système de fichiers virtuel initial (initramfs) est un système de fichiers initial en mémoire ram basé sur tmpfs (un système de fichiers léger de taille flexible, en mémoire), qui n'utilise pas un périphérique de blocs séparé.

### Résultat 
    cat /proc/mdstat
  ![image](https://github.com/user-attachments/assets/861ec442-f0f9-4c3e-9223-f4592b322e04)

</details>


---



<details>
<summary>
<h2>
2️⃣ PostgreSQL
</h2>
</summary>

[TUTO](https://shape.host/resources/comment-installer-postgresql-sur-debian-12)

## I Instalation 
## II Configuration

---

## `I Instalation`
[SOURCE](https://www.postgresql.org/download/linux/debian/)
### PostgreSQL, aussi connu sous le nom de Postgres, est un système de gestion de base de données relationnelle et objet

### 1.1) Installer `curl`
    sudo apt install curl ca-certificates

### 1.2) Crée le répertoire /usr/share/postgresql-common/pgdg avec les droits administrateur
    sudo install -d /usr/share/postgresql-common/pgdg

### 1.3) Télécharger la clé GPG officielle de PostgreSQL depuis le site officiel,
    sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc


### 1.4) Charger dans le shell les variables d’identification de la distribution Linux (nom, version, code, etc.) depuis le fichier système /etc/os-release
    . /etc/os-release


### 1.5) Créer un fichier de dépôt APT pour PostgreSQL, en ajoutant la source officielle PGDG correspondant à la version de la distribution.
    sudo sh -c "echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"

### 1.6) Installation
       sudo apt update
       sudo apt -y install  postgresql-18

--
## `II Configuration`

### 2.1) Passer dans le terminal de PostgreSQL via l'utilisateur system postgres
### Ici je suis en root donc
     su - postgres # le prompt doit changer.

### Et si en Utilisateur normal 
     sudo -i -u postgres

### Créez un utilisateur PostgreSQL (penser à noter les infos, dans description VM par exemple)
    createuser --interactive

![image](https://github.com/user-attachments/assets/6f7e7c28-6c61-4b1a-b714-baf19b20cb01)

### 2.2) Créez une base de données
    createdb <USERNAME>

### 2.3) accéder à la base de donnés:
      psql

![image](https://github.com/user-attachments/assets/60d90924-18fd-4a01-a41b-a3f9a1d788b4)

</details>


---

<details>
<summary>
<h2>
3️⃣ Bareos  
</h2>
</summary>

[TUTO_lionel](https://github.com/osmc2017/Tutos-et-Scripts-Apprenti-Technicien-Systeme-et-Reseau/blob/main/TUTO/Tuto_Bareos/Bareos_server_debian.md) // [TUTO_officiel](https://docs.bareos.org/) // [TUTO_web](https://computingforgeeks.com/how-to-install-bareos-on-ubuntu/)


## I) Ajout du Dépot et autorisation
## II) Instalation
## III) Configuration

---

## `I) Ajout du Dépot et autorisation`

### 1.1) Télécharger le script d’ajout des dépôts Bareos :
        wget https://download.bareos.org/current/Debian_12/add_bareos_repositories.sh

### 1.2) Droits d’exécution au script :
        chmod +x add_bareos_repositories.sh

### 1.3) Exécuter le script pour ajouter les dépôts Bareos :
        sh ./add_bareos_repositories.sh

### 1.4) Mettez à jour la liste des paquets :
        apt update

---

## `II) Installation`

### 2.1) Instalation de Bareos
    apt install bareos bareos-database-postgresql -y

### PostgreSQL est configuré corectement donc j'utilise l'option configurer avec dbconfig-common
### Donc yes puis reseigner passwoerd et confirmer

### 2.3) ⚠️Vérification⚠️
        su - postgre
        psql -U bareos -d bareos -h localhost
![image](https://github.com/user-attachments/assets/fb634c4c-ac0c-45e0-9447-f4b1092ae552)

### Ce prompt correspond à la base de donnée Bareos dans PostgreSQL.
### 2.3.1) `Lister toutes les tables`
        \dt

![image](https://github.com/user-attachments/assets/8b3f7d1b-5924-4017-b3e8-6f9c97cb803f)

### 2.3.2) `Lister le rôles`
        \du

![image](https://github.com/user-attachments/assets/f4cbc0f6-e520-410e-a013-7e39e06281b9)

### 2.3.3) `Lister les priviléges`     
        \dp

![image](https://github.com/user-attachments/assets/898a5d77-d3d7-4b28-939e-175c016a3344)
    

---

## `III) Configuration`

### 📝 Les paramètre relative au serveur Bareos sont dispo dans => /etc/dbconfig-common/bareos-database-common.conf
### 📝 Les Deamon Bareos dispo dans /usr/sbin

### 3.1) Activer les deamon
        systemctl enable --now bareos-director.service
        systemctl enable --now bareos-storage.service
        systemctl enable --now bareos-filedaemon.service

### 3.2) Configurer l'authentification de Bareos vers la base de donné postgreSQL
        nano /etc/postgresql/13/main/pg_hba.conf

### Ajouter cette ligne au fichier de conf ⚠️PQostgreSQL lit de hautvers le bas!!
        #Authentification Bareos
        local   all             bareos                                  md5

![image](https://github.com/user-attachments/assets/c92eb437-1606-4a99-baaf-8bf8996fcd55)


### 3.3) Redémarrer le service
        systemctl restart postgresql

### 3.4) `Test` 
        su - postgres
         psql -U bareos -d bareos -c '\dt'        
![image](https://github.com/user-attachments/assets/365aa1bd-d5e3-452b-932c-1dd954d14ebe)

        psql -U bareos bareos -W
![image](https://github.com/user-attachments/assets/73a2013a-b4b5-4f9d-83bf-fc171e3c8837)

* ### psql : Lance le client PostgreSQL

* ### -U bareos : Connexion avec l’utilisateur bareos

* ### -d bareos : Connexion à la base de données nommée bareos

* ### -W : Demande le mot de passe (prompte l’utilisateur)

 ### test bconsole (qui permet de communiquer avec Bareos Director)
        bconsole # Dans le shell du serveur
        *status director

### Sortie attendu
![image](https://github.com/user-attachments/assets/9657115f-ec66-4fd1-9733-62baf0bb6462)

* ### Connexion réussie à bareos-dir (le Director Bareos).

* ### Version : 24.0.3 (build du 15 mai 2025).

* ### Base de données utilisée : PostgreSQL — donc config de pg_hba.conf + psql est bien fonctionnelle.

* ### Aucune erreur détectée.

  
</details>


