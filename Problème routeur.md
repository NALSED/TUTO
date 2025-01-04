
#### 1️⃣`Matériel :`
* [offre à 16000](https://www.ucom.am/en/personal/home-services/unity/unity-packages/)
* [box](https://www.meconnect.net/upload/4275websiteAFCOM%20Dual%20Wif%20iONT.pdf)
* [routeur](https://www.tp-link.com/en/support/download/ex220/)
* [Switch](https://www.dlink.com/en/products/des-1005c-5-port-10-100-mbps-unmanaged-desktop-switch) : Mon PC ET Serveur Proxmox.
___
___
#### 2️⃣ Situation avant le drame :
* Je souhaitait installer PiHole (bloquer de pub) sur une VM, sur mon serveur proxmox a la maison.
La procédure est la suivante, configurer dans le routeur (tplink), pour  que le serveur DNS de référence soit celui de PiHole, donc besoin d'accéder à la configuration du routeur.
___
* Je regarde la procédure, il faut se connecter via un navigateur, chose que je tente avec l'IP fournie par Tplink => http://192.168.0.1 ou http://192.168.1.1.
___
* Cela ne fontionne pas, je regarde donc sur Powershell la gateway => 192.168.10.1 (déjà probléme..)
Voila la page (192.168.10.1) :
![image](https://github.com/user-attachments/assets/fa6af108-62a6-4a3d-bc99-bffab68c8cee)
Le message quand je tente de me loger..
![image](https://github.com/user-attachments/assets/72f0556d-fb0a-4530-b014-6d447ab9b6ca)
___
___
#### 3️⃣ `Recherche de solution`
1) Télécharger l'app Tplink
2) Débrancher rebrancher le routeur et la box
3) Ipconfig /release ipconfig/renew
4) Tester les différents ports de la box et du routeur
5) Et la ce qui a foutu la merde => RESET LE ROUTEUR EN MODE USINE..
Et la plus de wifi, impossible retrouver ma box sur le réseau..
Et toujours impossible de se connecter au routeur.
La je teste :
6) De redémarrer mon ordinateur
7) Tenter une connexion en https
8) Connexion sans la wifi
9) En direct sans le routeur (pas de connection)
10) Désactiver le firewall
11) Changer de navigateur
12) Effacer les données de navigation
13) Contacter mon FAI
___
___
#### 4️⃣ Résultat
1) Connexion uniquement en ethernet
2) Impossible de se connecter au routeur
3) Impossible de retrouver le réseau wifi, il a disparu...

Si vous avez des idées, merci.❤️



















  
