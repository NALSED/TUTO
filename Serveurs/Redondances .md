#### Prérequis 2 serveurs win 2022.

### Le détails des instalations des différents role n'est pas détaillé ici

### :one: Installation des roles 
* #### [DHCP](https://github.com/NALSED/R-vision/blob/main/Fichier%20de%20r%C3%A9vision.md#4422-windows-22) 
* #### [DNS](https://github.com/NALSED/R-vision/blob/main/Fichier%20de%20r%C3%A9vision.md#414-windows-1)
* #### [ADDS](https://github.com/NALSED/R-vision/blob/main/Fichier%20de%20r%C3%A9vision.md#368-cr%C3%A9er-un-adds-)

# Redondance DHCP :
### Vérifier les serveurs autorisés => clic droit DHCP (bleu) => Manage authorized servers...(rouge)
![ad1](https://github.com/user-attachments/assets/2eb6d9e9-f246-4b1b-b7bb-fb9c22b64c2a)
### Ici le serveur à répliquer nest pas autorisé
### clic Authorize (bleu) => rentrer l'IP du serveur à autoriser(rouge)
![ad1](https://github.com/user-attachments/assets/ad23a564-f483-41e9-97de-b191793cb530)
### Le serveur est retouvé et demande de confirmation 
#### ⚠️(le faire pour les deux serveurs SUR les deux serveurs)⚠️
![ad1](https://github.com/user-attachments/assets/1c30ba9c-9673-4678-937b-9a1616712d3e)
### Résultat 
![ad1](https://github.com/user-attachments/assets/db10e800-51c4-4c4d-ba9d-530591e21bf0)
### Pour démarer le redondance :
### Clic droit sur Scope => Configure Failover...
![ad1](https://github.com/user-attachments/assets/f1cc67e0-36c4-44e0-9398-312127750935)
### Rentrer l'IP du serveur de secours
![ad1](https://github.com/user-attachments/assets/70adfc4e-3976-4783-8b9c-376575ac598a)
### Configuration ⬇️
### Lien entre serveurs (bleu)
### Choisir Hot standby(rouge), 
##### (l'autre option permet de partager la charge dans l'attribution des adresses IP)
![ad1](https://github.com/user-attachments/assets/ce0f9c0e-e9b7-45a9-8b89-7bb6f4291b1d)
### Pour la suite diminuer l'intervale de 60 min par defaut à 5 min
##### (c'est le temps qu mettre le serveur deux à prendre le relais)
### Et cocher le case Enable Message Authentification
#### (Cela permet de chiffrer le echange au niveau de la trame)
![ad1](https://github.com/user-attachments/assets/6afddf6b-a7f4-408f-974a-54706d8efd2a)
### Puis finish
### Vérifier d'être en Successful partout
![ad1](https://github.com/user-attachments/assets/c8f106f4-e136-4b07-b66b-7b0ecc3a7dab)
# Redondance DNS :









### Redondance ADDS :

















