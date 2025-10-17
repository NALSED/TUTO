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


