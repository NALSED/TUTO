# 🐋 Création d'un serveur mail avec `Docker MailServer` 🐋

---

Ici utilisation de `Docker MailServer`, pour créer un serveur de messagerie, sur un `VPS`.

Ce serveur sera accessible depuis le WAN, via l'interface proposée par `SOGo`.

Pour ce faire voici la liste des étapes à réaliser pour arriver à un serveur opérationnel et sécurisé :

## `-1-` Enregistrements DNS sur OVH. [Accès Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/Serveur_Mail.md#-1--cr%C3%A9er-un-enregistrement-mx-et-a-pour-la-section-mail-sur-le-vps)

## `-2-` Créations des Certificats pour `Docker MailServer` et `SOGo` via `Caddy`. [Accès Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/Serveur_Mail.md#-2--certificat-lets-encrypt)

## `-3-` Création des Docker Compose `DMS`, `SOGo`, `PostGreSQL` et `Caddy`. [Accès Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/Serveur_Mail.md#-3--cr%C3%A9ation-des-docker-compose)

## `-4-` Sécurité des conteneurs. [Accès Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/Serveur_Mail.md#-4--gestions-de-la-s%C3%A9curit%C3%A9-des-conteneurs-et-services)

## `-5-` Administration Conteneurs. [Accès Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/Serveur_Mail.md#-5--administration-conteneurs)



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

- SOGo : `webmail.nalsed.fr. IN A 176.31.163.227`

`[NOTE]`

- Aucun enregistrement `AAAA` n'est créé : le PTR IPv6 du VPS reste générique, donc le FCrDNS échouerait côté IPv6. La sortie est forcée en IPv4 au point `- 3.7`.

`[TEST]`

<img width="543" height="114" alt="image" src="https://github.com/user-attachments/assets/5704b5f1-9c58-4d29-baf5-e60a9495e38f" />

---
---

# `-2-` Certificat `Let's Encrypt`

`- 2.1` Création des clés API sur OVH

