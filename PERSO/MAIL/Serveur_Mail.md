# 🐋 Création d'un serveur mail via `Docker MailServer` 🐋

---

Ici utilisation de `Docker MailServer`, pour créer un serveur de messagerie, sur un `VPS`.

Ce serveur sera accessible depuis la WAN, via l'interface proposé par `SOGo`.

Pour ce faire voici la liste des étapes à réaliser pour arriver à un serveur opérationnel et sécurisé :

## `-1-` Enregistrements DNS su OVH

## `-2-` Créations des Certificats pour `Docker MailServer` et `SOGo` 

## `-3-` Création des Docker Compose pour les container `DMS` , `SOGo` et `PostGreSQL` 
 
``

``

``

### `[RAPPEL]`

Il est bon de lire cette partie de la documentation afin de bien comprendre le fonctionnement de la messagerie.
[INTRO](https://docker-mailserver.github.io/docker-mailserver/latest/introduction/)


- 
---

### VPS

- `IP` : 176.31.163.227
- `Nom domaine` : nalsed.fr
- `Ram` : 8 Go
- `CPU` : 4 vCore
- `Disk` : 275 Go
- `OS` : Debian 13

---
---

[DOCUMENTATION_OFFICIELLE](https://docker-mailserver.github.io/docker-mailserver/latest/examples/tutorials/basic-installation/)

[Eric O Meehan](https://www.youtube.com/watch?v=NhoSOPGk3q0)

### `[NOTE]` 

# `-1-` Créer un enregistrement `MX` et `A` pour la section mail, sur le VPS.

## `- 1.1` Sur [OVH](https://manager.eu.ovhcloud.com/#/hub/) Web Cloud => Noms de domaine => nalsed.fr

<img width="1066" height="286" alt="image" src="https://github.com/user-attachments/assets/807d0392-3e26-4913-9933-7cded26ba222" />

## `- 1.2` Dans la section nom de domaine => `Zone Dns` => Ajouter une entrée => MX

<img width="597" height="715" alt="image" src="https://github.com/user-attachments/assets/1a27d56f-316e-42e2-96a4-7e9b54e1ac90" />

`- 1.3` Remplir les champs

Ici : `nalsed.fr. IN MX 1 mail.nalsed.fr.`

`- 1.4` Idem pour l'entrée `A` de `DMS` et `SOGo` 
Ici 

- DMS : `mail.nalsed.fr. IN A 176.31.163.227`

- SOGo  : `webmail.nalsed.fr. IN A 176.31.163.227`

`[TEST]`

<img width="543" height="114" alt="image" src="https://github.com/user-attachments/assets/5704b5f1-9c58-4d29-baf5-e60a9495e38f" />

---

# `-2-` Certificat `Let's Encrypt`

 `- 2.1` Création des clées API sur OVH

[Lien](https://auth.eu.ovhcloud.com/api/createToken)


<img width="522" height="508" alt="image" src="https://github.com/user-attachments/assets/c1f3eba1-c945-4b3c-83f6-4a7d102c58a0" />

`[NOTE]`

- Utilisation des 4 lignes car certbot lit la zone(GET) , crée le TXT_acme_challenge(POST), applique les modifs(PUT), et supprime(DELETE).

- Le champs doit être restrain car avec un token de type `/domain/zone/*`, le token donne accés à tous (facturation, VPS, DNS, etc...),le tout depuis un fichier en clair sur une machine exposée sur Internet.

### `- 2.2` Sur le `VPS` => `176.31.163.227`

Génération des certificats pour `Docker MailServer` et `SOGo`

````
# Installer le plugin
sudo apt install python3-certbot-dns-ovh
````

`- 2.3` Création du fichiers `Certificats` et édition fichier `Clées API`.
````
sudo mkdir -p /etc/letsencrypt

sudo vim /etc/letsencrypt/ovh.ini
# Editer
dns_ovh_endpoint = ovh-eu
dns_ovh_application_key = xxxxxxxx
dns_ovh_application_secret = xxxxxxxx
dns_ovh_consumer_key = xxxxxxxx
````

Droits
````
sudo chmod 600 /etc/letsencrypt/ovh.ini
sudo chown root:root /etc/letsencrypt/ovh.ini
````

`- 2.4` Génération Certificat 

`[NOTE]`

Un certificat unique couvrant les deux noms poserait trois problèmes :

- Le --deploy-hook redémarre le conteneur à chaque renouvellement. D'où deux certificats distincts : ainsi le renouvellement de SOGo ne coupe pas DMS.

- `SOGo` ne retrouverai pas son Certificat : il cherche un répertoire nommé `webmail.nalsed.fr`, qui n'existe pas dans ce schéma.

- Renouvellement solidaire : si une validation DNS échoue pour un des deux nom (SOGo et DMS), le certificat n'est pas renouvelé.

- `DNS-01` car `HTTP-01` demande le port 80 utilisé par `SOGo`, il faudrait l'arrêter temporairement.

- `DMS`
````
sudo certbot certonly \
  --dns-ovh \
  --dns-ovh-credentials /etc/letsencrypt/ovh.ini \
  -d mail.nalsed.fr \
  --deploy-hook "docker restart mailserver"
````

- `SOGo` (via `Caddy`)
````
sudo certbot certonly \
  --dns-ovh \
  --dns-ovh-credentials /etc/letsencrypt/ovh.ini \
  -d webmail.nalsed.fr \
  --deploy-hook "docker restart caddy"
````


---

# `-3-` Création des Docker compose 

`- 3.1` Créer dossiers pour `DMS`, `SOGo` et `Caddy`
````
# Contener DMS
mkdir -p ~/DMS/Mail_Server
cd ~/DMS/Mail_Server
vim compose.yaml

# Contener SOGO
mkdir -p ~/DMS/SOGo/
cd ~/DMS/SOGo/
vim compose.yaml

# Contener Caddy
mkdir -p ~/DMS/Caddy/
cd ~/DMS/Caddy/
vim compose.yaml
````

`- 3.2` DMS
```` 
services: 
  mailserver: 
    image: ghcr.io/docker-mailserver/docker-mailserver:latest
    container_name: mailserver 
    # le nom FQDN doit corespondre à l'enregistrement MX du VPS
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
# Les Variable suivante sont à 0 car par défaut à 1
      - ENABLE_SPAMASSASSIN=0
      - ENABLE_OPENDKIM=0
      - ENABLE_OPENDMARC=0
      - ENABLE_POLICYD_SPF=0
      - RSPAMD_CHECK_AUTHENTICATED=0
      - ENABLE_IMAP=1
      - SPOOF_PROTECTION=1 
    cap_add: 
      - NET_ADMIN 
    restart: always
    healthcheck:
      test: "ss --listening --tcp | grep -P 'LISTEN.+:smtp' || exit 1"
      timeout: 3s
      retries: 0
      start_period: 90s
````

`- 3.3`  SOGo

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
      - MAIL_IMAP_SERVER=imaps://mail.nalsed.fr:993
      - MAIL_SMTP_SERVER=smtp://mail.nalsed.fr:587
      - MAIL_SIEVE_SERVER=sieve://mail.nalsed.fr:4190
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

`- 3.4` Création du fichier .env pour Password `PostGreSQL`
````
cd ~/DMS/SOGo/
vim .env
# Editer :
POSTGRES_PASSWORD=<PASSWORD_DB>

# Droits
chmod 600 .env
````

`- 3.5` 
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

`- 3.6` Caddyfile
````
vim ~/DMS/Caddy/Caddyfile

# Editer
webmail.nalsed.fr {
    tls /etc/letsencrypt/live/webmail.nalsed.fr/fullchain.pem /etc/letsencrypt/live/webmail.nalsed.fr/privkey.pem
    reverse_proxy sogo:80
}
````


---

# `-4-` Gestions de la `Sécurité` des container et Services.

`- 4.1` Enregistrement `PTR` sur OVH

-1- Bare Metal Cloud => Network => IP

<img width="363" height="466" alt="image" src="https://github.com/user-attachments/assets/c08b802e-77a5-4ab5-9fdc-d784aa0f8216" />

-2- Se rendre dans Configurer reverse DNS

<img width="1513" height="435" alt="image" src="https://github.com/user-attachments/assets/6f567437-01a2-4017-bf55-09699badd22d" />

-3- Changer le nom `Reverse DNS` par `mail.nalsed.fr`

`[TEST]`

<img width="741" height="39" alt="image" src="https://github.com/user-attachments/assets/69040e67-3679-40f3-81cc-0850b7b1172e" />







`` Ouverture des ports sur le VPS en `SSH`
````
ports="80 443 25 465 587 993"
for i in $ports; do
    sudo iptables -A INPUT -p tcp --dport "$i" -j ACCEPT
done
````































