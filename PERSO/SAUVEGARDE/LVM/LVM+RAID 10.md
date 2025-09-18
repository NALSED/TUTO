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


#### Donc 1.4To pour Bareos + 150Go Pour Plex = 2.13To libre.











      
