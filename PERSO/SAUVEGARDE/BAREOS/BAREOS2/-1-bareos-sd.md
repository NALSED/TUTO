# Configuration de Bareos-sd en WAN et LAN 

---

### 📝 Définition de `Storage` et `Device` dans Bareos:

## 📦 Storage
Le **Storage** est la **configuration logique** du démon de stockage (`bareos-sd`).  
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

#### En résumé
                  
### 🧭 Plan synoptique Bareos

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
              │   Storage Daemon (SD1)   │      │   Storage Daemon (SD2)   │
              │      176.31.163.227      │      │      192.168.0.240       │
              ├──────────────────────────┤      ├──────────────────────────┤
              │  Nom : Storage-SiteA     │      │  Nom : Storage-SiteB     │
              │  Port : 9103             │      │  Port : 9103             │
              │  Device = Device-SiteA   │      │  Device = Device-SiteB   │
              └────────────┬─────────────┘      └────────────┬─────────────┘
                           │                                │
                     Référence externe                Référence interne
                           │                                │
                           ▼                                ▼
              ┌──────────────────────────┐      ┌──────────────────────────┐
              │         DEVICE           │      │         DEVICE           │
              │   Name = Device-SiteA    │      │   Name = Device-SiteB    │
              │   Media = File           │      │   Media = File           │
              │   Stockage :             │      │   Stockage :             │
              │   Disque sda – 200 Go    │      │   RAID10 – LVM local     │
              │   (VPS distant)          │      │   (Serveur local)        │
              └──────────────────────────┘      └──────────────────────────┘

---

## I) Régles à respecter
* #### 1.1) `Un seul Director` : Le Director possède un nom unique (bareos-dir) et un mot de passe unique, utilisé par tous les SD.
* #### 1.2) SD local et SD distant : Storage côté SD ne contient pas Device ni Media Type.
        Storage {
            Name = storage_local
            SDPort = 9103
        }

* #### 1.3) Chaque SD définit ses Devices
* #### 1.4) Il faut que le nomdre de storage créé corespondent au  nom de storage déclaré dans le bareos-dir dans /etc/bareos/bareos-dir.d/storage. Sinon conflit!


## II) Arborécence de fichier pour bareos-SD(avec un SD  local et un distant)
#### Ici  l'exemple est fait à partir d'une  VM mais le  principe est  le même avec le tunel ssh pour accéder au VPS en WAN        
          
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

### 1️⃣ `Device`


### 2️⃣ `Storage`



