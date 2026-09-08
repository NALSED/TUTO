# Implémentation Site Recherche emplois / Alternance.

----

Ce document montre le procédé complet pour la mise en ligne du site `presentation.nalsed.fr`

### `-1-` Configuration Serveur Web

### `-2-` Création Site

### `-3-` Hébergement du site

---

### `-1-` Configuration Serveur Web

- Cette partie détaillée [ICI](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/INSTALL/-3-%20Docker_Compose.md#---version-2---avec-le-site-de-demande-dalternance)

### `-2-` Création Site

- Cette partie détaillée [ICI](https://github.com/NALSED/presentation)

### `-3-` Hébergement du site


`- 3.1` Créer un entrée `A`
````
presentation.nalsed.fr. IN A 176.31.163.227
````

`- 3.2` Cloner le repo dans le dossier corespondant sur `176.31.163.227`
````
cd ~/www/site
````

````
git clone https://github.com/NALSED/presentation
````

`- 3.3` Vérifier la propagation DNS
````
dig +short presentation.nalsed.fr
````
Résultat attendu :
````
176.31.163.227
````

`- 3.4` Valider la configuration Caddy
````
sudo docker compose exec caddy caddy validate --config /etc/caddy/Caddyfile
````
Résultat attendu :
````
Valid configuration
````

`- 3.5` Recharger Caddy
````
sudo docker compose exec caddy caddy reload --config /etc/caddy/Caddyfile
````

`- 3.6` Vérifier l'émission du certificat
````
sudo docker compose logs --tail=50 caddy | grep presentation
````
- Résultat attendu
````
caddy  | {"level":"info","ts":1788846847.7598424,"logger":"http","msg":"enabling automatic TLS certificate management","domains":["presentation.nalsed.fr"]}
caddy  | {"level":"info","ts":1788846994.660106,"logger":"http","msg":"enabling automatic TLS certificate management","domains":["presentation.nalsed.fr"]}
caddy  | {"level":"info","ts":1788847133.9617865,"logger":"http","msg":"enabling automatic TLS certificate management","domains":["presentation.nalsed.fr"]}
````

`- 3.7` Tester l'accès au site
````
curl -I https://presentation.nalsed.fr
````
Résultat attendu :
````
HTTP/2 200
accept-ranges: bytes
alt-svc: h3=":443"; ma=2592000
content-type: text/html; charset=utf-8
etag: "dl9p1y48ndfad40"
last-modified: Tue, 08 Sep 2026 05:43:17 GMT
server: Caddy
vary: Accept-Encoding
content-length: 16992
date: Tue, 08 Sep 2026 05:59:00 GMT
````


