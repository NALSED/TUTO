# ⚠️ Les dossiers de partages sont configurés pour `Communication` et `Direction Financière` ainsi que leurs `Services`
## 1️⃣ Mettre le serveur de fichier sur le domain
![image](https://github.com/user-attachments/assets/36c0134a-9389-4300-8d37-4b848dd9ba94)
## 2️⃣ Éditer le droit du dossier de partage avec le groupe correspondant sur l'AD
![image](https://github.com/user-attachments/assets/1a925d7d-201c-49ea-ac48-fcd59262da9f)
## 3️⃣ Sur le service AD éditer le mappage des lecteur
#### Group Policy Management => Computer Configuration=> User Configuration => Preference => Windows Setting => Drive Maps => New
#### Renseigner le mappage comme ci dessous
#### 🔵 Create, car le dossier est à créer
#### 🔴 Chemin et nom du fichier
#### 🟢 Lettre du mappage
#### 🟡 Montrer le Lecteur
![image](https://github.com/user-attachments/assets/07e7aa85-75fe-470a-a415-3ec5cc95d93a)
## 4️⃣ Les GPO sont à éditer par Département et par service
![image](https://github.com/user-attachments/assets/7f4b5885-d2a2-4f04-839f-9efbb68b7f6c)
## 6️⃣ Créer un dossier HOME$ Générale, c'est ici que les dossiers seront créer par la suite.
![image](https://github.com/user-attachments/assets/ea10c8c4-b81e-4c0d-877a-a07bc03428d0)
#### Créer un partage => Sharing
![image](https://github.com/user-attachments/assets/7cb09d57-08b8-4778-8779-e9a4fd54f6b1)
#### Éditer => Security => Advanced
![image](https://github.com/user-attachments/assets/70ee5ff0-aaf7-4f9a-89c7-2a3095db920b)
#### Disable inheritance
![image](https://github.com/user-attachments/assets/7ac730d9-0ac3-4382-8765-97479ea0aaf1)
#### Converte inheritance ...
![image](https://github.com/user-attachments/assets/0fe60816-19ba-40db-b768-542ebd1ca8c1)
#### Supprimer User => OK
![image](https://github.com/user-attachments/assets/9cc0e51e-5a59-4d88-a78c-f395b0488a7f)
#### Éditer comme ci dessous
![image](https://github.com/user-attachments/assets/bf4458bd-fb3b-42c4-9b57-3984d01e8b5f)

















