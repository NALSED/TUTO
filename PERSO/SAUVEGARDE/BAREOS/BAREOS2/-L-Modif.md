# Liste des modification aporté sur bareos

---

### `=== DATE ===`

---

### `=== DATE : 26/01/2026 ===`



      /etc/bareos/bareos-sd.d/storage/Local-Sd.conf
      ===> Address = bareos.sednal.lan
      
      -----------------------------------------
      === AJOUT === >SD Address = bareos.sednal.lan
      
      /etc/bareos/bareos-dir.d/storage/Storage_Local.conf
      ===> SD Address = bareos.sednal.lan 
      
      
      
      Storage {
              Name = Storage_Local
              Address = 192.168.0.240
              SDPort = 9103
              SD Address = bareos.sednal.lan
              Password = "fCQqLZbkIZ+IBMpXOWtCZWOjrnxuJWt9ApbKT6PW8U8n"
              Device = Local_Device
              Media Type = File
              }
      
      
      === RETRAIT === => Address = 192.168.0.240 
      
      Storage {
              Name = Storage_Local
              SDPort = 9103
              SD Address = bareos.sednal.lan
              Password = "fCQqLZbkIZ+IBMpXOWtCZWOjrnxuJWt9ApbKT6PW8U8n"
              Device = Local_Device
              Media Type = File
              }
      
      === SUPPRESSION ===
      Seppression des deux fichiers suivant :
      
      /etc/bareos/bareos-dir.d/backup
      File.conf  File.conf.example
      
      
      Storage {
        Name = File
        Address = serveur                # N.B. Use a fully qualified name here (do not use "localhost" here).
        Password = "2IL44b8thALybotdvvPRXknA3plw8ijCs7tX255ugr33"
        Device = FileStorage
        Media Type = File
      }
      Storage {
        Name = File       # Same name to replace the default single File storage
        Description = "virtual file autochanger with autonumbered device"
        Address = serveur                # N.B. Use a fully qualified name here (do not use "localhost" here).
        Password = "2IL44b8thALybotdvvPRXknA3plw8ijCs7tX255ugr33"
        Device = FileStorage
        Media Type = File
        # Better to keep this synchronized with storage->device->vfile Count parameters
        Maximum Concurrent Jobs = 10
      }
