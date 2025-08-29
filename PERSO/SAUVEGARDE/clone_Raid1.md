# `Clonage RAID 1`

### Ce tuto montre comment cloner deux disques logiciel en RAID 1, sur un disque externe.
### L'idée est d'assurer un BackUp des disques RAID, aucas ou il y aurait un probléme lor du transsfert d'un  serveur  à l'autre.
### Le clonage de l'OS, contenant Bareos,  Plex et cockpit à était réalisé via clonezilla, ainsique le disque contenant les snapshot des différents clients.  

#### Voici la sortie  de  la commnde lsblk -f

NAME    FSTYPE            FSVER LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
fd0
sda
└─sda1  linux_raid_member 1.2   serveur:0 b11075b3-8674-0fd0-aeba-0c478258b28d
  └─md0 ext4              1.0             28d9de52-91a6-457b-8a16-2129113f1978  513.6G    39% /mnt/backup
sdb
├─sdb1  ext4              1.0             1f033d5c-e253-4ec7-a723-1ac2feedd7d4  541.8G     3% /mnt/snapshot
└─sdb2  ext4              1.0             2d7fdc1a-c5fb-44e0-b84f-52446db96e4b  236.9G    14% /mnt/Plex
sdc
├─sdc1  ext4              1.0             3cd5a805-dc7e-4953-bf1e-de84cd63566e   94.9G     7% /
├─sdc2
└─sdc5  swap              1               99c91db1-f15d-465e-92ce-a4a06f700779                [SWAP]
sdd
└─sdd1  linux_raid_member 1.2   serveur:0 b11075b3-8674-0fd0-aeba-0c478258b28d
  └─md0 ext4              1.0             28d9de52-91a6-457b-8a16-2129113f1978  513.6G    39% /mnt/backup
sde
├─sde1
└─sde2

---
### ⚠️ Le  disque externe doit être partitionné en GPT
      fdisk /dev/sde
g → pour créer une nouvelle table de partition GPT
d → pour supprimer les partitions existantes (répéter jusqu’à ce qu’il n’y ait plus rien)
n → pour créer une nouvelle partition
w → pour écrire les changements et quitter

## 1️⃣ `Formatage/montage Disque externe sde`

* #### Formatage ext4
      mkfs.ext4 -L sauvegardeRAID /dev/sde1

sde
├─sde1  ext4              1.0   sauvegardeRAID 30d02185-25b3-46a9-8b11-df4edafbd123
└─sde2

* #### Montage

#### Créer point de montage
      mkdir -p /mnt/ext
      mount /dev/sde1 /mnt/usb

## 2️⃣ `Sauvegarde`

* #### Sauvegarde
      sudo rsync -avh --progress /mnt/backup/ /mnt/usb/








