# Configuration du fichier Pool pour le WAN et le LAN

[POOL-BAREOS](https://docs.bareos.org/Configuration/Director.html#pool-resource)

---
## 1️⃣ LAN

### 1.1) BackUp Win => /etc/bareos/bareos-dir.d/pool/`Win_BackUp_Pool_LAN`
      
      
      Pool {
      Name = Win_BackUp_Pool_LAN           
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


### 1.2) Archive Win => /etc/bareos/bareos-dir.d/pool/`Win_Archive_Pool_LAN.conf`

      Pool {
        Name = Win_Archive_Pool_LAN
        Label Format = "Local_Archive_Vol-"
        Pool Type = Backup
        Storage = Storage_Local
        Recycle = no
        AutoPrune = no
        Volume Retention = 9999 days
        Label Format = "Local_Archive_Vol-"
      }

#### 1.3) BackUp Lin /etc/bareos/bareos-dir.d/pool/`Lin_BackUp_Pool_LAN`
                  Pool {
                        Name = Lin_BackUp_Pool_LAN
                        Label Format = "Lin_Local_BackUp_Vol-"
                        Pool Type = Backup
                        Storage = Storage_Local
                        Recycle = yes
                        AutoPrune = yes
                        Purge Oldest Volume = yes
                        Volume Retention = 6 days
                        Maximum Volumes = 2
                        }

## 2️⃣ WAN

### 2.1) BackUp => /etc/bareos/bareos-dir.d/pool/` Win_Backup_Pool_WAN`

      Pool {
        Name =  Win_Backup_Pool_WAN
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


#### 2.3) BackUp Lin /etc/bareos/bareos-dir.d/pool/`Lin_BackUp_Pool_WAN`

                  
            Pool {
                  Name = Lin_BackUp_Pool_WAN
                  Label Format = "Lin_Remote_BackUp_Vol-"
                  Pool Type = Backup
                  Storage = Storage_Local
                  Recycle = yes
                  AutoPrune = yes
                  Purge Oldest Volume = yes
                  Volume Retention = 6 days
                  Maximum Volumes = 2
                  }                  





