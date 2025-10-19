# Configuration du  Fichier      

---   
## 1️⃣ LAN

### 1.1) BackUp WIN =>  /etc/bareos/bareos-dir.d/schedule/`Win_Schedule_LAN.conf`

      Schedule {
          Name = Win_Schedule_LAN
      
          # Full chaque 1er dimanche du mois
          Run = Full 1st sun at 12:10
      
          # Incrémental les autres dimanches
          Run = Incremental 2nd-5th sun at 12:10
          }

### 1.2) BackUp Linux => /etc/bareos/bareos-dir.d/schedule/`Lin_Schedule_LAN.conf`
      
      Schedule {
        Name = Local_Lin_Schedule

        Run = Full 1st sun jan mar may jul sep nov at 12:00

        }
## 2️⃣ WAN        

### 1.1) BackUp WIN =>  /etc/bareos/bareos-dir.d/schedule/` Win_Schedule_WAN.conf`
      Schedule {
        Name =  Win_Schedule_WAN

        Run = Full 1st sun jan mar may jul sep nov at 14:00
        Run = Incremental 1st sun feb apr jun aug oct dec 14:00

        }
