# Installer/Configurer FreePbx

### L'instalation est réalisé avec ce tuto
https://sangomakb.atlassian.net/wiki/spaces/FP/pages/230326391/FreePBX+17+Installation

## SOMMAIRE 
### 1️⃣ `Installation de FreePbx`
### 2️⃣ `Configuration WebUi`
### 3️⃣ `Création d'Utilisateur`
### 4️⃣ `SIP`
### 5️⃣ `Intégration à l'AD`
### 6️⃣ ``
### 7️⃣ ``
### 8️⃣ ``

***
***

### 1️⃣ `Installation de FreePbx`

#### 1.1) Rentrer les commandes suivante

          cd /tmp
          wget https://github.com/FreePBX/sng_freepbx_debian_install/raw/master/sng_freepbx_debian_install.sh  -O /tmp/sng_freepbx_debian_install.sh
          bash /tmp/sng_freepbx_debian_install.sh

#### 1.2) FreePbx est maintenant installé sur sur le serveur CLI 

![image](https://github.com/user-attachments/assets/1d17666a-8c4d-4014-865a-7344bb560229)

#### 1.3) Se rendre sur la partie WebUi dde FreePbx
#### 1.4) Créer un Utilisateur et MDP

***

### 2️⃣ `Configuration WebUi`

#### 2.1) Sur la page d'acceuil de FreePBX
#### Admin => System Admin 

![image](https://github.com/user-attachments/assets/9ccbc032-bc8a-4b27-88a8-ef209d25da9e)

#### 2.2) Activation => Activate


![image](https://github.com/user-attachments/assets/21b1b449-a542-49c8-9293-15e7d4527c0c)

![image](https://github.com/user-attachments/assets/b2d575e4-58ca-40f0-9d7d-76f25e83c7ea)

#### 2.3) Renseigner les infos d'utilisateur
#### MDP Azerty1*131213 

![image](https://github.com/user-attachments/assets/0c4f00e7-5590-45b9-b4fa-2e067d2a583a)

#### Ici renseigner des infos aléatoires
#### Pour `Which best describes you` renseigner `I use your products and services with my Business(s) and do not want to resell it`.
![image](https://github.com/user-attachments/assets/1a64d024-b658-467a-b839-538e861bfd07)

#### Puis Create.

![image](https://github.com/user-attachments/assets/9ad4b64e-465f-47c0-aaa4-f6a9bafd561c)

#### 2.4) Activate

![image](https://github.com/user-attachments/assets/0f9059f8-01cc-4f4c-9f90-9a166af0a517)

#### 2.5) DNS
#### Admin => Sysadmin => DNS
#### Renseigner l'IP du DNS.

![image](https://github.com/user-attachments/assets/4b6d8d6d-220e-40e5-ae4e-d999a8375aea)

***

### 3️⃣ `Création d'Utilisateur`

#### 3.1) Se rendre dans Connectivity => Extention
![image](https://github.com/user-attachments/assets/5d04a45f-8e03-4ef7-84dd-867e16589a1e)


#### 3.2) SIP [chan_pjsip] Extensions => Add New SIP [chan_pjsip] Extensions
![image](https://github.com/user-attachments/assets/6f627005-f980-48fa-9594-d87ba02ec671)

#### 3.3) Création des Utilisateurs
#### Nous allons Utiliser des utilisateurs de l'AD comme ceci

![image](https://github.com/user-attachments/assets/45072ff3-aa5d-43ae-9e2e-25c65f9eb6db)

|Numéro de ligne/User Extention|Nom|MDP|
|:-:|:-:|:-:|
|80100|Adrian Schultz|Azerty1*131213|
|80101|Virginie Perrin|Azerty1*131213|

![image](https://github.com/user-attachments/assets/d861d4a9-845f-4987-81d8-e109dc05f6ed)

***

### 4️⃣ `SIP`

#### 4.1) Se rendre sur l'Url et télécharger:

                    https://3cxphone.software.informer.com/download/

![image](https://github.com/user-attachments/assets/09999152-a44e-48ab-94d9-cf5277c07bd9)

#### 4.2) next => I accept => Install
#### 4.3) Create account => New

![image](https://github.com/user-attachments/assets/d4f5c587-7f8d-4f3d-8b7d-752a0449ff4b)

#### 4.4) 
#### Account Name : Adrian Schultz
#### Caller ID : 80100
#### Extension : 80100
#### ID : 80100
#### Password : Azerty1*
#### I am in the office - local IP : l'adresse IP du serveur 10.15.0.41

![image](https://github.com/user-attachments/assets/2a612d3b-8798-4fc8-9c85-ec6b01bfc840)

#### 4.5) Faire la même chose sur le deuxiéme client
 
#### Account Name : Virginie Perrin
#### Caller ID : 80101
#### Extension : 80101
#### ID : 80101
#### Password : Azerty1*
#### I am in the office - local IP : l'adresse IP du serveur 10.15.0.41

#### 4.6) appeler 
![image](https://github.com/user-attachments/assets/2bac823d-5456-4937-b548-6f7ea7e42e99)

#### 4.7) répondre
![image](https://github.com/user-attachments/assets/50f4d7ee-fc92-4218-b07d-53fe71a03ed4)

***

### 5️⃣ `Intégration à l'AD`

#### 5.1) Tester le port n°389 du Client => AD
#### Utiliser Telnet
#### Télécharger Telnet sur le client et AD
          dism /online /Enable-Feature /FeatureName:TelnetClient

![image](https://github.com/user-attachments/assets/fb8d8ff1-dfec-4e17-8d95-be472a9961eb)

#### Lancer la requête : telnet 10.15.0.36 389
#### Si aucun message d'érreur et le shell change => port ouvert
![image](https://github.com/user-attachments/assets/fb1a3b76-a0f8-490e-bbff-221fded9b420)

#### 5.2) Se rendre dans Admin => User Management => Directories Add
![image](https://github.com/user-attachments/assets/590529cb-f888-4411-830d-543599273797)

![image](https://github.com/user-attachments/assets/d089c0cb-c77b-442b-8670-a7ad54a2efd2)

#### 5.3) Choisir `Microsoft Active Directory` et renseigner les infos:
#### Page de base => ! Not connected 
![image](https://github.com/user-attachments/assets/0a30f759-b568-438f-a8b5-f30631cdc7a0)

#### Renseigner :

#### Hôte : adresse IP du serveur AD
#### Port : la valeur par défaut est 389
#### Nom d'utilisateur : Administrator(ayant les droits de gestion AD)
#### Mot de passe : Mot de passe Administrator
#### Domaine : Pharmgreen.com
#### Base DN :DC=Pharmgreen,DC=com

#### => Submit retourner dans l'édition de AD 
![image](https://github.com/user-attachments/assets/64ccfd83-4647-46cd-9ae2-2f5063211b6c)

#### Le status à changer 
![image](https://github.com/user-attachments/assets/f1fd55be-47f6-4f06-8db0-b90d7b703794)

 #### 5.4) Renseigner l'ogject class ici par defaut

 #### 5.5) User object filter 
 #### Ici il faut créer un filtre prenant tout les utilisateur appartenant au groupe Domain User
                     (&(objectCategory=Person)(sAMAccountName=*)(memberOf=cn=Domain User,ou=Departments,dc=Pharmgreen,dc=com))

#### => Submit

#### Les utilisateur apparaissent dans User

![image](https://github.com/user-attachments/assets/eeeddd69-0ec9-4879-a82b-ee2c7eeb4088)





























