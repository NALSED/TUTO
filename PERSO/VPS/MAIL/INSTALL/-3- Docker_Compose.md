# `-3-` Création des Docker compose

`- 3.1` Créer les dossiers pour `DMS`, `SOGo` et `Caddy`
````
# Conteneur DMS
mkdir -p ~/DMS/Mail_Server
cd ~/DMS/Mail_Server
vim compose.yaml

# Conteneur SOGo
mkdir -p ~/DMS/SOGo/
cd ~/DMS/SOGo/
vim compose.yaml

# Conteneur Caddy
mkdir -p ~/DMS/Caddy/
cd ~/DMS/Caddy/
vim compose.yaml
````

---

### `Docker Compose`

`- 3.2` DMS
````
services:
  mailserver:
    image: ghcr.io/docker-mailserver/docker-mailserver:latest
    container_name: mailserver
    # Le nom FQDN doit correspondre à l'enregistrement A et au PTR du VPS
    hostname: mail.nalsed.fr
    ports:
      - "25:25" # SMTP
      - "465:465" # ESMTP (implicit TLS)
      - "587:587" # ESMTP (explicit TLS => STARTTLS)
      - "993:993" # IMAP4 (implicit TLS)
    volumes:
      - ./docker-data/dms/mail-data/:/var/mail/
      - ./docker-data/dms/mail-state/:/var/mail-state/
      - ./docker-data/dms/mail-logs/:/var/log/mail/
      - ./docker-data/dms/config/:/tmp/docker-mailserver/
      - /etc/letsencrypt/:/etc/letsencrypt:ro
      - /etc/localtime:/etc/localtime:ro
    environment:
      - ENABLE_FAIL2BAN=1
      - SSL_TYPE=letsencrypt
      - ENABLE_CLAMAV=1
      - ENABLE_RSPAMD=1
# Les variables suivantes sont mises à 0 car Rspamd remplace OpenDKIM, OpenDMARC et policyd-spf
      - ENABLE_SPAMASSASSIN=0
      - ENABLE_OPENDKIM=0
      - ENABLE_OPENDMARC=0
      - ENABLE_POLICYD_SPF=0
      - RSPAMD_CHECK_AUTHENTICATED=0
      - ENABLE_IMAP=1
      - SPOOF_PROTECTION=1
      - PERMIT_DOCKER=connected-networks
    cap_add:
      - NET_ADMIN
    restart: always
    healthcheck:
      test: "ss --listening --tcp | grep -P 'LISTEN.+:smtp' || exit 1"
      timeout: 3s
      retries: 0
      start_period: 90s

networks:
  default:
    name: sogo-net
````

`[NOTE]` Sans cette variable, `mynetworks` reste vide et Postfix refuse de relayer depuis SOGo (`5.7.1 Relay access denied`).

⚠️ Le bloc `networks` est au **niveau racine** du fichier, pas dans le service. Il place DMS sur le même réseau que SOGo, ce qui permet à ce dernier de le joindre par son nom de conteneur (voir `- 3.3`).

`- 3.3` SOGo

