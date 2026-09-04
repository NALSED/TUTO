
##########################################################################################################################################################################################################################################################################################################################################################################################################################

# V1 de la mise en place de Bareos, pour la version mise à jour voir [ICI](https://github.com/NALSED/TUTO/tree/main/PERSO/SAUVEGARDE/BAREOS/BAREOS2)

#############################################################################################################################################################################################################
#############################################################################################################################################################################################################





















### `Centralisation Des Sauvegardes`
### ⚠️MAJ DNS2 à été supprimé de l'infra, fichier de conf nettoyé de bareos, il reste dans la doc à titre d'exemple.
---

### Ce Tuto à pour but de créer une solution de sauvegarde et snapshot, centralisées pour windows et linux.
### Via les solution `Bareos`, `Timeshift`(Snapshot Linux), `Cron` (automatisation des taches sur debian 12),`Rsync`(transfert de fichier) et `Protection System pour Windows`(Snatshoot windows).


---

## :books: `INFRA` : 

### :wolf: Windows

* ## `PC Admin` / Données sensibles et précieuses


### :penguin: Linux

* ## `DNS 1 :`
   * ### Pihole 
* ## `DNS2 :`
   * ### Bind9, résolution de nom en locale
* ## `Serveur_Web :`
   * ### intranet, accès à GitHub et Services
* ## `Serveur Sauvegarde :`
   * ### Bareos : dipose d'un RAID1 => 2 x 1 To et un autre disque 1 To
   * ### Plex.

---

## :bulb: Objectif :

### => Automatiser et centraliser les sauvegardes et snapshots pour que Bareos les "Récoltes".
### => Pour la répartition entre Sauvegarde et Snapshot :
* ### 🔴 Sauvegarde : se concentrera uniquement sur les documents sensibles et fichiers de configuration.
* ### 🟢 Snapshoot : Uniquement points de restauration, tout les autres fichiers seront exclus, pour ne pas surcharger.
* ### Avec deux moyen de sauvegarde différent : 🔴 Sauvegarde => RAID1 et 🟢 Snapshoot un disque séparer voir [ici](https://github.com/NALSED/TUTO/tree/main/PERSO/SAUVEGARDE#disk)

<details>
<summary>
<h2>
Projet de Base
</h2>
</summary>


![cartographie de parcours utilisateur (2)](https://github.com/user-attachments/assets/075fc795-b569-4ef6-b7c7-a65b446b7918)
 
</details>


## `Nouvelle Solution`

### On garde l'idée Snapshot et sauvegarde, mais ici toutes les données passeront par DNS1(qui à une architecture arm64).
### Les snapshot et backup ainsi que leur transfert vers DNS1 sera assuré par script, cron, rsync.
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
      * ### `BackUp` : BackDns1-
      * ### `Snapshot`: SnapDns1-


---


* ## `DNS2 :`
    * ### Sur DNS2 :
    * ### `BackUp` : /home/sednal/TotalDNS2/BackupDNS2
    * ### `Snapshot` : /home/sednal/TotalDNS2/SnapshotDNS2
       * ### Sur DNS1 :
       * ### `BackUp` : BackDns2-
       * ### `Snapshot`: SnapDns2-

---


* ## `Serveur_Web :` 
     * ### Sur Serveur Web :
     * ### `BackUp` : /home/sednal/TotalWEB/BackupWEB
     * ### `Snapshot` : /home/sednal/TotalWEB/SnapshotWEB
        * ### Sur DNS1 :
        * ### `BackUp` : BackWeb-
        * ### `Snapshot`: SnapWeb-

---


* ## `Serveur Sauvegarde :`
    * ### Label Format BackUp : BackupSave- 
    * ### Label Format BackUp : SnapSave-   

---
---

## LABEL FICHIER CONFIGURATION BAREOS

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
* ### PC Administration : `admin`
* ### Serveur Sauvegarde : `save`
* ### DNS PiHole : `dns1`
* ### DNS Bind9 : `dns2`
* ### Serveur Web : `web`
---

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











