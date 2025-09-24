# :whale: `Liste des actions et commandes pour docker.` :whale:


## `Echapper sudo`

* #### Entrer l'utilisateur dans le groupe sudo
      sudo usermod -aG docker $USER

## `Lister`

* #### Liste  les container actifs
      docker ps
* #### Liste tous les container
      docker ps -a

## `Exécuter`

* #### `Télécharger/exécuter` un container
      docker run [options] image [commande]
* #### télécharger/éxécuter un  container  en `background` => -d (detached mode)
      docker run -d nginx:latest
* #### télécharger/éxécuter un container et `changer de nom`
      docker run -d  --name c1 nginx:latest => --name
* #### `Stopper/Démmarrer`
      docker stop [NAME]//[ID]
      docker start [NAME]//[ID]
 * #### changer le `hostname` du contnaire => --hostname
      docker run --name c2 --hostname test debian:latest

## `Supprimer`

  #### Stop le container et le `supprime`  => rm
      docker rm -f
  #### `Supprime` le container `à l'arret de celui ci` => --rm
      docker run -ti --rm --name c2 debian:latest

      
##  `Interaction container`
* #### `lancer un terminal` dans le container. => -ti 
      docker run -ti --name c2 debian:latest
      # terminal machine  physique
      sednal@origin:/$
      #terminal container
      root@c645cb50b1ee:/#  
  
#### `lancer une commande` dans  container `en cours d’exécution.`
      #Ici on ouvre le terminal de c3
      docker exec -ti c3 bash
      




---

##  `Volumes`
#### En nommant un volume  existant volume à la création d'un autre contener il est  possible  d'utiliser un volume pour plusieurs contener.
#### ⚠️ En local `/var/lib/docker/volumes/mynginx/` ⚠️

* #### `Lister`
      docker volume ls
* #### `Créer` 
      docker volume create [NOM VOLUME]

* #### `Monter` un volume => -v [NOM VOLUME]:[CHEMIN]
      docker run -d --name c1 -v mynginx:/usr/share/nginx/html/ nginx:latest

* #### `inspecter`
      docker volume inspect mynginx

            [
             {
                    "CreatedAt": "2025-09-24T19:08:11+01:00",
                    "Driver": "local",
                    "Labels": null,
                    "Mountpoint": "/var/lib/docker/volumes/mynginx/_data",#chemin dans le  host qui corespond à /usr/share/nginx/html/ dans le contener docker
                    "Name": "mynginx",
                    "Options": null,
                    "Scope": "local"
                }
            ]


*  ####  `Suprimmer`
      docker volume rm










      
<details>
<summary>
<h2>
:arrow_forward: --help
</h2>
</summary>


# Docker 

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


</details>



<details>
<summary>
<h2>
:arrow_forward: run --help
</h2>
</summary>

# Options courantes pour la commande `docker run`

