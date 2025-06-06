# Liens entre docker sur Linux et Windows

---

## Ce Tuto à pour but de montrer la mise en place, d'une administration de docker, sur PC `Windows 11 => 192.168.0.111`.
## Pour un logiciel installé sur VM `Ubuntu_Serveur => 192.168.0.103`.
## Ainsi que la connection avec `VSC`, pour l'édition des `Docker File` et `Docker Compose` 

### `Labo`
* ### PC admin
* ### Vm Ubuntu serveur 24.04

---

### Ce tuto démarre avec Docker installé et a jour voir [ici](https://github.com/NALSED/TUTO/blob/main/PERSO/DOCKERS/Install.md)

## 1️⃣ Connection Serveur / VSC.
## 2️⃣ Connection Docker Desktop sur Windows / Docker Engine sur Ubuntu SANS TLS
## 3️⃣ Connection Docker Desktop sur Windows / Docker Engine sur Ubuntu AVEC TLS
## 4️⃣ Session permanente Win11/Ubuntu-serveur

---
---

## 1️⃣ Connection Serveur / VSC.

### 1.1) Installer  l'extention Remote - SSH sur VSC
![image](https://github.com/user-attachments/assets/d435f3f0-81ef-444d-be27-eda72e1bc165)

### 1.2) Ouvrir la palette de commande (Ctrl+Shift+P), taper `>Add New SSH Host...`
### Entrer les infos : SSH `sednal@192.168.0.103`
###  Puis pour se connecter à l'hôte `>Remote-SSH: Connect to Host...` et  l'IP de l'hôte apparaitra
###  Explorer ces  modes
![image](https://github.com/user-attachments/assets/b25fd532-d78d-4288-812f-97bff29bc1e3)



---


<details>
<summary>
<h2>
2️⃣ SANS TLS 
</h2>
</summary>

## 🐳 Activer l'accée au serveur Ubuntu via un emachine Windows 11, mais sans certificats,  chiffrements, déconseillé en production, car les infos passent en clairs.


### 2.1) Activer le daemon Docker distant sur Ubuntu:

#### Par défaut, Docker écoute uniquement sur le socket local UNIX (`/var/run/docker.sock`), autoriser à écouter sur l’IP réseau (TCP).
### 📝 Modifier le fichier de configuration du daemon :

      sudo nano /etc/docker/daemon.json

### Editer
      {
        "hosts": ["unix:///var/run/docker.sock", "tcp://IPSERVEUR:2375"] # ici 192.168.0.103
      }

### 2.2) Redémarrer Docker :
      sudo systemctl daemon-reexec
      sudo systemctl restart docker

### 2.3) Vérifier que le port 2375 est ouvert :
      sudo ss -tuln | grep 2375


### 2.4) configurer parfeu
      sudo ufw allow 2375/tcp

### Et restreindre l'accés
      sudo ufw allow from 192.168.0.111 to any port 2375 proto tcp


### 2.5) Configurer Docker Desktop

* ### Ouvrir Docker Desktop.
* ### Cliquer sur l’icône ⚙️ Settings.
* ### Dans Docker Engine.
### Remplacer le contenu par (⚠️cette action désactivera le moteur Docker local de Docker Desktop, et tout sera redirigé vers le serveur Ubuntu distant.):
      {
        "hosts": ["tcp://192.168.0.103:2375"]
      }

### 2.6) tester  la connection
      docker -H tcp://192.168.0.103:2375 ps

</details>

---


<details>
<summary>
<h2>
3️⃣ AVEC TLS 
</h2>
</summary>

## Dans  cette partie
* ## Création d'une autorité de certification `CA` => `ca.pem`
* ## Création  d'un  certificat Client => key.pem
* ## Création  d'un  certificat Serveur => cert.pem
* ## Modification  de  docker.sercice, pour éviter un conflit avec notre configuration
* ## Intégration de  la configuration du serveur sur le PC admin

---

### 3.1) SUR UBUNTU Créer une autorité de certification (CA).
      mkdir -p ~/docker-certs
      cd ~/docker-certs

### Génèrer la CA :
      openssl genrsa -aes256 -out ca-key.pem 4096
      openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem

### Et ici 
### 🔴 Renseigner Mot de passe
### 🟢 CN Important le reste peux  être laissé vide
![image](https://github.com/user-attachments/assets/c3d73450-e5cc-4e73-9221-0b46ab639248)


### 3.2) Créer les certificats pour le serveur Docker
      openssl genrsa -out server-key.pem 4096
      openssl req -subj "/CN=192.168.0.103" -new -key server-key.pem -out server.csr

### Crée un fichier d’extensions :  
      echo "subjectAltName = IP:192.168.0.103" > extfile.cnf
### Puis  signer
      openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf


### 3.3) Créer les certificats pour le client (Docker Desktop)
      openssl genrsa -out key.pem 4096
      openssl req -subj '/CN=client' -new -key key.pem -out client.csr

### Puis
      echo "extendedKeyUsage = clientAuth" > extfile-client.cnf

### Et signer:
      openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile-client.cnf

### 3.4)  Configurer Docker pour utiliser TLS
       nano /etc/docker/daemon.json

### Editer
###  Mettre l'IP de la   VM sur laquelle  tourne Docker, et le port  d''écoute  change, il  passe de  2375 => 2376      
      
      {
        "hosts": ["tcp://192.168.0.103:2376", "unix:///var/run/docker.sock"],
        "tls": true,
        "tlsverify": true,
        "tlscacert": "/etc/docker/certs/ca.pem",
        "tlscert": "/etc/docker/certs/server-cert.pem",
        "tlskey": "/etc/docker/certs/server-key.pem"
      }

![image](https://github.com/user-attachments/assets/6e3080b8-594b-4df5-b397-d2fea17a93f1)


### 3.5)  Déplacer les certificats au bon endroit
      sudo mkdir -p /etc/docker/certs
      sudo cp ca.pem server-cert.pem server-key.pem /etc/docker/certs

### ⚠️Opération importante pour supprimer le conflit de endpoints entre `docker.service` et  `/etc/docker/daemon.json`   
### Docker refuse de démarrer car il détecte cette double définition conflictuelle des hosts
### Résumer des  étapes à réaliser
*  ### Modifier le service systemd (via sudo systemctl edit --full docker.service) pour supprimer -H fd:// dans la ligne ExecStart.
*  ### Vérifier la modification avec sudo systemctl cat docker.service.
*  ### Recharger systemd (sudo systemctl daemon-reload) et redémarrer Docker (sudo systemctl restart docker).
### Probléme 

### Editer le fichier docker.service
      sudo systemctl edit --full docker.service

### Supprimer `-H fd://`
      ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

### Resultat
      ExecStart=/usr/bin/dockerd --containerd=/run/containerd/containerd.sock

### Redémarer le service
      sudo systemctl daemon-reload
      sudo systemctl restart docker
      sudo systemctl status docker
![image](https://github.com/user-attachments/assets/ca2dd134-32fe-4928-a0d7-930667991ed9)


### 3.6)  Intégrer les fichier de certifications au pc Admin 
### Copier les fichiers serveur=>admin
       sudo scp -r /etc/docker/certs sednal@192.168.0.111:C/certif

### Renomer les fichier copier  en => ca.pem / cert.pem / key.pem

### Créer un dossier ici: 

### Copier les fichiers de certification

### Et pour finir lancer cette commande dans powershell (en une seul fois)
    docker --tlsverify `
      --tlscacert="C:\cert-docker\ca.pem" `
      --tlscert="C:\cert-docker\cert.pem" `
      --tlskey="C:\cert-docker\key.pem" `
      -H=tcp://192.168.0.103:2376 version

### Resultat attendu
![image](https://github.com/user-attachments/assets/a2cff0cc-8a9b-4ac5-9a26-99ce18854dd6)





  
</details>

---

<details>
<summary>
<h2>
4️⃣ Session permanente
</h2>
</summary>

##  `Ubuntu-serveur/Win11`

###  L'objectif de cette dernière partie  est de créer un session permanant et sécurisée entre  Pc admin etle serveur Ubuntu.
### 4.1) Pour ce  passer de ces lignes à chaques commandes
             --tlsverify `
             --tlscacert="C:\cert-docker\ca.pem" `
             --tlscert="C:\cert-docker\cert.pem" `
             --tlskey="C:\cert-docker\key.pem" `

### 4.2) On  pourrait définir des variables d'environement
            $env:DOCKER_HOST = "tcp://192.168.0.101:2376"
            $env:DOCKER_TLS_VERIFY = "1"
            $env:DOCKER_CERT_PATH = "C:\cert-docker"

### Mais  à chaque redémarage elle seront effacées

###  4.3) Inscription définitive  des variables d'environement: 
### Powershell en Admin  
            [System.Environment]::SetEnvironmentVariable("DOCKER_HOST", "tcp://192.168.0.101:2376", "User")
            [System.Environment]::SetEnvironmentVariable("DOCKER_TLS_VERIFY", "1", "User")
            [System.Environment]::SetEnvironmentVariable("DOCKER_CERT_PATH", "C:\cert-docker", "User")
![image](https://github.com/user-attachments/assets/096c63c6-5dda-4e65-8570-8577dec15936)

### 4.5) Maintenant on  peux exécuter des commandes Docker sécurisées via  Windows 11 vers le serveur Ubuntu distant 
![image](https://github.com/user-attachments/assets/1d4e0adc-5296-483e-be77-60273f9555f8)

![image](https://github.com/user-attachments/assets/0866f573-fa6e-4d38-970c-44d1457fbfe1)


---
---

## `Ubuntu-serveur/Debian`

### 1.1) Editer les certificats 
     [VOIR]()
      
### 1.2) Editer le fichier docker.service
      nano /lib/systemd/system/docker.service

### 1.3) Editer
            ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376 \
            --containerd=/run/containerd/containerd.sock \
            --tlsverify \
            --tlscacert=/etc/docker/certs/ca.pem \
            --tlscert=/etc/docker/certs/cert.pem \
            --tlskey=/etc/docker/certs/key.pem
            ExecReload=/bin/kill -s HUP $MAINPID
            TimeoutStartSec=0
            RestartSec=2
            Restart=always

### Ce qui est rajouté  en 🟢
![image](https://github.com/user-attachments/assets/92246ecb-e59c-49ba-86e1-f24fae4dcd49)

### Redemarrer Daemon et service
       systemctl daemon-reexec
       systemctl daemon-reload
       systemctl restart docker

### Vérif 
# 🔴 Après un systemctl status docker` 
![image](https://github.com/user-attachments/assets/639afd77-79a1-42e6-9f97-4b78d5f74643)

# 🟢 Après un `systemctl status docker` 
![image](https://github.com/user-attachments/assets/6086a240-7d2a-476f-8199-fa77e865fbe2)




























</details>
