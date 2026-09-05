## Instalation de `Uptime-Kuma`

--

- Installation et configuration de Uptime-Cuma via Docker compose

- Le monitoring sera gérer via un `Raspberry Pi 2 Model B`

=== Lab ===

- `IP` : 192.168.0.237

- `HOSTNAME` : monitoring.sednal.lan

- `CPU` : 900MHz Arm Cortex-A53 quad-core 64-bit processor 

- `RAM` : 1GB RAM


---


## `-1-` Installation

`- 1.1` Installer docker via script => [ICI](https://github.com/NALSED/TUTO/blob/main/PERSO/DOCKERS/SCRIPTS/-1-docker_install.sh)


`- 1.2` Créer le docker compose

[DOC](https://github.com/louislam/uptime-kuma/wiki/Environment-Variables)

````
services:
  uptime-kuma:
    image: louislam/uptime-kuma:2
    restart: unless-stopped
    volumes:
      - ./data:/app/data
    ports:
      - "3001:3001"
````


`- 1.3` Vérification de la compatibilité d'architecture avant lancement :
````
docker manifest inspect louislam/uptime-kuma:2 | grep -A2 architecture
````


Démarrage :

````
docker compose up -d
````