[DOC](https://sarit-r.medium.com/set-secure-email-server-with-docker-mailserver-604616c35c37)

````
services:
  sogo:
    image: pmietlicki/sogo-from-sources
    container_name: sogo
    expose:
      - "80"
    volumes:
      - sogo-conf:/srv/etc
      - sogo-data:/srv/lib/sogo
    environment:
      - MAIL_DOMAIN=nalsed.fr
      - MAIL_IMAP_SERVER=imap://mailserver:143
      - MAIL_SIEVE_SERVER=sieve://mailserver:4190
      - SOGO_LANGUAGE=French
      - SOGO_TIMEZONE=Europe/Paris
      - SOGO_PAGE_TITLE=Webmail nalsed.fr
      - SOGO_LOGGING_LEVEL=normal
      - SOGO_DEBUG_REQUESTS=NO
      - SOGO_DEBUG_BASE_URL=NO
      - POSTGRESQL_HOST=db
      - POSTGRESQL_PORT=5432
      - POSTGRESQL_DATABASE=sogo
      - POSTGRESQL_USER=sogo
      # Le password est dans un .env
      - POSTGRESQL_PASSWORD=${POSTGRES_PASSWORD}
    depends_on:
      - db
    restart: always

  db:
    image: postgres:17
    container_name: sogo-postgres
    environment:
      # Le password est dans un .env
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=sogo
      - POSTGRES_USER=sogo
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: always

volumes:
  sogo-conf:
    driver: local
  sogo-data:
    driver: local
  postgres-data:
    driver: local

networks:
  default:
    name: sogo-net
````

⚠️ SOGo joint DMS via `mailserver:143` sur le réseau Docker interne, et **non** via `imaps://mail.nalsed.fr:993`. Passer par le nom public oblige le conteneur à sortir vers l'IP publique du VPS et à y revenir (hairpin NAT), ce que Docker ne route pas : la connexion IMAP reste bloquée plusieurs minutes avant d'échouer, et le webmail affiche une page blanche. Le port 143 en clair est sans risque ici, le trafic ne quitte jamais le réseau Docker.

`- 3.4` Création du fichier .env pour le mot de passe `PostGreSQL`
````
cd ~/DMS/SOGo/
vim .env
# Editer :
POSTGRES_PASSWORD=<PASSWORD_DB>

# Droits
chmod 600 .env
````

`- 3.5` Caddy

### - `=== Version 1 ===` => Sans le site de demande d'Alternance
````
services:
  caddy:
    image: caddy:2-alpine
    container_name: caddy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - /etc/letsencrypt/:/etc/letsencrypt:ro
      - caddy-data:/data
    restart: always
    networks:
      - sogo-net

volumes:
  caddy-data:

networks:
  sogo-net:
    external: true
````

-v1
`- 3.6` Caddyfile
````
vim ~/DMS/Caddy/Caddyfile

-v1
# Editer
webmail.nalsed.fr {
    tls /etc/letsencrypt/live/webmail.nalsed.fr/fullchain.pem /etc/letsencrypt/live/webmail.nalsed.fr/privkey.pem
    redir / /SOGo permanent
    reverse_proxy sogo:80
}
````
-v1
`[NOTE]` L'image SOGo embarque Apache, qui sert sa page d'accueil par défaut à la racine. Sans le `redir`, `https://webmail.nalsed.fr` affiche la page Apache au lieu du webmail. La redirection ne cible que la racine exacte, les autres chemins passent normalement au proxy.



### - `=== Version 2 ===` => Avec le site de demande d'Alternance
````
services:
  caddy:
    image: caddy:2-alpine
    container_name: caddy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - ./conf.d:/etc/caddy/conf.d:ro
      - /home/debian/www/site:/srv/site:ro
      - /etc/letsencrypt/:/etc/letsencrypt:ro
      - caddy-data:/data
      - caddy-config:/config
    restart: always
    networks:
      - sogo-net
volumes:
  caddy-data:
  caddy-config:
networks:
  sogo-net:
    external: true
````

- v2
- Création dossier et fichier pour le site + backup config
````
mkdir -p ~/DMS/Caddy/conf.d ~/www/site
cp ~/DMS/Caddy/Caddyfile ~/DMS/Caddy/Caddyfile.bak
````

-v2 Changement de l’arborescence fichier afin d'avoir deux configuration de `Caddy`.
````
~/DMS/Caddy/
├── Caddyfile          # ne contient plus que l'import
├── compose.yaml
└── conf.d/
    ├── webmail.caddy
    └── site.caddy
~/www/site/            # fichiers statiques, hors DMS
└── index.html
````

-v2
- Le `Caddyfile` ne contient plus que l'import
````
vim ~/DMS/Caddy/Caddyfile
-v2
# Remplacer tout le contenu par
import /etc/caddy/conf.d/*.caddy
````

-v2
- Editer bloc `Serveur Mail`
````
vim ~/DMS/Caddy/conf.d/webmail.caddy
````
````
# Editer
webmail.nalsed.fr {
    tls /etc/letsencrypt/live/webmail.nalsed.fr/fullchain.pem /etc/letsencrypt/live/webmail.nalsed.fr/privkey.pem
    redir / /SOGo permanent
    reverse_proxy sogo:80
}
````


-v2
- Editer bloc du site statique
````
vim ~/DMS/Caddy/conf.d/site.caddy
````
````
# Editer
site.nalsed.fr {
    root * /srv/site
    encode zstd gzip
    file_server
}
````

-v2


`[NOTE]` 

Absence de directive `tls` : c'est ce qui déclenche l'obtention automatique du certificat par Caddy (challenge HTTP-01 sur le port 80). Le webmail conserve ses certificats certbot, les deux modes cohabitent sans conflit.

Pour le deployment du site voir [ICI]()

---

`- 3.7` Forcer la sortie SMTP en IPv4

````
mkdir -p ~/DMS/Mail_Server/docker-data/dms/config/
vim ~/DMS/Mail_Server/docker-data/dms/config/postfix-main.cf

# Editer
inet_protocols = ipv4
smtp_address_preference = ipv4
````

`[NOTE]` Le VPS sort en IPv6 par défaut vers les destinations qui le supportent. Aucun `AAAA` n'étant publié pour `mail.nalsed.fr` et le PTR IPv6 restant générique, le FCrDNS échouerait côté IPv6 et Gmail rejetterait.


````
cd ~/DMS/Mail_Server/
sudo docker compose down
sudo docker compose up -d
````

`[TEST]`
````
sudo docker exec mailserver postconf inet_protocols smtp_address_preference
````
