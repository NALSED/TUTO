# 🐋 Création d'un serveur mail avec `Docker MailServer` 🐋

---

Ici utilisation de `Docker MailServer`, pour créer un serveur de messagerie, sur un `VPS`.

Ce serveur sera accessible depuis la WAN, via l'interface proposé par `SOGo`.

Pour ce faire voici la liste des étapes à réaliser pour arriver à un serveur opérationnel et sécurisé :

## `-1-` Enregistrements DNS sur OVH. [Accés Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/MAIL/Serveur_Mail.md#-1--cr%C3%A9er-un-enregistrement-mx-et-a-pour-la-section-mail-sur-le-vps)

## `-2-` Créations des Certificats pour `Docker MailServer` et `SOGo` via `Caddy`. [Accés Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/MAIL/Serveur_Mail.md#-2--certificat-lets-encrypt)

## `-3-` Création des Docker Compose `DMS` , `SOGo`, `PostGreSQL` et `Caddy`. [Accés Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/MAIL/Serveur_Mail.md#-3--cr%C3%A9ation-des-docker-compose) 
 
## `-4-` Sécurité des container. [Accés Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/MAIL/Serveur_Mail.md#-4--gestions-de-la-s%C3%A9curit%C3%A9-des-container-et-services)

## `-5-` Administration Container. [Accés Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/MAIL/Serveur_Mail.md#-5--administration-container)



### `[RAPPEL]`

