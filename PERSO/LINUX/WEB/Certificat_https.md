# Activer les certificats https sur apache2

---

### Ce tuto à pour objectif la mise en place de  certificat SSL auto-signé pour :
### ⚠️ A faire quand les intéraction avec bareos et les certifcat ssl seront gérer ⚠️



# Créer un certificat SSL auto-signé

sudo mkdir -p /etc/apache2/ssl

sudo openssl req -x509 -nodes -days 365 \
 -newkey rsa:2048 \
 -keyout /etc/apache2/ssl/apache-selfsigned.key \
 -out /etc/apache2/ssl/apache-selfsigned.crt

 
 # Créer un fichier de configuration SSL pour Apache
 
 sudo nano /etc/apache2/sites-available/default-ssl.conf


 <IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        ServerAdmin webmaster@localhost
        ServerName localhost

        DocumentRoot /var/www/html

        SSLEngine on

        SSLCertificateFile      /etc/apache2/ssl/apache-selfsigned.crt
        SSLCertificateKeyFile /etc/apache2/ssl/apache-selfsigned.key

        <FilesMatch "\.(cgi|shtml|phtml|php)$">
                SSLOptions +StdEnvVars
        </FilesMatch>

        <Directory /usr/lib/cgi-bin>
                SSLOptions +StdEnvVars
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
</IfModule>



# Activer les modules et le site SSL

sudo a2enmod ssl
sudo a2ensite default-ssl.conf
sudo systemctl reload apache2










