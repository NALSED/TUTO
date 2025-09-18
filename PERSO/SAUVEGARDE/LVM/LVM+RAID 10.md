### Utilisation de LVM pour patitionner une grapper RAID, entre un LV pour les Backups Bareos en RAID 10 et un LV pour PLex en RAID 0.

---

[CHEAT SHEAT](http://www.datadisk.co.uk/html_docs/redhat/rh_lvm.htm)
[SOURCE](https://wiki.gentoo.org/wiki/LVM#LVM_RAID10)


---


#### Les PV ont été créés dans [Partition](https://github.com/NALSED/TUTO/blob/main/PERSO/SAUVEGARDE/LVM/Partition.md#cette-partie-aborde-les-probl%C3%A9mes-li%C3%A9s-au-partitionement-avec-lvm)
#### Vérif
      pvs
      PV         VG Fmt  Attr PSize   PFree
      /dev/sdb      lvm2 ---  931.51g 931.51g
      /dev/sdc      lvm2 ---  931.51g 931.51g
      /dev/sdd      lvm2 ---  931.51g 931.51g
      /dev/sde      lvm2 ---  931.51g 931.51g


### `Création du VG`, ici un seul pour plus de flexibilité, mais si besoin de partitionner, il peux être utile de  faire 2 groupes.

      vgcreate Serveur /dev/sdb /dev/sdc /dev/sdd /dev/sde
      Volume group "Serveur" successfully created

#### Vérif
         PV         VG      Fmt  Attr PSize   PFree
        /dev/sdb   Serveur lvm2 a--  931.51g 931.51g
        /dev/sdc   Serveur lvm2 a--  931.51g 931.51g
        /dev/sdd   Serveur lvm2 a--  931.51g 931.51g
        /dev/sde   Serveur lvm2 a--  931.51g 931.51g

#### Résumé de VG
      vgs
      VG      #PV #LV #SN Attr   VSize  VFree
      Serveur   4   0   0 wz--n- <3.64t <3.64t


### `Création LV`, Ici un LV pour Bareos de 700G en RAID 10, et le reste de la place pour Plex en RAID 1.

    #Le raid 10 prend en réalité 1.4to 
    lvcreate --type raid10 -L700G -i 2 -m 1 -n Bareos Serveur
    lvcreate --type raid0 -L150G -i 2 -n Plex Serveur

   lvs
   LV     VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
   Bareos Serveur rwi-a-r--- 700.00g                                    100
   Plex   Serveur rwi-a-r--- 150.00g

#### Donc 1.4To pour Bareos + 150Go Pour Plex = 2.13To libre.

      lsblk
      
      NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
      sda                         8:0    0 111.8G  0 disk
      ├─sda1                      8:1    0 110.8G  0 part /
      ├─sda2                      8:2    0     1K  0 part
      └─sda5                      8:5    0   975M  0 part [SWAP]
      sdb                         8:16   0 931.5G  0 disk
      ├─Serveur-Bareos_rmeta_0  253:0    0     4M  0 lvm
      │ └─Serveur-Bareos        253:8    0   700G  0 lvm
      ├─Serveur-Bareos_rimage_0 253:1    0   350G  0 lvm
      │ └─Serveur-Bareos        253:8    0   700G  0 lvm
      └─Serveur-Plex_rimage_0   253:9    0    75G  0 lvm
        └─Serveur-Plex          253:11   0   150G  0 lvm
      sdc                         8:32   0 931.5G  0 disk
      ├─Serveur-Bareos_rmeta_1  253:2    0     4M  0 lvm
      │ └─Serveur-Bareos        253:8    0   700G  0 lvm
      ├─Serveur-Bareos_rimage_1 253:3    0   350G  0 lvm
      │ └─Serveur-Bareos        253:8    0   700G  0 lvm
      └─Serveur-Plex_rimage_1   253:10   0    75G  0 lvm
        └─Serveur-Plex          253:11   0   150G  0 lvm
      sdd                         8:48   0 931.5G  0 disk
      ├─Serveur-Bareos_rmeta_2  253:4    0     4M  0 lvm
      │ └─Serveur-Bareos        253:8    0   700G  0 lvm
      └─Serveur-Bareos_rimage_2 253:5    0   350G  0 lvm
        └─Serveur-Bareos        253:8    0   700G  0 lvm
      sde                         8:64   0 931.5G  0 disk
      ├─Serveur-Bareos_rmeta_3  253:6    0     4M  0 lvm
      │ └─Serveur-Bareos        253:8    0   700G  0 lvm







      
