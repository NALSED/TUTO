1) INTRO ### Raid
#### Le systéme Raid permet la sauvegarde de donnés, les disques ne sont pas accessibles directement mais via un contrôleur RAID. 
#### Pour ce faire il existe 4 types de Raid:
* #### `Raid 0`(striped ou spanned) => deux disques mini, les données sont réparties sur les deux disques(très sensible à la panne, utilisé pour ça rapidité) 
![ad0](https://github.com/user-attachments/assets/22eeb378-d6e5-499f-bd12-9eb69ef178dd)
#### ⚠️Différences entre 1️⃣Spanned (Fractionné) ou 2️⃣Striped (Abrégé par Bandes)
#### 1️⃣ Pour un disque fractionné, les données sont placées les unes après les autres. Une partition peut être étendue sur plusieurs disques de manière totalement transparente donnant l'impression qu'elle se trouve sur un seul disque. Cela est très pratique si une partition manque d'espace car elle peut être étendue en rajoutant un disque. Il n'y a aucun gain de performances. Si un disque tombe, seules les données sur ce disque sont perdues , le reste pouvant être récupéré avec des logiciels tiers.
#### 2️⃣ Les donnés sont répartie sue les N Disques
* ####  `Raid 1`(mirroring) => deux disques mini, les données sont copiées sur les deux disques
![ad1](https://github.com/user-attachments/assets/0ebeae76-87ce-42a7-831b-473131136871)

* ####  `Raid 5` => Les données sont réparties sur les en tant que donnés et parités .La parités est l'équivalent des donnés sauvegardées, en utilisant un OU logique

|XOR|0|1|
|:-:|:-:|:-:|
|0|0|1|
|1|1|0|

![ad5](https://github.com/user-attachments/assets/d5c7a1a5-b20f-4b81-be3e-6708c9ed1a66)

* ####  `Raid 10` est une combinaison de RAID 1 + RAID 0.
2 ) WINDOWS ### RAID
#### Se rendre dans Disk Manager, on peux y retrouver les différent disk
![ad1](https://github.com/user-attachments/assets/c1e33a78-1228-4172-aaab-89f01c2ed2e0)
#### Lors d'un clic droit sur le disk ou l'on souhaite faire un RAID, choisir les option et ce laisser guider.
3 ## LINUX
##### Créer les volumes sur VB, cocher la case branchable à chaux
![ad1](https://github.com/user-attachments/assets/a0646a97-8859-4ff8-af53-c651ed07ebda)
### 1️⃣ `Préparation disk`
##### Installer L'outil mdadm
      sudo apt install mdadm
##### Lister les disk
      lsblk
##### Repérer et partitionner les disk souhaitez
      sudo fdisk /dev/sdb/c/d
##### Vérifier 👌
![ad1](https://github.com/user-attachments/assets/fe46e674-60c1-4210-af2e-94dd8bf64d70)
### 2️⃣ `Création d'un RAID` et `Vérifications`
    sudo mdadm --create /dev/md0 --level 1 --raid-devices 2 /dev/sdb1 /dev/sdc1    
##### 📝 Explication de la commande :
* ##### ▶️/dev/md0 : nom du périphérique RAID à créer
* ##### ▶️--level 1 : niveau de RAID, soit ici du RAID 1 (on peut aussi écrire --level=1)
* ##### ▶️--raid-devices 2 : le nombre de disques, soit ici 2 (on peut aussi écrire --raid-devices=2)
* ##### ▶️/dev/sdb1 /dev/sdc1 : les partitions des disques concernés
##### Résultat 
![ad1](https://github.com/user-attachments/assets/b6a6aba8-24dc-43d8-a75a-674e0049ccbd)
##### Vérifier 
      cat /proc/mdstatcat
![ad1](https://github.com/user-attachments/assets/5d3f64bf-a7b8-4daf-b621-2893f03b47dc)
##### 📝 Explication :
##### Le résultat de la commande donne un RAID 1 actif md0 avec les partitions sdb1 et sdc1. De plus[UU] indique que les 2 disques sont en marche (Up).
      sudo mdadm --detail /dev/md0
![ad1](https://github.com/user-attachments/assets/77716515-d56f-4409-9da8-ef6b95bc8e79)
##### 📝 Explication :
##### Ici le statut du RAID est clean et les partitions concernées sont bien /dev/sdb1 et /dev/sdc1.De plus, /dev/sdb1 et /dev/sdc1 sont bien synchronisés.
### 3️⃣ `Formatage du disk md0`
      sudo mkfs.ext4 /dev/md0 -L "PersonalData"
##### Les disque md0 s'appelent maintenant "PersonalData".
### 4️⃣ `Montage du RAID :`
##### Ajoute d'un dossier Data-Raid1 sous /home/wilder, pour monter la partition md0 :     
      sudo mkdir /home/sednal/Data-RAID1 -p
##### Monter la partition md0 dans ce dossier : 
      sudo mount /dev/md0 /home/sednal/Data-RAID1/
##### Pour que le RAID soit monté automatiquement ajouter la ligne suivante au fichier /etc/fstab
      /dev/md0 /home/sednal/Data-RAID1 ext4 nofail 0 0
##### 📝 Explication :
* ##### ▶️ /dev/md0 : Le RAID
* ##### ▶️ /home/wilder/Data-RAID1 : Le point de montage de la partition RAID
* ##### ▶️ ext4 : Le FS choisi pour le RAID
* ##### ▶️ nofail : Avec cette option, il n'y aura pas de blocage au boot s'il y a un problème avec md0.
![ad1](https://github.com/user-attachments/assets/685de409-b875-4956-9033-bac74995d492)
### 5️⃣ `Verrouillage du nom md0 de la partition RAID`
##### La commande suivante nous montre que le fichier RAID n'a pas le bon nom.
      sudo mdadm --detail --scan
![ad1](https://github.com/user-attachments/assets/03fa3b35-e4aa-402d-a395-f7b5c485f2ea)
##### Utiliser l'UUID pour fixer le nom.
##### Pour ce faire rajouter le ligne => ARRAY /dev/md0 metadata=1.2 name=sednal-VirtualBox:0 UUID=UUID RECUPERE AVEC LA COMMANDE PRECEDANTE.
##### Et le nom avec lsblk -l
##### Dans le fichier /etc/mdadm/mdadm.conf
![ad1](https://github.com/user-attachments/assets/e46bcd6f-9587-4467-b93b-7aa6d9ac3d8c)
##### Appliquer les changement et redémarer
      sudo update-initramfs -u

















