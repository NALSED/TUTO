# Configuration du fichier Pool pour le WAN et le LAN

[POOL-BAREOS](https://docs.bareos.org/Configuration/Director.html#pool-resource)

---
## 1️⃣ LAN

### 1.1) BackUp => /etc/bareos/bareos-dir.d/pool/`BackUp_Pool_LAN`
      
      
      Pool {
      Name = BackUp_Pool_LAN             
      Label Format = "Local_BackUp_Vol-"   
      Pool Type = Backup
      Storage = Storage_Local
      Recycle = yes
      AutoPrune = yes
      Maximum Volume Bytes = 680G
      Purge Oldest Volume = yes
      Volume Retention = 6 days
      Maximum Volumes = 2
      }


### 1.2) Archive => /etc/bareos/bareos-dir.d/pool/`Archive_Pool_LAN.conf`

      Pool {
        Name = Archive_Pool_LAN.conf
        Pool Type = Archive
        Recycle = no
        AutoPrune = no
        Volume Retention = 9999 days
        Label Format = "Local_Archive_Vol-"
      }

## 2️⃣ WAN

### 2.1) BackUp => /etc/bareos/bareos-dir.d/pool/`Backup_Pool_WAN`

      Pool {
        Name = Backup_Pool_WAN
        Label Format = "VPS_Backup_Vol-"
        Pool Type = Backup
        Storage = Storage_Remote
        Recycle = yes
        AutoPrune = yes
        Maximum Volume Bytes = 190G
        Purge Oldest Volume = yes
        Volume Retention = 29 days
        Maximum Volumes = 2
      
      }



