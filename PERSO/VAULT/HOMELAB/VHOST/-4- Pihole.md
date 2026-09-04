##  Pihole `192.168.0.241`

`[NOTE]`

`proxy_pass` sans `/admin/` : Pihole gère lui-même ses chemins et redirige vers `/admin/login`.
Avec `/admin/` dans le `proxy_pass`, nginx transmet `/admin/admin/` et le navigateur boucle
(`ERR_TOO_MANY_REDIRECTS`).

- Création fichier de configuration 
````
sudo vim /etc/nginx/sites-available/pihole.conf
````

- Edition fichier
````
server {
    listen 80;
    server_name pihole.sednal.lan;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name pihole.sednal.lan;

    include snippets/ssl-nalsed.conf;

    location = / {
        return 301 /admin/;
    }

    location / {
        proxy_pass http://192.168.0.241;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
````
