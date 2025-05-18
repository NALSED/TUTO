
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
### 3️⃣ Instalation et configuration de `Bareos CLI` => voir -2-Instalation.md => Chapitre 3
### 4️⃣ 	Instalation et configuration de `Bareos WebUI` => voir -3-WebUi.md
### 5️⃣ `Ajout du RAID1` à la soulution `Bareos` via CLI => voir -4-Ajout-RAID1et ROLES.md => Chapitre 1
### 6️⃣ `Instalation` de la solution `Bareos` sur le `client` => voir -5-Instalation-ClientWIN.md
### 7️⃣ `Ajout` du `Client` sur le serveur `Bareos` => voir -6-Ajout-Client->Serveur.md 
### 8️⃣ Configuration `Pool` => voir
### 9️⃣ Configuration `FileSet` => voir
### 🔟 Configuration `Job ` => voir
### 
### 🔚 `Test` => voir


