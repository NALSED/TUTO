# Instalation/Configuration de WinRM
##### Source [IT1](https://www.it-connect.fr/observateur-devenements-transferts-et-abonnements/)
##### [IT2](https://www.it-connect.fr/activer-winrm-par-gpo-sous-windows-server/)
---
## 1️⃣ Configuration de WinRM => Client
---
* ###  `Activer WinRM` 
#### Services => Windows Remote Management (WS-Management) => clic droit Properties
![image](https://github.com/user-attachments/assets/c6dd562b-b1b5-42a5-9b92-66890c0edab3)
#### Puis Automatic (Delayed Start)
![image](https://github.com/user-attachments/assets/890c875e-f02c-42d6-95c8-2d0b6e99f0a1)
---
* ### `Firewall`
#### Dans les régle rentrante => New Rules ⚠️Attention deux régles sont à éditer à la suite!! 
![image](https://github.com/user-attachments/assets/d10bddad-6dd2-49b7-a52b-84ba5f389711)
#### Cocher Predefined => Windows Remote Management et par la suite Remote Management(compatibility
![image](https://github.com/user-attachments/assets/58edd5e1-7735-46f4-a2cc-6db7c8ffd39f)
#### Puis Profile => Domain, Pivate
![image](https://github.com/user-attachments/assets/76f7488e-ccff-435e-ade2-fa8adb10d025)
#### Allow Connection
#### Clic droit sur Windows Remote Management (HTTP-In) => Properties
![image](https://github.com/user-attachments/assets/7be50976-2c66-47f2-97e9-28dd08801eba)
#### Advanced => Cocher Domain
![image](https://github.com/user-attachments/assets/d33ab730-74d3-4fbe-bc96-8a92957a63a3)
---
* ### `Computer Manager`
#### System Tools => Local Users and Group => clic droit sur l'utilisateur concerné => Properties
![image](https://github.com/user-attachments/assets/e9d8111b-9854-47a5-84f1-121840cd36a3)
#### 🔵 Member of => 🔴 Add..
![image](https://github.com/user-attachments/assets/4a86c6a9-a73a-49e2-9e80-d8b03a02edc0)
#### Advanced..
![image](https://github.com/user-attachments/assets/ea99d218-7102-4a01-ba79-7afdd0948ec4)
#### Find Now
![image](https://github.com/user-attachments/assets/31a45453-9104-4126-91d7-a05f1601908e)
#### Remote Management Users
![image](https://github.com/user-attachments/assets/3651b310-94c0-4630-a33c-7638a5fc51f3)
---
* ### `PS en Admin`
#### la commande       
      winrm quickconfig
      Enable-PSRemoting
#### Configurer l'hôtes de confiance
      Set-Item WSMan:\localhost\Client\TrustedHosts SRVWIN-ADDS-GUI.Pharmgreen.com
      winrm get winrm/config/client
#### On voit que le client de confiance est bien présent :
![image](https://github.com/user-attachments/assets/41b2a654-bbc6-4223-9d19-179310bf83ac)
---
* ### `Autorisation de lecture`
##### ⚠️La configuration est effectué sur une machine, mais il faut l'effectuer en GPO pour l'entreprise
#### Computer Management => System tools => Local Users and Groups => Groups => Event Log Readers
![image](https://github.com/user-attachments/assets/76161ea9-3587-435f-81e3-8aacbf3a7b79)
##### Cocher ordinateur
![image](https://github.com/user-attachments/assets/acbe0bcc-e857-4f0d-b25e-1a653d4a08d1)
#### Rentrer le nom du serveur
![image](https://github.com/user-attachments/assets/4f29e518-77a6-494d-bef6-8f8829790583)
#### Résultat
![image](https://github.com/user-attachments/assets/130944d9-430f-4a2c-b0fe-a846919cf0ee)
## 2️⃣ Configuration du Serveur 
* ### `créer un abonnement`
#### Event Viewer => clic droit Create Subsciption...
![image](https://github.com/user-attachments/assets/d81c7eac-4ab0-4632-808e-7db5ca8e13c3)
#### 🔵 Renseigner le Nom du serveur colecteur et une description.
#### 🔴 Ici le nom du journal dans lequel l'abonement sera collecté.
#### 🟢 Ici c'est le serveur colecteur qui est à l'initiative de la collecte, renseiger sont FQDN.
![image](https://github.com/user-attachments/assets/7a807ef6-f053-4f18-9adb-1f1c971a05d1)
#### 🔵 Select Events... => Filtrages des Evenements
#### 🔴 Event Level => Critical + Warning
#### 🟢 By log(filtres) Secutity + System
![image](https://github.com/user-attachments/assets/d212babd-3845-4e77-8818-c4aefe5a830c)
#### 🔵Advenced...
#### 🔴 Normal
![image](https://github.com/user-attachments/assets/d14a9037-c4fd-4bb9-92b8-962c6570073c)
















