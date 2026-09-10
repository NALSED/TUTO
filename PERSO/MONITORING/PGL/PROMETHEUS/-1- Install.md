## Installation Prometheus +Grafana

---

- Installer Docker via [Script](https://github.com/NALSED/TUTO/blob/main/PERSO/DOCKERS/SCRIPTS/-1-docker_install.sh), la VM est neuve.


- [Repo-Utilisé](https://github.com/docker/awesome-compose/tree/master/prometheus-grafana)

- Créer l'arborecence suivante
````
$HOME/
    └──  Monitoring
            ├── compose.yaml
            ├── grafana
            |       └── datasource.yml
            ├── prometheus
            |       └── prometheus.yml
            └── README.md
````

- Récupérer le repo
````
git clone https://github.com/docker/awesome-compose/tree/master/prometheus-grafana
````

- Création des container
````
docker compose up -d
````

---
