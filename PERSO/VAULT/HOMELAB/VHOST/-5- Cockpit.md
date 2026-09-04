##  Cockpit `192.168.0.241`

---

### `-1-` Vhost sur `192.168.0.239`

- Création
````
sudo vim /etc/nginx/sites-available/cockpit.conf
````

- Édition
````
server {
    listen 80;
    server_name cockpit.sednal.lan;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name cockpit.sednal.lan;

    include snippets/ssl-nalsed.conf;

    location / {
        proxy_pass https://192.168.0.241:9090;
        proxy_ssl_verify off;

        proxy_http_version 1.1;
        proxy_set_header Upgrade    $http_upgrade;
        proxy_set_header Connection $connection_upgrade;

        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_buffering off;
        proxy_read_timeout 3600s;
        send_timeout       3600s;
    }
}
````

`[NOTE]`

Cockpit écoute en HTTPS avec son propre certificat auto-signé, d'où `proxy_ssl_verify off`.

- Activation
````
cd /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/cockpit.conf cockpit.conf
sudo nginx -t && sudo systemctl reload nginx
````

---

### `-2-` Configuration sur `192.168.0.241`

`[NOTE]`

Sans `Origins`, Cockpit refuse les requêtes venant du proxy : page blanche ou erreur de
websocket à la connexion. Le fichier n'existe pas par défaut, il est à créer.

- Création
````
sudo mkdir -p /etc/cockpit
sudo vim /etc/cockpit/cockpit.conf
````

- Édition
````
[WebService]
Origins = https://cockpit.sednal.lan https://192.168.0.241:9090
ProtocolHeader = X-Forwarded-Proto
````

- Redémarrage
````
sudo systemctl restart cockpit.socket
````

