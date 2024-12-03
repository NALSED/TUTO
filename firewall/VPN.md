# Instalation d'un VPN via pfense

## :one: Création de l'autorité de certification
   * ### `System => Certificate` 
   * ### Puis Add 
![ad1](https://github.com/user-attachments/assets/a0956f3f-0c5b-4ba8-9571-e062b549f98d)
 ![ad1](https://github.com/user-attachments/assets/c74f82ea-8238-4dab-aceb-fd57a52c83c7)
   * ### Remplir les champs en 🔵 puis Save 🔴
   * ### Résultat ⚠️ Depuis Authorities ⚠️
![ad1](https://github.com/user-attachments/assets/f8e834c8-dff5-45c2-aafd-e8ac20c05ae3)
## 2️⃣ Certificat de server 
   * ### Dans `Certificates` 🔵 => Add 🔴 
![ad1](https://github.com/user-attachments/assets/14acade5-1dd5-4400-bd0c-693e78438b8f)
   * ### Donner un nom au Certificat
![ad1](https://github.com/user-attachments/assets/6faa404b-db5a-4091-bf57-11bfd4c34194)
   * ### Common Name 
   ![ad1](https://github.com/user-attachments/assets/c57346da-f8e6-4f45-ba91-771524ea4044)
   * ### Changer Server Certificate 🔵
   * ### Puis Save 🔴
![ad1](https://github.com/user-attachments/assets/a65baa7b-1e07-4155-bb23-9d9df2c5d920)
## 3️⃣ Création utilisateur
   * ### System => User Manager 
![ad1](https://github.com/user-attachments/assets/e32042d5-e9ad-49e2-9a99-36a08d24e88b)
   * ### Dans Users 🔵 => Add 🔴
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
   * ### 🔵 Renseigner la Description 
   * ### 🔴 Server Mode RemotAccess (SSL/TLS+User Auth)
   * ### 🟢 le VPN, ce protocole s'appuie sur de l'UDP, avec le port 1194 (Il est conseillé de changer) 
#### (Pour l'interface, nous allons conserver "WAN" puisque c'est bien par cette interface que l'on va se connecter en accès distant)
![ad1](https://github.com/user-attachments/assets/fc53a0ea-a1d9-4d88-a58d-ea480428ffdf)
   * ### Remplir Peer Certificate Authority (bleu)
   * ### Serveur certificate avec le serveur corespondant au PCA ⏫ (rouge)
![ad1](https://github.com/user-attachments/assets/744f2715-bf90-408e-ab61-08c9fe7b378a)
   *  #### 🔵 IPv4 Tunnel Network : adresse du réseau VPN, c'est-à-dire que lorsqu'un client va se connecter en VPN il obtiendra une adresse IP dans ce réseau au niveau de la carte réseau locale du PC. 
   * #### 🔴 Redirect IPv4 Gateway : si vous cochez cette option, vous passez sur un full tunnel c'est-à-dire que tous les flux réseau du PC distant vont passer dans le VPN, sinon nous sommes en split-tunnel.
   * #### 🟢 IPv4 Local network : les adresses réseau des LAN que vous souhaitez rendre accessibles via ce tunnel VPN. Si l'on à plusieurs valeurs à indiquer, il faut les séparer par une virgule.
   * #### 🟡 Concurrent connections : le nombre de connexions VPN simultanés que vous autorisez.

:yell



















