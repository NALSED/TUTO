## Ajouter un disk sur linux

#### 1️⃣ lister
    lsblk # liste les disques

#### 2️⃣ créer la partition
    cfdisk /devv/<DISK CHOISI>

#### 3️⃣ format disk
    sudo mkfs.ext 4 /dev/<DISK CHOISI>

#### 4️⃣ Créer un point de montage permanant 
        blkid #monter les UUID des disk
        mkdir /media/new-part # dossier pour point de montage
        sudo nano /etc/fstab
#### Entrer les infos comme ce qui suit => UUID => Point de montage => format => option et 0 0 

![image](https://github.com/user-attachments/assets/c06e6cb9-2077-4740-a820-ff63e389eadc)
