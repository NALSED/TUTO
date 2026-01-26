#  Fichier Storage

---
### 1️⃣ LAN => /etc/bareos/bareos-dir.d/storage/`Storage_Local.conf`
      
      Storage {
              Name = Storage_Local
              Address = 192.168.0.240
              SDPort = 9103
              Password = "fCQqLZbkIZ+IBMpXOWtCZWOjrnxuJWt9ApbKT6PW8U8n"
              Device = Locale_Device
              Media Type = File
              }

### 2️⃣ WAN => /etc/bareos/bareos-dir.d/storage/`Storage_Remote.conf`
      
      Storage {
              Name = Storage_Remote
              Address = 176.31.163.227
              SDPort = 9103
              Password = "fCQqLZbkIZ+IBMpXOWtCZWOjrnxuJWt9ApbKT6PW8U8n"
              Device = Remote_Device
              Media Type = File
              }
