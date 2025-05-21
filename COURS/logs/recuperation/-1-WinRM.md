## Configuration de WinRM par GPO
### 1️⃣ `Edition GPO`
#### Computer Configuration => Polities Administrative Templates => Windows Composents => windows Remote Management => WinRM Service
![image](https://github.com/user-attachments/assets/ffaf09db-9622-40be-aafb-25832f072e72)
#### Allow remote server management through WinRM
![image](https://github.com/user-attachments/assets/966e873b-8f8e-4ed2-b855-0d53e01385f1)
#### Enable , puis dans IPv4 et IPv6 filter => * pour que toutes les addresse IP puissent (mais il est conseillé de rentrer les IP du service SI non configuré encore)
### 2️⃣ `Démarrer automatiquement le service WinRM`
#### Computer Configuration => Polities => Windows Settings => Security Settings => System Service 
![image](https://github.com/user-attachments/assets/58a257a7-ae3b-4878-a6be-aec4eae4c484)
### Automatic 
![image](https://github.com/user-attachments/assets/3c0ed8bc-7ab7-4e07-8424-38e692d15849)
### 3️⃣ Firewall
#### Dans les régle rentrante => New Rules
![image](https://github.com/user-attachments/assets/d10bddad-6dd2-49b7-a52b-84ba5f389711)
#### Cocher Predefined => Windows Remote Management
![image](https://github.com/user-attachments/assets/58edd5e1-7735-46f4-a2cc-6db7c8ffd39f)
#### Puis Profile => Domain, Pivate
![image](https://github.com/user-attachments/assets/76f7488e-ccff-435e-ade2-fa8adb10d025)
#### Allow Connection
### 4️⃣ Edition de la Régle Firewall
#### Clic droit sur Windows Remote Management (HTTP-In) => Properties
![image](https://github.com/user-attachments/assets/7be50976-2c66-47f2-97e9-28dd08801eba)
#### Advanced => Cocher Domain
![image](https://github.com/user-attachments/assets/d33ab730-74d3-4fbe-bc96-8a92957a63a3)








