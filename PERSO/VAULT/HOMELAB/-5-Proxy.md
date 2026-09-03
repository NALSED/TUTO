# Reverse Proxy

---

Dans cette section, sera abordé le montage du reverse proxy TLS sur `192.168.0.239`.
Le certificat est déjà livré par l'agent (`-4-`), il ne reste que la configuration `nginx`.

---

## **SOMMAIRE**

### `-1-` **DNS**

### `-2-` Configuration `nginx`

### `-3-` Vérification

---

`[RAPPEL]`

Un seul certificat multi-SAN sur le proxy plutôt qu'un certificat par service.
Le trafic proxy → backend reste **en clair** sur le LAN : limitation assumée.

---
---

## `-1-` DNS

`[NOTE]`

Tous les noms du certificat doivent pointer sur `192.168.0.239` dans pfSense,
et non plus sur les machines d'origine : c'est le proxy qui répond.

| Nom | Cible |
|:--|:--|
| `infra.sednal.lan` | 192.168.0.239 |
| `pihole.sednal.lan` | 192.168.0.239 |
| `bareos.sednal.lan` | 192.168.0.239 |
| `cockpit.sednal.lan` | 192.168.0.239 |
| `proxmox.sednal.lan` | 192.168.0.239 |

- Contrôle
````
getent hosts pihole.sednal.lan proxmox.sednal.lan
````

---
---

## `-2-` Configuration `nginx`

### `- 2.1` Snippet TLS

`[NOTE]`

Un `snippet` est un fragment de configuration nginx isolé dans un fichier, inséré dans un
vhost avec `include`. Il évite de recopier les mêmes directives dans chaque site : le bloc
TLS est écrit une fois dans `/etc/nginx/snippets/ssl-nalsed.conf`, puis appelé par tous les vhosts.
Un changement de paramètre se fait alors à un seul endroit.

- Création du fichier de configuration
````
sudo vim /etc/nginx/snippets/ssl-nalsed.conf
````

- Edition
````
ssl_certificate     /etc/ssl/nalsed/infra.crt;
ssl_certificate_key /etc/ssl/nalsed/infra.key;

ssl_protocols       TLSv1.2 TLSv1.3;
ssl_session_cache   shared:SSL:10m;
ssl_session_timeout 10m;
ssl_session_tickets off;

add_header X-Content-Type-Options nosniff;
add_header X-Frame-Options SAMEORIGIN;
````

---

### `- 2.2` Support des websockets

[DOC_OFFICIELLE](https://nginx.org/en/docs/http/websocket.html)

`[NOTE]`

Indispensable pour la console noVNC de Proxmox et le terminal de Cockpit.

- Création fichier
````
sudo vim /etc/nginx/conf.d/websocket.conf
````

- Edition
````
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}
````

---

### `- 2.3` Vhost simple — exemple `pihole`

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

    location / {
        proxy_pass http://192.168.0.241/admin/;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
````

---

### `- 2.4` Vhost websocket — exemple `proxmox`

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

`[NOTE]`
Pour Cockpit, ajouter en plus sur `192.168.0.241` dans `/etc/cockpit/cockpit.conf` :

- Fichier
````
sudo vim /etc/cockpit/cockpit.conf
````

- Editer dans la configuration de Cockpit
````
[WebService]
Origins = https://cockpit.sednal.lan https://192.168.0.241:9090
ProtocolHeader = X-Forwarded-Proto
````

- Redemarrer Service
````
sudo systemctl restart cockpit.socket
````

---

### `- 2.5` Activation nginx
````
cd /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/pihole.conf  pihole.conf
sudo ln -s /etc/nginx/sites-available/proxmox.conf proxmox.conf

sudo nginx -t
sudo systemctl enable --now nginx
sudo systemctl reload nginx
````

---
---

## `-3-` Vérification

### `- 3.1` Chaîne servie
````
openssl s_client -connect pihole.sednal.lan:443 -servername pihole.sednal.lan \
  -CAfile /etc/ssl/nalsed/ca.crt </dev/null 2>/dev/null | grep "Verify return code"
````

---

### `- 3.2` Chaîne complète
````
openssl s_client -connect pihole.sednal.lan:443 -showcerts </dev/null 2>/dev/null \
| grep -c "BEGIN CERTIFICATE"
````

`[NOTE]`

Doit valoir au moins `2` : certificat + intermédiaire. Si le compte est de 1,
le template ne concatène pas `.Data.issuing_ca`.

---

### `- 3.3` Depuis un poste client

`[NOTE]`

Cadenas valide **après** import de la Root
(cf. `CERTIFICAT_SSL/Déploiement_win11.md`).

````
https://pihole.sednal.lan
https://proxmox.sednal.lan
````

---
---
