# Configuration Bareos2

## Ce Tuto commence  après l'installation et la configuration de [PostgreSQL](https://github.com/NALSED/TUTO/blob/main/PERSO/SAUVEGARDE/BAREOS/INSTALLATION/BAREOS-2-Installation.md#i-instalation)


---
## 1️⃣ RAPPEL:
### `PostgreSQL` 
<img width="405" height="61" alt="image" src="https://github.com/user-attachments/assets/eb112749-9760-4e6e-bfee-ad1a1b3db285" />

### `Bareos`
### Configuring bareos-database-common password  => classic

--- 
## 2️⃣ BACKUP :

### I) `Plan Synoptique`
                                      +-----------------------+
                                      |       PC Admin        |
                                      +-----------------------+
                                      |      192.168.0.235    |
                                      | Interface Bareos/SSH  |
                                      +-----------+-----------+
                                                  |
                                                  v
                                      +-------------------------+
                                      |     Bareos Director     |
                                      |     192.168.0.240       |
                                      +-----------+-------------+
                                                  |
                                                  | 
                                                  v
                                      +-------------------------+
                                      | PostgreSQL Catalog      |
                                      | 192.168.0.240           |
                                      | Dump automatique        |
                                      | via cron/script         |
                                      +-----------+-------------+
                                                  |
                                                  v
                                         +----------------+
                                         | Storage Local  |
                                         | (bareos-sd)    |
                                         | Local Backup   |
                                         +----------------+
                                                  |
                           -----------------------/--------------------------
                           |                      ^   Tunel autoSSH +cron   |
                           v                      |                         v
                  +----------------+              |               +-------------------+
                  | Local Backup   |              |               |   Remote Backup   |
                  +----------------+              |               +-------------------+
                  |  192.168.0.240 |              |               | WAN 176.31.163.227|
                  | Redondance     |              |               | Stockage distant  |
                  +----------------+              |               +-------------------+
                           ^                      |                          ^
                           |                      |                          |
                           |                      ----------------------------
          +----------------+----------------+         Tunel autoSSH + cron   |                           
          |      Clients à sauvegarder      |                                |                   
          +---------------------------------+                                |
          | 192.168.0.235 PC Admin          |                        +----------------+
          | 192.168.0.241 Raspberry Pi 1    |                        | Client distant |
          | - Unbound + Pi-hole +           |                        +----------------+
          | gestioninfra                    |                        | 176.31.163.227 |
          | (Future) 2ème Raspberry Pi      |                        |    système     |
          | - Gcert + Site Web              |                        +----------------+
          +---------------------------------+                        
                                                                      
### II) `WebUi Bareos`                        
#### 2.1) Install + Activer php-fpm pour Apache2       
#### 2.2) Activer PHP-FPM pour Apache2 sert à améliorer la gestion et les performances de PHP sur le serveur web.  
        # install
        apt-get install bareos-webui -y
        # Activer php-fpm
        a2enmod proxy_fcgi setenvif
        a2enconf php8.1-fpm
        systemctl reload apache2
        service php8.4-fpm status 

<img width="1494" height="364" alt="image" src="https://github.com/user-attachments/assets/c4b6f46b-7634-4e88-9fd5-18ce3f542754" />

#### 2.3) Config WebUi 
      cp /etc/bareos/bareos-dir.d/console/admin.conf.example /etc/bareos/bareos-dir.d/console/admin.conf
      nano /etc/bareos/bareos-dir.d/console/admin.conf

<img width="436" height="364" alt="image" src="https://github.com/user-attachments/assets/38082443-ea43-4d5f-8f1b-0a1f41b6953a" />

#### 2.4) Vérifier que le fichier /etc/bareos/bareos-dir.d/profile/webui-admin.conf est présent et correct

<img width="1188" height="306" alt="image" src="https://github.com/user-attachments/assets/89e0ca19-e655-45c7-9676-b011786241a1" />

#### 2.5 Redémarrer les services 
    systemctl restart apache2 && systemctl restart php8.4-fpm && systemctl restart bareos-director
    
#### Accès => `http://192.168.0.240/bareos-webui/`

### III) `Tunnel SSH` 

#### 📝 ICI un tunnel SSH simple suffit, car:
* #### Le Director (DIR) initie toujours la connexion vers le Storage Daemon (SD) ou le File Daemon (FD).
* #### Le Director se connecte à localhost:9103 (qui est redirigé via le tunnel vers le SD distant).
* #### Le SD envoie les données à travers ce tunnel vers le Director.
#### En résumé => le SD “pousse” les données au Director, mais le flux est déclenché et encapsulé dans la connexion TCP que le Director a ouverte via le tunnel local.

---

### 3.1) Afin que le Bareo.SD du VPS puisse communiquer avec le  bareos.DIR du serveur local mise en  place d'un tunnel SSH.
#### Ce tunnel sera configuré dans systemd afin que, à chaque démarrage du serveur, le tunnel soit recréé automatiquement.

#### 3.2) Installer Auto SSH
        sudo apt install autossh
#### 3.3) Copier la clé ssh sur serveur  distant
        ssh-copy-id -i /home/sednal/.ssh/id_ecdsa.pub debian@176.31.163.227

#### 3.4) Créer une règle Iptable  sur le  serveur distant(VPS), pour autoriser  uniquement les  connection  depuis le serveur local sur le port 9103(port  Bareos.SD).
        # Autoriser le serveur local à se connecter au SD distant
        sudo iptables -A INPUT -p tcp -s 192.168.0.240 --dport 9103 -m state --state NEW,ESTABLISHED -j ACCEPT
        # Autoriser les paquets liés aux connexions existantes
        sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#### 3.5) Rendre la règle permanente (sinon elle disparaît au reboot)
          sudo apt install iptables-persistent -y
          sudo netfilter-persistent save

#### 3.6) Créer le  tunnel SSH  via systemd:
          
          sudo  nano /etc/systemd/system/tunnel-bareos.service
          #  EDITER
          [Unit]
          Description=Tunnel SSH persistant vers VPS pour BAREOS.Dir
          After=network.target
          
          [Service]
          User=sednal
          ExecStart=/usr/bin/autossh -M 0 -N -L 9103:localhost:9103 debian@172.31.163.227 \
            -o "ServerAliveInterval=30" -o "ServerAliveCountMax=3"
          Restart=always
          RestartSec=10
          
          [Install]
          WantedBy=multi-user.target

####  3.7)  Activation du service
          sudo systemctl daemon-reload
          sudo systemctl enable --now tunnel-bareos.service
          sudo systemctl  status tunnel-bareos.service

#### Vérification du service

<img width="1254" height="237" alt="image" src="https://github.com/user-attachments/assets/cff617ca-c531-4ccd-894a-c40212bfaf75" />

#### Vérification du tunnel
        nc -vz localhost 9103

#### Cela signifie que le tunnel SSH est opérationnel et que le Director local peut communiquer avec le SD distant via localhost:9103.

<img width="413" height="38" alt="image" src="https://github.com/user-attachments/assets/eb20dcbd-28d6-4b93-806c-f889c3061a6a" />
