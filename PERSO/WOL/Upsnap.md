# Instalation upsnap et configuration clients:

## 1️⃣ 192.168.0.241
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

# 2️⃣ 192.168.0.240 

### 1) Activer WOL dans le bios

### Installer `ethtool`
    sudo apt update
    sudo apt install ethtool

### Vérifier si Wol est activer

#### 1) voir les interfaces 
      ip link 
#### SORTIE
      sednal@serveur:~$ ip link
      1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
          link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
      2: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000 <=== On travaille donc sur celle la
          link/ether 30:b5:c2:01:63:1e brd ff:ff:ff:ff:ff:ff
          altname enx30b5c201631e
      3: enp3s0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
          link/ether 38:ea:a7:ab:f9:28 brd ff:ff:ff:ff:ff:ff
          altname enx38eaa7abf928
      4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default
          link/ether 02:44:ec:ab:11:f2 brd ff:ff:ff:ff:ff:ff

#### 2) Voir si WOL est actif
       sudo ethtool enp2s0 | grep "Wake-on"
#### SORTIE
      sednal@serveur:~$ sudo ethtool enp2s0 | grep "Wake-on"
        Supports Wake-on: pumbg
        Wake-on: d <=== DESACTIVE...

#### 3) Activation de WOL via `systemd` : 
      sudo nano /etc/systemd/system/wol@.service
#### EDITER
      [Unit]
      Description=Activer Wake-on-LAN pour enp2s0 # Description du service
      After=network.target # Ce service doit démarrer après que le réseau soit opérationnel
      
      [Service]
      Type=oneshot # Type oneshot = exécute la commande une seule fois puis se termine
      ExecStart=/usr/sbin/ethtool -s enp2s0 wol g # Commande pour activer Wake-on-LAN Magic Packet sur l'interface enp2s0
      RemainAfterExit=yes # Indique à systemd que même si le service se termine rapidement, il doit être considéré comme "actif" pour les dépendances
      
      [Install]
      WantedBy=multi-user.target # Ce service sera lancé automatiquement au démarrage quand le système atteint le mode "multi-utilisateur"

#### 4) Recharge systemd :
      sudo systemctl daemon-reload

#### 5) Active et démarre le service :
      sudo systemctl enable wol@enp2s0
      sudo systemctl start wol@enp2s0

#### 6) test 
      sudo systemctl status wol@enp2s0
      sudo ethtool enp2s0 | grep "Wake-on"

<img width="922" height="287" alt="image" src="https://github.com/user-attachments/assets/3feefee5-50e1-4f02-982a-579a200f8c69" />



### CONFIG UPSNAP
 
 ## 1️⃣ Up 
 
### Cron + wakeonlan
    wakeonlan 30:b5:c2:01:63:1e
    55 11 * * 0 

### Tout les dimanche à 11:55

---

 ## 2️⃣ Down

### Cron + wakeonlan
    wakeonlan 30:b5:c2:01:63:1e
    0 16 * * 0

### Tout les dimanche à 16:00


---

# 3️⃣ 192.168.0.111

#### Gestionnaire de périphériques





