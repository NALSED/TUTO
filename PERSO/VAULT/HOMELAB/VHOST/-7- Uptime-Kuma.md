## Uptime-Kuma `192.168.0.237:3001`

---
Convention de nommage (identique à pihole et bareos) :

| Nom                     | Cible           | Usage                     |
|-------------------------|-----------------|---------------------------|
| `monitoring.sednal.lan` | 192.168.0.237   | Hôte (SSH, administration)|
| `kuma.sednal.lan`       | 192.168.0.239   | Service, via reverse proxy|

## `- 1.1` Filtrage sur le Pi2 (192.168.0.237)
````
sudo nft add rule ip filter DOCKER-USER ip daddr 172.18.0.2 tcp dport 3001 ip saddr != 192.168.0.239 drop
````

## `- 1.2` Vérification depuis `192.168.0.239` :

````
curl -I http://192.168.0.237:3001
````

Résultat attendu : `HTTP/1.1 302 Found`.

- Depuis le PC admin `192.168.0.235` (PowerShell) :

````
Test-NetConnection 192.168.0.237 -Port 3001
````

Résultat attendu : `PingSucceeded : True` et `TcpTestSucceeded : False`.

## `- 1.3` Certificat

Ajouter `kuma.sednal.lan` dans `alt_names` des **deux** templates de `192.168.0.239` (voir `-4-Agent.md` => Section [- 4.3](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/HOMELAB/-4-Agent.md#--43-templates)), Vault sur `192.168.0.238` allumé.

- Sur 192.168.0.239
````
sudo systemctl restart vault-agent
openssl x509 -in /etc/ssl/nalsed/infra.crt -noout -ext subjectAltName
````

- Résultat attendu : `kuma.sednal.lan` présent dans la liste.

## Vhost sur infra `192.168.0.239`

## `- 1.4` Créer fichier
````
sudo vim /etc/nginx/sites-available/kuma.conf
````

## `- 1.5` Editer
````
server {
    listen 80;
    server_name kuma.sednal.lan;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name kuma.sednal.lan;

    include snippets/ssl-nalsed.conf;

    location / {
        proxy_pass http://192.168.0.237:3001;

        proxy_http_version 1.1;
        proxy_set_header Upgrade    $http_upgrade;
        proxy_set_header Connection $connection_upgrade;

        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }
}
````

## `- 1.6` Activation
````
cd /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/kuma.conf kuma.conf
sudo nginx -t && sudo systemctl reload nginx
````

## `- 1.7` Vérification

````
curl -I https://kuma.sednal.lan
````

Résultat attendu : `HTTP/2 200`, et l'interface ne doit pas rester
bloquée sur « Connecting… » (signe que les en-têtes websocket ne
passent pas).
