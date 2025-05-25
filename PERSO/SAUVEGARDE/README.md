# `Centralisation Des Sauvegardes`

---

### Ce Tuto à pour but de créer une solution de sauvegarde et snapshot, centralisées pour windows et linux.
### Via les solution `Bareos`, `Timeshift`(Snapshot Linux), `Cron` (automatiosation des tache sur debian 12),`Rsync`(transfert de fichier) et `Protection System pour Windows`(Snatshoot windows).


---

## :books: `INFRA` : 

### :wolf: Windows
### PC Admin / Données sensibles et précieuses


### :penguin: Linux
* ### DNS 1 : Pihole 
* ### DNS2 : Bind9, résolution de nom en locale
* ### Serveur_Web : intranet, accés à GitHub et Services
* ### Serveur Sauvegarde : Bareos avec RAID1 2 x 1 To + 1 To, Plex.

---

## :bulb: Objectif :

### => Automatiser et centraliser les sauvegardes et snapshots pour que Baréos les "Récoltes".
### => Pour la répartition entre Sauvegarde et Snapshot :
* ### 🔴 Sauvegarde : se concentrera uniquement sur les document sensible et fichiers de configuration.
* ### 🟢 Snapshoot : Uniquement points de restauration, tout les autres fichiers seront exclu, pour ne pas surcharger.
* ### Avec deux moyende sauvegarde différent : 🔴 Sauvegarde => RAID1 et 🟢 Snapshoot un disque séparer voir [ici](https://github.com/NALSED/TUTO/tree/main/PERSO/SAUVEGARDE#disk)

<details>
<summary>
<h2>
Projet de Base
</h2>
</summary>


![cartographie de parcours utilisateur (2)](https://github.com/user-attachments/assets/075fc795-b569-4ef6-b7c7-a65b446b7918)
 
</details>


## `Nouvelle Solution`

### On garde l'idée Snapshot et sauvegarde, mais ici toute les données passeront par DNS1(qui à une architecture arm64).
### Les snapshot et backup ainsi que leurs transfert vers DNS1 sera assuré par script, cron, rsync.
![cartographie de parcours utilisateur (3)](https://github.com/user-attachments/assets/061550e3-48ec-488b-a624-9c0a5d09ac10)





---

# :clipboard: Récap Label infra

---
---

## LABEL SAUVEGARDE ET SNAPSHOT

## `PC Admin :` 
  * ### Label Format BackUp : BackupWin-

---

* ## `DNS 1 :`
    * ### Avant "recolte" par Bareos
    * ### `BackUp` : /home/sednal/TotalDNS1/BackupDNS1
    * ### `Snapshot` : /home/sednal/TotalDNS1/SnapshotDNS1
      * ### Bareos
---


* ## `DNS2 :`
    * ### Sur DNS2 :
    * ### `BackUp` : /home/sednal/TotalDNS2/BackupDNS2
    * ### `Snapshot` : /home/sednal/TotalDNS2/SnapshotDNS2
       * ### Sur DNS1 :
       * ### `BackUp` : 
       * ### `Snapshot`

---


* ## `Serveur_Web :` 
     * ### Sur Serveur Web :
     * ### `BackUp` : /home/sednal/TotalWEB/BackupWEB
     * ### `Snapshot` : /home/sednal/TotalWEB/SnapshotWEB
        * ### Sur DNS1 :
        * ### `BackUp` : 
        * ### `Snapshot`

---


* ## `Serveur Sauvegarde :`
    * ### Label Format BackUp : BackupSave- SnapSave-
    * ### Label Format BackUp : SnapSave-   

---
---

## LABEL FICHIER BAREOS

### Fichier type :
### Tout en minuscule

||BackUp|SnapShot|
|:-:|:-:|:-:|
|Pool|pool NOM MACHINE back |pool NOM MACHINE snap|
|FileSet |file NOM MACHINE back.conf|file NOM MACHINE snap.conf|
|Schedule|sch NOM MACHINE back.conf|file NOM MACHINE snap.conf|
|Storage|stor NOM MACHINE back.conf|stor NOM MACHINE snap.conf|
|Job|job NOM MACHINE back.conf|job NOM MACHINE snap.conf|

### Nom Machine :
* ### PC Adminitration : `admin`
* ### Serveur Sauvegarde : `save`
* ### DNS PiHole : `dns1`
* ### DNS Bind9 : `dns2`
* ### Servveur Web : `web`
---

# 📝 Recap Label Bareos :

* ## `save` :

   * ### BackUp :

     * ### pool : poolsaveback.conf
     * ### fileset : filesaveback.conf
     * ### schedule : schsaveback.conf
     * ### storage : storsaveback.conf
     * ### job : jobsaveback.conf
   
   * ### SnapShot

     * ### pool : poolsavesnap.conf
     * ### fileset : filesavesnap.conf
     * ### schedule : schsavesnap.conf
     * ### storage : storsavesnap.conf
     * ### job : jobsavesnap.conf

---
---

* ## `admin` :

   * ### BackUp :
   
   


---
---

 * ## `dns1` :

* ### BackUp dns1 :
   
   
   
* ### SnapShot dns1 :

---

   * ### BackUp dns2 :
   
   
   
   * ### SnapShot dns2 :
  
---

   * ### BackUp web :
   
   
   
   * ### SnapShot web :


---
---

## DISK:

       NAME    MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
       fd0       2:0    1     4K  0 disk
       sda       8:0    0 111.8G  0 disk
       ├─sda1    8:1    0 110.8G  0 part  /
       ├─sda2    8:2    0     1K  0 part
       └─sda5    8:5    0   975M  0 part  [SWAP]
       sdb       8:16   0 931.5G  0 disk
      └─sdb1    8:17   0 931.5G  0 part
        └─md0   9:0    0 931.4G  0 raid1 /mnt/backup
       sdc       8:32   0 931.5G  0 disk 
       └─sdc1    8:33   0 931.5G  0 part
         └─md0   9:0    0 931.4G  0 raid1 /mnt/backup
       sdd       8:48   0 931.5G  0 disk
       ├─sdd1    8:49   0   600G  0 part  /mnt/snapshot
       └─sdd2    8:50   0   300G  0 part  /mnt/plex




![image](https://github.com/user-attachments/assets/89afc183-99bf-4717-8f67-48b18463fd83)











