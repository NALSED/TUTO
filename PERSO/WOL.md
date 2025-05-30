# Création Configuration du Protocol WOL.

---

### Dans Ce tuto nous allons installer configurer et implémenter sur une page HTML le protocole WOL pour pourvoir allumer les serveurs à distance.


---
[TUTO WOL](https://belginux.com/activer-wake-on-lan-sous-debian/)
## `INFRA`
### 1) PC Admin 192.168.0.111
### 2) Serveur Web 192.168.0.122
### 3) Serveur Bareos / Plex 192.168.0.141

### Instalation du protocole WOL sur `Serveur Bareos / Plex`, pour implémenter le fontionement de ce protocole sur `Serveur Web`, pour pouvoir accéder à une page HTML sur `PC Admin`, pour allumer `Serveur Bareos`.



---


## 1️⃣ `Intalation et configuration`

## SUR `Serveur Bareos / Plex 192.168.0.141`

### 1.1) Se rendre dans le BIOS de `Serveur Bareos / Plex` (F2), chercher l'option `Power On by PCI-E`, Redémarrer.
### 1.2) Intaller ethtool sur `Serveur Bareos / Plex`
      sudo apt install ethtool
### Test 
      ethtool enp4s0
### Si Wake-on: d (désactivé)
![image](https://github.com/user-attachments/assets/3ba62123-6caa-4ca1-abd6-e97eeba83b86)

### Entrer la commande 
      ethtool -s enp4s0 wol g

### PUIS
      ethtool enp4s0

### Résultat attendu
![image](https://github.com/user-attachments/assets/1b097080-dd5f-47d3-b4d1-84b8256b1e4a)

### 1.3) Pour rendre le WOL persistant :
### Se rendre dans /etc/systemd/system 
      nano /etc/systemd/system/wol.service

### 1.4) Renseigner 
      [Unit]
      Description=Activer Wake-on-LAN pour enp4s0
      After=network.target # Indique que ce service doit être lancé après que le réseau ait été initialisé. Cela garantit que l’interface réseau enp4s0 existe et est prête.

      [Service]
      Type=oneshot # Ce service exécute une seule commande et se termine. Il ne reste pas en arrière-plan.
      ExecStart=/usr/sbin/ethtool -s enp4s0 wol g # Execution de la commande
      RemainAfterExit=yes # indique à systemd que, même si le service se termine rapidement, il doit être considéré comme "actif"

      [Install]
      WantedBy=multi-user.taget # Ce service sera lancé automatiquement au démarrage quand le système atteint le mode "multi-utilisateur"

### 1.5) Activer le service au démarrage
      systemctl daemon-reexec
      systemctl daemon-reload
      systemctl enable wol.service
      systemctl start wol.service
      
### 1.6) Status 
      systemctl status wol.service
![image](https://github.com/user-attachments/assets/605dd12d-bb24-46f2-867c-98bf171d5738)

### et le tatus de la `commande ethtool` enp4s0 est passé de `d` => `g` 

### 1.7) Test Réaliser avant implémentation HTML avec [WakeMeOnLine](https://www.nirsoft.net/utils/wake_on_lan.html)
### Test OK

---

## SUR `Serveur Web 192.168.0.122`

### 1.8) Installer le module php-sockets (pour envoyer des paquets réseau bas niveau.)
      apt install php php-sockets





---

## 2️⃣ `Implémentation HTML`

## SUR `Serveur Web 192.168.0.122`

### 2.1) Créer un fichier php, qui envérra le paquet magique au serveur
             nano /var/www/html/wol.php

### Fichier

                  <?php
                  function wake_on_lan($mac) {
                      $mac_bytes = explode(':', $mac);
                      $hw_addr = '';

                      foreach ($mac_bytes as $byte) {
                          $hw_addr .= chr(hexdec($byte));
                      }

                      $packet = str_repeat(chr(0xFF), 6) . str_repeat($hw_addr, 16);

                      $sock = socket_create(AF_INET, SOCK_DGRAM, SOL_UDP);
                      socket_set_option($sock, SOL_SOCKET, SO_BROADCAST, true);

                      // Adresse de broadcast
                      $broadcast = '192.168.0.255';
                      $port = 9;

                      socket_sendto($sock, $packet, strlen($packet), 0, $broadcast, $port);
                      socket_close($sock);
                  }

                  $mac_address = '00:11:22:33:44:55'; // Adresse MAC du serveur
                  wake_on_lan($mac_address);

                  echo "Machine réveillée (paquet envoyé à $mac_address)";
                  ?>







