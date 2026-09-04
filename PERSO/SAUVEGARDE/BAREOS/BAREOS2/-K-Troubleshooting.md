# Liste des Problèmes réglé sur Bareos

---

=> Format

`=== DATE ===`

`=== PROBLEME ===`

`=== CAUSE ===`

`=== RESOLUTION ===`

---

# `=== DATE // ===`

---

### - [Lien_Rapide]()

---
---

## `Résumés Pannes`

### - Probléme de connection entre `bareos-dir` et `bareos-sd`  [Lien_Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/SAUVEGARDE/BAREOS/BAREOS2/-K-Troubleshooting.md#--impossible-pour-bareos-dir-et-bareos-sd-de-se-connecter-ensemble)

### - bareos-sd démarre puis s'arrête seul au bout de ~15s, sans erreur systemd [Lien_Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/SAUVEGARDE/BAREOS/BAREOS2/-K-Troubleshooting.md#--bareos-sd-d%C3%A9marre-puis-sarr%C3%AAte-seul-au-bout-de-15s-sans-erreur-systemd)

### - Probleme de connection Sata [Lien_Rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/SAUVEGARDE/BAREOS/BAREOS2/-K-Troubleshooting.md#--varlibbareosstorage-vide-et-mont%C3%A9-sur-la-racine--au-lieu-du-raid10) 

---
---




# `=== DATE 26/01/2026 ===`

---
---

### `=== PROBLEME ===`

#### - Impossible pour bareos-dir et bareos-sd de se connecter ensemble.

`message erreur:`

````
Connecting to Storage daemon Storage_Remote at 192.168.0.240:9103
Failed to connect to Storage daemon File.
````


#### - Échec de connection TLS 


`message erreur:`

````
Jan 25 14:18:47 bareos systemd[1]: Started bareos-storage.service - Bareos Storage Daemon service.
Jan 25 15:36:15 bareos bareos-sd[2925]: lib/tls_openssl_private.cc:421 Connect failure: ERR=error:0A0000FD:SSL routines::binder does not verify
Jan 25 15:36:15 bareos bareos-sd[2925]: lib/bnet.cc:125 TLS Negotiation failed.
````

##### Impossible de faire un backup ou archive en local.


[DOC dépannage](https://docs.bareos.org/Appendix/Troubleshooting.html#troubleshooting) et [DOC débug](https://docs.bareos.org/Appendix/Debugging.html)

la doc de débug va plus loins dans l'analyse notamment avec des outils comme `gdb`


---

1) Utilisation du [traceback](https://docs.bareos.org/Appendix/Debugging.html#traceback) :
Utilisation de la commande suivante pour Désactive les restrictions de sécurité => permettant ainsi à n'importe quel processus de déboguer/tracer n'importe quel autre processus sur le système.

EXPLICATION :
* Valeurs possibles :

   * 0 : Aucune restriction - n'importe quel processus peut tracer n'importe quel autre
   * 1 : Restriction modérée - seuls les processus parents peuvent tracer leurs enfants
   * 2+ : Restrictions plus strictes

Ici on va lui mettre 0 comme valeur :

````
test -e /proc/sys/kernel/yama/ptrace_scope && echo 0 > /proc/sys/kernel/yama/ptrace_scope
````

---

2) Utilisation de la commande `ps fax` :

EXPLICATION :
* ps : Affiche les processus
* f : Format arborescence (forest) 
* a : Tous les utilisateurs
* x : Inclut les processus sans terminal (daemons)

````
ps fax | grep bareos-dir
````

**Sortie :**

````
2186 pts/2    S+     0:00                      \_ grep bareos-dir
1098 ?        Ssl    0:02 /usr/sbin/bareos-dir -f
````

Donc on à maintenant le PID du processus : 1098

---

3) on peux à présent utiliser `btraceback `,  un utilitaire de Bareos qui génère une trace de pile (backtrace) pour diagnostiquer les crashes.

````
btraceback /usr/sbin/bareos-dir 2186
````

**Sortie :**

````
bsmtp: tools/bsmtp.cc:129-0 Fatal malformed reply from localhost: 501 <root>: sender address must contain a domain 
````

On à donc le problème => Déclaration DNS non conforme pour le `Bareos-sd`,étant donné que c'est lui qui pose problème. 
Lors du `status` dans `bconsole` il est le seul à présenter des problèmes.

---

4) confirmation avec `gdb` et le shell Bareos

Cette commande bascule vers l'utilisateur bareos avec un shell bash

````
su - bareos -s /bin/bash
````

Cette commande lance gdb (débogueur GNU) pour déboguer le daemon bareos-sd

EXPLICATION :

