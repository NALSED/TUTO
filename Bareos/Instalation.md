# `Instalation de Bareos sur Debian 12`

---

### Ce tuto à pour but de présenter la mise en place d'un raid 1 ainsi que l'instalation de Bareos

---

## 1️⃣ `Raid1`
## 2️⃣ `PostgreSQL`
## 3️⃣ `Bareos`
## 4️⃣ ``
## 5️⃣ ``
## 6️⃣ ``
## 7️⃣ ``
## 8️⃣ ``
## 9️⃣ ``



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

## I) `Vérification des disques(Inutile sur VM)`

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

## II) Préparation des disques

### 2.1) Ici utilisation de gdisk pour faire du GPT (fdisk => MBR)
    gdisk /dev/sdX

### 2.2) Dans gdisk en achainement des commandes 

* ### `o` pour créer une nouvelle table de partition GPT puis sur Entrée (confirmer avec Y et Entrée)

* ### On appuie sur `n` pour créer une nouvelle partition. Pour le numéro de partition, laissez par défaut. Pour ma part, c’est 1 puisque mes disques ne contiennent pas d’autres partitions. Il y a de fortes chances pour que ce soit la même chose chez vous.

* ### Pour le choix du `First Sector`, laissez le `choix par défaut`. Cela devrait vous créer une partition à partir du secteur `2048`.

* ### Idem pour le `last secto`, laissez par `défaut`.

* ### Pour le `code de la partition`, entrez `fd00` cela correspond à Linux RAID

* ### Appuyez sur `w` pour enregistrer les changements et quitter gdisk (confirmer avec Y et Entrée)


## III) Création du RAID 1 (avec mdadm)

### 1.1) Vérification des partitions créer 
    mdadm -E /dev/sd[b-c]

### Sortie attendu:
![image](https://github.com/user-attachments/assets/b5399c69-c9df-4ce5-a502-09edc9660b08)

### 1.2) Création de la grapper RAID :
    mdadm –-create /dev/md0 –-level=1 -–raid-devices=2 /dev/sd[b-c]1

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



## IV) Création du point de montage

### 4.1) récupérer les UUID
    blkid

### 4.2) Monter et créer un dossier de point de montage
    mount /dev/md0 /mnt/backup
    mkdir /mnt/backup
    

### 4.3) Création du point de montage dans fstab
    nano /etc/fstab
![image](https://github.com/user-attachments/assets/7805236e-8dbc-4d73-ac8e-421497a7fe8f)



### 4.5) Sauvegarde de la configuration du RAID

### Copie l'ancienne config avant édition
    cp /etc/mdadm/mdadm.conf /etc/mdadm/mdadm.conf.old 

### Redirige la sortie vers le ficher de conf 
    mdadm --detail --scan >> /etc/mdadm/mdadm.conf 

![image](https://github.com/user-attachments/assets/6c2a84d1-2e05-4385-ae79-e546b81f8212)

### MAJ initramfs
    update-initramfs -u -k all

>Un système de fichiers virtuel initial (initramfs) est un système de fichiers initial en mémoire ram basé sur tmpfs (un système de fichiers léger de taille flexible, en mémoire), qui n'utilise pas un périphérique de blocs séparé.

  
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

## I Instalation

### PostgreSQL, aussi connu sous le nom de Postgres, est un système de gestion de base de données relationnelle et objet

### 1.1) Installer `GNUP` (clés PGP)
    apt install gnupg -y

### 1.2) Importez la clé du dépôt PostgreSQL 
     wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

### Sortie attendu:
![image](https://github.com/user-attachments/assets/4c95412a-8415-4775-9abf-5dca855aac21)

### 1.3) Ajoutez le dépôt PostgreSQL
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

### 1.4) Installez PostgreSQL:
    sudo apt install postgresql-13 -y

### 1.5) Activer démarer status
    systemctl enable postgresql
    systemctl start postgresql
    systemctl status postgresql

![image](https://github.com/user-attachments/assets/1f9db2d0-d724-40f2-9a67-9627a37c4ca2)

--
## II Configuration

### 2.1) Passer dans le terminal de PostgreSQL via l'utilisateur system postgres
### Ici je suis en root donc
     su - postgres # le prompt doit changer.

### Et si en Utilisateur normal 
     sudo -i -u postgres

### Créez un utilisateur PostgreSQL (penser à noter les infos, dans description VM par exemple)
    creatuser --interctive

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




























  
</details>


---

## 4️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>


---

## 5️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>


---

## 6️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>


---

## 7️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>


---

## 8️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>


---

## 9️⃣ ``

<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>
