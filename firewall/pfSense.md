## Premiére configuration de pfSense
### 1️⃣Installer pfSense => [liens IT connect](https://www.it-connect.fr/comment-installer-pfsense-dans-virtualbox-pour-creer-un-lab-virtuel/)
#### ⚠️Vérifier si les carte corespondent bien à LAN et WAN sinon menu 1
### 2️⃣Configuration de pfSense en CLI
* #### Menu Principale
![ad1](https://github.com/user-attachments/assets/6350b9b1-e3e9-46d7-8158-58c6d6c2087b)
* #### Renseigner la nouvelle IP
![ad1](https://github.com/user-attachments/assets/29262ade-e66a-44ff-897e-c1b1426042f0)
![ad1](https://github.com/user-attachments/assets/87dce0d2-3b4b-4649-9ea0-3d3c267f61db)
#### (Résultat après édition IP et corection des interfaces via menu 1)
* #### Un message nous indique `https://172.16.10.20.`
*  #### Se rendre sur le client puis configurer l'interface réseau.
![ad1](https://github.com/user-attachments/assets/f43f82e6-52c1-4c59-8bd0-8d0fd3b66817)
* #### test ping
![ad1](https://github.com/user-attachments/assets/69f7a5dd-8fc8-4f6f-a1d3-bd1d1f0b50dd)
### 3️⃣ Configuration de pfSense en GUI
* #### Se rendre sur la page pfSense et conection avec => admin + pfsense.
* ### `step 2`
   * #### renseigner les DNS et AD si besoin ⬇️
![ad1](https://github.com/user-attachments/assets/eb60e7a4-306a-4f47-8915-8833ce8cecc6)
* ### `step 3`
   * #### renseigner serveur horaire et fuseau horaire
![ad1](https://github.com/user-attachments/assets/b20eaef4-8585-4db0-acc4-2c2e44eaf748)
* ### `step 4`
   * #### Dans cette fenêtre toute la configuration IP/DHCP/MAC/PPPoE.
   * #### Dans le cadre de ce labo pensé à décocher les deux dernières cases.
![ad1](https://github.com/user-attachments/assets/73620cfe-9207-48cc-a94d-437703e1a67f)
* ### `step 5`
   * #### Dans cette étapes il est possible de configurer l'interface LAN (Déjà fait, plus haut).
* ### `step 6`
   * #### Modification de mot de passe pfSense
* ### `step 7`
   * #### redémarage 
* ### `step 8`
   * #### Idem
* ### `step 9`
   * #### finish ⬇️
![ad1](https://github.com/user-attachments/assets/099c2f4b-d737-484c-9acd-362150aa621e)






