| Option                         | Description                                                                                       |
| ------------------------------| -------------------------------------------------------------------------------------------------|
| `--add-host list`              | Ajouter une entrée personnalisée host:IP dans le fichier hosts du conteneur                      |
| `--annotation map`             | Ajouter une annotation au conteneur (transmise au runtime OCI) (par défaut map[])                |
| `-a, --attach list`            | Attacher STDIN, STDOUT ou STDERR                                                                 |
| `--blkio-weight uint16`        | Poids relatif du bloc IO (entre 10 et 1000, ou 0 pour désactiver) (par défaut 0)                 |
| `--blkio-weight-device list`   | Poids relatif IO pour un périphérique spécifique (par défaut [])                                 |
| `--cap-add list`               | Ajouter des capacités Linux au conteneur                                                        |
| `--cap-drop list`              | Retirer des capacités Linux du conteneur                                                        |
| `--cgroup-parent string`       | Cgroup parent optionnel pour le conteneur                                                       |
| `--cgroupns string`            | Namespace cgroup à utiliser : <br> - `host` : namespace du host <br> - `private` : namespace privé <br> - `""` : valeur par défaut du démon |
| `--cidfile string`             | Écrire l'ID du conteneur dans un fichier                                                        |
| `--cpu-period int`             | Limiter la période CPU CFS (scheduler)                                                          |
| `--cpu-quota int`              | Limiter le quota CPU CFS                                                                         |
| `--cpu-rt-period int`          | Limiter la période CPU temps réel (microsecondes)                                               |
| `--cpu-rt-runtime int`         | Limiter le temps CPU temps réel (microsecondes)                                                 |
| `-c, --cpu-shares int`         | Parts CPU relatives (poids)                                                                      |
| `--cpus decimal`               | Nombre de CPU à utiliser                                                                         |
| `--cpuset-cpus string`         | CPU autorisés (ex : `0-3`, `0,1`)                                                              |
| `--cpuset-mems string`         | MEMs autorisés (ex : `0-3`, `0,1`)                                                             |
| `-d, --detach`                 | Détacher le conteneur (lancer en arrière-plan)                                                 |
| `--detach-keys string`         | Remplacer la séquence de touches pour détacher                                                  |
| `--device list`                | Ajouter un périphérique du host au conteneur                                                    |
| `--device-cgroup-rule list`   | Ajouter une règle aux périphériques autorisés dans cgroup                                       |
| `--device-read-bps list`       | Limiter le débit de lecture (bytes/sec) d’un périphérique                                       |
| `--device-read-iops list`      | Limiter le nombre d’IOs de lecture par seconde                                                  |
| `--device-write-bps list`      | Limiter le débit d’écriture (bytes/sec)                                                        |
| `--device-write-iops list`     | Limiter le nombre d’IOs d’écriture par seconde                                                 |
| `--disable-content-trust`      | Désactiver la vérification des images (par défaut true)                                        |
| `--dns list`                   | Définir des serveurs DNS personnalisés                                                         |
| `--dns-option list`            | Options DNS                                                                                     |
| `--dns-search list`            | Domaines de recherche DNS personnalisés                                                        |
| `--domainname string`          | Nom de domaine NIS du conteneur                                                                |
| `--entrypoint string`          | Remplacer le ENTRYPOINT par défaut de l’image                                                  |
| `-e, --env list`               | Définir des variables d’environnement                                                          |
| `--env-file list`              | Lire des variables d’environnement depuis un fichier                                          |
| `--expose list`                | Exposer un ou plusieurs ports                                                                   |
| `--gpus gpu-request`           | Ajouter des GPU au conteneur (`all` pour tous les GPUs)                                        |
| `--group-add list`             | Ajouter des groupes supplémentaires                                                           |
| `--health-cmd string`          | Commande pour vérifier la santé du conteneur                                                  |
| `--health-interval duration`   | Intervalle entre chaque check (ms|s|m|h) (par défaut 0s)                                       |
| `--health-retries int`         | Nombre d’échecs consécutifs avant d’indiquer un état non sain                                 |
| `--health-start-interval duration` | Intervalle entre chaque check pendant la période de démarrage (par défaut 0s)            |
| `--health-start-period duration` | Période de démarrage avant de commencer le comptage des échecs (par défaut 0s)             |
| `--health-timeout duration`    | Durée maximale autorisée pour un check (par défaut 0s)                                        |
| `--help`                      | Afficher l’aide                                                                                |
| `-h, --hostname string`        | Nom d’hôte du conteneur                                                                         |
| `--init`                      | Lancer un init dans le conteneur pour gérer les signaux et processus zombies                  |
| `-i, --interactive`            | Garde STDIN ouvert même si non attaché                                                        |
| `--ip string`                 | Adresse IPv4 personnalisée (ex: 172.30.100.104)                                               |
| `--ip6 string`                | Adresse IPv6 personnalisée (ex: 2001:db8::33)                                                 |
| `--ipc string`                | Mode IPC à utiliser                                                                            |
| `--isolation string`          | Technologie d’isolation du conteneur                                                          |
| `--kernel-memory bytes`       | Limite mémoire noyau                                                                           |
| `-l, --label list`            | Ajouter des métadonnées (labels)                                                               |
| `--label-file list`           | Lire les labels depuis un fichier                                                             |
| `--link list`                 | Ajouter un lien vers un autre conteneur                                                       |
| `--link-local-ip list`        | Adresses link-local IPv4/IPv6 pour le conteneur                                               |
| `--log-driver string`         | Pilote de log à utiliser                                                                      |
| `--log-opt list`              | Options pour le pilote de log                                                                 |
| `--mac-address string`        | Adresse MAC du conteneur (ex: 92:d0:c6:0a:29:33)                                            |
| `-m, --memory bytes`          | Limite mémoire                                                                               |
| `--memory-reservation bytes`  | Limite douce de mémoire                                                                       |
| `--memory-swap bytes`         | Limite swap (mémoire + swap) : `-1` pour illimité                                           |
| `--memory-swappiness int`     | Ajuster le swappiness mémoire (0-100), défaut -1                                            |
| `--mount mount`               | Monter un système de fichiers                                                                |
| `--name string`               | Nommer le conteneur                                                                           |
| `--network network`           | Connecter le conteneur à un réseau                                                           |
| `--network-alias list`        | Ajouter un alias réseau                                                                       |
| `--no-healthcheck`            | Désactiver les vérifications HEALTHCHECK                                                     |
| `--oom-kill-disable`          | Désactiver l’OOM Killer                                                                      |
| `--oom-score-adj int`         | Ajuster la préférence OOM du host (-1000 à 1000)                                            |
| `--pid string`                | Namespace PID à utiliser                                                                     |
| `--pids-limit int`            | Limite du nombre de processus (-1 = illimité)                                               |
| `--platform string`           | Spécifier la plateforme si le serveur est multi-plateforme                                  |
| `--privileged`                | Donner des privilèges étendus au conteneur                                                  |
| `-p, --publish list`          | Publier un ou plusieurs ports du conteneur sur l’hôte                                      |
| `-P, --publish-all`           | Publier tous les ports exposés sur des ports aléatoires                                   |
| `--pull string`               | Tirer l’image avant de lancer (`always`, `missing`, `never`) (par défaut `missing`)         |
| `-q, --quiet`                 | Supprimer la sortie du pull                                                                  |
| `--read-only`                 | Monter le système de fichiers racine en lecture seule                                      |
| `--restart string`            | Politique de redémarrage à appliquer (par défaut `no`)                                     |
| `--rm`                       | Supprimer automatiquement le conteneur et ses volumes anonymes à l’arrêt                   |
| `--runtime string`            | Runtime à utiliser pour ce conteneur                                                       |
| `--security-opt list`         | Options de sécurité                                                                        |
| `--shm-size bytes`            | Taille de /dev/shm                                                                         |
| `--sig-proxy`                 | Proxy des signaux reçus vers le processus (par défaut true)                                |
| `--stop-signal string`        | Signal pour arrêter le conteneur                                                          |
| `--stop-timeout int`          | Timeout en secondes pour arrêter un conteneur                                            |
| `--storage-opt list`          | Options du driver de stockage                                                             |
| `--sysctl map`                | Options sysctl (par défaut map[])                                                         |
| `--tmpfs list`                | Monter un répertoire tmpfs                                                                |
| `-t, --tty`                   | Allouer un pseudo-TTY                                                                     |
| `--ulimit ulimit`             | Options ulimit (par défaut [])                                                            |
| `--use-api-socket`            | Monter la socket API Docker avec authentification requise                                |
| `-u, --user string`           | Utilisateur ou UID (format : `<nom|uid>[:<groupe|gid>]`)                                  |
| `--userns string`             | Namespace utilisateur à utiliser                                                         |
| `--uts string`                | Namespace UTS à utiliser                                                                  |
| `-v, --volume list`           | Monter un volume                                                                         |
| `--volume-driver string`      | Driver de volume optionnel                                                               |
| `--volumes-from list`         | Monter les volumes d’un ou plusieurs conteneurs                                          |
| `-w, --workdir string`        | Répertoire de travail dans le conteneur                                                 |












































</details>