* /usr/sbin/bareos-sd : Le daemon de stockage Bareos
* Options de bareos-sd :

   * -f : Foreground - ne se daemonise pas (reste au premier plan)
   * -s : No signals - désactive la gestion des signaux (facilite le débogage)
   * -d 200 : Debug level 200 - active un niveau de verbosité très élevé    

````
gdb --args /usr/sbin/bareos-sd -f -s -d 200
(gdb) run
````

**Sortie:**

````
Local-Sd (10): lib/bnet_server_tcp.cc:246-0 ERROR: Cannot bind address 192.168.0.240 port 9103: ERR=Address already in use.
````

---
---

### `=== RESOLUTION ===`

1) Déclarer le nom de domain référencer sur pfsense dans bareos et rectifier l'erreur vu avec `gdb`

* Ajouter la ligne suivante dans  /etc/bareos/bareos-sd.d/storage/Local-Sd.conf

````
Address = bareos.sednal.lan
````

* Rééditer le fichier de configuration comme ci dessous
Suppression de => `Address = 192.168.0.240`

````
Storage {
      Name = Storage_Local
      SDPort = 9103
      SD Address = bareos.sednal.lan <= AJOUT
      Password = "fCQqLZbkIZ+IBMpXOWtCZWOjrnxuJWt9ApbKT6PW8U8n"
      Device = Local_Device
      Media Type = File
      }
````

2) Et pour finir, revenir à la configuration de `/proc/sys/kernel/yama/ptrace_scope` initiale

````
test -e /proc/sys/kernel/yama/ptrace_scope && echo 1 > /proc/sys/kernel/yama/ptrace_scope
````


---

**RESULTAT**

````
Connecting to Storage daemon Storage_Local at bareos.sednal.lan:9103
 Encryption: TLS_CHACHA20_POLY1305_SHA256 TLSv1.3

Local-Sd Version: 25.0.2~pre67.c4bf7e33b (21 January 2026) Debian GNU/Linux 13 (trixie)
Daemon started 26-Jan-26 14:41. Jobs: run=0, running=0, Bareos community binary
 Sizes: boffset_t=8 size_t=8 int32_t=4 int64_t=8 bwlimit=0kB/s
````


---
---
---

# `=== DATE 04/09/2026 ===`

---
---

### `=== PROBLEME ===`

#### - `bareos-sd` démarre puis s'arrête seul au bout de ~15s, sans erreur systemd.

`systemctl status bareos-sd :`

````
Active: inactive (dead)
Process: ExecStart=/usr/sbin/bareos-sd -f (code=exited, status=0/SUCCESS)
````

#### - Port 9103 absent de `ss -lntp`, le Director reste bloqué sur `status storage=Storage_Local`.

#### - `journalctl -u bareos-sd` ne remonte rien : l'arrêt est considéré comme normal par systemd.

---

1) Lancer le SD en avant-plan avec un niveau de debug élevé :

````
sudo -u bareos /usr/sbin/bareos-sd -f -d 200 2>&1 | tail -40
````

**Sortie :**

````
Local-Sd (100): lib/bnet_server_tcp.cc:141-0 Addresses host[ipv4;192.168.0.239;9103]
Local-Sd (10): lib/bnet_server_tcp.cc:210-0 WARNING: Cannot bind address 192.168.0.239 port 9103 ERR=Cannot assign requested address. Retrying...
Local-Sd (10): lib/bnet_server_tcp.cc:246-0 ERROR: Cannot bind address 192.168.0.239 port 9103: ERR=Cannot assign requested address.
````

2) Vérifier la résolution du nom déclaré dans `Address` :

````
getent hosts bareos.sednal.lan
````

**Sortie :**

````
192.168.0.239   bareos.sednal.lan
````

---
---

### `=== CAUSE ===`

Le nom `bareos.sednal.lan` a été réattribué au reverse proxy nginx `192.168.0.239`
lors de la mise en place de la PKI V2 (vhost WebUI Bareos).

Or ce même nom était utilisé depuis le 26/01/2026 dans `Address` du Storage SD,
qui indique au démon **sur quelle adresse locale se binder**.

Le SD tente donc de se binder sur une IP qui ne lui appartient pas → `Cannot assign
requested address` → arrêt du démon.

⚠️ Un nom DNS utilisé par un vhost du reverse proxy ne doit jamais servir de
`Address` à un démon Bareos.

---
---

### `=== RESOLUTION ===`

1) Créer un enregistrement DNS dédié au démon sur pfSense

````
bareos-sd.sednal.lan  ->  192.168.0.240
````

2) `/etc/bareos/bareos-sd.d/storage/Local-Sd.conf`

````
Storage {
      Name = Local-Sd
      SDPort = 9103
      Address = bareos-sd.sednal.lan
  }
````

3) `/etc/bareos/bareos-dir.d/storage/Storage_Local.conf`

