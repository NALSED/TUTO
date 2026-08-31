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

# `-1-` Créer un enregistrement `MX`, sur le VPS.


## `- 1.1` Sur [OVH](https://manager.eu.ovhcloud.com/#/hub/) Web Cloud => Noms de domaine => nalsed.fr

<img width="1066" height="286" alt="image" src="https://github.com/user-attachments/assets/807d0392-3e26-4913-9933-7cded26ba222" />

## `- 1.2` Dans la section nom de domaine => `Zone Dns` => Ajouter une entrée => MX

<img width="597" height="715" alt="image" src="https://github.com/user-attachments/assets/1a27d56f-316e-42e2-96a4-7e9b54e1ac90" />

`-1.3` Remplir les champs

Ici : `nalsed.fr. IN MX 1 nalsed.fr.`

---

# `-3-` Création des Docker compose 

`- 3.1` Créer dossiers pour `DMS` et `SOGo`
````
# Contener DMS
mkdir -p ~/DMS/Mail_Server
vim compose.yaml

# Contener SOGO
mkdir -p ~/DMS/SOGo/
vim compose.yaml
````

`- 3.2` DMS
```` 
services: 
  mailserver: 
    image: ghcr.io/docker-mailserver/docker-mailserver:latest
    container_name: mailserver 
    # le nom FQDN doit corespondre à l'enregistrement MX du VPS
    hostname: nalsed.fr  
    ports:
      - "25:25"
      - "465:465"
      - "587:587"
      - "993:993"
    volumes: 
      - ./docker-data/dms/mail-data/:/var/mail/ 
      - ./docker-data/dms/mail-state/:/var/mail-state/ 
      - ./docker-data/dms/mail-logs/:/var/log/mail/ 
      - ./docker-data/dms/config/:/tmp/docker-mailserver/ 
      - ./docker-data/nginx-proxy/certs/:/etc/letsencrypt/ 
      - /etc/localtime:/etc/localtime:ro 
    environment: 
      - ENABLE_FAIL2BAN=1 
      - SSL_TYPE=letsencrypt 
      - PERMIT_DOCKER=network 
      - ONE_DIR=1 
      - ENABLE_POSTGREY=1 
      - ENABLE_CLAMAV=1 
      - ENABLE_RSPAMD=1
      - ENABLE_SPAMASSASSIN=1 
      - ENABLE_IMAP=1
      - SPOOF_PROTECTION=1 
    cap_add: 
      - NET_ADMIN 
    restart: always
````

`- 3.2 SOGo`
````

````

### `env` [ICI](https://github.com/docker-mailserver/docker-mailserver/blob/master/mailserver.env)



























'- 2.1' 
