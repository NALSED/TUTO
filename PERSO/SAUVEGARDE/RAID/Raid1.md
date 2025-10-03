# RAID1

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
