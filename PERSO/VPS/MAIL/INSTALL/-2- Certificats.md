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
