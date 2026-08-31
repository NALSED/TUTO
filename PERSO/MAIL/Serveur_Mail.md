# 🐋 Création d'un serveur mail via `Docker MailServer` 🐋

---

Ici utilisation de `Docker MailServer`, pour créer un serveur de messagerie, sur un `VPS`.

Il est bon de lire cette partie de la documentation afin de bien comprendre le fonctionnement de la messagerie.
[INTRO](https://docker-mailserver.github.io/docker-mailserver/latest/introduction/)

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

---

# `-2-` Certificat `Let's Encrypt`

 `- 2.1` Création des clées API sur OVH

[Lien](https://auth.eu.ovhcloud.com/api/createToken)


<img width="531" height="501" alt="image" src="https://github.com/user-attachments/assets/c2e85a0b-477d-4050-a966-915c66e2901d" />


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
````

`- 2.4` Génération Certificats `DMS` et `SOGo`
````
sudo certbot certonly \
  --dns-ovh \
  --dns-ovh-credentials /etc/letsencrypt/ovh.ini \
  -d mail.nalsed.fr \
  -d webmail.nalsed.fr \
  --deploy-hook "docker restart mailserver sogo"
````

---

# `-3-` Création des Docker compose 

`- 3.1` Créer dossiers pour `DMS` et `SOGo`
````
# Contener DMS
mkdir -p ~/DMS/Mail_Server
cd ~/DMS/Mail_Server
vim compose.yaml

# Contener SOGO
mkdir -p ~/DMS/SOGo/
cd ~/DMS/SOGo/
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
      - "143:143" # IMAP4 (explicit TLS => STARTTLS)
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
      - ENABLE_SPAMASSASSIN=0 
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
    ports:
      - "80:80"       # HTTP
      - "443:443"     # HTTPS
      - "8800:8800"   # Port pour Apple devices
    volumes:
      - sogo-conf:/srv/etc
      - sogo-data:/srv/lib/sogo
      - /etc/letsencrypt/:/etc/letsencrypt:ro
    environment:
      - SOGoDomainAllowed=nalsed.fr
      - SOGoMailingMechanism=smtp
      - SOGoSMTPServer=smtp://mail.nalsed.fr:587?tls=YES
      - SOGoIMAPServer=imaps://mail.nalsed.fr:993
      - WOWorkersCount=4
      - SOGoLanguage=French
      - SOGoTimeZone=Europe/Paris
      - POSTGRESQL_HOST=db
      - POSTGRESQL_PORT=5432
      - POSTGRESQL_DATABASE=sogo
      - POSTGRESQL_USER=sogo
      # Le password est dans un .env 
      - POSTGRESQL_PASSWORD=${POSTGRES_PASSWORD}

    depends_on:
      - db

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

volumes:
  sogo-conf:
    driver: local
  sogo-data:
    driver: local
  postgres-data:
    driver: local
````

`- 3.4` Création du fichier .env pour Password `PostGreSQL`
````
cd ~/DMS/SOGo/
vim .env
# Editer :
POSTGRES_PASSWORD=PASSWORD_DB

# Droits
chmod 600 .env
````



### `env` => [DMS](https://github.com/docker-mailserver/docker-mailserver/blob/master/mailserver.env) et [SOGo]([https://www.sogo.nu/files/docs/SOGoInstallationGuide.html](https://www.sogo.nu/files/docs/SOGoInstallationGuide.html#_general_preferences))





