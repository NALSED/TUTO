# Création et implémentation des Vhost.


##  Vhost par défaut

`[NOTE]`

Sans vhost par défaut, nginx sert le **premier vhost déclaré** pour tout nom inconnu :
`https://192.168.0.239` ouvrait alors l'interface Pihole. Le code `444` ferme la connexion
sans réponse.

`[NOTE]`

Un seul `default_server` par port est autorisé : ne pas ajouter ce mot-clé dans un autre vhost.

- Création
````
sudo vim /etc/nginx/sites-available/default-ssl.conf
````

- Edition
````
server {
    listen 443 ssl default_server;
    server_name _;

    include snippets/ssl-nalsed.conf;

    return 444;
}
````


##  Portail Infra `192.168.0.239`

`[NOTE]`

Le portail HTML des services est servi directement par nginx depuis `/var/www/html`
sur `192.168.0.239` : pas de `proxy_pass`, la machine héberge les fichiers.

- Création
````
sudo vim /etc/nginx/sites-available/infra.conf
````

- Edition
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

---


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

---

## Proxmox `192.168.0.242`

`[NOTE]`

Proxmox parle **HTTPS** sur 8006 avec son propre certificat auto-signé :
`proxy_ssl_verify off` est nécessaire tant qu'il n'est pas remplacé.

- Création fichier
````
sudo vim /etc/nginx/sites-available/proxmox.conf
````

- Edition fichier
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


---

### `- 2.7` Activation

`[NOTE]`

Le `default` de Debian est désactivé : il capte le port 80 en `default_server`
et n'a plus d'utilité, le portail étant servi par `infra.conf`.

- Désactivation du vhost Debian
````
sudo rm /etc/nginx/sites-enabled/default
````

- Liens symboliques
````
cd /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/default-ssl.conf default-ssl.conf
sudo ln -s /etc/nginx/sites-available/infra.conf        infra.conf
sudo ln -s /etc/nginx/sites-available/pihole.conf       pihole.conf
sudo ln -s /etc/nginx/sites-available/proxmox.conf      proxmox.conf
````

- Contrôle et rechargement
````
sudo nginx -t
sudo systemctl enable --now nginx
sudo systemctl reload nginx
````

---

### `- 2.8` Vérification

`[NOTE]`

L'accès par IP doit échouer sans réponse — `curl: (52) Empty reply from server`
ou `curl: (92) HTTP/2 stream 1 was not closed cleanly` selon le protocole négocié.
C'est le comportement attendu du code `444`.

- Portail
````
curl -Ik https://infra.sednal.lan
````

- Attendu
````
HTTP/2 200
````

- Service derrière le proxy
````
curl -kL -o /dev/null -w '%{num_redirects} redirections, code final %{http_code}\n' \
  https://pihole.sednal.lan/admin/
````

- Attendu
````
1 redirections, code final 200
````

- Proxmox

`[NOTE]`

`curl -I` renvoie un `501` sur Proxmox : son serveur n'implémente pas la méthode `HEAD`.
Ce n'est pas une erreur de configuration, il faut tester en GET.

````
curl -k -o /dev/null -w '%{http_code}\n' https://proxmox.sednal.lan
````

- Accès par IP
````
curl -Ik https://192.168.0.239
````

`[RAPPEL]`

Le test décisif pour Proxmox est l'ouverture d'une console noVNC ou du shell d'un nœud
depuis un navigateur : c'est ce qui valide le passage des websockets.

---
---

##  Cockpit `192.168.0.241`

`[NOTE]`

⚠️ SECTION À DÉROULER — non testée à ce jour. `cockpit.sednal.lan` figure dans les SAN du
certificat mais n'a pas encore de vhost : l'accès tombe sur le `default_server` et renvoie
un `444`.

---

### `- 3.1` Vhost sur `192.168.0.239`

- Création
````
sudo vim /etc/nginx/sites-available/cockpit.conf
````

- Edition
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

### `- 3.2` Configuration sur `192.168.0.241`

`[NOTE]`

Sans `Origins`, Cockpit refuse les requêtes venant du proxy : page blanche ou erreur de
websocket à la connexion. Le fichier n'existe pas par défaut, il est à créer.

- Création
````
sudo mkdir -p /etc/cockpit
sudo vim /etc/cockpit/cockpit.conf
````

- Edition
````
[WebService]
Origins = https://cockpit.sednal.lan https://192.168.0.241:9090
ProtocolHeader = X-Forwarded-Proto
````

- Redémarrage
````
sudo systemctl restart cockpit.socket
````

---

### `- 3.3` Vérification
````
curl -k -o /dev/null -w '%{http_code}\n' https://cockpit.sednal.lan
````

`[RAPPEL]`

Le test décisif est l'ouverture du terminal dans l'interface : c'est ce qui valide le passage
des websockets.

---
---

## Bareos WebUI `192.168.0.240`

`[NOTE]`

⚠️ SECTION À DÉROULER — non testée à ce jour. `192.168.0.240` n'est allumée que quelques
heures par semaine, et Bareos est en cours de réparation. Ce vhost ne concerne que la WebUI :
les démons `bareos-dir`, `bareos-sd` et `bareos-fd` ne passent pas par le proxy et restent
hors périmètre V2.

---

### `- 4.1` Vhost sur `192.168.0.239`

- Création
````
sudo vim /etc/nginx/sites-available/bareos.conf
````

- Edition
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

---

### `- 4.2` Vérification

`[NOTE]`

La machine `192.168.0.240` doit être allumée et la WebUI fonctionnelle en HTTP local
avant de tester le proxy.

````
curl -kL -o /dev/null -w '%{num_redirects} redirections, code final %{http_code}\n' \
  https://bareos.sednal.lan
````

---
---
