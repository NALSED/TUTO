# Reverse Proxy

---

Dans cette section, sera abordé le montage du reverse proxy TLS sur `192.168.0.239`.
Le certificat est déjà livré par l'agent (`-4-`), il ne reste que la configuration `nginx`.

---

## **SOMMAIRE**

### `-1-` **DNS**

### `-2-` Configuration `nginx`

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

`[NOTE]`

nginx 1.22.1 sur `192.168.0.239` : la directive `http2 on;` n'existe qu'à partir de la 1.25.1.
HTTP/2 s'active donc via `listen 443 ssl http2;`.

- Création du fichier de configuration
````
sudo vim /etc/nginx/snippets/ssl-nalsed.conf
````

- Édition
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

- Édition
````
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}
````

---

Suite de la configuration des `Vhost` => [ICI](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/HOMELAB/-6-Vhost.md)