[Lien](https://auth.eu.ovhcloud.com/api/createToken)


<img width="529" height="435" alt="image" src="https://github.com/user-attachments/assets/910e1743-2765-42d1-800e-17873c1d3b33" />


`[NOTE]`

- Utilisation des 4 verbes car certbot lit la zone (GET), crée le TXT `_acme-challenge` (POST), applique les modifications (PUT), et supprime (DELETE).

⚠️ Le périmètre doit être `/domain/zone/*` et **non** `/domain/zone/nalsed.fr/*`. Le plugin appelle l'endpoint racine `/domain/zone/` pour énumérer les zones avant d'agir : avec un périmètre restreint au seul domaine, certbot échoue sur `403 Client Error: Forbidden for url: https://eu.api.ovh.com/1.0/domain/zone/`.

````
GET     /domain/zone/*
POST    /domain/zone/*
PUT     /domain/zone/*
DELETE  /domain/zone/*
````

- Mettre une date d'expiration (1 an) plutôt qu'illimité, et noter l'échéance : le renouvellement échouera silencieusement quand le token expirera.
- Les 3 valeurs (Application Key, Application Secret, Consumer Key) ne sont affichées qu'une seule fois. Les noter avant de fermer la page.


### `- 2.2` Sur le `VPS` => `176.31.163.227`

Génération des certificats pour `Docker MailServer` et `SOGo`

`[NOTE]` Le paquet `python3-certbot-dns-ovh` est absent des dépôts Debian 13 (bug Debian, il existe en Bookworm et en sid). Passage obligatoire par pip.

````
# Installer le plugin
sudo apt install certbot python3-pip
sudo pip install --break-system-packages certbot-dns-ovh
certbot plugins --text | grep -i ovh
````

`- 2.3` Création du fichier `Clés API`.
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

- Le `--deploy-hook` redémarre le conteneur à chaque renouvellement. D'où deux certificats distincts : ainsi le renouvellement de SOGo ne coupe pas DMS.
- `Caddy` ne retrouverait pas son certificat : il cherche un répertoire nommé `webmail.nalsed.fr`, qui n'existe pas dans ce schéma.
- Renouvellement solidaire : si la validation DNS échoue pour un des deux noms, le certificat n'est pas renouvelé.

Par ailleurs, `DNS-01` est utilisé car `HTTP-01` demande le port 80, occupé par `Caddy`, qu'il faudrait arrêter temporairement.

⚠️ Le premier mot du hook doit être un **chemin absolu** (ou un binaire du `$PATH`), sinon la validation certbot le rejette. Vérifier avec `which docker`.

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

`[NOTE]` À ce stade les conteneurs n'existent pas encore, le hook remonte donc `No such container`. C'est normal : il ne s'exécutera réellement qu'au premier renouvellement.

`- 2.5` Timer certbot et test de renouvellement

- Vérifier que le service tourne
````
systemctl list-timers certbot.timer
sudo systemctl enable --now certbot.timer
````

- Test de renouvellement à blanc
````
sudo certbot renew --dry-run
````

- Sortie attendue

<img width="734" height="402" alt="image" src="https://github.com/user-attachments/assets/54b4fd73-32fb-4d7a-9339-6c7fb955c718" />


---
---

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

⚠️ Sans `PERMIT_DOCKER=connected-networks`, `mynetworks` reste vide et Postfix refuse de relayer les mails envoyés depuis SOGo (`5.7.1 Relay access denied`). La surcharge manuelle via `postfix-main.cf` n'est pas appliquée sur DMS v16.

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
      - MAIL_SMTP_SERVER=smtp://mailserver:587
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

⚠️ Ne jamais committer ce fichier.

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

`[NOTE]` Le montage `/etc/letsencrypt/` complet est nécessaire : les fichiers de `live/` sont des liens symboliques vers `archive/`. Monter uniquement `live/` donnerait des liens cassés.

`- 3.6` Caddyfile
````
vim ~/DMS/Caddy/Caddyfile

# Editer
webmail.nalsed.fr {
    tls /etc/letsencrypt/live/webmail.nalsed.fr/fullchain.pem /etc/letsencrypt/live/webmail.nalsed.fr/privkey.pem
    redir / /SOGo permanent
    reverse_proxy sogo:80
}
````

`[NOTE]` L'image SOGo embarque Apache, qui sert sa page d'accueil par défaut à la racine. Sans le `redir`, `https://webmail.nalsed.fr` affiche la page Apache au lieu du webmail. La redirection ne cible que la racine exacte, les autres chemins passent normalement au proxy.

`- 3.7` Forcer la sortie SMTP en IPv4

⚠️ Non fonctionnel sur DMS v16. Le fichier est bien monté dans `/tmp/docker-mailserver/` mais ses directives ne sont pas appliquées. Mécanisme de surcharge à identifier (piste : `user-patches.sh`). En attendant, la sortie SMTP reste en IPv6 quand la destination le permet.

````
mkdir -p ~/DMS/Mail_Server/docker-data/dms/config/
vim ~/DMS/Mail_Server/docker-data/dms/config/postfix-main.cf

# Editer
inet_protocols = ipv4
smtp_address_preference = ipv4
````

`[NOTE]` Le VPS sort en IPv6 par défaut vers les destinations qui le supportent. Aucun `AAAA` n'étant publié pour `mail.nalsed.fr` et le PTR IPv6 restant générique, le FCrDNS échouerait côté IPv6 et Gmail rejetterait.

`[TEST]`
````
sudo docker exec mailserver postconf inet_protocols smtp_address_preference
````

---
---

# `-4-` Gestions de la `Sécurité` des conteneurs et Services.

`[NOTE]`

### - Cette partie est un peu longue, voici le récapitulatif :

### `- 4.1` Enregistrement `PTR` sur OVH

### `- 4.2` Pare-feu et ouverture des ports sur le VPS

### `- 4.3` Sécuriser `SSH` et port `22`

### `- 4.4` SPF, DKIM et DMARC

---

`- 4.1` Enregistrement `PTR` sur OVH

- Bare Metal Cloud => Network => IP

<img width="363" height="466" alt="image" src="https://github.com/user-attachments/assets/c08b802e-77a5-4ab5-9fdc-d784aa0f8216" />

- Se rendre dans Configurer reverse DNS

<img width="1513" height="435" alt="image" src="https://github.com/user-attachments/assets/6f567437-01a2-4017-bf55-09699badd22d" />

- Changer le nom `Reverse DNS` par `mail.nalsed.fr`

`[NOTE]` L'enregistrement `A` du point `- 1.4` doit être propagé avant : OVH refuse un reverse dont le forward ne résout pas.

`[TEST]`

<img width="741" height="39" alt="image" src="https://github.com/user-attachments/assets/69040e67-3679-40f3-81cc-0850b7b1172e" />

````
# Toujours interroger un résolveur public : le DNS local (pfSense) répond avant et masque le résultat réel
dig +short -x 176.31.163.227 @1.1.1.1
dig +short mail.nalsed.fr A @1.1.1.1
````

---

`- 4.2` Pare-feu et ouverture des ports sur le VPS

`[NOTE]` Debian 13 utilise `nftables`, mais la commande `iptables` passe par la couche de compatibilité `iptables-nft`. Ne pas mélanger les deux syntaxes sur la même machine : deux jeux de règles dans des tables différentes s'évaluent en parallèle et le `DROP` le plus restrictif l'emporte.

- Ports volontairement **non** ouverts :
  - `5432` : le service `db` n'a aucun mapping `ports:`, il n'écoute que sur le réseau Docker interne.
  - `143` : IMAP en clair, utilisé uniquement en interne entre SOGo et DMS.

- `Pare-feu`
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
# Vérifier que lo, ESTABLISHED,RELATED et 22 sont bien dans les trois premières lignes AVANT de basculer
````

- Bascule et persistance
````
sudo iptables -P INPUT DROP
sudo netfilter-persistent save
````

`[NOTE]` Le tunnel Bareos (`-L 9103:localhost:9103`) continue de fonctionner : le trafic arrive par le port 22 et ressort en loopback, couvert par la règle `-i lo`.

---

`- 4.3` Sécuriser `SSH` et port `22`

`[INFO]`

- Pour se rendre compte de l'utilité de sécuriser `SSH` :

<img width="871" height="41" alt="image" src="https://github.com/user-attachments/assets/b8502fef-06cd-4fc4-a69e-82546f50ac13" />

````
sudo journalctl -u ssh --since "24 hours ago" | grep -c "Failed password"
````

- Créer un fichier de configuration prioritaire sur celui d'OVH (`50-cloud-init.conf`, qui contient `PasswordAuthentication yes`).

`[NOTE]` Les fichiers de `sshd_config.d/` sont inclus en tête et la **première** valeur lue l'emporte. Le préfixe `00-` garantit la priorité, et le fichier survit à un rebuild du VPS contrairement à une édition de `50-cloud-init.conf`.

⚠️ L'authentification par mot de passe ne sera plus possible après, penser à gérer un mode d'authentification, ici clé SSH. Vérifier au préalable que la connexion par clé fonctionne :
````
sudo journalctl -u ssh | grep Accepted | tail -5
# Doit afficher "Accepted publickey", pas "Accepted password"
````

````
sudo vim /etc/ssh/sshd_config.d/00-HardeningSSH.conf

# Editer
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
````

- Vérification
````
sudo sshd -t
sudo systemctl restart ssh

# Config effective (et non le contenu du fichier)
sudo sshd -T | grep -iE 'passwordauth|permitroot'
````

Garder la session courante ouverte et en ouvrir une seconde pour tester avant de fermer.

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
- Le qualificateur `~all` (softfail) marque les autres émetteurs comme suspects sans les rejeter. On durcira en `-all` (hardfail) une fois la configuration validée.

### - `DKIM`
(Sera implémenté plus tard en `-5-`, la clé étant générée par rspamd dans le conteneur)
- DomainKeys Identified Mail : le serveur signe chaque message sortant avec une clé privée, et publie la clé publique dans le DNS.
- La signature couvre le corps du message et une sélection d'en-têtes, dont `From:`. Elle survit aux transferts, contrairement à SPF.

### - `DMARC`
- Domain-based Message Authentication, Reporting and Conformance : c'est la politique qui relie le tout. SPF et DKIM produisent chacun un verdict mais ne disent pas quoi en faire.
- Un message passe DMARC si au moins un des deux est à la fois valide et **aligné** avec le domaine du `From:`.
- On démarre en `p=none` (observation seule) : rien n'est bloqué, mais les rapports agrégés permettent de vérifier que tout le trafic légitime passe avant de durcir.

---

### SPF

- Enregistrement `SPF` sur DNS OVH => Web Cloud => Noms de domaine => nalsed.fr => Zone Dns

Ici : `nalsed.fr. IN TXT "v=spf1 mx ~all"`, avec autorisation des serveurs `MX` et sous-domaine `@`.

### DMARC

- Enregistrement `DMARC` sur DNS OVH => Web Cloud => Noms de domaine => nalsed.fr => Zone Dns

Ici : `_dmarc.nalsed.fr. IN TXT "v=DMARC1; p=none; rua=mailto:dmarcnalsed@proton.me; sp=none; aspf=r"`

`[NOTE]`

- L'aperçu OVH affiche `IN DMARC`, ce type n'existe pas : l'enregistrement réel est un `TXT`.
- `aspf=r` (relaxed) et non `s` (strict) au démarrage : l'alignement strict exigerait un `MAIL FROM` exactement sur `nalsed.fr`.
- Le `rua` pointe sur une adresse externe pour éviter la dépendance circulaire (si le serveur mail tombe, les rapports qui expliqueraient la panne n'arriveraient pas). Contrepartie : sans contrôle de la zone `proton.me`, l'autorisation croisée `nalsed.fr._report._dmarc.proton.me` ne peut pas exister et certains émetteurs (Google, Microsoft) n'enverront pas leurs rapports.

`[TEST]`

<img width="637" height="42" alt="image" src="https://github.com/user-attachments/assets/33206721-9cfd-4da7-ac7d-6868359bbfd9" />

````
dig +short @1.1.1.1 nalsed.fr TXT
dig +short @1.1.1.1 _dmarc.nalsed.fr TXT
````

---
---

# `-5-` Administration Conteneurs.

⚠️ Prérequis propre à mon infra ⚠️
````
# Stopper nginx (occupe le port 80, empêche Caddy de démarrer)
sudo systemctl disable --now nginx

# Désactiver exim4 (écoute sur 127.0.0.1:25)
sudo systemctl disable --now exim4
````

⚠️ Ne **pas** purger exim4 : `bareos-director` dépend de `bsd-mailx`, qui dépend d'un MTA. Un `apt purge exim4` entraînerait la suppression de toute la chaîne Bareos. Un simple `disable` suffit.

`- 5.1` Lancement des conteneurs

- Ordre important
1 `DMS` => 2 `SOGo` => 3 `Caddy`
````
cd ~/DMS/Mail_Server/
sudo docker compose up -d

cd ~/DMS/SOGo/
sudo docker compose up -d

cd ~/DMS/Caddy/
sudo docker compose up -d
````

`[NOTE]` En cas de changement de réseau sur une stack déjà lancée, un `docker compose up -d` échoue avec `network ... not found`. Faire `docker compose down` puis `up -d` : les données sont dans des bind mounts, rien n'est perdu.

`[TEST]`

- LOGS
````
sudo docker ps
sudo docker logs mailserver --tail 50
sudo docker logs sogo --tail 50
sudo docker logs caddy --tail 50
````

`[NOTE]` Le healthcheck DMS a un `start_period` de 90 s, le temps que ClamAV charge ses signatures. Un `health: starting` pendant deux minutes est normal.

- VARIABLES
````
sudo docker exec mailserver ps aux | grep -E 'opendkim|opendmarc|policyd'
# Ne doit rien retourner
````

- RÉSEAU
````
sudo docker network inspect sogo-net --format '{{range .Containers}}{{.Name}} {{end}}'
# Doit lister mailserver, sogo, sogo-postgres et caddy
````


`- 5.2` Création des comptes mail

- Boîte principale
````
sudo docker exec -ti mailserver setup email add martin@nalsed.fr
````

⚠️ Le `-ti` est indispensable sur toute commande qui demande une saisie. Sans lui, la saisie du mot de passe n'est pas captée et l'échec est **silencieux** : le compte apparaît normal dans `setup email list` mais aucune authentification ne fonctionne.

- Alias
````
sudo docker exec -ti mailserver setup alias add contact@nalsed.fr martin@nalsed.fr
sudo docker exec -ti mailserver setup alias add postmaster@nalsed.fr martin@nalsed.fr
sudo docker exec -ti mailserver setup alias add abuse@nalsed.fr martin@nalsed.fr
````

`[NOTE]`

`postmaster` et `abuse` ne sont pas cosmétiques : la RFC 2142 les rend obligatoires, plusieurs blocklists vérifient qu'ils répondent, et c'est là qu'arrivent les notifications d'incidents.



### ⚠️ Si problème de mot de passe ⚠️

- Tester l'authentification contre Dovecot
````
sudo docker exec -ti mailserver doveadm auth test martin@nalsed.fr
# Attendu : passdb: martin@nalsed.fr auth succeeded
````

⚠️ Les deux mots de passe (DMS et SOGo) doivent être identiques ⚠️

- Changer le mot de passe DMS
````
sudo docker exec -ti mailserver setup email update martin@nalsed.fr

# Test
sudo docker exec mailserver setup email list

# Restart
sudo docker restart mailserver
````

- Changer le mot de passe SOGo
````
sudo docker exec -ti sogo-postgres psql -U sogo -d sogo

UPDATE sogo_users SET c_password = MD5('nouveau') WHERE c_uid = 'martin';

# Quitter
\q

# Restart
sudo docker restart sogo
````


`- 5.3` Création de la table et de l'utilisateur SQL

`[NOTE]`
Sans cette table, le compte créé précédemment n'aura pas d'utilisateur, donc la connexion sur le WebUI de SOGo est impossible. SOGo ne supporte que deux types de sources utilisateurs, `sql` et `ldap` : il n'existe pas de source `imap`, la duplication du mot de passe est donc inévitable.

⚠️ Le mot de passe de l'utilisateur doit être le même que celui du compte mail. En cas de changement ou de révocation, penser à gérer les deux.

- Connexion à la `DB`
````
sudo docker exec -ti sogo-postgres psql -U sogo -d sogo
````

- Création de la table `sogo_users` dans PostgreSQL
````
CREATE TABLE sogo_users (
    c_uid VARCHAR(255) PRIMARY KEY,                -- Identifiant unique (nom d'utilisateur)
    c_name VARCHAR(255) NOT NULL,                  -- Nom unique ou adresse email
    c_password VARCHAR(255) NOT NULL,              -- Mot de passe haché
    mail VARCHAR(255) NOT NULL,                    -- Adresse email principale
    aliases TEXT,                                  -- Autres adresses email ou alias
    c_cn VARCHAR(255),                             -- Nom complet (Common Name)
    last_login TIMESTAMP                           -- Dernière date de connexion (facultatif)
);
````

- Ajout d'un compte utilisateur
````
# !!! Le mot de passe doit être identique à celui de DMS, sinon SOGo authentifie via SQL
# mais échoue à ouvrir la session IMAP derrière (page blanche, sans message d'erreur visible). !!!
INSERT INTO sogo_users (c_uid, c_name, c_password, c_cn, mail, aliases)
VALUES ('martin', 'martin@nalsed.fr', MD5('MOT_DE_PASSE_DMS'), 'Martin', 'martin@nalsed.fr', 'contact@nalsed.fr');
````

`[NOTE]` L'algorithme `md5` est celui configuré par défaut dans `sogo.conf` (`userPasswordAlgorithm = md5;`). Il n'est pas salé, à durcir en `ssha512` lors du passage sous gestionnaire de mots de passe.

- Redémarrer SOGo
````
sudo docker restart sogo
````


`- 5.4` Configuration de `sogo.conf`

`[NOTE]` Deux paramètres manquants empêchent le webmail de fonctionner correctement, même une fois la table créée.

- Fichier côté hôte :
````
sudo vim /var/lib/docker/volumes/sogo_sogo-conf/_data/sogo.conf
````

- Ajouter dans le bloc principal (attention aux points-virgules, syntaxe OpenStep) :
````
    SOGoForceExternalLoginWithEmail = YES;
    WOWorkersCount = 5;
    SOGoSMTPServer = "smtp://mailserver:25";
````

- `SOGoForceExternalLoginWithEmail` : sans lui, SOGo se connecte en IMAP avec le seul `c_uid` (`martin`) alors que DMS attend l'adresse complète (`martin@nalsed.fr`). Symptôme : connexion au webmail réussie mais page blanche, et `IMAP4 login failed ... user=martin` dans les logs.
- `WOWorkersCount` : sans lui, `No child available to handle incoming request!` sature les logs et l'interface reste instable.
- `SOGoSMTPServer` : remplacer la ligne existante, ne pas en ajouter une seconde — le paramètre déclaré deux fois voit la dernière valeur écraser la première. Le port 587 échoue en `5.7.0 Must issue a STARTTLS command first`, puis en `not allowed in state 1` avec `?tls=YES`. Le port 25 en interne fonctionne sans authentification, le trafic ne quittant jamais le réseau Docker.

````
sudo docker restart sogo
````

`[TEST]`
````
sudo docker exec sogo tail -50 /var/log/sogo/sogo.log
````

`[NOTE]` L'erreur `'OCSAdminURL' is not set` au démarrage est bénigne (administration multi-domaines, non utilisée ici).


`- 5.5` DKIM

- Générer la clé
````
sudo docker exec -ti mailserver setup config dkim
````

- Vérifier l'implémentation
````
sudo docker exec mailserver ls /tmp/docker-mailserver/rspamd/dkim/
# La clé doit être visible. Si le répertoire n'existe pas et que la clé se trouve sous
# opendkim/, les variables du point 3.2 ne sont pas appliquées : corriger AVANT de publier
# quoi que ce soit dans le DNS.
````

- Récupérer la valeur publique
````
sudo docker exec mailserver cat /tmp/docker-mailserver/rspamd/dkim/rsa-2048-mail-nalsed.fr.public.dns.txt
# Ne récupérer que la partie entre guillemets.
````

- Dans OVH, créer un enregistrement TXT avec sous-domaine `mail._domainkey` et valeur `v=DKIM1; k=rsa; p=<clé>`

`[TEST]`

````
dig +short @1.1.1.1 mail._domainkey.nalsed.fr TXT
# Le résultat attendu est le même enregistrement que celui saisi dans OVH.
````

- À présent https://webmail.nalsed.fr/SOGo/ fonctionne.

- Test de bout en bout : envoyer un mail depuis la boîte vers `check-auth@verifier.port25.com`. Le rapport automatique dira si SPF, DKIM et DMARC passent tous les trois. 
````
# Resultat
The Port25 Solutions, Inc. team

==========================================================
Summary of Results
==========================================================
SPF check:          permerror <=== Erreur OVH, reste OK 
"iprev" check:      pass
DKIM check:         pass

==========================================================
````

`- 5.6` Test des deploy-hooks

`[NOTE]` Le `--dry-run` seul n'exécute **pas** les deploy-hooks. L'option `--run-deploy-hooks` les déclenche sans consommer de quota Let's Encrypt.

````
sudo certbot renew --dry-run --run-deploy-hooks

sudo docker ps --filter name=caddy
# Le STATUS doit montrer un démarrage récent.
````

- Vérifier les hooks enregistrés
````
sudo grep -r renew_hook /etc/letsencrypt/renewal/
````


`- 5.7` Accès depuis un client mobile

| | Réception | Envoi |
|---|---|---|
| Serveur | mail.nalsed.fr | mail.nalsed.fr |
| Port | 993 | 587 |
| Sécurité | SSL/TLS | STARTTLS |
| Identifiant | martin@nalsed.fr | martin@nalsed.fr |

- Le webmail peut aussi être ajouté à l'écran d'accueil (PWA) : Chrome => ⋮ => Ajouter à l'écran d'accueil, ou Safari => Partager => Sur l'écran d'accueil.
