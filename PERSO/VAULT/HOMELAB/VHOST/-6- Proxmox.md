## Proxmox `192.168.0.242`

`[NOTE]`

Proxmox parle `HTTPS` sur 8006 avec son propre certificat auto-signé :
`proxy_ssl_verify off` est nécessaire tant qu'il n'est pas remplacé.

- Création fichier
````
sudo vim /etc/nginx/sites-available/proxmox.conf
````

- Édition fichier
````
server {
    listen 80;
    server_name proxmox.sednal.lan;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name proxmox.sednal.lan;
    client_max_body_size 0;

    include snippets/ssl-nalsed.conf;

    location / {
        proxy_pass https://192.168.0.242:8006;
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

