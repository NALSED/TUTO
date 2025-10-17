# Configuration du fichier Pool pour le WAN et le LAN

[POOL-BAREOS]

---
## 1️⃣ LAN

### 1.1) BackUp => /etc/bareos/bareos-dir.d/pool/`Local_BackUp_Pool.conf`
      
      
      Pool {
      Name = Local_BackUp_Pool             
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


### 1.2) Archive => /etc/bareos/bareos-dir.d/pool/`Local_Archive_Pool.conf`

      Pool {
        Name = Local_Archive_Pool
        Pool Type = Archive
        Recycle = no
        AutoPrune = no
        Volume Retention = 9999 days
        Label Format = "Local_Archive_Vol-"
      }

## 2️⃣ WAN

### 2.1) BackUp => /etc/bareos/bareos-dir.d/pool/`VPS_Backup_Pool.conf`

      Pool {
        Name = VPS_Backup_Pool
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



