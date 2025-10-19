# Fichier Jobs

---

### 1️⃣ LAN

#### 1.1) BackUp Win => /etc/bareos/bareos-dir.d/job/`Win_BachUp_Job_LAN`

      Job {
        Name = Win_BachUp_Job_LAN
        Type = Backup
        Client = win
        FileSet = Win_BackUp_FileSet_LAN
        Schedule = Win_Schedule_LAN
        Storage = Storage_Local
        Pool = BackUp_Pool_LAN
        Messages = Standard
        Priority = 10
        }

#### 1.2 Archive Win => /etc/bareos/bareos-dir.d/job/`Win_Archive_Job_LAN`

        Job {
              Name = Win_Archive_Job_LAN
              Type = Archive
              Client = win
              FileSet = Win_Archive_FileSet_LAN
              Storage = Storage_Local
              Pool = Archive_Pool_LAN
              Messages = Standard
              Priority = 10
              }

---

### 2️⃣

#### 2.1) BackUp Win => /etc/bareos/bareos-dir.d/job/`Win_BackUp_Job_WAN`
         Job {
              Name = Win_BackUp_Job_WAN
              Type = Backup
              Client = win
              FileSet = Win_BackUp_FileSet_WAN
              Storage = Storage_Remote
              Pool = Backup_Pool_WAN
              Messages = Standard
              Priority = 10
              }



