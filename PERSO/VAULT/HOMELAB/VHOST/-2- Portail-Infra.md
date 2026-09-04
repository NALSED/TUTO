##  Portail Infra `192.168.0.239`

`[NOTE]`

Le portail HTML des services est servi directement par nginx depuis `/var/www/html`
sur `192.168.0.239` : pas de `proxy_pass`, la machine héberge les fichiers.

- Création
````
sudo vim /etc/nginx/sites-available/infra.conf
````

- Édition
````
server {
    listen 80;
    server_name infra.sednal.lan;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name infra.sednal.lan;

    include snippets/ssl-nalsed.conf;

    root  /var/www/html;
    index index.html;
}
````
