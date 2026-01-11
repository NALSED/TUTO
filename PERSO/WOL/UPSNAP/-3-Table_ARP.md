# Table ARP sur 192.168.0.241.

#### Cette procédure permet de rendre les entrées ARP des clients permanentes, afin qu’UpSnap puisse envoyer les paquets WOL à la bonne adresse MAC à chaque fois, même après un redémarrage.
#### Vérification de l’état de la table ARP et inscription de celle-ci dans systemd pour la rendre permanente, via un script bash.

---

### 1) Edition script

     sudo vim /usr/local/bin/arp-wol.sh

#### 1.1) Editer 
      
      #!/bin/bash
      # /usr/local/bin/arp-wol.sh
      # ARP statiques permanents pour Wake-on-LAN
      
      DEV=eth0
      
      ip link set dev $DEV up
      
      # Remplacer ou ajouter les entrées ARP permanentes
      ip neigh replace 192.168.0.235 lladdr 04:7c:16:cb:89:1d nud permanent dev $DEV
      ip neigh replace 192.168.0.240 lladdr 30:b5:c2:01:63:1e nud permanent dev $DEV

---

### 2) Rendre le script exécutable

      sudo chmod +x /usr/local/bin/arp-wol.sh

---

### 3) Editer systemd

      sudo vim /etc/systemd/system/arp-wol.service

#### 3.1) Editer

        [Unit]
        Description=ARP statique pour Wake-on-LAN
        After=network-online.target
        Wants=network-online.target
        
        [Service]
        Type=oneshot
        ExecStart=/usr/local/bin/arp-wol.sh
        RemainAfterExit=yes
        
        [Install]
        WantedBy=multi-user.target

---
        
 ### 4) Activer et Lancer

        sudo systemctl daemon-reload
        sudo systemctl enable arp-wol.service
        sudo systemctl start arp-wol.service

---

### 5) Vérification

        sudo systemctl status arp-wol.service

#### Sortie

<img width="897" height="232" alt="image" src="https://github.com/user-attachments/assets/85399965-44c0-47c7-bca4-8fd0c64705ad" />












 