Il est bon de lire cette partie de la documentation afin de bien comprendre le fonctionnement de la messagerie.
[INTRO](https://docker-mailserver.github.io/docker-mailserver/latest/introduction/)


--- 
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
---

# `-2-` Certificat `Let's Encrypt`

 `- 2.1` Création des clées API sur OVH

[Lien](https://auth.eu.ovhcloud.com/api/createToken)


<img width="529" height="435" alt="image" src="https://github.com/user-attachments/assets/910e1743-2765-42d1-800e-17873c1d3b33" />


`[NOTE]`

- Utilisation des 4 lignes car certbot lit la zone(GET) , crée le TXT_acme_challenge(POST), applique les modifs(PUT), et supprime(DELETE).


### `- 2.2` Sur le `VPS` => `176.31.163.227`

Génération des certificats pour `Docker MailServer` et `SOGo`

````
# Installer le plugin
sudo apt install certbot python3-pip
sudo pip install --break-system-packages certbot-dns-ovh
certbot plugins --text | grep -i ovh
````

`- 2.3` Création du fichier `Clées API`.
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

---

### `Certificats`

- `DMS`
````
sudo certbot certonly \
  --dns-ovh \
  --dns-ovh-credentials /etc/letsencrypt/ovh.ini \
  -d mail.nalsed.fr \
  --deploy-hook "/usr/bin/docker restart mailserver"
````

- `SOGo` (via `Caddy`)
````
sudo certbot certonly \
  --dns-ovh \
  --dns-ovh-credentials /etc/letsencrypt/ovh.ini \
  -d webmail.nalsed.fr \
  --deploy-hook "/usr/bin/docker restart caddy"
````

`- 2.5` Timer certbot et certbot renew dry

- Vérif que le service tourne
````
systemctl list-timers certbot.timer
sudo systemctl enable --now certbot.timer
````

- Test renouvellement dry des certificats
````
sudo certbot renew --dry-run
````

- Sortie attendu

<img width="734" height="402" alt="image" src="https://github.com/user-attachments/assets/54b4fd73-32fb-4d7a-9339-6c7fb955c718" />


---
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

---

### `Docker Compose`

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

`- 3.5` Caddy
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
---

# `-4-` Gestions de la `Sécurité` des container et Services.

`[NOTE]` 

### - Cette partie est un peux longue, voici le récapitulatif :

### `- 4.1` Enregistrement `PTR` sur OVH

### `- 4.2` Parfeu et Ouverture des ports sur le VPS en `SSH`

### `- 4.3` Sécuriser `SSH` et port `22`

### `- 4.4` SPF, DKIM et DMARC

---

`- 4.1` Enregistrement `PTR` sur OVH

- Bare Metal Cloud => Network => IP

<img width="363" height="466" alt="image" src="https://github.com/user-attachments/assets/c08b802e-77a5-4ab5-9fdc-d784aa0f8216" />

- Se rendre dans Configurer reverse DNS

<img width="1513" height="435" alt="image" src="https://github.com/user-attachments/assets/6f567437-01a2-4017-bf55-09699badd22d" />

- Changer le nom `Reverse DNS` par `mail.nalsed.fr`

`[TEST]`

<img width="741" height="39" alt="image" src="https://github.com/user-attachments/assets/69040e67-3679-40f3-81cc-0850b7b1172e" />


---

`- 4.2` Parfeu et Ouverture des ports sur le VPS en `SSH`

- `Parfeu`
````
sudo iptables -I INPUT 1 -i lo -j ACCEPT
sudo iptables -I INPUT 2 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I INPUT 3 -p tcp --dport 22 -j ACCEPT
````


- `Ports`
````
ports="80 443 25 465 587 993"
for i in $ports; do
    sudo iptables -A INPUT -p tcp --dport "$i" -j ACCEPT
done
````

`[TEST]`
````
sudo iptables -L INPUT --line-numbers -n
````


- Bascule et rendre persistant
````
sudo iptables -P INPUT DROP
sudo netfilter-persistent save
````

---

`- 4.3` Sécuriser `SSH` et port `22`

`[INFO]`

- Pour se rendre compte de l'utilité de sécuriser `SSH` :

<img width="871" height="41" alt="image" src="https://github.com/user-attachments/assets/b8502fef-06cd-4fc4-a69e-82546f50ac13" />


- Créer un fichier de configuration prioritaire sur celui de OVH (50-cloud-init.conf)
⚠️ L'authentification par mot de pass ne sera plus possible après, pensé à gérer un mode d'authentification, ici clé ssh.
````
sudo vim /etc/ssh/sshd_config.d/00-HardeningSSH.conf

# Editer
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
````


- vérif
````
sudo sshd -t
sudo systemctl restart ssh
````

---
---

`- 4.4` SPF, DKIM et DMARC

`[INFO]`

- Ces protocoles ont pour but d'assurer que la personne qui envoie le mail y est autorisée, et que le message envoyé n'est pas corrompu.
En effet, à sa création en 1982, SMTP n'a aucune notion d'authentification de l'expéditeur.
SPF valide l'enveloppe (`MAIL FROM`), DKIM signe le message et couvre l'en-tête `From:`. DMARC vérifie que le domaine validé correspond bien à celui affiché au destinataire.

- Pour ce faire, mise en place de :

### - `SPF`
- Sender Policy Framework : publie dans le DNS (ici OVH) la liste des IP autorisées à émettre pour le domaine (nalsed.fr).
- Enregistrement `TXT` listant les émetteurs autorisés. Le mécanisme `mx` autorise les IP des serveurs déclarés en MX du domaine.

### - `DKIM` 
(Sera implémenté plus tard en -5-)
- DomainKeys Identified Mail : le serveur signe chaque message sortant avec une clé privée, et publie la clé publique dans le DNS.
- La signature couvre le corps du message et une sélection d'en-têtes, dont `From:`. Elle survit aux transferts, contrairement à SPF.

### - `DMARC`
- Domain-based Message Authentication, Reporting and Conformance : c'est la politique qui relie le tout. SPF et DKIM produisent chacun un verdict mais ne disent pas quoi en faire.
- Un message passe DMARC si au moins un des deux est à la fois valide et **aligné** avec le domaine du `From:`.

---

### SPF

- Enregistrement `SPF` sur DNS OVH => Web Cloud => Noms de domaine => nalsed.fr => Zone Dns

Ici : `nalsed.fr. IN TXT "v=spf1 mx ~all"` , avec Autorisation serveurs `MX`

### DMARC

- Enregistrement `DMARC` sur DNS OVH => Web Cloud => Noms de domaine => nalsed.fr => Zone Dns

Ici : `_dmarc.nalsed.fr. IN DMARC v=DMARC1; p=none; rua=mailto:dmarcnalsed@proton.me; sp=none; aspf=r`

`[TEST]`

<img width="637" height="42" alt="image" src="https://github.com/user-attachments/assets/33206721-9cfd-4da7-ac7d-6868359bbfd9" />


---
---

# `-5-` Administration Container.

⚠️ Prérequis propre à mon infra ⚠️
````
# Stopper nginx 
sudo systemctl disable --now nginx

# Désactiver exim4
sudo systemctl disable --now exim4
````


`- 5.1` Lancement Container

- Ordre important
1 `DMS` => 2 `SOGo` => 3 `Caddy`
````
cd ~/DMS/Mail_Server/
docker compose up -d

cd ~/DMS/SOGo/
docker compose up -d

cd ~/DMS/Caddy/
docker compose up -d
````
  
`[TEST]`

- LOGS
````
docker ps
docker logs mailserver --tail 50
docker logs sogo --tail 50
docker logs caddy --tail 50
````

- VARIABLES
````
docker exec mailserver ps aux | grep -E 'opendkim|opendmarc|policyd'
````


`- 5.2` Création des comptes mail

- Boite principale
````
docker exec -ti mailserver setup email add martin@nalsed.fr
````

- Alias
````
docker exec -ti mailserver setup alias add contact@nalsed.fr martin@nalsed.fr
docker exec -ti mailserver setup alias add postmaster@nalsed.fr martin@nalsed.fr
docker exec -ti mailserver setup alias add abuse@nalsed.fr martin@nalsed.fr
````

`[NOTE]`

`postmaster` et `abuse` ne sont pas cosmétique plusieurs blocklist vérifient qu'ils répondent, et c'est là qu'arrivent les notification d'incidents.


`- 5.3` DKIM

- Générer la clé
````
docker exec -ti mailserver setup config dkim
````

- Vérifier l'implémentation
````
docker exec mailserver ls /tmp/docker-mailserver/rspamd/dkim/
# La clé doit être visible, si ce n'est pas le cas les les variables du point 4 ne sont pas appliquées, une correction est nécessaire.
````

- Récupérer la valeur pub
````
docker exec mailserver cat /tmp/docker-mailserver/rspamd/dkim/mail.public.dns.txt
# La sortie contient l'enregistrement complet. Ne récupèrer que la partie entre guillemets.
````

`[TEST]`

dig +short @1.1.1.1 mail._domainkey.nalsed.fr TXT

Test de bout en bout : envoie un mail depuis la boîte vers check-auth@verifier.port25.com. Le rapport automatique dira si SPF, DKIM et DMARC passent tous les trois. C'est le contrôle qui valide réellement les points 4.5 et 5.3.



`- 5.4` Test des deploy-hook
````
sudo certbot renew --force-renewal --cert-name webmail.nalsed.fr

docker ps --filter name=caddy
# Le STATUS doit montrer un démarrage récent.
````


