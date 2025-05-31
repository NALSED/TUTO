# Chronologie Sauvegarde

---

### Ce document récapitule la chronologie des différentes sauvegardes, sur les différents clients.

---
---
### Pour `DNS2` et `WEB` Pas de sauegarde dirrectement sur Bareos, passage sur ` DNS1` .
### Ici sont noté Snapshot et Copie sur DNS1
### Ces Automatisation ne sont programmé que 3 fois par an:
## Une ` Sauvegarde ciblée`  + ` Snapshot`  le 1er du mois de ` FEVRIER`  ` JUIN`  et ` OCTOBRE`. 


* ## 1️⃣ `DNS2`
   * ### Snapshot : 2:10
   * ### Copie Snapshot +BackUp => `DNS1` => 3:00

---

* ## 2️⃣ `WEB`
   * ### Snapshot : 2:10
   * ### Copie Snapshot +BackUp => `DNS1` => 3:40

---
## Une ` Sauvegarde ciblée`  + ` Snapshot`  le 1er du mois de ` FEVRIER`  ` JUIN`  et ` OCTOBRE`. 
* ## 3️⃣ `DNS1`
  * ### Snapshot : 2:10
  * ## Récupération des dossier par Baréos de `WEB`  =>  `Snapshot` 9:00 // `BackUp` 9:30
  * ## Récupération des dossier par Baréos de `DNS1` =>  `Snapshot`  10:00 // `BackUp` 10::00
  * ## Récupération des dossier par Baréos de `DNS2` => `Snapshot` 11:00 // `BackUp` 11:30




---
## Une ` Sauvegarde ciblée`  + ` Snapshot`  => Une Full 1er dimache du mois et une incrémentale les autres dimanches du mois
* ## 4️⃣ `Serveur`
    * ### Snapshot : 2:10
    * ## Récupération des dossier par Baréos de `Serveur` => `Snapshot` 12:00 // `BackUp` 12:30

---
## Une ` Sauvegarde ciblée`  => Une Full 1er dimache du mois et une incrémentale les autres dimanches du mois
* ## 5️⃣ `Admin`
   * ### Snapshot : 1er de chaque mois
   * ## Récupération des dossier par Baréos de `Serveur` =>  `BackUp` 13:00




