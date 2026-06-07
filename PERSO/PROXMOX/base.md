# Configuration et Administration de base de **Proxmox**

---

- Suite à l'intallation de proxmox, suivre le cours de [Stéphane Robert](https://blog.stephane-robert.info/docs/virtualiser/type1/proxmox/fondamentaux/interface-ui/), pour avoir les bases de proxmox.

---

[INTRO]

Proxmox fonctionne selon 3 niveaux :

- Data Center

- Node

- Guest

```
┌─────────────────────────────────────────────────────────┐
│                     DATACENTER                          │
│  Niveau logique global — vue d'ensemble du cluster      │
│                                                         │
│  - Gestion des utilisateurs et permissions (RBAC)       │
│  - Config réseau partagée (SDN)                         │
│  - Stockage partagé (Ceph, NFS, etc.)                   │
│  - Haute dispo (HA) entre les nodes                     │
│  - Backup jobs globaux                                  │
│  - Firewall global                                      │
├─────────────────────────────────────────────────────────┤
│                       NODE                              │
│  Serveur physique — l'hyperviseur                       │
│                                                         │
│  - Ressources réelles : CPU, RAM, disques               │
│  - Stockage local (LVM, ZFS, ext4...)                   │
│  - Réseau local (bridges, bonds, VLANs)                 │
│  - Firewall node                                        │
│  - Shell direct (accès root à la machine)               │
├─────────────────────────────────────────────────────────┤
│                      GUEST                              │
│  VM ou CT — ce qui tourne sur le node                   │
│                                                         │
│  - VM  : machine virtuelle complète (noyau propre)      │
│  - CT  : conteneur LXC (partage le noyau du node)       │
│  - Config propre : CPU, RAM, disque, réseau             │
│  - Firewall guest                                       │
└─────────────────────────────────────────────────────────┘
```

---

### `VM`

**Télécharger**

Avant de pouvoir installer un `vm`, il faut se procurer l'iso.

Plusieurs options (exemple avec Ubuntu 22.04):

- Télécharger l'iso depuis le site
```
https://releases.ubuntu.com/jammy/
```

-  Télécharger depuis proxmox
```
# Se rendre sur le node, Stockage local (ce qui corespond à l'espace disque dédié à proxmox) 
# ISO Images -> Dowload from URL
```


-  Depuis le shell avec `wget`
```
cd /var/lib/vz/template/iso
wget https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso
```

**Installer**

- Onglet `Create VM` en haut à droite.

















