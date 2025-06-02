# Instalation de Docker

---

## Ce tuto présentera l'instalation de docker manuelement sur, l''avantage de cette installation, est que par la suite docker pourra être mise à jour via `apt` 
### un serveur Ubuntu noble 24.04.1 (la version doit être 64bits) 
* ### RAM 5Gb
* ### Coeurs 2
 
---

## 1️⃣ Prérequis

## 2️⃣ Source.list

## 3️⃣ Install Docker

---
---

##  1️⃣ `Prérequis`
### 1.1) Plusieurs paquets sont nécessaires avant l'instalation de Docker, pour la créationnde certificats clés gpg.  
     sudo apt install -y ca-certificates curl  gnupg

### 1.2) Créer un répertoir keyrings  dans /etc/apt afin de  stocker  les clés : 
    sudo install -m 0755 -d /etc/apt/keyrings

* #### `install ` créer le répertoire.
* #### `-m 0755` édition des droits.
* #### `-d` créé le répertoire si il  n'est pas présent dans apt

##### (sudo install -m 0755 -d /etc/apt/keyrings = sudo mkdir -p /etc/apt/keyrings && sudo chmod 0755 /etc/apt/keyrings )

### 1.3) Récupérer la clé gpg de docker :
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg


* #### f => n'affiche pas les erreurs
* #### s => si le téléchargement échoue, affichage erreur
* #### S => Montre les erreurs de redirection
* #### L => gére les redirections
* #### --dearmor retir l'envelope ASCII => -----BEGIN PGP PUBLIC KEY BLOCK----- et -----END PGP PUBLIC KEY BLOCK-----
* #### -o outpout => donc la sortie vers

### 1.4) changer permitions en lecture
          sudo chmod a+r /etc/apt/keyrings/docker.gpg


---

## 2️⃣ `Source.list`
### 2.1) Création d''un fichier docker.list, pour  installation et mise à jour des paquets.
### 2.2) Ce rendre dans  le répertoire `/sources.list.d` et créer le  fichier
      cd /etc/apt/sources.list.d
      sudo nano docker.source
### 2.3) y placer un commentaire (peux importe)
      # Docker.source

### Rechercher la version de l'OS et l'architecture:
      cat  /etc/os-release
### Ici
![image](https://github.com/user-attachments/assets/5d1ed7d7-184f-4aab-96b8-b8fa89a5440c)

       dpkg --print-architecture
### Ici => amd64

### Création de la liste
    sudo nano /etc/apt/sources.list.d/docker.sources

### Editer   
    Types: deb
    URIs: https://download.docker.com/linux/ubuntu
    Suites: noble
    Components: stable
    Architectures: amd64
    Signed-By: /etc/apt/keyrings/docker.gpg


---

## 3️⃣ `Install` 

### 3.1) MAJ apt :
    sudo apt update

### Sortie attendu :
![image](https://github.com/user-attachments/assets/8801b558-777c-4862-8fae-b7408b2adf47)

### 3.2) Installation de Docker
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

* #### docker-ce => le logiciel
* #### docker-ce-cli => client
* #### containerd.io  => daemond execution conteneur
* #### docker-buildx-plugin => ajoute du support de création  de conteneur
* #### docker-compose-plugin => Décrire l'architecture en .yaml 

### 3.3) Test
![image](https://github.com/user-attachments/assets/9f71e017-5c7c-47fa-87f0-aa5a44bdf568)

### 3.4) ajouter l'utilisateur au  groupe docker (pour ne plus taper sudo)
    sudo usermod -aG docker $USER
    newgrp docker

    
