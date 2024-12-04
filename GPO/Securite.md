

# 1️⃣ Execution des scripts OU et Users
# 2️⃣ Définition et Installation des GPO
## Classement des GPO par importance
## **SOMMAIRE**
### `1) SECURITE`
#### 1. [Politique de mot de passe  + Verrouillage de compte]
#### 2. [Restriction d'installation de logiciel pour les utilisateurs non-administrateurs]
#### 3. [Restriction des périphériques amovible]
#### 4. [Écran de veille avec mot de passe en sortie]
#### 5. [Blocage complet ou partiel au panneau de configuration]
#### 6. [Gestion de Windows update] 
#### 7. [Gestion du pare-feu]	
#### 8. [Gestion d'un compte du domaine qui est administrateur local des machines]
#### 9. [Forçage du type d'utilisation sécurisée du bureau à distance]
#### 10. [Blocage de l'accès à la base de registre]
#### 11. [Limitation des tentatives d'élévation de privilèges]
#### 12. [Définition de scripts de démarrage pour les machines et/ou les utilisateurs]
#### 13. [Politique de sécurité PowerShell]
### `2) STANDART`
#### 1. [Fond d'écran]
#### 2. [ Mappage de lecteurs]
#### 3. [Gestion de l'alimentation]
#### 4. [Déploiement de logiciels]
#### 5. [Configuration des paramètres du navigateur] 
#### 6. [Redirection de dossiers] 
## **SOMMAIRE**
### `1) SECURITE`
#### 1. `Politique de mot de passe + Verrouillage de compte` 
* ##### Clic droite sur L'OU => Create a GPO in this domain, and Link it here 
![ad1](https://github.com/user-attachments/assets/7354a6bf-ba09-4024-b7ad-74b06717644f)
* ##### Nommer la GPO  
![ad1](https://github.com/user-attachments/assets/1dc75c18-978d-42c7-80e5-284fc0964b0f)
* ##### Clic droit sur la GPO => Edit
![ad1](https://github.com/user-attachments/assets/82210cbc-ae01-40f8-8457-74618b64965c)
* ##### Se rendre dans le menu voulu => ici Password Policy 
![ad1](https://github.com/user-attachments/assets/c9056c3a-ca67-4fff-85b0-da020e58461b)
* ##### Politique de MDP :
![ad1](https://github.com/user-attachments/assets/dae7f4d0-aadc-4289-8945-ee5594fd34ca)
#### 2. `Restriction d'installation de logiciel pour les utilisateurs non-administrateurs`
* ###### Se rendre dans Sofware Restriction Policies => clic droit New Software Restriction Policies 
![ad2](https://github.com/user-attachments/assets/b1e9b43e-6b92-4db4-9dc8-a323ced558fe)
![ad1](https://github.com/user-attachments/assets/2f8d9141-3800-4f3e-9571-7c07be6fb0be)
* ##### Edition de security level => Basic User => Set as Default
![ad1](https://github.com/user-attachments/assets/8d655a4c-2389-4534-a085-718a2b88e0ef)
* ##### Edition => Enforcement
![ad1](https://github.com/user-attachments/assets/a490ebca-ae27-4554-963f-fa68345d1ed3)
* ##### Edition => Dsignated File Types=> Rajouter VBS et PAF
![ad1](https://github.com/user-attachments/assets/b0619ccd-f449-4824-9bad-4eb2b5c61e76)
* ##### Dans Additional Rules (régles éditées)⬇️
![ad2](https://github.com/user-attachments/assets/2b1d438f-da1c-4da7-9e64-2884de646c96)
* ##### Clic droite sur Additional Rules => New Path Rules
![ad1](https://github.com/user-attachments/assets/d928c515-afd0-49e2-a4c9-61aaea865a32)
* ##### Donner le chemin voulu 
![ad1](https://github.com/user-attachments/assets/5db9c63a-52f4-411b-974d-6cb59c80a31e)
#### 3. `Restriction des périphériques amovible`
* ##### Removable Storage Access => All Removable Strorage classes : Deny all access
![ad1](https://github.com/user-attachments/assets/14c41c08-7300-4e76-97f5-bd886c280e7c)
#### 4. `Écran de veille avec mot de passe en sortie`
* ##### Policies => System => Power Management => Sleep settings
* ##### Require a password when a computer wakes (plugged in) et  (on battery ) 
![ad1](https://github.com/user-attachments/assets/52ecf1f7-6a1c-4588-9a5e-b8fff59b3967)
* ##### Specify the system sleep time out (plugged in) et  (on battery ) 
![ad1](https://github.com/user-attachments/assets/d7ac9ac6-ad76-47d3-84fa-2a1454df5dbd)
#### 5. `Blocage complet ou partiel au panneau de configuration`
* ##### User Configuration => Policies => Administrative Templates ... => Control Panel => Prohibit access to Control Panel and PC settings
![ad1](https://github.com/user-attachments/assets/5d5d8b5e-70de-42c3-a027-e0b544671775)


#### 6. `Gestion de Windows update` 
#### 7. `Gestion du pare-feu`	
#### 8. `Gestion d'un compte du domaine qui est administrateur local des machines`
#### 9. `Forçage du type d'utilisation sécurisée du bureau à distance`
#### 10. `Blocage de l'accès à la base de registre`
#### 11. `Limitation des tentatives d'élévation de privilèges`
#### 12. `Définition de scripts de démarrage pour les machines et/ou les utilisateurs`
#### 13. `Politique de sécurité PowerShell`
### `2) STANDARD`
#### 1. `Fond d'écran`
##### ⚠️ créer un [partage de fichier](https://github.com/NALSED/Future-R-vision/blob/main/AD/Partage%20de%20fichier.md) our le fond d'écran
* ##### User configuration => Policies => Administrative Templates => Desktop => Desktop Wallpaper
* ##### Renseigner le chemin du partage 🔴
![ad1](https://github.com/user-attachments/assets/e625b515-2e85-4b0f-bc38-c4de248fe5bc)
#### 2. `Mappage de lecteurs`



#### 3. `Gestion de l'alimentation`



#### 4. `Déploiement de logiciels`



#### 5. `Configuration des paramètres du navigateur`



#### 6. `Redirection de dossiers`































