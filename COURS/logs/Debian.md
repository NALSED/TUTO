## 1️⃣ Installer un serveur Web
      sudo apt update
      sudo apt install apache2
## 2️⃣Configurer Les logs
#### Se rendre dans le fichier de conf de apache2
    /etc/apache2/sites-available/000-default.conf
#### Puis si ce n'est pas le cas décommenter les lignes
      ErrorLog ${APACHE_LOG_DIR}/error.log
      CustomLog ${APACHE_LOG_DIR}/access.log combined
## 3️⃣ Installation et utilisation de curl
      apt install curl
#### Puis lancer des requêtes
      curl https://192.168.10.12 🟢
      curl https://192.16.10.12/lls🔴
## 4️⃣ Logs
#### Se rendre dans le fichiers logs
    cat /var/log/apache2/access.log
IP 🔵
ok 🟢
not found 🔴
![image](https://github.com/user-attachments/assets/09de870b-5902-4ce5-9686-6d7f8b8c2dae)





















