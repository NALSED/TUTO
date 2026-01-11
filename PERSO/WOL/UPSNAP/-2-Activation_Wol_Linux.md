
# 192.168.0.240 
#### Vérification de l’état du WOL sur un client Linux. Si désactivé : activation et inscription à systemd pour rendre le WOL actif de manière permanente.

---
---

### 1) Activer WOL dans le bios

---

### 2) Vérification état Wol

### 2.1) Installer `ethtool`
    sudo apt update
    sudo apt install ethtool

#### 2.2)  voir les interfaces 
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

#### 2.3) Voir si WOL est actif
       sudo ethtool enp2s0 | grep "Wake-on"
#### SORTIE
      sednal@serveur:~$ sudo ethtool enp2s0 | grep "Wake-on"
        Supports Wake-on: pumbg
        Wake-on: d <=== DESACTIVE...

---

#### 3) Activation de WOL via `systemd` : 
      sudo nano /etc/systemd/system/wol.service

#### EDITER
      [Unit]
      Description=Activer Wake-on-LAN pour enp2s0 # Description du service
      After=network.target # Ce service doit démarrer après que le réseau soit opérationnel
      
      [Service]
      Type=oneshot # Type oneshot = exécute la commande une seule fois puis se termine
      ExecStart=/usr/sbin/ethtool -s enp2s0 wol g # Commande pour activer Wake-on-LAN Magic Packet sur l'interface enp2s0
      RemainAfterExit=yes # Indique à systemd que même si le service se termine rapidement, il doit être considéré comme "actif" pour les dépendances
      
      [Install]
      WantedBy=basic.target # Ce service sera lancé automatiquement au démarrage quand le système atteint le mode basic utilisateur"

---

#### 4) Recharge systemd :
      sudo systemctl daemon-reload

---

#### 5) Active et démarre le service :
      sudo systemctl enable wol.service
      sudo systemctl start wol.service

---

#### 6) test 
      sudo systemctl status wol.service
      sudo ethtool enp2s0 | grep "Wake-on"

<img width="843" height="211" alt="image" src="https://github.com/user-attachments/assets/6744e200-8ee8-4938-9057-e5e37406f329" />


