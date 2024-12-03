# Instalation d'un VPN via pfense

## :one: Création de l'autorité de certification
   * ### `System => Certificate` 
   * ### Puis Add 
![ad1](https://github.com/user-attachments/assets/a0956f3f-0c5b-4ba8-9571-e062b549f98d)
 ![ad1](https://github.com/user-attachments/assets/c74f82ea-8238-4dab-aceb-fd57a52c83c7)
   * ### Remplir les champs en (bleu) puis Save(rouge)
   * ### Résultat ⚠️ Depuis Authorities ⚠️
![ad1](https://github.com/user-attachments/assets/f8e834c8-dff5-45c2-aafd-e8ac20c05ae3)
## 2️⃣ Certificat de server 
   * ### Dans `Certificates` (rouge) => Add (rouge)
![ad1](https://github.com/user-attachments/assets/14acade5-1dd5-4400-bd0c-693e78438b8f)
   * ### Donner un nom au Certificat
![ad1](https://github.com/user-attachments/assets/6faa404b-db5a-4091-bf57-11bfd4c34194)
   * ### Common Name 
   ![ad1](https://github.com/user-attachments/assets/c57346da-f8e6-4f45-ba91-771524ea4044)
   * ### Changer Server Certificate (bleu)
   * ### Puis Save (rouge)
![ad1](https://github.com/user-attachments/assets/a65baa7b-1e07-4155-bb23-9d9df2c5d920)
## 3️⃣ Création utilisateur
   * ### System => User Manager 
![ad1](https://github.com/user-attachments/assets/e32042d5-e9ad-49e2-9a99-36a08d24e88b)
   * ### Dans Users (bleu) => Add (rouge)
![ad1](https://github.com/user-attachments/assets/3910fccc-0e9a-426a-836c-f762992a6c16)
   * ### Renseigner Username / Password / Full name 
![ad1](https://github.com/user-attachments/assets/e543b6a4-2fe0-452d-bd47-238e902b6e5c)
   * ### Création du certificat User
![ad1](https://github.com/user-attachments/assets/7265d6d9-ef69-46ac-a95c-1e028cb309d5)
   * ### Renseigner Certificate authority / Common Name => Save
![ad1](https://github.com/user-attachments/assets/525331cb-6a09-4e90-b74b-bb06c41aa11e)
   * ### Le certificat apparait maintenant dans la création User => Save
   * ### User ⬇️
![ad1](https://github.com/user-attachments/assets/e9b7c56b-532c-4454-892f-865dd7503116)
## 4️⃣ Open VPN
   * ### VPN => Open VPN => Add
![ad1](https://github.com/user-attachments/assets/336bc09f-380c-4937-8ffb-8960efd1ccfb)
   * ### Renseigner la Description (bleu)
   * ### Server Mode RemotAccess (SSL/TLS+User Auth)
   * ### le VPN, le protocole s'appuie sur de l'UDP, avec le port 1194 (Il est conseillé de changer) 
#### Pour l'interface, nous allons conserver "WAN" puisque c'est bien par cette interface que l'on va se connecter en accès distant



























