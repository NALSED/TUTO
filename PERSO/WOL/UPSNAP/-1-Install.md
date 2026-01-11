# Instalation upsnap et configuration clients:

## 192.168.0.241
### Créer un docker compose => docker-compose.yml       
     
      nano  docker-compose.yml 

###  Editer       
      services:
        upsnap:
          container_name: upsnap
          image: ghcr.io/seriousm4x/upsnap:4
          network_mode: host
          restart: unless-stopped
          volumes:
            - /srv/appdata/upsnap/data:/app/pb_data
          environment:
            - UPSNAP_SCAN_RANGE=192.168.0.1/24
            - TZ=Asia/Yerevan

### Ce script crée le dossier /srv/appdata/upsnap/data (y compris tous les dossiers parents manquants) puis changer son propriétaire et son groupe pour l’utilisateur actuel.
### Dossier editer dans le docker compose...

             sudo mkdir -p /srv/appdata/upsnap/data
             sudo chown -R $USER:$USER /srv/appdata/upsnap/

### Lancer le docker compose      
             docker compose up -d

### WebUi Upsnap     
      192.168.0.241:8090

---







