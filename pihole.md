Préalablement un server debian en cli est installé sur un proxmox.

⚠️le serveur debian ip fixe 192.168.0.103 gateway 192.168.0.1 => DNS sur pihole net 192.168.10.103

1️⃣ télécharger

1) MAJ

          sudo apt update && sudo apt upgrade -y

2) Télécharger le script d'instal

          wget -O basic-install.sh https://install.pi-hole.net

3) Changer les droits et exécuter le script 

          chmod 744 basic-install.sh
         ./basic-install.sh

2️⃣ instalation

tout laisser par defaut

![Capture d’écran 2025-01-05 220600](https://github.com/user-attachments/assets/5aee4ed9-5dee-42ba-8018-21d2e5c33a53)

3️⃣ pihole web 192.168.0.103

* DNS 192.168.10.103
* activer le DHCP pool 192.168.0.100 // 192.168.0.253

4️⃣ configuration routeur R2

En plus la roue à gauche
# => chaine ( menu 2 à gauche ) désactiver le dhcp

![image](https://github.com/user-attachments/assets/69881572-4e83-40fb-863c-bea777b08f66)

# => internet (menu 4 à gauche ) => paramétre avancé 

![image](https://github.com/user-attachments/assets/cb0969b3-32b2-438f-ae35-c26e9f1d8cd7)

# utiliser le DNS suivant

![image](https://github.com/user-attachments/assets/20f4b45f-bae2-43e7-9ad8-06394e884f32)

# configurer le DNS 192.168.10.103 (perso) // 9.9.9.9(quad)

![image](https://github.com/user-attachments/assets/a3020012-0c34-4d51-b11e-2d70100766f2)






          
