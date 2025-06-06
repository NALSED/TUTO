# Première utilistation de Docker context.

---

##### Un contexte Docker permet de spécifier le répertoire de référence pour les opérations Docker, notamment pour la construction d'images. Il permet également de gérer plusieurs environnements Docker, comme des instances locales ou distantes

---

### Ce tuto à pour Objectif l'utilisation de Docker context pour déployer un logiciel (Wazuh), depuis le serveur Docker 192.168.0.101, via un PC Admin 192.168.0.111, sur une machine distante 192.168.0.104.
### Prérequis Clé ssh déployé sur les deux machine [voir](https://github.com/NALSED/TUTO/tree/main/PERSO/SSH)
### Docker installé sur 192.168.0.104 [voir](https://github.com/NALSED/TUTO/blob/main/PERSO/DOCKERS/Install.md) ainsi que TLS géré [voir](https://github.com/NALSED/TUTO/blob/main/PERSO/DOCKERS/Liens_Lx-Win.md#3%EF%B8%8F%E2%83%A3-avec-tls-)
### [TUTO DOKER](https://www.docker.com/blog/how-to-deploy-on-remote-docker-hosts-with-docker-compose/) // [TUTO EXEMPLE](https://labex.io/tutorials/docker-how-to-use-docker-context-use-command-to-switch-contexts-555137)  // [DOC  OFFICIEL](https://docs.docker.com/engine/manage-resources/contexts/)

---

