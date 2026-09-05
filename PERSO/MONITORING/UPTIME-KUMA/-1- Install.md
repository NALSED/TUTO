## Instalation de `Uptime-Kuma`

--

- Installation et configuration de Uptime-Cuma via Docker compose

- Le monitoring sera gérer via un `Raspberry Pi 2 Model B`

=== Lab ===

- `IP_ADMIN` : 192.168.0.237:3001/setup-database

- `HOSTNAME_ADMIN` : monitoring.sednal.lan

- `Enregistrement_DNS_PROXY` : kuma.sednal.lan / 192.168.0.239

- `CPU` : 900MHz Arm Cortex-A53 quad-core 64-bit processor 

- `RAM` : 1GB RAM

[DOC](https://www.crosstalksolutions.com/uptime-kuma-complete-setup-guide-on-digital-ocean-with-docker/)

---


## `-1-` Installation

`- 1.1` Installer docker via script => [ICI](https://github.com/NALSED/TUTO/blob/main/PERSO/DOCKERS/SCRIPTS/-1-docker_install.sh)

`- 1.2` Créer dossier
````
mkdir -p $HOME/Uptime

# Allez dans le dossier
cd $HOME/Uptime
````

`- 1.3`
Créer le docker compose
````
vim docker-compose.yml
````

`- 1.4` Créer le docker compose

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


`- 1.5` Vérification de la compatibilité d'architecture avant lancement :
````
docker manifest inspect louislam/uptime-kuma:2 | grep -A2 architecture
````


`- 1.5` Démarrage :

````
sudo docker compose up -d
````

`- 1.6` Connection 
````
http://monitoring.sednal.lan:3001/setup-database
````
