# Configuration de Bareos-sd en WAN et LAN 

[DEVICE-BAREOS](https://docs.bareos.org/Configuration/StorageDaemon.html#device-resource)

[STORAGE-BAREOS](https://docs.bareos.org/Configuration/Director.html#storage-resource)

---

### 📝 Définition de `Storage` et `Device` dans Bareos:

## 📦 Storage
Le **Storage** est la **configuration logique** de `bareos-sd`.  
C’est **l’interface réseau** par laquelle le **Director** communique avec le **Storage Daemon**.

### Il définit :
- Le **nom** du stockage  
- Le **port d’écoute** (`SDPort`)  
- Les **devices** qu’il utilise  
- Les **paramètres réseau** (adresse, mot de passe, etc.)

## 💽 Device
Le **Device** définit le **périphérique physique ou logique** utilisé par le Storage Daemon pour **écrire les sauvegardes**.

### Il indique :
- Le **chemin d’accès** au support (ex. `/var/lib/bareos/storage`)  
- Le **type de média** (`File`, `Tape`, etc.)  
- Les **options d’accès** (montage automatique, lecture/écriture aléatoire, etc.)


                  
### 🧭 Plan Synoptique Bareos LAN/WAN

                             ┌──────────────────────────┐
                             │        Director          │
                             +--------------------------+
                             │       192.168.0.240      │
                             └────────────┬─────────────┘
                                          │
                          ┌───────────────┼────────────────┐
                          │                                │
                  Connexion réseau WAN          Connexion réseau LAN
                          │                                │
                          ▼                                ▼
                      Tunnel SSH
              ┌──────────────────────────┐      ┌──────────────────────────┐
              │      Storage_Remote      │      │      Storage_Local       │
              │      176.31.163.227      │      │      192.168.0.240       │
              ├──────────────────────────┤      ├──────────────────────────┤
              │  Nom : Remote_Sd         │      │  Nom : Local_Sd          │
              │  Port : 9103             │      │  Port : 9103             │
              │  Device = Remote_Device  │      │  Device = Local_Device   │
              └────────────┬─────────────┘      └────────────┬─────────────┘
                           │                                 │
                     Référence externe                 Référence interne
                           │                                 │
                           ▼                                 ▼
              ┌──────────────────────────┐      ┌──────────────────────────┐
              │         DEVICE           │      │         DEVICE           │
              │   Name = Remote_Device   │      │   Name = Local_Device    │
              │   Media = File           │      │   Media = File           │
              │   Stockage :             │      │   Stockage :             │
              │   Disque sda – 200 Go    │      │   RAID10 – LVM RAID 10   │
              │      (VPS distant)       │      │     (Serveur local)      │
              └──────────────────────────┘      └──────────────────────────┘

---
<details>
<summary>
<h2>
I) Règles à respecter
</h2>
</summary>

* #### 1.1) `Un seul Director` : Le Director possède un nom unique (bareos-dir) et un mot de passe unique, utilisé par tous les SD.
* #### 1.2) SD local et SD distant : Storage côté SD ne contient pas Device ni Media Type.

      Storage {
                Name = storage_local
                SDPort = 9103
            }

* #### 1.3) Chaque SD définit ses Devices
* #### 1.4) Il faut que le nombre de storage créé corespondent au  nom de storage déclaré dans le bareos-dir dans /etc/bareos/bareos-dir.d/storage. Sinon conflit!


## II) Arborescence de fichier pour bareos-SD(avec un SD  local et un distant)
#### Ici  l'exemple est fait à partir d'une  VM mais le  principe est  le même avec le tunnel ssh pour accéder au VPS en WAN        
          
          Bareos Director (192.168.0.240)
          ├── /etc/bareos/bareos-dir.d/storage/
          │   ├── local_sto.conf         # Référence Storage local + Device local
          │   │   Storage {
          │   │       Name = storage_local
          │   │       Address = 192.168.0.240
          │   │       SDPort = 9103
          │   │       Password = "motdepasse_unique"
          │   │       Device = FileStorage
          │   │       Media Type = File
          │   │   }
          │   └── remote_sto.conf        # Référence Storage distant + Device distant
          │       Storage {
          │           Name = storage_remote
          │           Address = 192.168.0.101
          │           SDPort = 9103
          │           Password = "motdepasse_unique"
          │           Device = RemoteStorage
          │           Media Type = File
          │       }
          
          Storage Daemon Local (192.168.0.240)
          ├── /etc/bareos/bareos-sd.d/
          │   ├── director/
          │   │   └── bareos-dir.conf       # Password du Director (motdepasse_unique)
          │   ├── storage/
          │   │   └── local_sd.conf         # Storage { Name = storage_local; SDPort = 9103 }
          │   └── device/
          │       └── FileStorage.conf      # Device local
          │           Device {
          │               Name = FileStorage
          │               Media Type = File
          │               Archive Device = /var/lib/bareos/storage
          │               Label Media = yes
          │               Random Access = yes
          │               Automatic Mount = yes
          │               Removable Media = no
          │               Always Open = no
          │               Description = "Device local pour SD local"
          │           }
          
          Storage Daemon Distant (192.168.0.101)
          ├── /etc/bareos/bareos-sd.d/
          │   ├── director/
          │   │   └── bareos-dir.conf       # Password du Director (motdepasse_unique)
          │   ├── storage/
          │   │   └── remote_sd.conf        # Storage { Name = storage_remote; SDPort = 9103 }
          │   └── device/
          │       └── RemoteStorage.conf    # Device distant
          │           Device {
          │               Name = RemoteStorage
          │               Media Type = File
          │               Archive Device = /var/lib/bareos
          │               Label Media = yes
          │               Random Access = yes
          │               Automatic Mount = yes
          │               Removable Media = no
          │               Always Open = no
          │               Description = "Device distant pour SD distant"
          │           }


#### En résumé
          # Fichiers à renseigner pour Bareos avec SD local et distant

          ## SD local (192.168.0.240)
          - `/etc/bareos/bareos-sd.d/device/FileStorage.conf`
          - `/etc/bareos/bareos-sd.d/storage/local_sd.conf`
          - `/etc/bareos/bareos-sd.d/director/bareos-dir.conf`
          
          ## SD distant (192.168.0.101)
          - `/etc/bareos/bareos-sd.d/device/RemoteStorage.conf`
          - `/etc/bareos/bareos-sd.d/storage/remote_sd.conf`
          - `/etc/bareos/bareos-sd.d/director/bareos-dir.conf`
          
          ## Director (192.168.0.240)
          - `/etc/bareos/bareos-dir.d/storage/local_sto.conf`
          - `/etc/bareos/bareos-dir.d/storage/remote_sto.conf`


</details>



---
##### ICI Utilisation du mot de passe unique présent dans  /etc/bareos/bareos-sd.d/director/bareos-dir.conf => 192.168.0.240

# 1️⃣ `Fichier Device + Storage + Director LAN et WAN`


## I) === `Locale` 192.168.0.240 ===


<details>
<summary>
<h2>
 Rappel config LAN Storage
</h2>
</summary>

        NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
        sda                         8:0    0 111.8G  0 disk
        ├─sda1                      8:1    0 110.8G  0 part /
        ├─sda2                      8:2    0     1K  0 part
        └─sda5                      8:5    0   975M  0 part [SWAP]
        sdb                         8:16   0 931.5G  0 disk
        ├─Serveur-Bareos_rmeta_0  254:0    0     4M  0 lvm
        │ └─Serveur-Bareos        254:8    0   700G  0 lvm  /var/lib/bareos/storage
        ├─Serveur-Bareos_rimage_0 254:1    0   350G  0 lvm
        │ └─Serveur-Bareos        254:8    0   700G  0 lvm  /var/lib/bareos/storage
        └─Serveur-Plex_rimage_0   254:9    0    75G  0 lvm
          └─Serveur-Plex          254:11   0   150G  0 lvm
        sdc                         8:32   0 931.5G  0 disk
        ├─Serveur-Bareos_rmeta_1  254:2    0     4M  0 lvm
        │ └─Serveur-Bareos        254:8    0   700G  0 lvm  /var/lib/bareos/storage
        ├─Serveur-Bareos_rimage_1 254:3    0   350G  0 lvm
        │ └─Serveur-Bareos        254:8    0   700G  0 lvm  /var/lib/bareos/storage
        └─Serveur-Plex_rimage_1   254:10   0    75G  0 lvm
          └─Serveur-Plex          254:11   0   150G  0 lvm
        sdd                         8:48   0 931.5G  0 disk
        ├─Serveur-Bareos_rmeta_2  254:4    0     4M  0 lvm
        │ └─Serveur-Bareos        254:8    0   700G  0 lvm  /var/lib/bareos/storage
        └─Serveur-Bareos_rimage_2 254:5    0   350G  0 lvm
          └─Serveur-Bareos        254:8    0   700G  0 lvm  /var/lib/bareos/storage
        sde                         8:64   0 931.5G  0 disk
        ├─Serveur-Bareos_rmeta_3  254:6    0     4M  0 lvm
        │ └─Serveur-Bareos        254:8    0   700G  0 lvm  /var/lib/bareos/storage
        └─Serveur-Bareos_rimage_3 254:7    0   350G  0 lvm
          └─Serveur-Bareos        254:8    0   700G  0 lvm  /var/lib/bareos/storage

#### Droit sur /var/lib/bareos/storage
      total 16
      drwxr-x--- 2 bareos bareos 16384 Oct 17 10:54 lost+found

#### /etc/fstab
    #Point de montage Bareos
    UUID=ef12d012-9b37-44e4-9058-5a1995567243  /var/lib/bareos/storage  ext4  defaults  0  2
    
</details>

### 1.1) /etc/bareos/bareos-sd.d/device/`Local_Device.conf`
      
      Device {
        Name = Local_Device
        Media Type = File
        Archive Device = /var/lib/bareos/storage
        Label Media = yes
        Random Access = yes
        Automatic Mount = yes
        Removable Media = no
        Always Open = no
        Description = "File Device local utilisant le RAID10 LVM /var/lib/bareos/storage."
      }


### 1.2) /etc/bareos/bareos-sd.d/storage/`Local_Sd.conf`

      Storage {
          Name = Local-Sd
          SDPort = 9103
      }

### 1.3 /etc/bareos/bareos-sd.d/director/`bareos-dir.conf`

      Director {
        Name = bareos-dir
        Password = "[PASSWORD]"
        Description = "Director, who is permitted to contact this storage daemon."
      }

---


## II) === `Distant` 176.31.163.227 ===

<details>
<summary>
<h2>
 Rappel config WAN Storage
</h2>
</summary>


      NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
      sda       8:0    0   75G  0 disk
      ├─sda1    8:1    0 74.9G  0 part /
      ├─sda14   8:14   0    3M  0 part
      └─sda15   8:15   0  124M  0 part /boot/efi
      sdb       8:16   0  200G  0 disk
      └─sdb1    8:17   0  200G  0 part /var/lib/bareos/storage

#### Droit sur /var/lib/bareos/storage
      total 16
      drwxr-x--- 2 bareos bareos 16384 Oct 17 11:30 lost+found

#### /etc/fstab
      UUID=709584d8-4d56-440a-9a81-76c59a6ef34e /var/lib/bareos/storage  ext4  defaults  0  2

</details>


### 2.1) /etc/bareos/bareos-sd.d/device/`Remote_Device.conf`
      Device {
              Name = Remote_Device
              Media Type = File
              Archive Device = /var/lib/bareos/storage
              Label Media = yes
              Random Access = yes
              Automatic Mount = yes
              Removable Media = no
              Always Open = no
              Description = "File Device Remote utilisant dans le VPS => sdb1 /var/lib/bareos/storage."
            }


### 1.2) /etc/bareos/bareos-sd.d/storage/`Remote_Sd.conf`
      Storage {
              Name =  Remote_Sd
              SDPort = 9103
          }

### 1.3 /etc/bareos/bareos-sd.d/director/
      Director {
        Name = bareos-dir
        Password = "[PASSWORD]"
        Description = "Director, who is permitted to contact this storage daemon."
      }


##

### 2.1) /etc/bareos/bareos-dir.d/storage/`Storage_Local.conf`

      Storage {
              Name = Storage_Local
              Address = 192.168.0.240
              SDPort = 9103
              Password = "fCQqLZbkIZ+IBMpXOWtCZWOjrnxuJWt9ApbKT6PW8U8n"
              Device =  Local_Device
              Media Type = File
              }

### 2.2) /etc/bareos/bareos-dir.d/storage/`Storage_Remote.conf`

      Storage {
              Name = Storage_Remote
              Address = 176.31.163.227
              SDPort = 9103
              Password = "fCQqLZbkIZ+IBMpXOWtCZWOjrnxuJWt9ApbKT6PW8U8n"
              Device = Remote_Device
              Media Type = File
              }

---


### Redemmarage service + Test
      
      sudo -u bareos /usr/sbin/bareos-sd -t
      sudo -u bareos /usr/sbin/bareos-dir -t
      sudo systemctl restart bareos-sd
      sudo systemctl restart bareos-dir
      sudo systemctl status bareos-sd --no-pager
      sudo systemctl status bareos-dir --no-pager

### Résultat attendu

### Tout les services en vert et actifs et bconsole ⬇️

#### `Local`

<img width="584" height="158" alt="image" src="https://github.com/user-attachments/assets/53ae026f-1d49-4978-a2ab-c08672622269" />

#### `Remote`

<img width="608" height="159" alt="image" src="https://github.com/user-attachments/assets/70b9a449-d74f-4951-a2f7-b57e9d0b0efc" />









