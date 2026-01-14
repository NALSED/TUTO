# Automatisations

---
---
#### Automatisation d'un cycle pouyr allumer et eteindre les machines concernées pas la sauvegarde de Bareos.

---

### 1️⃣ Wol via cron sur `192.168.0.241`

#### 1.1) Installer wakeonlan
      sudo apt install wakeonlane

#### 1.2)   Installer cron    
      sudo apt install cron

#### 1.3) Tache cron
      crontab -e => 1

#### Editer Wol pour linux Et wol et shutdown pour Win 11
#### Pour que la commande `shutdown /s /t 0 /f`, puisse fonctionner créer une connection ssh sans mot de pas de linux => win 11 [voir](https://github.com/NALSED/TUTO/blob/main/PERSO/SSH/Multi_OS.md#ubuntu---windows)       
      # ADMIN
      50 11 * * * /usr/bin/wakeonlan 04:7c:16:cb:89:1d
      52 11 * * * ssh sednal@192.168.0.235 "shutdown /s /t 0 /f"
      
      #Bareos
      50 11 * * * /usr/bin/wakeonlan 30:b5:c2:01:63:1e
      
      #Proxmox
      50 11 * * * /usr/bin/wakeonlan 34:5a:60:e0:1c:72


### 2️⃣ Poweroff

#### ⚠️ Lancer poweroff avec `sudo` 

      sudo contab -e

#### Editer serveur Bareos `192.168.0.240`

      # Extinction
      10 12 * * * /sbin/poweroff








