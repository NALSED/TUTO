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
![ad1](https://github.com/user-attachments/assets/d46e0ea2-6522-4cb1-bba0-ca5796a4f7e0)
   * ### 🔵 Dynamic IP : si l'adresse IP publique d'un client change, il pourra maintenir sa connexion VPN.
   * ### 🔴 net30 - isolated /30 network per client
   * ##### ⚠️ Au niveau de la `Topology`, pour des raisons de sécurité, il vaut mieux utiliser la topologie "net30 - isolated /30 network per client" pour que chaque client soit isolé dans un sous-réseau (de la plage réseau VPN) afin que les clients ne puissent pas communiquer entre eux !
##### Cela n'est pas sans conséquence : plutôt qu'une connexion VPN consomme une adresse IP sur la plage réseau dédiée au VPN, elle va consommer 4 adresses IP : une adresse IP pour le PC, une adresse IP pour le pare-feu et les adresses de réseau et broadcast du sous-réseau en /30.
##### Si vous avez besoin de plus de 60 connexions VPN en simultanés, vous ne devez pas utiliser un réseau VPN en /24, mais vous devez prendre plus large. Dans ce cas, modifiez la valeur "IPv4 Tunnel Network" définie précédemment.
![ad1](https://github.com/user-attachments/assets/324d88a9-e4ab-42c8-9ce1-28e1b4957521)
   * ### La prochaine section concerne le DNS mais dans notre cas pas de résolution DNS
   * ### 🔵 Custom options", indiquez : auth-nocache. Cette option offre une protection supplémentaire contre le vol des identifiants en refusant la mise en cache.
   * ### 🔴 Save :sweat_smile: :ok_hand:
 ![ad1](https://github.com/user-attachments/assets/1f521504-b4ef-4ec9-8bcd-eb2244eb7382)
## 5️⃣ Exporter la configuration OpenVPN
##### Pour télécharger la configuration au format ".ovpn", il est nécessaire d'installer un paquet supplémentaire sur notre pare-feu.
   * ###  System => Package Manager => Available Packages.
   * ### 🔵 Taper openvpn
   * ### 🔴 + Install
![ad1](https://github.com/user-attachments/assets/d95ee0e5-bb5a-492f-bae0-3994c4e27741)
   * ### VPN => 🔵 OpenVPN => 🔴 Client Export
   * ### Laisser par defaut => Advanced => rentrer auth-nocache => Save as default
![ad1](https://github.com/user-attachments/assets/19ced4b5-1763-4643-904e-b08b42d13098)
   * ### Possibilité d'archiver le VPN 
![ad1](https://github.com/user-attachments/assets/ccdaef7c-6038-42ee-8fc9-4bc081c79525)
## 6️⃣ Règles de firewall pour OpenVPN
  * ###  ▶️ Autoriser le flux VPN 
   * ### Firewall => Rules => WAN
   * ### Protocol UDP 
![ad1](https://github.com/user-attachments/assets/4d0c9b27-3796-4f8f-aae6-2bfa89e5f5e2)
   * ### Source Any
   * ### 🔵 Destination : WAN / 🔴 Destination Port Range : openVPN(1194) 
![ad1](https://github.com/user-attachments/assets/4c82f825-e7cf-49ec-b136-1840bc4f0b39)
   * ### Dans Extra Options : Log => Save
![ad1](https://github.com/user-attachments/assets/aa492e67-0b4f-4e7d-b7bd-29182cc916de)
   * ### ▶️ Autoriser les flux vers les ressources :
   * ### Par defaut => Destination
   * ### 🔵 Address or Alias => adresse de l'hôte 172.16.10.10
   * ### 🔴 Destination Port Range : 3389 pour le RDP
   * ### Save 
# 🎆
## 7️⃣ Tester sur le client 
   * ### Télécharger [OpenVPN](https://openvpn.net/community-downloads/)
   * ### Importe le fichier de configuration depuis host => client
   * ### Puis copier le contenu du dossier dans C:\Programmes\OpenVPN\Config
![ad1](https://github.com/user-attachments/assets/15742578-b971-467c-a393-9519fa63c833)
   * ### clic droit sur OpenVPN
![ad2](https://github.com/user-attachments/assets/0cb6575f-cb9d-4713-be8f-2a61c2a6909d)
   * ### Fournir Login et Password de pfSense GUI
![ad1](https://github.com/user-attachments/assets/5c134401-b323-4323-8f77-3f69441c39b8)
   * ### On peux vérifier au niveau de l'icon OpenVPN
![ad1](https://github.com/user-attachments/assets/2289df16-a4f2-4a86-a29a-d139f015b223)

