````
Storage {
      Name = Storage_Local
      SD Address = bareos-sd.sednal.lan
      SDPort = 9103
      Password = "[PASSWORD]"
      Device = Local_Device
      Media Type = File
      }
````

4) Test et redémarrage

````
sudo bareos-sd -t -f && sudo bareos-dir -t -f
sudo systemctl restart bareos-sd bareos-dir
ss -lntp | grep 9103
````

**RESULTAT ATTENDU**

````
LISTEN 0  50  192.168.0.240:9103  0.0.0.0:*  users:(("bareos-sd",...))
````


---
---
---

### `=== DATE 04/09/2026 ===`

---
---

### `=== PROBLEME ===`

#### - `/var/lib/bareos/storage` vide et monté sur la racine `/` au lieu du RAID10.

````
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       109G  5.1G   98G   5% /
````

#### - Le volume group `vg_bareos` est incomplet, un PV est absent...

`sudo pvs -a :`

````
WARNING: Couldn't find device with uuid fXzPHv-2jBN-p33g-LYlo-G1dy-JL5q-FXLR9Y.
WARNING: VG vg_bareos is missing PV fXzPHv-2jBN-p33g-LYlo-G1dy-JL5q-FXLR9Y
/dev/sdb   vg_bareos lvm2 a--  931.51g    0
/dev/sdc   vg_bareos lvm2 a--  931.51g    0
/dev/sdd   vg_bareos lvm2 a--  931.51g    0
[unknown]  vg_bareos lvm2 a-m  931.51g    0
````

#### - Le LV `lv_Bareos` est en mode partiel et n'est pas activé au boot.

`sudo lvs -a :`

````
lv_Bareos            vg_bareos rwi---r-p-   <1.82t
[lv_Bareos_rimage_2] vg_bareos Iwi---r-p- <931.51g   [unknown](1)   partial <====
````

#### - Seuls 3 disques sur 4 sont énumérés par le noyau : `sde` est absent.

---

1) Identifier le port SATA en défaut :

````
sudo dmesg | grep -iE "ata[0-9]+:" | tail -30
````

**Sortie :**

````
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5: link is slow to respond, please be patient (ready=0)
ata5: found unknown device (class 0)
ata5: link online but 1 devices misclassified, retrying
ata5: softreset failed (1st FIS failed)
ata5: limiting SATA link speed to 1.5 Gbps
ata5: link online but 1 devices misclassified, device detection might fail
````

Les 3 ports sains montent en 0,5 s. `ata5` met 63 s et n'aboutit jamais.

2) Activer le VG en mode dégradé pour vérifier l'intégrité des données :

````
sudo vgchange -ay --activationmode degraded vg_bareos
sudo mount -o ro /dev/vg_bareos/lv_Bareos /mnt
ls -la /mnt
````

Les données sont intactes : en RAID10, la perte d'un leg sur quatre est tolérée.

3) Le rescan à chaud du contrôleur reste bloqué, confirmant un défaut physique :

````
echo "- - -" | sudo tee /sys/class/scsi_host/host4/scan
````

---
---

### `=== CAUSE ===`

Contact SATA défectueux sur le port `ata5`.

Le lien électrique s'établissait bien (`SATA link up 3.0 Gbps`), mais le disque ne
répondait jamais correctement au protocole ATA (`found unknown device (class 0)`,
`softreset failed`). Aucun périphérique `sdX` n'était donc créé.


---
---

### `=== RESOLUTION ===`

1) Arrêt propre avant intervention physique

````
sudo umount /var/lib/bareos/storage
sudo vgchange -an vg_bareos
sudo systemctl stop bareos-sd bareos-dir
sudo shutdown -h now
````

2) Machine hors tension et alimentation débranchée :
   débrancher puis rebrancher fermement le câble SATA data **et** le câble
   d'alimentation du disque sur `ata5`, des deux côtés.

3) Redémarrage et vérification

````
sudo dmesg | grep -iE "ata5|sde"
sudo pvs -a
df -h /var/lib/bareos/storage
````

**RESULTAT ATTENDU**

````
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-8: ST1000DM010-2EP102, CC43, max UDMA/133
ata5.00: configured for UDMA/133
sd 5:0:0:0: [sde] Attached SCSI disk

/dev/sdb   vg_bareos lvm2 a--  931.51g    0
/dev/sdc   vg_bareos lvm2 a--  931.51g    0
/dev/sdd   vg_bareos lvm2 a--  931.51g    0
/dev/sde   vg_bareos lvm2 a--  931.51g    0

/dev/mapper/vg_bareos-lv_Bareos  1.8T   37G  1.7T   3% /var/lib/bareos/storage
````

4) Surveiller les erreurs CRC du lien SATA. Si le compteur augmente, remplacer
   le câble même si le disque fonctionne.

````
sudo smartctl -A /dev/sde | grep -i UDMA_CRC_Error_Count
````
