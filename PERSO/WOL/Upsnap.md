
=> docker-compose.yml
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

     sudo mkdir -p /srv/appdata/upsnap/data
sudo chown -R $USER:$USER /srv/appdata/upsnap/

 docker compose up -d

192.68.0.240:8090
