## `-1-` Activation

`[NOTE]`

Le `default` de Debian est désactivé : il capte le port 80 en `default_server`
et n'a plus d'utilité, le portail étant servi par `infra.conf`.

- Désactivation du vhost Debian
````
sudo rm /etc/nginx/sites-enabled/default
````

- Liens symboliques
````
cd /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/default-ssl.conf default-ssl.conf
sudo ln -s /etc/nginx/sites-available/infra.conf        infra.conf
sudo ln -s /etc/nginx/sites-available/pihole.conf       pihole.conf
sudo ln -s /etc/nginx/sites-available/proxmox.conf      proxmox.conf
````

- Contrôle et rechargement
````
sudo nginx -t
sudo systemctl enable --now nginx
sudo systemctl reload nginx
````

---


