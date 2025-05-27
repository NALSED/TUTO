# Reverse proxy

---

### Ce tuto a pour objectif de présenter l'installation et la configuration d'un reverse proxy.
### L'utilisation d'un reverse proxy est motivé pour rendre accessible différents services, qui sont installé sur une même machine, avec donc une adresse IP.

---

### 📝INFRA:
* ### Serveur web 192.168.0.122 => apache2 // page infra
* ### Serveur debian 192.168.0.141 => Bareos // Plex // Cockpit
* ### DNS secondaire 192.168.0.210 => bind9
### Donc utilisation d'un reverse proxy afin de faire pointer les différents services présent sur le serveur débian, vers le DNS secondaire, et accéssible en WebUi via le serveur web. 

---

## 1️⃣ `Activation des modules`
      sudo a2enmod proxy
      sudo a2enmod proxy_http
      sudo a2enmod proxy_wstunnel
      sudo a2enmod headers
      sudo systemctl restart apache2

## 2️⃣ Fichier de configuration proxy-reverse
      nano /etc/apache2/sites-available/srv-debian.conf

## Configuration pour rediriger les ip sur les bon nom de domain via bind9 
### ⚠️ Penser à changer le adresse IP dans bind9 des services concernés par le reverse proxy, afin qu'il soit redirigés vers le serveur web .
### Adresse réel de Bareos//cockpit et Plex 192.168.0.141 mais dans bind9 192.168.0.122 pour pointer vers le serceur web.⚠️

      <VirtualHost *:80>
          ServerName plex.sednal.lan

          ProxyPreserveHost On
          ProxyPass / http://192.168.0.141:32400/
          ProxyPassReverse / http://192.168.0.141:32400/
      </VirtualHost>

      <VirtualHost *:80>
          ServerName bareos.sednal.lan

          ProxyPreserveHost On
          ProxyPass / http://192.168.0.141/bareos-webui/
          ProxyPassReverse / http://192.168.0.141/bareos-webui/
      </VirtualHost>

      <VirtualHost *:80>
          ServerName cockpit.sednal.lan

          ProxyPreserveHost On
          ProxyPass / http://192.168.0.141:9090/
          ProxyPassReverse / http://192.168.0.141:9090/
      </VirtualHost>


### Redemarer

            sudo a2ensite srv-debian.conf
            sudo systemctl reload apache2


















