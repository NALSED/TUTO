
![bareos](https://github.com/user-attachments/assets/2db98514-9d6e-427c-a31e-50b80714323b)




# Ce document à pour But de récapituler les étapes d'`installation` ainsi que de `configuration`,et `orienter` vers les différents tutos.

---

## :books: `LAB`

### 1️⃣ Serveur : 
* ### VM Debian 12
* ### Ram 15Gb
* ###  Réseau: bridge + DHCP

### 2️⃣ Client
* ### Win 11 (ordinateur perso)

---

### 📘Voici l'ordre que j'ai suivi pour la mise en place de la solution baréos:

### 1️⃣ Création du `RAID` (ici RAID1) => voir -2-Instalation.md => Chapitre 1
### 2️⃣	Instalation et configuration de `PostgreSQL` => voir -2-Instalation.md => Chapitre 2
### 3️⃣ Instalation et configuration de `Bareos CLI` et `Bareos WebUI` => voir -2-Instalation.md => Chapitre 3 et => voir -3-WebUi.md
### 4️⃣ 	`Ajout du RAID1` à la soulution `Bareos` via CLI => voir -4-Ajout-RAID1et ROLES.md => Chapitre 1
### 5️⃣ `Instalation` de la solution `Bareos` sur le `client` => voir -5-Instalation-ClientWIN.md 
### 6️⃣ `Ajout` du `Client` sur le serveur `Bareos` => voir -6-Ajout-Client->Serveur.md 
### 7️⃣ Configuration `Pool` => voir -4-Ajout-RAID1et ROLES.md => Chapitre 3
### 8️⃣ Configuration `FileSet` => voir -4-Ajout-RAID1et ROLES.md => Chapitre 4
### 9️⃣ Configuration `Storage ` => voir -4-Ajout-RAID1et ROLES.md => Chapitre 7
### 🔟 Configuration `Schedule` et `Job ` => voir -4-Ajout-RAID1et ROLES.md => Chapitre 6 et 5 (bien faire job en dernier)
### 🔚 `Test` => voir -7-Test.md
### :floppy_disk: `Restauration`  => voir -8-Restor.md

<img width="710" height="814" alt="image" src="https://github.com/user-attachments/assets/bc54a8dc-3e1f-44b1-89e6-b99ad1edd6cc" />
