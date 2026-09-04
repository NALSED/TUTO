# Automatisations

---
---
#### Automatisation d'un cycle pour allumer et éteindre les machines concernées pas la sauvegarde de Bareos.

---

### 1️⃣ Wol via cron sur `192.168.0.241`

#### 1.1) Installer wakeonlan
      sudo apt install wakeonlan

#### 1.2)   Installer cron    
      sudo apt install cron

#### 1.3) Tache cron
      crontab -e => 1

#### Éditer Wol pour linux Et wol et shutdown pour Win 11
#### Pour que la commande `shutdown /s /t 0 /f` puisse fonctionner, créer une connexion ssh sans mot de passe de linux => win 11 [voir](https://github.com/NALSED/TUTO/blob/main/PERSO/SSH/Multi_OS.md#ubuntu---windows)

      crontab -e

      # ADMIN
      0 12 * * 0 /usr/bin/wakeonlan 04:7c:16:cb:89:1d
      45 18 * * 0 ssh sednal@192.168.0.235 "shutdown /s /t 0 /f"

      #Bareos
      0 12 * * 0 /usr/bin/wakeonlan 30:b5:c2:01:63:1e

      #Proxmox
      #0 12 * * 0 /usr/bin/wakeonlan 34:5a:60:e0:1c:72
      
`[NOTE]` L'extinction du PC Windows est à 18h45 et non 16h00 : le job Windows LAN
peut durer jusqu'à 3h30 en incrémental, suivi du job WAN. 
Une extinction trop tôt coupe la sauvegarde en cours.

### 2️⃣ Poweroff

#### ⚠️ Lancer poweroff avec `sudo` 

      sudo contab -e

#### Éditer serveur Bareos `192.168.0.240`

      # Extinction
      00 19 * * 0 /sbin/poweroff








