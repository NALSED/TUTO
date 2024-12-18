# Création de dossier de partage personalisé et commun 

### 1️⃣ Création d'un dossier de partage à la racine.
#### Mettre les deux serveurs sur le même réseaux
#### Partage du dossier (En ajoutant le symbole dollar « $ »après le nom de partage, vous cachez le nom de partage sur le réseau)
![image](https://github.com/user-attachments/assets/03825b23-c14e-4751-8267-e984aace983d)
#### Editer les permitions du dossier => Supprimer Everyone => Ajouter
![image](https://github.com/user-attachments/assets/2b30586e-2b3d-4a39-9a15-06bb1a9df291)
#### Rentrer Administrator et Authenticated Users
![image](https://github.com/user-attachments/assets/037d604f-c966-40f4-921f-d10009d19204)
#### Accordez un contrôle total sur ce partage pour les utilisateurs sélectionnés 
![image](https://github.com/user-attachments/assets/93e0b6f3-2cf7-48ce-a105-e44a2a8b77c6)
#### Cliquez l’onglet « Security » et accédez aux réglages avancés en cliquant le bouton « Advanced » :
![image](https://github.com/user-attachments/assets/44732999-6cf4-4c8b-ae48-f571ecd38cc0)
#### Cliquez le bouton Disable inheritance
![image](https://github.com/user-attachments/assets/85b87a4f-e6ce-476f-a64d-b41e87f3e176)
#### Cliquer sur Removeall inherited permissions from this object.
![image](https://github.com/user-attachments/assets/bf924892-989d-4637-8c74-28cef2c1c35c)
#### Cliquer sur Add
![image](https://github.com/user-attachments/assets/58fbd452-4c94-42a3-8d3c-89bb8fd02af2)
#### Select principal
![image](https://github.com/user-attachments/assets/552df444-7253-4e0f-828b-7c9dcfa95bf4)
#### Advanced...
![image](https://github.com/user-attachments/assets/90116b83-19e2-4e4f-a2e3-d852392934e8)
#### CREATOR OWNER
![image](https://github.com/user-attachments/assets/aa8ba2c5-ecd5-46cc-ba11-a73d180c4605)
#### Full Control => Ok
![image](https://github.com/user-attachments/assets/c6e76e46-8d40-402d-8cb7-af17d47be9dd)
#### Puis répéter l'opération précédante pour System + Authentificated Users +Administrator
![image](https://github.com/user-attachments/assets/815caa49-33b9-43cb-8be6-a95369ee7fe4)
#### Résultat attendu
![image](https://github.com/user-attachments/assets/05b66a3a-ab7f-4b1b-adf4-e4fc805a32c9)
### 2️⃣ Création de la stratégie de groupe
#### Group Policy Management => Créer un GPO
#### User Configuration => Preferences => Windows Settings => Folder => New
#### Renseigner le chemin du partage dans Path et rajouter %LogonUser% pour spécifier que c'est l'utilisateur connecté qui partage le dossier
![image](https://github.com/user-attachments/assets/2f3a838a-f9c1-44f1-8fd2-00c0952f7858)
#### Cocher la case suivante 
![image](https://github.com/user-attachments/assets/1beacc67-914c-498a-a87e-4cd636ee95fc)
#### Résultat
![image](https://github.com/user-attachments/assets/60a1610d-34e9-45eb-98c8-deb506897145)
### 3️⃣ Mappage du lecteur
#### Drive Maps remplir comme si dessous chemin + nom + plus lettre mappage
![image](https://github.com/user-attachments/assets/d5c7c66c-d7e9-415f-a2f4-d9420088d27f)
#### Puis common=> cocher les deux case en bleu => Targeting 
![image](https://github.com/user-attachments/assets/fc3460c7-97d9-4579-ac52-5acafea114f9)
#### New Item => Security Group
![image](https://github.com/user-attachments/assets/eca241f3-b934-450c-a1b4-1df202a8b2ec)





















































