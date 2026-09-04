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
              Address = 192.168.0.240
              SDPort = 9203
              Password = "[PASSWORD]"
              Device = Remote_Device
              Media Type = File
              }

`[NOTE]` L'adresse est celle du **tunnel SSH local**, pas celle du VPS.
Le port 9203 est le port d'entree du tunnel sur 192.168.0.240, redirige vers
le 9103 du SD distant. Voir [-A-Configuration §III](./-A-Configuration.md).
