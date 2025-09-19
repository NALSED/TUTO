#  Liste des actions et commandes pour docker.


###  Echapper sudo

      #Entrer l'utilisateur dans le groupe sudo
      sudo usermod -aG docker $USER

### `Lister`

      # Liste  les conteners actifs
      docker ps
      # Liste tous les conteners
      docker ps -a

### `Exécuter`

      #Télécharger et exécuter un conteneur
      docker run [options] image [commande]
      #télécharger  éxécuter un  contener  en background => -d (detached mode)
      docker run -d nginx:latest
      
<details>
<summary>
<h2>
:arrow_forward: --help
</h2>
</summary>


# Docker - Un environnement autonome pour les conteneurs

## Commandes courantes

| Commande | Description                                       |
| -------- | ------------------------------------------------|
| `run`    | Crée et lance un nouveau conteneur à partir d’une image |
| `exec`   | Exécute une commande dans un conteneur en cours d’exécution |
| `ps`     | Liste les conteneurs                             |
| `build`  | Construit une image à partir d’un Dockerfile    |
| `bake`   | Construire à partir d’un fichier                 |
| `pull`   | Télécharge une image depuis un registre          |
| `push`   | Envoie une image vers un registre                 |
| `images` | Liste les images                                 |
| `login`  | Authentification auprès d’un registre            |
| `logout` | Déconnexion d’un registre                         |
| `search` | Recherche d’images sur Docker Hub                 |
| `version`| Affiche la version de Docker                      |
| `info`   | Affiche des informations globales sur le système |

## Commandes de gestion

| Commande  | Description                                    |
| --------- | ----------------------------------------------|
| `builder` | Gérer les builds                              |
| `buildx*` | Docker Buildx                                 |
| `compose*`| Docker Compose                               |
| `container`| Gérer les conteneurs                         |
| `context` | Gérer les contextes                           |
| `image`   | Gérer les images                              |
| `manifest`| Gérer les manifestes d’image Docker          |
| `network` | Gérer les réseaux                             |
| `plugin`  | Gérer les plugins                             |
| `system`  | Gérer Docker                                  |
| `trust`   | Gérer la confiance sur les images Docker     |
| `volume`  | Gérer les volumes                             |

## Commandes Swarm

| Commande | Description                                  |
| -------- | --------------------------------------------|
| `swarm`  | Gérer Docker Swarm                          |

## Autres commandes

| Commande  | Description                                     |
| --------- | -----------------------------------------------|
| `attach`  | Attacher les flux standard (entrée/sortie) à un conteneur en cours |
| `commit`  | Créer une nouvelle image à partir des modifications d’un conteneur  |
| `cp`      | Copier des fichiers/dossiers entre un conteneur et le système local |
| `create`  | Créer un nouveau conteneur                       |
| `diff`    | Inspecter les modifications sur le système de fichiers d’un conteneur |
| `events`  | Obtenir les événements en temps réel du serveur  |
| `export`  | Exporter le système de fichiers d’un conteneur en archive tar |
| `history` | Afficher l’historique d’une image               |
| `import`  | Importer le contenu d’une archive tar pour créer une image |
| `inspect` | Retourner des informations détaillées sur des objets Docker |
| `kill`    | Tuer un ou plusieurs conteneurs en cours        |
| `load`    | Charger une image à partir d’une archive tar ou de l'entrée standard |
| `logs`    | Récupérer les logs d’un conteneur                |
| `pause`   | Mettre en pause tous les processus d’un ou plusieurs conteneurs |
| `port`    | Lister les mappages de ports d’un conteneur     |
| `rename`  | Renommer un conteneur                            |
| `restart` | Redémarrer un ou plusieurs conteneurs           |
| `rm`      | Supprimer un ou plusieurs conteneurs            |
| `rmi`     | Supprimer une ou plusieurs images                |
| `save`    | Sauvegarder une ou plusieurs images dans une archive tar |
| `start`   | Démarrer un ou plusieurs conteneurs arrêtés     |
| `stats`   | Afficher en direct les statistiques d’utilisation des ressources d’un conteneur |
| `stop`    | Arrêter un ou plusieurs conteneurs en cours     |
| `tag`     | Créer une étiquette TARGET_IMAGE qui réfère à SOURCE_IMAGE |
| `top`     | Afficher les processus en cours dans un conteneur |
| `unpause` | Reprendre tous les processus mis en pause dans un ou plusieurs conteneurs |
| `update`  | Mettre à jour la configuration d’un ou plusieurs conteneurs |
| `wait`    | Bloquer jusqu’à ce qu’un ou plusieurs conteneurs s’arrêtent, puis afficher leur code de sortie |

## Options globales

| Option                     | Description                                                    |
| -------------------------- | --------------------------------------------------------------|
| `--config string`          | Emplacement des fichiers de configuration client (par défaut `"/home/sednal/.docker"`) |
| `-c, --context string`     | Nom du contexte à utiliser pour se connecter au démon (remplace la variable d’environnement DOCKER_HOST) |
| `-D, --debug`              | Activer le mode debug                                          |
| `-H, --host string`        | Socket du démon auquel se connecter                           |
| `-l, --log-level string`   | Niveau de journalisation ("debug", "info", "warn", "error", "fatal") (par défaut "info") |
| `--tls`                    | Utiliser TLS (impliqué par --tlsverify)                        |
| `--tlscacert string`       | Certificats CA de confiance (par défaut `"/home/sednal/.docker/ca.pem"`) |
| `--tlscert string`         | Chemin vers le certificat TLS (par défaut `"/home/sednal/.docker/cert.pem"`) |
| `--tlskey string`          | Chemin vers la clé TLS (par défaut `"/home/sednal/.docker/key.pem"`) |
| `--tlsverify`              | Utiliser TLS et vérifier le serveur distant                    |
| `-v, --version`            | Affiche la version et quitte                                   |

---

Pour plus d'informations sur une commande spécifique, exécute :
```bash
docker COMMAND --help

</details>
