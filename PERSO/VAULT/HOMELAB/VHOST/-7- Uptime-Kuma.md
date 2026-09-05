## Uptime-Kuma `192.168.0.237:3001`

---

Convention de nommage (identique à pihole et bareos) :

| Nom                     | Cible           | Usage                     |
|-------------------------|-----------------|---------------------------|
| `monitoring.sednal.lan` | 192.168.0.237   | Hôte (SSH, administration)|
| `kuma.sednal.lan`       | 192.168.0.239   | Service, via reverse proxy|


## `- 1.1` Filtrage sur le Pi2 (192.168.0.237)

```bash
nft add rule inet filter input ip saddr 192.168.0.239 tcp dport 3001 accept
nft add rule inet filter input tcp dport 3001 drop
```

## `- 1.2` Vérification depuis `192.168.0.239` :
````
curl -I http://192.168.0.237:3001
````

Résultat attendu : `HTTP/1.1 302 Found`.
Depuis toute autre machine, la connexion doit être rejetée.

## Vhost sur 192.168.0.239

## `- 1.3` Créer fichier
````
/etc/nginx/conf.d/kuma.conf
````

## `- 1.4` Editer
````
server {
    listen 443 ssl;
    http2 on;
    server_name kuma.sednal.lan;

    ssl_certificate     /etc/nginx/tls/infra.crt;
    ssl_certificate_key /etc/nginx/tls/infra.key;

    location / {
        proxy_pass http://192.168.0.237:3001;

        proxy_http_version 1.1;
        proxy_set_header Upgrade    $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }
}
````

## `- 1.5` Redemarrer nginx
```bash
nginx -t && systemctl reload nginx
```

## `- 1.6` Vérification

```bash
curl -I https://kuma.sednal.lan
```

Résultat attendu : `HTTP/2 200`, et l'interface ne doit pas rester
bloquée sur « Connecting… » (signe que les en-têtes websocket ne
passent pas).
