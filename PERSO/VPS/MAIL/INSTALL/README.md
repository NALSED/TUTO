## 🐋 Mise en place compléte de DockerMailServer. 🐋 

--- 

Dans cette section est regroupé toutes les étapes pour obtenir, un service `Docker MailServer`, avec WebUi `SOGo`, et base de donnée `PostGreSQL`.


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

`SOMMAIRE`

-1- `Enregistrement DNS` => [Liens]()

-2- `Création des Certificats` pour `DMS` / `SOGo` / `PostGreSQL` / `Caddy` => [Liens]()

-3- `Création Docker Compose` pour `DMS` / `SOGo` / `PostGreSQL` / `Caddy` => [Liens]()

-4- `Sécurité Conteneurs` => [Liens]()

-5- `Administration Conteneurs` => [Liens]()
