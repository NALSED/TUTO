## 🐋 Mise en place complète de DockerMailServer. 🐋 

--- 

Dans cette section est regroupé toutes les étapes pour obtenir, un service `Docker MailServer`, avec WebUi `SOGo`, et base de données `PostGreSQL`.


`[RAPPEL]`

Il est bon de lire cette partie de la documentation afin de bien comprendre le fonctionnement de la messagerie. => [Intro_Fonctionnement](https://docker-mailserver.github.io/docker-mailserver/latest/introduction/)


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

-1- `Enregistrement DNS` => [Liens](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/INSTALL/-1-%20Enregistrement_DNS.md)

-2- `Création des Certificats` pour `DMS` / `SOGo` / `PostGreSQL` / `Caddy` => [Liens](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/INSTALL/-2-%20Certificats.md)

-3- `Création Docker Compose` pour `DMS` / `SOGo` / `PostGreSQL` / `Caddy` => [Liens](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/INSTALL/-3-%20Docker_Compose.md)

-4- `Sécurité Conteneurs` => [Liens](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/INSTALL/-4-%20S%C3%A9curit%C3%A9.md)

-5- `Administration Conteneurs` => [Liens](https://github.com/NALSED/TUTO/blob/main/PERSO/VPS/MAIL/INSTALL/-5-%20Administration.md)
