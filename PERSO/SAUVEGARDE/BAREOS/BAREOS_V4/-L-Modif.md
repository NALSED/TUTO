# Journal des modifications Bareos

---

Chaque entrée suit la même structure :

````
x.1  Fichier / élément concerné
x.2  Retrait   ce qui a été supprimé
x.3  Ajout     ce qui a été mis à la place
x.4  Motif     pourquoi
````

---

## `-0-` Sommaire

| N°  | Date       | Modification                                              | Portée      |
| --- | ---------- | --------------------------------------------------------- | ----------- |
| 1   | 26/01/2026 | [Passage de Address IP à SD Address DNS](#-1--passage-de-address-ip-à-sd-address-dns) | Storage     |
| 2   | 20/10/2026 | [Configuration PKI Vault V1 — obsolète](#-2--configuration-pki-vault-v1--obsolète) | PKI         |
| 3   | 04/09/2026 | [Mise à jour de la PKI en V2](#-3--mise-à-jour-de-la-pki-en-v2) | PKI         |
| 4   | 04/09/2026 | [Renommage du DNS du démon en bareos-sd.sednal.lan](#-4--renommage-du-dns-du-démon-en-bareos-sdsednallan) | Storage / DNS |
| 5   | 04/09/2026 | [Recâblage SATA du port ata5](#-5--recâblage-sata-du-port-ata5) | Matériel    |

---

## `-1-` Passage de Address IP à SD Address DNS

`Date : 26/01/2026`

### `- 1.1` Fichiers concernés

````
/etc/bareos/bareos-sd.d/storage/Local-Sd.conf
/etc/bareos/bareos-dir.d/storage/Storage_Local.conf
````

### `- 1.2` Retrait

````
Address = 192.168.0.240
````

### `- 1.3` Ajout

````
SD Address = bareos.sednal.lan
````

Le fichier `Storage_Local.conf` devient :

````
Storage {
    Name = Storage_Local
    SDPort = 9103
    SD Address = bareos.sednal.lan
    Password = "[PASSWORD]"
    Device = Local_Device
    Media Type = File
}
````

### `- 1.4` Suppression des fichiers par défaut

````
/etc/bareos/bareos-dir.d/backup/File.conf
/etc/bareos/bareos-dir.d/backup/File.conf.example
````

Contenu supprimé :

````
Storage {
    Name = File
    Address = serveur          # N.B. Use a fully qualified name here (do not use "localhost").
    Password = "[PASSWORD]"
    Device = FileStorage
    Media Type = File
}

Storage {
    Name = File                # Same name to replace the default single File storage
    Description = "virtual file autochanger with autonumbered device"
    Address = serveur          # N.B. Use a fully qualified name here (do not use "localhost").
    Password = "[PASSWORD]"
    Device = FileStorage
    Media Type = File
    # Better to keep this synchronized with storage->device->vfile Count parameters
    Maximum Concurrent Jobs = 10
}
````

### `- 1.5` Motif

Résolution de la panne n°1 du
[journal des pannes](./-K-Troubleshooting.md#-1--connexion-impossible-entre-bareos-dir-et-bareos-sd).

---

## `-2-` Configuration PKI Vault V1 — obsolète

`Date : 20/10/2026`

⚠️ `[ATTENTION]` ⚠️

Version obsolète depuis le 04/09/2026, conservée pour historique.
Voir l'entrée n°3.

### `- 2.1` Référence

````
https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/-2-HOMELAB/PKI/-3-%20Configuration_Client.md#serveur-bareos--1921680240
````

---

## `-3-` Mise à jour de la PKI en V2

`Date : 04/09/2026`

### `- 3.1` Modification

Mise à jour de la PKI. La V1 (entrée n°2) n'est plus d'actualité, la V2 a un impact
sur Bareos.

### `- 3.2` Référence

[Vault_V2](https://github.com/NALSED/TUTO/tree/main/PERSO/VAULT/HOMELAB)

---

## `-4-` Renommage du DNS du démon en bareos-sd.sednal.lan

`Date : 04/09/2026`

### `- 4.1` Fichiers concernés

````
/etc/bareos/bareos-sd.d/storage/Local-Sd.conf
/etc/bareos/bareos-dir.d/storage/Storage_Local.conf
DNS pfSense
````

### `- 4.2` Retrait

````
Local-Sd.conf       Address    = bareos.sednal.lan
Storage_Local.conf  SD Address = bareos.sednal.lan
````

### `- 4.3` Ajout

````
Local-Sd.conf       Address    = bareos-sd.sednal.lan
Storage_Local.conf  SD Address = bareos-sd.sednal.lan
DNS pfSense         bareos-sd.sednal.lan -> 192.168.0.240
````

### `- 4.4` Motif

`bareos.sednal.lan` est désormais le vhost nginx du reverse proxy `192.168.0.239`
(WebUI Bareos, PKI V2). Ce nom ne peut plus servir d'`Address` au démon `bareos-sd`.

Détail dans le
[journal des pannes](./-K-Troubleshooting.md#-2--bareos-sd-sarrête-seul-au-bout-de-15-secondes).

---

## `-5-` Recâblage SATA du port ata5

`Date : 04/09/2026`

### `- 5.1` Élément concerné

````
Matériel — HP ProLiant Gen8
````

### `- 5.2` Ajout

Recâblage SATA data + alimentation du disque sur le port `ata5`.

Aucune modification de fichier de configuration.

### `- 5.3` Motif

Contact SATA défectueux sur `ata5` : disque non énuméré par le noyau,
PV `fXzPHv-2jBN-p33g-LYlo-G1dy-JL5q-FXLR9Y` manquant dans `vg_bareos`,
`lv_Bareos` non activé au boot et `/var/lib/bareos/storage` monté sur la racine.

Détail dans le
[journal des pannes](./-K-Troubleshooting.md#-3--point-de-montage-raid10-absent-port-sata-défectueux).
