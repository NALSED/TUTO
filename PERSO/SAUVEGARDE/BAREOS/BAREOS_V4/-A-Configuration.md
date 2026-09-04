# Configuration Bareos

---

Ce tuto commence après l'installation et la configuration de [PostgreSQL](https://github.com/NALSED/TUTO/blob/main/PERSO/SAUVEGARDE/BAREOS/INSTALLATION/BAREOS-2-Installation.md#i-instalation)

---

## `-1-` Rappel

### `- 1.1` PostgreSQL

<img width="405" height="61" alt="image" src="https://github.com/user-attachments/assets/eb112749-9760-4e6e-bfee-ad1a1b3db285" />

### `- 1.2` Bareos

Configuring bareos-database-common password => classic

---

## `-2-` Plan synoptique

### `- 2.1` Vue d'ensemble

````
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
                           |                      ^   Tunnel autoSSH +cron   |
                           v                      |                          v
                  +----------------+              |               +-------------------+
                  | Local Backup   |              |               |   Remote Backup   |
                  +----------------+              |               +-------------------+
                  |  192.168.0.240 |              |               | WAN 176.31.163.227|
                  | Redondance     |              |               | Stockage distant  |
                  +----------------+              |               +-------------------+
                           ^                      |                          ^
                           |                      |                          |
                           |                      ----------------------------
          +----------------+----------------+         Tunnel autoSSH + cron
          |      Clients à sauvegarder      |                                |
          +---------------------------------+                                |
          | 192.168.0.235 PC Admin          |                        +----------------+
          | 192.168.0.241 Raspberry Pi 1    |                        | Client distant |
          | - Unbound + Pi-hole +           |                        +----------------+
          | gestioninfra                    |                        | 176.31.163.227 |
          | (Future) 2ème Raspberry Pi      |                        |    système     |
          | - Gcert + Site Web              |                        +----------------+
          +---------------------------------+
````

---

## `-3-` WebUI Bareos

### `- 3.1` Installer et activer php-fpm pour Apache2

Activer PHP-FPM pour Apache2 sert à améliorer la gestion et les performances de PHP
sur le serveur web.

````
apt-get install bareos-webui -y
````

````
a2enmod proxy_fcgi setenvif
a2enconf php8.1-fpm
systemctl reload apache2
service php8.4-fpm status
````

<img width="1494" height="364" alt="image" src="https://github.com/user-attachments/assets/c4b6f46b-7634-4e88-9fd5-18ce3f542754" />

### `- 3.2` Configurer le WebUI

````
cp /etc/bareos/bareos-dir.d/console/admin.conf.example /etc/bareos/bareos-dir.d/console/admin.conf
nano /etc/bareos/bareos-dir.d/console/admin.conf
````

<img width="436" height="364" alt="image" src="https://github.com/user-attachments/assets/38082443-ea43-4d5f-8f1b-0a1f41b6953a" />

### `- 3.3` Vérifier le profil webui-admin

Vérifier que le fichier `/etc/bareos/bareos-dir.d/profile/webui-admin.conf` est présent
et correct.

<img width="1188" height="306" alt="image" src="https://github.com/user-attachments/assets/89e0ca19-e655-45c7-9676-b011786241a1" />

### `- 3.4` Redémarrer les services

````
systemctl restart apache2 && systemctl restart php8.4-fpm && systemctl restart bareos-director
````

Accès => `http://192.168.0.240/bareos-webui/`

---

## `-4-` Tunnel SSH

### `- 4.1` Pourquoi un tunnel

Ici un tunnel SSH est nécessaire, car :

- Le port 9103 du SD distant n'est pas exposé sur Internet.
- Le Director (DIR) initie toujours la connexion vers le Storage Daemon (SD).
- Le SD envoie ensuite les données à travers cette connexion.

⚠️ Deux contraintes à respecter impérativement :

- Le port local du tunnel doit être **différent de 9103**, déjà occupé par le SD local.
- Le tunnel doit se binder sur l'**IP LAN** et non sur `localhost` : le Director transmet
  l'adresse du Storage au File Daemon, et les autres clients du LAN (ex. 192.168.0.235)
  doivent pouvoir la joindre.

### `- 4.2` Installer AutoSSH

````
sudo apt install autossh
````

### `- 4.3` Copier la clé SSH sur le serveur distant

````
ssh-copy-id -i /home/sednal/.ssh/id_ecdsa.pub debian@176.31.163.227
````

### `- 4.4` Enregistrer la clé d'hôte du VPS

Indispensable : sous systemd il n'y a pas de TTY, `ssh` ne peut donc pas demander
de confirmation interactive. Un `known_hosts` vide fait échouer le tunnel avec
`Host key verification failed`.

Vérifier l'empreinte **sur le VPS** :

````
ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
````

Puis l'enregistrer sur le serveur local après comparaison :

````
ssh-keyscan -t ed25519 176.31.163.227 >> /home/sednal/.ssh/known_hosts
ssh-keygen -F 176.31.163.227 -f /home/sednal/.ssh/known_hosts
````

### `- 4.5` Autoriser le bind sur l'IP LAN

````
vim /etc/ssh/sshd_config
````

````
GatewayPorts clientspecified
````

Puis tester et recharger :

````
sudo sshd -t && sudo systemctl reload sshd
````

### `- 4.6` Créer le tunnel SSH via systemd

````
vim /etc/systemd/system/tunnel-bareos.service
````

````
[Unit]
Description=Tunnel SSH persistant vers VPS pour BAREOS.Dir
After=network-online.target
Wants=network-online.target

[Service]
User=sednal
ExecStart=/usr/bin/autossh -M 0 -N -L 192.168.0.240:9203:localhost:9103 debian@176.31.163.227 \
  -o "ServerAliveInterval=30" -o "ServerAliveCountMax=3" \
  -o "ExitOnForwardFailure=yes" -o "StrictHostKeyChecking=yes"
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
````

`[NOTE]` `ExitOnForwardFailure=yes` évite que le service se déclare actif alors
que le forward a échoué.

### `- 4.7` Activation du service

````
sudo systemctl daemon-reload
sudo systemctl enable --now tunnel-bareos.service
sudo systemctl status tunnel-bareos.service
````

### `- 4.8` Vérification du tunnel

````
ss -lntp | grep 9203
nc -vz 192.168.0.240 9203
````

**RÉSULTAT ATTENDU**

````
LISTEN 0  128  192.168.0.240:9203  0.0.0.0:*  users:(("ssh",...))
192.168.0.240 9203 open
````

Et côté Bareos :

````
printf "status storage=Storage_Remote\nquit\n" | sudo bconsole
````

````
Connecting to Storage daemon Storage_Remote at 192.168.0.240:9203
 Encryption: TLS_CHACHA20_POLY1305_SHA256 TLSv1.3

Remote_Sd Version: 24.0.7~pre3.0e656b287 (16 October 2025) Debian GNU/Linux 13 (trixie)
Device "Remote_Device" (/var/lib/bareos/storage) is not open.
````

`[NOTE]` Aucune règle firewall n'est à ajouter sur le VPS : tout le trafic Bareos
transite dans la connexion SSH sur le port 22, déjà ouvert.
