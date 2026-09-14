## Installation de `n8n` sur VPS

---

### -1- Créer un enregistrement `DNS` pour n8n sur le VPS
- Ici
````
n8n.nalsed.fr. IN A 176.31.163.227
````


### -2- Création docker compose

- Le docker compose créera un container pour n8n et po

- Créer le fichier
````
vim $HOME/n8n/compose.yml
````

- Editer
````
services:
  n8n:
    image: n8nio/n8n:latest
    restart: always
    ports:
      - "127.0.0.1:5678:5678"
    environment:
      - N8N_HOST=n8n.nalsed.fr
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      # Le password est dans un .env
      - DB_POSTGRESDB_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - n8n_data:/home/sednal/.n8n
    depends_on:
      - postgres

  postgres:
    image: postgres:16
    restart: always
    environment:
      - POSTGRES_DB=n8n
      - POSTGRES_USER=n8n
      # Le password est dans un .env
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - n8n_pg:/var/lib/postgresql/data

volumes:
  n8n_data:
  n8n_pg:
````

### -3- création du fichier `.env`
````
cd $HOME/n8n
# Editer :
POSTGRES_PASSWORD=<PASSWORD_DB>

# Droits
chmod 600 .env
````

### -4- Redémarrage de `n8n` si reboot du VPS

- créer le fichier .service
````
sudo vim /etc/systemd/system/n8n.service
````

- Editer
````
[Unit]
Description=n8n workflow automation (Docker Compose)
After=network.target

[Service]
Type=oneshot
WorkingDirectory=/home/debian/n8n
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
````

- Démarrage service
````
systemctl enable --now n8n
````

### -5- Créer un `Caddyfile`
````
vim ~/DMS/Caddy/conf.d/n8n.caddy
````

- Editer
````
n8n.nalsed.fr {
    reverse_proxy localhost:5678
}
````

- Reload
````
sudo systemctl reload caddy
````






