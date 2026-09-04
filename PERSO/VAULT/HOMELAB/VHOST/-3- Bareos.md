## Vhost sur `192.168.0.239` pour `Bareos`

- Création
````
sudo vim /etc/nginx/sites-available/bareos.conf
````

- Édition
````
server {
    listen 80;
    server_name bareos.sednal.lan;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name bareos.sednal.lan;

    include snippets/ssl-nalsed.conf;

    location / {
        proxy_pass http://192.168.0.240/bareos-webui/;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
````

`[NOTE]`

Le chemin `/bareos-webui/` est à confirmer selon l'installation. Si la WebUI boucle en
redirections, retirer ce chemin du `proxy_pass` comme pour Pihole.

- Activation
````
cd /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/bareos.conf bareos.conf
sudo nginx -t && sudo systemctl reload nginx
````

