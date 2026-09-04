# Fichier Jobs

---

### 1️⃣ LAN

#### 1.1) BackUp Win => /etc/bareos/bareos-dir.d/job/`Win_BackUp_Job_LAN.conf `

      Job {
        Name = Win_BackUp_Job_LAN
        Type = Backup
        Client = win
        FileSet = Win_BackUp_FileSet_LAN
        Schedule = Win_Schedule_LAN
        Storage = Storage_Local
        Pool = Win_BackUp_Pool_LAN
        Messages = Standard
        Priority = 10
        }

#### 1.2 Archive Win => /etc/bareos/bareos-dir.d/job/`Win_Archive_Job_LAN.conf`

        Job {
              Name = Win_Archive_Job_LAN
              Type = Backup
              Client = win
              FileSet = Win_Archive_FileSet_LAN
              Storage = Storage_Local
              Pool = Win_Archive_Pool_LAN
              Messages = Standard
              Priority = 10
              }

#### 1.3 BackUp Lin => /etc/bareos/bareos-dir.d/job/`Lin_BackUp_Job_LAN.conf`

````
Job {
      Name = Lin_BackUp_Job_LAN
      Type = Backup
      Client = lin
      FileSet = Lin_BackUp_FileSet_LAN
      Schedule = Lin_Schedule_LAN
      Storage = Storage_Local
      Pool = Lin_BackUp_Pool_LAN
      Messages = Standard
      Priority = 10
      RunBeforeJob = "/usr/bin/sudo -u sednal /home/sednal/pull_mail.sh"
      }
````

---

### 2️⃣

#### 2.1) BackUp Win => /etc/bareos/bareos-dir.d/job/`Win_BackUp_Job_WAN.conf`

         Job {
              Name = Win_BackUp_Job_WAN
              Type = Backup
              Client = win
              FileSet = Win_BackUp_FileSet_WAN
              Schedule = Win_Schedule_WAN
              Storage = Storage_Remote
              Pool = Win_Backup_Pool_WAN
              Messages = Standard
              Priority = 20
              }

`[NOTE]` `Priority = 20` (supérieure au 10 des jobs LAN) : le job WAN attend la fin
du job LAN sur le même client Windows au lieu d'entrer en concurrence avec lui.
Le job LAN peut durer jusqu'à 3h30 en incrémental.

#### 2.2 BackUp Lin => /etc/bareos/bareos-dir.d/job/`Lin_BackUp_Job_WAN.conf`

            Job {
              Name = Lin_BackUp_Job_WAN
              Type = Backup
              Client = lin
              FileSet = Lin_BackUp_FileSet_WAN
              Schedule = Lin_Schedule_WAN
              Storage = Storage_Remote
              Pool = Lin_BackUp_Pool_WAN
              Messages = Standard
              Priority = 10
              }

---

Job {
      Name = Lin_BackUp_Job_LAN
      Type = Backup
      Client = lin
      FileSet = Lin_BackUp_FileSet_LAN
      Schedule = Lin_Schedule_LAN
      Storage = Storage_Local
      Pool = Lin_BackUp_Pool_LAN
      Messages = Standard
      Priority = 10
      RunBeforeJob = "/usr/bin/sudo -u sednal /home/sednal/pull_mail.sh"
      }
