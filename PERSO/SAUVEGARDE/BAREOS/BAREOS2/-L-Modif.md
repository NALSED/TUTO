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

==============================================================================================

==============================================================================================


### `=== DATE === : 20/10/2026`

========== VERSION VAULT OBSOLETE (04/09/2026) ==========

**Congiguration PKI Vault** 
```
https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/-2-HOMELAB/PKI/-3-%20Configuration_Client.md#serveur-bareos--1921680240
```
========== VERSION VAULT OBSOLETE (04/09/2026) ==========

==============================================================================================


### ### `=== DATE === : 04/09/2026`

MAJ de la PKI (la V1 ci dessus n'est plus d'actualité voir), la V2 à un impact sur Bareos. [Vault_V2](https://github.com/NALSED/TUTO/tree/main/PERSO/VAULT/HOMELAB)

==============================================================================================

==============================================================================================


### `=== DATE : 04/09/2026 ===`

      /etc/bareos/bareos-sd.d/storage/Local-Sd.conf
      === RETRAIT ===  Address = bareos.sednal.lan
      === AJOUT   ===  Address = bareos-sd.sednal.lan

      /etc/bareos/bareos-dir.d/storage/Storage_Local.conf
      === RETRAIT ===  SD Address = bareos.sednal.lan
      === AJOUT   ===  SD Address = bareos-sd.sednal.lan

      DNS pfSense
      === AJOUT   ===  bareos-sd.sednal.lan -> 192.168.0.240

      Motif : bareos.sednal.lan est désormais le vhost nginx du reverse proxy
      192.168.0.239 (WebUI Bareos, PKI V2). Ce nom ne peut plus servir de
      Address au démon bareos-sd.

==============================================================================================

==============================================================================================


### `=== DATE : 04/09/2026 ===`

      Materiel — HP ProLiant Gen8
      === AJOUT === Recablage SATA data + alimentation du disque sur le port ata5

      Aucune modification de fichier de configuration.

      Motif : contact SATA defectueux sur ata5, disque non enumere par le noyau,
      PV fXzPHv-2jBN-p33g-LYlo-G1dy-JL5q-FXLR9Y manquant dans vg_bareos,
      lv_Bareos non active au boot et /var/lib/bareos/storage monte sur la racine.
