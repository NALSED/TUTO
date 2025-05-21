## 1. Installation du socle LAMP

- apt install apache2 php mariadb-server -y
- apt install php-xml php-common php-json php-mysql php-mbstring php-curl php-gd php-intl php-zip php-bz2 php-imap php-apcu -y
- apt install php-ldap -y

## 2. PREPARATION DE LA BASE DONNEE

- mysql_secure_installation
	- n
	- y
	- y
	- y
	- y
	- y

- mysql -u root -p

```
CREATE DATABASE db23_glpi;
GRANT ALL PRIVILEGES ON db23_glpi.* TO glpi_adm@localhost IDENTIFIED BY "Pascal01";
FLUSH PRIVILEGES;
EXIT
```

## 3. Téléchargement de GLPI

### 3.1 téléchargement et installation
- cd /tmp
- wget https://github.com/glpi-project/glpi/releases/download/10.0.10/glpi-10.0.10.tgz
- tar -xzvf glpi-10.0.10.tgz -C /var/www/
- chown www-data /var/www/glpi/ -R

### 3.2 Sécurisation
nous allons devoir créer plusieurs dossiers et sortir des données de la racine Web (/var/www/glpi) de manière à les stocker dans les nouveaux dossiers que nous allons créer. Ceci va permettre de faire une installation sécurisée de GLPI, qui suit les recommandations de l'éditeur.

- mkdir /etc/glpi
- chown www-data /etc/glpi/
- mv /var/www/glpi/config /etc/glpi
- mkdir /var/lib/glpi
- chown www-data /var/lib/glpi/
- mv /var/www/glpi/files /var/lib/glpi
- mkdir /var/log/glpi
- chown www-data /var/log/glpi


### 3.3 Configuration  pour indiquer à GLPI ou sont stockés les données.

nano /var/www/glpi/inc/downstream.php

```
<?php
define('GLPI_CONFIG_DIR', '/etc/glpi/');
if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
    require_once GLPI_CONFIG_DIR . '/local_define.php';
}
```

- nano /etc/glpi/local_define.php

```
<?php
define('GLPI_VAR_DIR', '/var/lib/glpi/files');
define('GLPI_LOG_DIR', '/var/log/glpi');
```

## 4. Préparer Apache2

- nano /etc/apache2/sites-available/domaine.local.conf
```
<VirtualHost *:80>
    ServerName domaine.local

    DocumentRoot /var/www/glpi/public

    # If you want to place GLPI in a subfolder of your site (e.g. your virtual host is serving multiple applications),
    # you can use an Alias directive. If you do this, the DocumentRoot directive MUST NOT target the GLPI directory itself.
    # Alias "/glpi" "/var/www/glpi/public"

    <Directory /var/www/glpi/public>
        Require all granted

        RewriteEngine On

        # Redirect all requests to GLPI router, unless file exists.
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^(.*)$ index.php [QSA,L]
    </Directory>
</VirtualHost>
```

- a2ensite domaine.local
- a2dissite 000-default.conf
- a2enmod rewrite
- systemctl restart apache2


## 5. Utilisation de PHP8.2-FPM

- apt install php8.2-fpm
- a2enmod proxy_fcgi setenvif
- a2enconf php8.2-fpm
- systemctl reload apache2
- nano /etc/php/8.2/fpm/php.ini
(recherchez l'option "session.cookie_httponly" et indiquez la valeur "on" pour l'activer)

```
; Whether or not to add the httpOnly flag to the cookie, which makes it
; inaccessible to browser scripting languages such as JavaScript.
; https://php.net/session.cookie-httponly
session.cookie_httponly = on
```

- systemctl restart php8.2-fpm.service

- nano /etc/apache2/sites-available/domaine.local.conf
(rajouter avant le dernier </VirtualHost>

```
<FilesMatch \.php$>
    SetHandler "proxy:unix:/run/php/php8.2-fpm.sock|fcgi://localhost/"
</FilesMatch>
```

-systemctl restart apache2

## 6. On vérifie et on ajoute l'utilisateur de la base Mariadb

- nano /etc/hosts

Ajoutez une ligne qui mappe le nom d'hôte db23_glpi à l'adresse IP de votre serveur MariaDB (ou de la machine sur laquelle il se trouve). Par exemple :

- 127.0.0.1   db23_glpi

- systemctl restart mariadb

## 7. Installation de GLPI

voir le tuto https://www.it-connect.fr/installation-pas-a-pas-de-glpi-10-sur-debian-12/

