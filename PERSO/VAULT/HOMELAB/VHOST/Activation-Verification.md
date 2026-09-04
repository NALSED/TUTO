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

### `-2-` Vérification

`[NOTE]`

L'accès par IP doit échouer sans réponse — `curl: (52) Empty reply from server`
ou `curl: (92) HTTP/2 stream 1 was not closed cleanly` selon le protocole négocié.
C'est le comportement attendu du code `444`.

### `- 2.1`Portail
````
curl -Ik https://infra.sednal.lan
````

- Attendu
````
HTTP/2 200
````

### `- 2.2` Proxmox

`[NOTE]`

`curl -I` renvoie un `501` sur Proxmox : son serveur n'implémente pas la méthode `HEAD`.
Ce n'est pas une erreur de configuration, il faut tester en GET.

- Accès par IP
````
curl -Ik https://192.168.0.239
````

`[RAPPEL]`

Le test décisif pour Proxmox est l'ouverture d'une console noVNC ou du shell d'un nœud
depuis un navigateur : c'est ce qui valide le passage des websockets.

