##  Vhost par défaut

`[NOTE]`

Sans vhost par défaut, nginx sert le `premier vhost déclaré`:
`https://192.168.0.239` qui ouvrait alors sur l'interface `Pihole`. 

Le code `444` ferme la connexion
sans réponse.

`[NOTE]`

⚠️Un seul `default_server` par port est autorisé : ne pas ajouter ce mot-clé dans un autre vhost. ⚠️

- Création
````
sudo vim /etc/nginx/sites-available/default-ssl.conf
````

- Edition
````
server {
    listen 443 ssl default_server;
    server_name _;

    include snippets/ssl-nalsed.conf;

    return 444;
}
````
