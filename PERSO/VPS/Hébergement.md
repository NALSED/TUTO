# 🏠 Hébergement site Web en Local 🏠

---

### Je vais contourner l’absence d’accès à mon routeur FAI en mettant en place un reverse proxy sur mon VPS, afin de pouvoir héberger mon site en local.

---
## 1️⃣ ⏳ Préalables: ⏳
*  #### Avoir un nom de domaine, enregistré, valide et actif
*  #### Faire un enregistrement A du nom de demaine pointanters l'IP du VPS => www.nalsed.fr.  0	A	176.31.163.227
* #### Créer une page html (ou autre) en local
* #### Installer sur serveur `LAN`
     * #### autossh
     * #### nginx
* #### Installer sur `VPS`
     * #### nginx
     * #### iptables-persistent

---
  
## 2️⃣  ⤴️ Mise en place `Reverse  proxy` ⤵️

#### ⚠️  Ne pas utiliser UFW, problémes si  mal configuré. ⚠️

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

#### ICI changement du port du site => conflit avec pihole sur raspberry 
#### ON passe du  port 80  => 3000
## `SUR SERVEUR LOCAL`
                        nano /etc/nginx/sites-enabled/default
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

####  2.1) Vérifier si le port 80 ouvert
<img width="560" height="60" alt="image" src="https://github.com/user-attachments/assets/c00c58b4-886c-4d10-87c3-70b0b6e7616f" />

#### 2.2) Installer `AutoSSH` => un outil qui maintient automatiquement un tunnel SSH ouvert et le relance si la connexion tombe.
        sudo apt install autossh

#### 2.3) Créer un connection sans MDP et Initier la connectio via autossh
          ssh-copy-id -i /home/sednal/.ssh/id_ecdsa.pub debian@176.31.163.227
          nohup autossh -M 0 -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" \
-R 0.0.0.0:8080:localhost:3000 debian@176.31.163.227 > ~/autossh.log 2>&1 &

<details>
<summary>
<h2>
 EXPLICATION COMMANDE ⬆️
</h2>
</summary>

# Décomposition de la commande

## 1. `nohup`
- Ignore le signal **SIGHUP** qui ferme les processus lorsque le terminal est fermé.  
- Permet au tunnel de continuer à fonctionner après la déconnexion.  
- Les sorties sont redirigées vers un fichier (`~/autossh.log`).

## 2. `autossh`
- Version améliorée de `ssh` qui **relance automatiquement le tunnel** si la connexion tombe.  
- Idéal pour les tunnels SSH permanents.

## 3. `-M 0`
- Désactive le monitoring interne d’`autossh`.  
- On utilise ici la vérification via `ServerAliveInterval` et `ServerAliveCountMax`.

## 4. `-N`
- Aucune commande exécutée à distance.  
- Utile uniquement pour **établir le tunnel**.

## 5. `-o "ServerAliveInterval 30"`
- Envoie un “ping” toutes les 30 secondes pour vérifier que la connexion SSH est toujours active.

## 6. `-o "ServerAliveCountMax 3"`
- Si le serveur ne répond pas à **3 pings consécutifs**, la connexion est considérée comme tombée.  
- `autossh` relance alors automatiquement le tunnel.

## 7. `-R 0.0.0.0:8080:localhost:3000`
- Crée un **tunnel inversé (reverse tunnel)** :  
  - `localhost:3000` → ton service local  
  - `0.0.0.0:8080` → port 8080 du VPS exposé sur toutes les interfaces publiques  
- Permet d’accéder au service local via le VPS depuis Internet.

## 8. `> ~/autossh.log 2>&1`
- Redirige **stdout et stderr** vers le fichier `~/autossh.log` pour garder un historique.

## 9 `&`
- Met le processus en **arrière-plan**, pour libérer le terminal.



</details>

           
#### `Stopper la connection`
        pkill autossh # TOUT KILL
        ps -ef | grep ssh
        sudo kill <PID>  # PLUS FIN
        

---

### III) `SUR VPS`

#### 3.1) Installer nginx
      sudo apt update
      sudo apt install nginx -y

#### 3.2) éditer le fichier `reverse-local`

        sudo nano /etc/nginx/sites-available/reverse-local
        server {
            listen 80;  #
            server_name nalsed.fr www.nalsed.fr;
        
            location / {
                proxy_pass http://127.0.0.1:8080;  # tunnel vers app locale
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_http_version 1.1;
                proxy_set_header Connection "";
            }
        }

#### 3.3) Tester config et reload Ngnix 
          sudo nginx -t
          sudo systemctl reload nginx

#### SORTIE
          nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
          nginx: configuration file /etc/nginx/nginx.conf test is successful

#### 3.4) ⚠️ Modifier le fichier de configuration SSH ⚠️
        sudo nano /etc/ssh/sshd_config
        GatewayPorts yes # Ajouter  ou décommenter cet  ligne

---
---

#### 🎉 Tester le site 🎉
<img width="477" height="227" alt="image" src="https://github.com/user-attachments/assets/7a0b3e07-6321-4e09-bba5-9408dc157f3d" />



