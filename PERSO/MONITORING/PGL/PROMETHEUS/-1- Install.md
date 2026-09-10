## Installation Prometheus

---

- Installer Docker via [Script](https://github.com/NALSED/TUTO/blob/main/PERSO/DOCKERS/SCRIPTS/-1-docker_install.sh), la VM est neuve.

- Créer le dossier
````
mkdir $HOME/Prometheus
````

````
cd $HOME/Prometheus
````

- Editer
````
vim docker-compose.yml
````
````
global:
  scrape_interval: 15s
  scrape_timeout: 10s
  evaluation_interval: 15s
alerting:
  alertmanagers:
  - static_configs:
    - targets: []
    scheme: http
    timeout: 10s
    api_version: v1
scrape_configs:
- job_name: prometheus
  honor_timestamps: true
  scrape_interval: 15s
  scrape_timeout: 10s
  metrics_path: /metrics
  scheme: http
  static_configs:
  - targets:
    - localhost:9090
````

---
