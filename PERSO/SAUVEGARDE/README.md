# `Centralisation Des Sauvegardes`

---

### Ce Tuto à pour but de créer une solution de sauvegarde et snapshot, centralisées pour windows et linux.
### Via les solution `Bareos`, `Timeshift`(Snapshot Linux) et `Protection System pour Windows`(Snatshoot windows).


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

### => Automatiser et centraliser les sauvegardes et snapshots pour que Baréos les "Récolte".
### => Pour la répartition entre Sauvegarde et Snapshot :
* ### 🔴 Sauvegarde : se concentrera uniquement sur les document sensible et fichiers de configuration.
* ### 🟢 Snapshoot : Uniquement points de restauration, tout les autres fichiers seront exclu, pour ne pas surcharger.
![cartographie de parcours utilisateur (2)](https://github.com/user-attachments/assets/075fc795-b569-4ef6-b7c7-a65b446b7918)







