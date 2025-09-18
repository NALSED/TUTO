### Cette partie aborde les problémes liés au partitionement avec LVM. 

---

### 1️⃣ Partition disque

      lsblk
      NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
      sda      8:0    0 111.8G  0 disk
      ├─sda1   8:1    0 110.8G  0 part /
      ├─sda2   8:2    0     1K  0 part
      └─sda5   8:5    0   975M  0 part [SWAP]
      sdb      8:16   0 931.5G  0 disk
      └─sdb1   8:17   0 931.5G  0 part
      sdc      8:32   0 931.5G  0 disk
      └─sdc1   8:33   0 931.5G  0 part
      sdd      8:48   0 931.5G  0 disk
      └─sdd1   8:49   0 931.5G  0 part
      sde      8:64   0 931.5G  0 disk
      └─sde1   8:65   0 931.5G  0 part

#### Ici les disques sont partitionés, et impossible d'utiliser LVM.
      
      root@serveur:/# pvcreate /dev/sdb /dev/sdc /dev/sdd /dev/sde
      Cannot use /dev/sdb: device is partitioned
      Cannot use /dev/sdc: device is partitioned
      Cannot use /dev/sdd: device is partitioned
      Cannot use /dev/sde: device is partitioned

#### Utiliser les utilitaire parted (créer un nnouvelle table de partion, ici gpt) et wipefs (efface les métadonnées

----

### 2️⃣ Solutions

#### Ici 
      apt install parted
      # wipefs deja present


* #### I) `parted`

        parted /dev/sdb
        (parted) mklabel gpt
        (parted) quit

#### Répéter l'opération pour chaques disques


* #### II) `wipefs`

        wipefs -a /dev/sdb      

#### Répéter l'opération pour chaques disques

#### Résultats :

      lsblk
      NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
      sda      8:0    0 111.8G  0 disk
      ├─sda1   8:1    0 110.8G  0 part /
      ├─sda2   8:2    0     1K  0 part
      └─sda5   8:5    0   975M  0 part [SWAP]
      sdb      8:16   0 931.5G  0 disk
      sdc      8:32   0 931.5G  0 disk
      sdd      8:48   0 931.5G  0 disk
      sde      8:64   0 931.5G  0 disk

#### ET

    pvcreate /dev/sdb /dev/sdc /dev/sdd /dev/sde
    Physical volume "/dev/sdb" successfully created.
    Physical volume "/dev/sdc" successfully created.
    Physical volume "/dev/sdd" successfully created.
    Physical volume "/dev/sde" successfully created.      
