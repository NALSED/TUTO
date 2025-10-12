# 🏠 Hébergement site Web en Local 🏠

---

### Je vais contourner l’absence d’accès à mon routeur FAI en mettant en place un reverse proxy sur mon VPS, afin de pouvoir héberger mon site en local.

---

## Mise en place ⤴️ `Reverse  proxy` ⤵️

#### ⚠️  Ne pas utiliser UFW, probléme si  mal configuré. ⚠️

### I) `SUR VPS`
#### 1.1) Création d'une régle avec iptable sur le port `8080 TCP`
        sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT

####  RESULTAT
<img width="684" height="48" alt="image" src="https://github.com/user-attachments/assets/14f7a5f9-fea0-405f-b42c-240aff56362e" />

#### 1.2) Pour rendre la règle permanente (sinon elle disparaît au reboot) :

        sudo apt install iptables-persistent -y
        sudo netfilter-persistent save

#### Les fichiers se trouvent ici ⬇️
<img width="329" height="43" alt="image" src="https://github.com/user-attachments/assets/83ede9f9-78dd-4f22-95f5-9d6c16a44301" />

---

### II)  `SUR SERVEUR LOCAL`

####  2.1) Vérifier si le port 80 ouvert
<img width="560" height="60" alt="image" src="https://github.com/user-attachments/assets/c00c58b4-886c-4d10-87c3-70b0b6e7616f" />

#### 2.2) Installer `AutoSSH` => un outil qui maintient automatiquement un tunnel SSH ouvert et le relance si la connexion tombe.
        sudo apt install autossh

#### 2.3) Créer un connection sans MDP et Initier la connection.
          ssh-copy-id -i /home/sednal/.ssh/id_ecdsa.pub debian@IP
          autossh -M 0 -f -N -R 8080:localhost:80 debian@176.31.163.227
          
- #### `-M 0` : désactive le port de monitoring automatique.  
- #### `-f` : met le tunnel en arrière-plan.  
- #### `-N` : ne pas exécuter de commande distante (tunnel uniquement).  
- #### `-R [port_distant]:[host_local]:[port_local]` : tunnel inversé, le serveur distant redirige vers la machine locale.

#### `Stopper la connection`
        pkill autossh # TOUT KILL
        ps -ef | grep ssh
        sudo kill <PID>  # PLUS FIN
        
### 📝 TEST 📝

#### `SUR SERVEUR LOCAL`
<img width="1306" height="62" alt="image" src="https://github.com/user-attachments/assets/37ee2be5-0309-4590-9ba8-1ab806335af1" />



---

### III) `SUR VPS`

#### Installer nginx
      sudo apt update
      sudo apt install nginx -y

#### éditer le fichier `reverse-local`

        sudo nano /etc/nginx/sites-available/reverse-local
        server {
            listen 80;
            server_name nalsed.fr www.nalsed.fr;
        
            location / {
                proxy_pass http://127.0.0.1:8080;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
            }
        }

#### TESTER CONFIG
          sudo nginx -t
#### SORTIE
          nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
          nginx: configuration file /etc/nginx/nginx.conf test is successful

---
---

#### ICI changement du port du site => conflit avec pihole sur raspberry 
#### ON passe du  port 80  => 3000

                        server {
                            listen 3000 default_server;
                            listen [::]:3000 default_server;
                            
                            root /var/www/html;
                            index index.html index.htm index.nginx-debian.html;
                        
                            server_name _;
                        
                            location / {
                                try_files $uri $uri/ =404;
                            }
                        }
#### Donc changement  pour autossh et VPS ngnix 

### ngnix `VPS`

                server {
                    listen 3000;
                    server_name nalsed.fr www.nalsed.fr;
                
                    location / {
                        proxy_pass http://127.0.0.1:8080;
                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                    }
                }


### `AutoSSH`
                utossh -M 0 -f -N -R 8080:localhost:3000 debian@176.31.163.227


#### TEST FINAL 

## `SUR SERVEUR LOCAL`
                curl http://localhost:3000
### SORTIE
                <!DOCTYPE html>
                <html lang="fr">
                <head>
                    <meta charset="UTF-8">
                    <title>Site Test</title>
                </head>
                <body>
                    <h1>Bonjour depuis le VPS !</h1>
                    <p>Cette page remplace la page par défaut de Nginx.</p>
                </body>
                </html>      

## `SUR VPS`
                curl http://localhost:3000
### SORTIE
                <!DOCTYPE html>
                <html lang="fr">
                <head>
                    <meta charset="UTF-8">
                    <title>Site Test</title>
                </head>
                <body>
                    <h1>Bonjour depuis le VPS !</h1>
                    <p>Cette page remplace la page par défaut de Nginx.</p>
                </body>
                </html>                 

##  `SUR PC`
                        PS C:\Users\sednal> curl http://176.31.163.227:3000


                        StatusCode        : 200
                        StatusDescription : OK
                        Content           : <!DOCTYPE html>
                                            <html lang="fr">
                                            <head>
                                                <meta charset="UTF-8">
                                                <title>Site Test</title>
                                            </head>
                                            <body>
                                                <h1>Bonjour depuis le VPS !</h1>
                                                <p>Cette page remplace la page par dÃ©faut de Ng...
                        RawContent        : HTTP/1.1 200 OK
                                            Connection: keep-alive
                                            Accept-Ranges: bytes
                                            Content-Length: 225
                                            Content-Type: text/html
                                            Date: Sun, 12 Oct 2025 19:07:17 GMT
                                            ETag: "68ebf869-e1"
                                            Last-Modified: Sun, 12 Oct 2025 1...
                        Forms             : {}
                        Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 225],
                                            [Content-Type, text/html]...}
                        Images            : {}
                        InputFields       : {}
                        Links             : {}
                        ParsedHtml        : mshtml.HTMLDocumentClass
                        RawContentLength  : 225





