# 1️⃣ Execution des scripts OU et Users
# 2️⃣ Définition et Installation des GPO => 16 GPO's
## Classement des GPO par importance
## **SOMMAIRE**
### `1) SECURITE`
#### 1. [Politique de mot de passe  + Verrouillage de compte](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#1-politique-de-mot-de-passe--verrouillage-de-compte)
#### 2. [Restriction d'installation de logiciel pour les utilisateurs non-administrateurs](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#2-restriction-dinstallation-de-logiciel-pour-les-utilisateurs-non-administrateurs-1)
#### 3. [Restriction des périphériques amovible](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#3-restriction-des-p%C3%A9riph%C3%A9riques-amovible-1)
#### 4. [Écran de veille avec mot de passe en sortie](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#4-%C3%A9cran-de-veille-avec-mot-de-passe-en-sortie-1)
#### 5. [Blocage complet ou partiel au panneau de configuration](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#5-blocage-complet-ou-partiel-au-panneau-de-configuration-1)
#### 6. [Gestion de Windows update](https://github.com/NALSED/Future-R-vision/edit/main/GPO/Securite.md#6-gestion-de-windows-update-1) 
#### 7. [Gestion du pare-feu](https://github.com/NALSED/Future-R-vision/edit/main/GPO/Securite.md#7-gestion-du-pare-feu-1)	
### 2) [`STANDART`](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#2-standard)
#### 1. [Fond d'écran](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#1-fond-d%C3%A9cran-1)
#### 2. [ Mappage de lecteurs](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#2-mappage-de-lecteurs)
#### 3. [Gestion de l'alimentation](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#3-gestion-de-lalimentation-1)
#### 4. [Déploiement de logiciels](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#4-d%C3%A9ploiement-de-logiciels-1)
#### 5. [Configuration des paramètres du navigateur](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#5-configuration-des-param%C3%A8tres-du-navigateur-1)
#### 6. [Redirection de dossiers](https://github.com/NALSED/Future-R-vision/edit/main/GPO/Securite.md#6-redirection-de-dossiers-1)
## **SOMMAIRE**
### `1) SECURITE`
#### 1.[⏫](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance) `Politique de mot de passe + Verrouillage de compte` 
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
#### 2.[⏫](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance) `Restriction d'installation de logiciel pour les utilisateurs non-administrateurs`
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
#### 3.[⏫](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance) `Restriction des périphériques amovible`
* ##### Removable Storage Access => All Removable Strorage classes : Deny all access
![ad1](https://github.com/user-attachments/assets/14c41c08-7300-4e76-97f5-bd886c280e7c)
#### 4.[⏫](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance) `Écran de veille avec mot de passe en sortie`
* ##### Policies => System => Power Management => Sleep settings
* ##### Require a password when a computer wakes (plugged in) et  (on battery ) 
![ad1](https://github.com/user-attachments/assets/52ecf1f7-6a1c-4588-9a5e-b8fff59b3967)
* ##### Specify the system sleep time out (plugged in) et  (on battery ) 
![ad1](https://github.com/user-attachments/assets/d7ac9ac6-ad76-47d3-84fa-2a1454df5dbd)
#### 5.[⏫](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance) `Blocage complet ou partiel au panneau de configuration`
* ##### User Configuration => Policies => Administrative Templates ... => Control Panel => Prohibit access to Control Panel and PC settings
![ad1](https://github.com/user-attachments/assets/5d5d8b5e-70de-42c3-a027-e0b544671775)
#### 6.[⏫](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance) `Gestion de Windows update` 
* ##### Computer Configuration => Policies => Administrative Templates => Windows Components => Windows Update.
* ##### Configure Automatic Updates
* ##### Configurer comme si dessous, pour que les mises à jours se fassent le 1er lundi de chaques mois 
![ad1](https://github.com/user-attachments/assets/8d894b28-66e3-41f2-b43a-a8e895009bc5)
#### 7.[⏫](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance) `Gestion du pare-feu`	
* ##### Computer Configuration > Policies > Windows Settings > Security Settings > Windows Firewall with Advanced Security
* ##### Avoir en fonction des besoin.
### `2) STANDARD`
#### 1.[⏫]([https://github.com/NALSED/Future-R-vision/edit/main/GPO/Securite.md#sommaire](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance)) `Fond d'écran`
##### ⚠️ créer un [partage de fichier](https://github.com/NALSED/Future-R-vision/blob/main/AD/Partage%20de%20fichier.md) our le fond d'écran
* ##### User configuration => Policies => Administrative Templates => Desktop => Desktop Wallpaper
* ##### Renseigner le chemin du partage 🔴
![ad1](https://github.com/user-attachments/assets/e625b515-2e85-4b0f-bc38-c4de248fe5bc)
#### 2.[⏫]([https://github.com/NALSED/Future-R-vision/edit/main/GPO/Securite.md#sommaire](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance)) `Mappage de lecteurs`
* ##### User policy => Policies => preferences => Windows settings => Drive Maps
![ad6](https://github.com/user-attachments/assets/0b4ae39b-ee7c-4de8-800e-6bc749be4951)
* ##### Clic droit => New  
![ad2](https://github.com/user-attachments/assets/4a838cdd-ab3d-4868-8502-6dbe2abccc46)
* ##### Renseigner le chemin du partage 
![AD3](https://github.com/user-attachments/assets/b0754a21-2723-4fda-a045-86e881de7dda)
* ##### Le mappage s'affiche ici
![ad5](https://github.com/user-attachments/assets/59c978ec-471f-482a-9395-c40788f96bbe)
#### 3.[⏫]([https://github.com/NALSED/Future-R-vision/edit/main/GPO/Securite.md#sommaire](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance)) `Gestion de l'alimentation`
* ##### Computer configuration => System => Power configuration => Select an active power plan
![ad1](https://github.com/user-attachments/assets/8fa1b7d7-8cfd-4c8c-a619-591a6caf234d)
#### 4.[⏫]([https://github.com/NALSED/Future-R-vision/edit/main/GPO/Securite.md#sommaire](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance)) `Déploiement de logiciels`

### 🔵`.msi`
* ##### Computer Configuration => Policies => Software Settings => Software Instalation
* ##### New 
![ad2](https://github.com/user-attachments/assets/d5c1340b-8cdd-4fd5-a30b-bc0fc5615fc5)
* ##### Renseigner le chemin du logiciel à déployer via Le partage.
* ##### Le fichier apparait ici après configuration
![ad33](https://github.com/user-attachments/assets/f9deb51f-ea6c-473d-9f95-8317e81ceb2e)
### 🔵 `.exe`
* #### 1) Script installer un exécutable
      ### Variables
      # Chemin UNC vers le partage qui contient l'exécutable ADAPTER LE CHEMIN
      $SharedFolder = "\\SRVWIN-ADDS-GUI\applications$"
      # Chemin vers le dossier temporaire local sur le poste
      $LocalFolder = "C:\TEMP"
      # Nom de l'exécutable ADAPTER LE NOM
      $ExeName = "7z2409-x64.exe"

      # Argument(s) à associer à l'exécutable
      $ExeArgument = "/S"
      # Si le chemin réseau vers l'exécutable est valide, on continue
      if(Test-Path "$SharedFolder\$ExeName"){

      # Créer le dossier temporaire en local et copier l'exécutable sur le poste
      New-Item -ItemType Directory -Path "$LocalFolder" -ErrorAction SilentlyContinue
      Copy-Item "$SharedFolder\$ExeName" "$LocalFolder" -Force

      # Si l'on trouve bien l'exécutable en local, on lance l'installation
      if(Test-Path "$LocalFolder\$ExeName"){
        Start-Process -Wait -FilePath "$LocalFolder\$ExeName" -ArgumentList "$ExeArgument"
      }

      # On supprime l'exécutable à la fin de l'installation
      Remove-Item "$LocalFolder\$ExeName"

      }else{
      Write-Warning "L'exécutable ($ExeName) est introuvable sur le partage !"
      }
* #### 2) Script le logiciel est-il installé ?
      # ADAPTER LE NOM 
      if(Get-Package -Name "7z2409-x64.exe"){
   Write-Output "Le logiciel 7z2409-x64.exe est présent sur la machine !"
}
* #### 3) Script le logiciel est-il à jour ?
      ### Variables
        # Chemin UNC vers le partage qui contient l'exécutable ADAPTER LE CHEMIN
         $SharedFolder = "\\SRVWIN-ADDS-GUI\applications$"

        # Chemin vers le dossier temporaire local sur le poste
         $LocalFolder = "C:\TEMP"

         # Nom de l'exécutable ADAPTER LE NOM
        $ExeName = "7z2409-x64.exe"

        # Argument(s) à associer à l'exécutable
        $ExeArgument = "/S"

        # Version cible de l'exécutable (obtenue sur une installation manuelle)
        $ExeVersion = "7.2.1.0"

        # Chemin vers l'exécutable une fois l'installation terminée
         $ExeInstallPath = "C:\Program Files\7-Zip.exe"

         # Le logiciel est-il déjà installé dans la bonne version ?
         $InstalledVersion = (Get-ItemProperty -Path "C:\Program Files\7-Zip.exe" -ErrorAction             SilentlyContinue).VersionInfo.FileVersion

        if(($InstalledVersion -eq $null) -or ($InstalledVersion -ne $null -and $InstalledVersion -ne $ExeVersion)){

        # Si $InstalledVersion n'est pas null et que la version est différente : c'est qu'il faut faire une mise à jour
        if($InstalledVersion -ne $null){ 
        Write-Output "Le logiciel va être mis à jour : $InstalledVersion -> $ExeVersion"
        }

        # Si le chemin réseau vers l'exécutable est valide, on continue
        if(Test-Path "$SharedFolder\$ExeName"){

        # Créer le dossier temporaire en local et copier l'exécutable sur le poste
        New-Item -ItemType Directory -Path "$LocalFolder" -ErrorAction SilentlyContinue
        Copy-Item "$SharedFolder\$ExeName" "$LocalFolder" -Force

        # Si l'on trouve bien l'exécutable en local, on lance l'installation
        if(Test-Path "$LocalFolder\$ExeName"){
        Start-Process -Wait -FilePath "$LocalFolder\$ExeName" -ArgumentList "$ExeArgument"
        }

        # On supprime l'exécutable à la fin de l'installation
        Remove-Item "$LocalFolder\$ExeName"

        }else{

       Write-Warning "L'exécutable ($ExeName) est introuvable sur le partage !"
        }
        }else{
       Write-Output "Le logiciel est déjà installé dans la bonne version !"
        }
🔵### GLPI instalation GLPI Agent
*  ###  1) Se rendre sur GUI GLPI
* ##### Acceuil => Administration => Inventaire => Activer l'inventaire 
![ad1](https://github.com/user-attachments/assets/efe7f65c-ac41-4789-8c52-71038e55769e)
* ##### Télécharger l'agent GLPI 
      https://github.com/glpi-project/glpi-agent/releases/tag/1.5
![ad1](https://github.com/user-attachments/assets/30239544-45d0-4dc0-954f-016d66b4cc1c)
* ##### Placer le .msi dans le fichier de partage
* ##### Computer Configuration => Policies => Software Settings => clic droit Software installation 
![ad1](https://github.com/user-attachments/assets/2a155358-a1b4-4dce-b578-50d4c29b2b84)
* ##### Assigned
*  ### 2) Configurer l'agent GLPI avec le Registre Windows
* ##### Computer Configuration => Policies => Preferences => Windows Settings => Regitry
* ##### Clic droit New => Registry Item
* ##### Renseigner dans la fenêtre comme ci dessous
![ad1](https://github.com/user-attachments/assets/904967da-e7c0-4104-992a-208640541c83)
* ##### Clic droit New => Registry Item 
* ##### Renseigner dans la fenêtre comme ci dessous
![ad2](https://github.com/user-attachments/assets/7ed3a7dd-8686-4819-b423-0801c63178e2)
* ##### Resultat 
![ad3](https://github.com/user-attachments/assets/64687da4-4725-4ae6-b76a-b727aebd3004)
* ### 4) Rendre le script executable dans la GPO
* ##### Computer Configuration => Windows Settings => Scripts => Startup
![ad1](https://github.com/user-attachments/assets/5a8b2bbf-b3eb-46bf-9ec6-2fb3ce2e554a)
* ##### ⚠️Conserver le chemin présent à l'ouverture de la fenétre
![ad1](https://github.com/user-attachments/assets/bccae377-9ae8-41fd-a647-1905773669b3)
* ##### Choisir Run Windows PowerShell script first
![ad1](https://github.com/user-attachments/assets/3ca8c003-a7f7-44c6-a9f9-fef41f157b5d)
* ##### Modification de la politique d'exécution de la GPO
* ##### Computer configuration => Policies => Administrative Templates => Windows Composents => Windows Powershell => Turn on Script Execution
* ##### Allow local script and remote signed scripts
![ad1](https://github.com/user-attachments/assets/3122d858-badf-4f8a-8256-e75b53072631)
#### 5.[⏫]([https://github.com/NALSED/Future-R-vision/edit/main/GPO/Securite.md#sommaire](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance)) `Configuration des paramètres du navigateur`
### 1️⃣ Définir le navigateur par défaut
* ##### Computer Configuration => Policies => Administrative Template => Windows Composents => File Explorer
* #####  Set a default association configuration file
* ##### Rentrer le chemin du partage et valider
![ad1](https://github.com/user-attachments/assets/2351a6ec-40d8-40cd-a299-e36d9df9bffd)
### 2️⃣ Configurer le navigateur
* ##### Récupérer le fichier admx et adml sur le GitHub
* ##### Copier le fichier admx et adml (=> US, sinon risque d'incompatiblité).
            Dans => %SYSTEMROOT%\PolicyDefinitions
![ad1](https://github.com/user-attachments/assets/be6226e1-c13d-402e-b40d-30d1797be03a)
* ##### Les nouvelles options GPO sont ici ⏬
![ad1](https://github.com/user-attachments/assets/d64dd2e1-e1f6-48f3-bbbb-07f5177f3e44)
   * ##### GPO éditées pour firefox
       * ##### Page acceuil
       * ##### Bloquer la localisation
#### 6.[⏫]([https://github.com/NALSED/Future-R-vision/edit/main/GPO/Securite.md#sommaire](https://github.com/NALSED/Future-R-vision/blob/main/GPO/Securite.md#classement-des-gpo-par-importance)) `Redirection de dossiers`































