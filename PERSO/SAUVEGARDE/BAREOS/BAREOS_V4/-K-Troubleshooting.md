# Journal des pannes Bareos

---

Chaque panne est documentée selon la même structure :

````
x.1  Symptômes      ce qui est constaté
x.2  Diagnostic     les commandes qui ont permis de remonter à la cause
x.3  Cause          la cause racine, en une phrase
x.4  Résolution     les actions correctives
x.5  Résultat       la sortie attendue une fois corrigé
````

---

## `-0-` Sommaire

| N°  | Date       | Panne                                                     | Composant  |
| --- | ---------- | --------------------------------------------------------- | ---------- |
| 1   | 26/01/2026 | [Connexion impossible entre bareos-dir et bareos-sd](#-1--connexion-impossible-entre-bareos-dir-et-bareos-sd) | Réseau / DNS |
| 2   | 04/09/2026 | [bareos-sd s'arrête seul au bout de 15 secondes](#-2--bareos-sd-sarrête-seul-au-bout-de-15-secondes) | DNS / bind |
| 3   | 04/09/2026 | [Point de montage RAID10 absent, port SATA défectueux](#-3--point-de-montage-raid10-absent-port-sata-défectueux) | Matériel / LVM |
| 4   | 04/09/2026 | [Catalogue désynchronisé du storage](#-4--catalogue-désynchronisé-du-storage) | Catalogue |

---

## `-1-` Connexion impossible entre bareos-dir et bareos-sd

`Date : 26/01/2026`

### `- 1.1` Symptômes

Le Director n'atteint pas le Storage Daemon :

````
Connecting to Storage daemon Storage_Remote at 192.168.0.240:9103
Failed to connect to Storage daemon File.
````

Échec de la négociation TLS :

````
Jan 25 14:18:47 bareos systemd[1]: Started bareos-storage.service - Bareos Storage Daemon service.
Jan 25 15:36:15 bareos bareos-sd[2925]: lib/tls_openssl_private.cc:421 Connect failure: ERR=error:0A0000FD:SSL routines::binder does not verify
Jan 25 15:36:15 bareos bareos-sd[2925]: lib/bnet.cc:125 TLS Negotiation failed.
````

Aucun backup ni archive possible en local.

### `- 1.2` Diagnostic

Documentation de référence :
[dépannage](https://docs.bareos.org/Appendix/Troubleshooting.html#troubleshooting) et
[débug](https://docs.bareos.org/Appendix/Debugging.html).
La doc de débug va plus loin dans l'analyse, notamment avec `gdb`.

**a) Autoriser le traçage des processus**

[traceback](https://docs.bareos.org/Appendix/Debugging.html#traceback) nécessite de
désactiver les restrictions de sécurité `yama`, ce qui permet à n'importe quel
processus d'en tracer un autre.

Valeurs possibles :

- `0` : aucune restriction, n'importe quel processus peut tracer n'importe quel autre
- `1` : restriction modérée, seuls les processus parents peuvent tracer leurs enfants
- `2+` : restrictions plus strictes

````
test -e /proc/sys/kernel/yama/ptrace_scope && echo 0 > /proc/sys/kernel/yama/ptrace_scope
````

**b) Récupérer le PID du Director**

`ps fax` affiche les processus :

- `f` : format arborescence (forest)
- `a` : tous les utilisateurs
- `x` : inclut les processus sans terminal (daemons)

````
ps fax | grep bareos-dir
````

**Sortie**

````
2186 pts/2    S+     0:00                      \_ grep bareos-dir
1098 ?        Ssl    0:02 /usr/sbin/bareos-dir -f
````

**c) Générer la trace de pile**

`btraceback` est l'utilitaire Bareos qui génère une trace de pile (backtrace)
pour diagnostiquer les crashes.

````
btraceback /usr/sbin/bareos-dir 2186
````

**Sortie**

````
bsmtp: tools/bsmtp.cc:129-0 Fatal malformed reply from localhost: 501 <root>: sender address must contain a domain
````

Le problème vient donc d'une déclaration DNS non conforme pour le `bareos-sd` :
lors du `status` dans `bconsole`, il est le seul à présenter des problèmes.

**d) Confirmation avec `gdb`**

Basculer vers l'utilisateur bareos avec un shell bash :

````
su - bareos -s /bin/bash
````

Lancer `gdb` sur le démon de stockage :

- `-f` : foreground, ne se daemonise pas
- `-s` : no signals, désactive la gestion des signaux
- `-d 200` : niveau de debug 200, très verbeux

````
gdb --args /usr/sbin/bareos-sd -f -s -d 200
(gdb) run
````

**Sortie**

````
Local-Sd (10): lib/bnet_server_tcp.cc:246-0 ERROR: Cannot bind address 192.168.0.240 port 9103: ERR=Address already in use.
````

### `- 1.3` Cause

Le nom de domaine référencé sur pfSense n'était pas déclaré côté Bareos, et le SD
tentait de se binder sur une adresse déjà utilisée.

### `- 1.4` Résolution

**a) Déclarer le nom de domaine dans le Storage SD**

````
vim /etc/bareos/bareos-sd.d/storage/Local-Sd.conf
````

````
Address = bareos.sednal.lan
````

**b) Rééditer le Storage côté Director**

Suppression de `Address = 192.168.0.240` :

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

**c) Revenir à la configuration `ptrace_scope` initiale**

````
test -e /proc/sys/kernel/yama/ptrace_scope && echo 1 > /proc/sys/kernel/yama/ptrace_scope
````

### `- 1.5` Résultat

````
Connecting to Storage daemon Storage_Local at bareos.sednal.lan:9103
 Encryption: TLS_CHACHA20_POLY1305_SHA256 TLSv1.3

Local-Sd Version: 25.0.2~pre67.c4bf7e33b (21 January 2026) Debian GNU/Linux 13 (trixie)
Daemon started 26-Jan-26 14:41. Jobs: run=0, running=0, Bareos community binary
 Sizes: boffset_t=8 size_t=8 int32_t=4 int64_t=8 bwlimit=0kB/s
````

⚠️ `[ATTENTION]` ⚠️

Cette résolution a été invalidée le 04/09/2026 par la panne n°2 : le nom
`bareos.sednal.lan` a été réattribué au reverse proxy.

---

## `-2-` bareos-sd s'arrête seul au bout de 15 secondes

`Date : 04/09/2026`

### `- 2.1` Symptômes

`bareos-sd` démarre puis s'arrête seul au bout d'environ 15 secondes, sans erreur
systemd :

````
Active: inactive (dead)
Process: ExecStart=/usr/sbin/bareos-sd -f (code=exited, status=0/SUCCESS)
````

- Port 9103 absent de `ss -lntp`, le Director reste bloqué sur
  `status storage=Storage_Local`.
- `journalctl -u bareos-sd` ne remonte rien : l'arrêt est considéré comme normal
  par systemd.

### `- 2.2` Diagnostic

**a) Lancer le SD en avant-plan avec un niveau de debug élevé**

````
sudo -u bareos /usr/sbin/bareos-sd -f -d 200 2>&1 | tail -40
````

**Sortie**

````
Local-Sd (100): lib/bnet_server_tcp.cc:141-0 Addresses host[ipv4;192.168.0.239;9103]
Local-Sd (10): lib/bnet_server_tcp.cc:210-0 WARNING: Cannot bind address 192.168.0.239 port 9103 ERR=Cannot assign requested address. Retrying...
Local-Sd (10): lib/bnet_server_tcp.cc:246-0 ERROR: Cannot bind address 192.168.0.239 port 9103: ERR=Cannot assign requested address.
````

**b) Vérifier la résolution du nom déclaré dans `Address`**

````
getent hosts bareos.sednal.lan
````

**Sortie**

````
192.168.0.239   bareos.sednal.lan
````

### `- 2.3` Cause

Le nom `bareos.sednal.lan` a été réattribué au reverse proxy nginx `192.168.0.239`
lors de la mise en place de la PKI V2 (vhost WebUI Bareos).

Or ce même nom était utilisé depuis le 26/01/2026 dans `Address` du Storage SD,
qui indique au démon **sur quelle adresse locale se binder**.

Le SD tente donc de se binder sur une IP qui ne lui appartient pas
=> `Cannot assign requested address` => arrêt du démon.

⚠️ `[ATTENTION]` ⚠️

Un nom DNS utilisé par un vhost du reverse proxy ne doit jamais servir de
`Address` à un démon Bareos.

### `- 2.4` Résolution

**a) Créer un enregistrement DNS dédié au démon sur pfSense**

````
bareos-sd.sednal.lan  ->  192.168.0.240
````

**b) Corriger le Storage côté SD**

````
vim /etc/bareos/bareos-sd.d/storage/Local-Sd.conf
````

````
Storage {
    Name = Local-Sd
    SDPort = 9103
    Address = bareos-sd.sednal.lan
}
````

**c) Corriger le Storage côté Director**

````
vim /etc/bareos/bareos-dir.d/storage/Storage_Local.conf
````

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

**d) Test et redémarrage**

````
sudo bareos-sd -t -f && sudo bareos-dir -t -f
sudo systemctl restart bareos-sd bareos-dir
ss -lntp | grep 9103
````

### `- 2.5` Résultat

````
LISTEN 0  50  192.168.0.240:9103  0.0.0.0:*  users:(("bareos-sd",...))
````

---

## `-3-` Point de montage RAID10 absent, port SATA défectueux

`Date : 04/09/2026`

### `- 3.1` Symptômes

`/var/lib/bareos/storage` est vide et monté sur la racine `/` au lieu du RAID10 :

````
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       109G  5.1G   98G   5% /
````

Le volume group `vg_bareos` est incomplet, un PV est absent (`sudo pvs -a`) :

````
WARNING: Couldn't find device with uuid fXzPHv-2jBN-p33g-LYlo-G1dy-JL5q-FXLR9Y.
WARNING: VG vg_bareos is missing PV fXzPHv-2jBN-p33g-LYlo-G1dy-JL5q-FXLR9Y
/dev/sdb   vg_bareos lvm2 a--  931.51g    0
/dev/sdc   vg_bareos lvm2 a--  931.51g    0
/dev/sdd   vg_bareos lvm2 a--  931.51g    0
[unknown]  vg_bareos lvm2 a-m  931.51g    0
````

Le LV `lv_Bareos` est en mode partiel et n'est pas activé au boot (`sudo lvs -a`) :

````
lv_Bareos            vg_bareos rwi---r-p-   <1.82t
[lv_Bareos_rimage_2] vg_bareos Iwi---r-p- <931.51g   [unknown](1)   partial <====
````

Seuls 3 disques sur 4 sont énumérés par le noyau : `sde` est absent.

### `- 3.2` Diagnostic

**a) Identifier le port SATA en défaut**

````
sudo dmesg | grep -iE "ata[0-9]+:" | tail -30
````

**Sortie**

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

**b) Activer le VG en mode dégradé pour vérifier l'intégrité des données**

````
sudo vgchange -ay --activationmode degraded vg_bareos
sudo mount -o ro /dev/vg_bareos/lv_Bareos /mnt
ls -la /mnt
````

Les données sont intactes : en RAID10, la perte d'un leg sur quatre est tolérée.

**c) Rescan à chaud du contrôleur**

Il reste bloqué, ce qui confirme un défaut physique :

````
echo "- - -" | sudo tee /sys/class/scsi_host/host4/scan
````

### `- 3.3` Cause

Contact SATA défectueux sur le port `ata5`.

Le lien électrique s'établissait bien (`SATA link up 3.0 Gbps`), mais le disque ne
répondait jamais correctement au protocole ATA (`found unknown device (class 0)`,
`softreset failed`). Aucun périphérique `sdX` n'était donc créé.

### `- 3.4` Résolution

**a) Arrêt propre avant intervention physique**

````
sudo umount /var/lib/bareos/storage
sudo vgchange -an vg_bareos
sudo systemctl stop bareos-sd bareos-dir
sudo shutdown -h now
````

**b) Intervention physique**

Machine hors tension et alimentation débranchée : débrancher puis rebrancher
fermement le câble SATA data **et** le câble d'alimentation du disque sur `ata5`,
des deux côtés.

**c) Redémarrage et vérification**

````
sudo dmesg | grep -iE "ata5|sde"
sudo pvs -a
df -h /var/lib/bareos/storage
````

**d) Surveiller les erreurs CRC du lien SATA**

Si le compteur augmente, remplacer le câble même si le disque fonctionne.

````
sudo smartctl -A /dev/sde | grep -i UDMA_CRC_Error_Count
````

### `- 3.5` Résultat

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

---

## `-4-` Catalogue désynchronisé du storage

`Date : 04/09/2026`

### `- 4.1` Symptômes

Le catalogue référence des volumes qui n'existent plus sur le storage.
`list media` annonce 6 volumes côté LAN :

````
| mediaid | volumename                 | volstatus | volbytes        | storage       |
|       3 | Local_BackUp_Vol-0003      | Error     | 389,015,950,096 | Storage_Local |
|       5 | Local_Archive_Vol-0005     | Append    | 206,380,251,960 | Storage_Local |
|       6 | Local_BackUp_Vol-0006      | Error     |               0 | Storage_Local |
|       1 | Lin_Local_BackUp_Vol-0001  | Append    |          62,320 | Storage_Local |
|       2 | Lin_Remote_BackUp_Vol-0002 | Append    |          49,526 | Storage_Local |
|       7 | Win_BackUp_Vol_001         | Append    |  39,171,254,650 | Storage_Local |
````

Alors que le disque n'en contient qu'un seul :

````
ls -la /var/lib/bareos/storage/
````

````
drwx------ 2 root   root         16384 lost+found
-rw-r----- 1 bareos bareos 39171254650 Win_BackUp_Vol_001
````

Deux volumes sont en statut `Error`, trois autres en `Append` sur des pools
limités à `Maximum Volumes = 2`.

### `- 4.2` Diagnostic

**a) Comparer catalogue et storage**

````
printf "list media\nquit\n" | sudo bconsole
ls -la /var/lib/bareos/storage/
````

**b) Vérifier quels jobs dépendent de ces volumes**

````
printf "list jobs\nquit\n" | sudo bconsole
````

### `- 4.3` Cause

Désynchronisation entre le **catalogue PostgreSQL** (l'index) et le **storage**
(les fichiers de volumes).

Les volumes ont disparu lors de la recréation du volume group `vg_bareos`
le 17/05/2026, mais leurs enregistrements sont restés dans le catalogue.

⚠️ `[ATTENTION]` ⚠️

Conséquence si rien n'est fait : les pools `Lin_BackUp_Pool_LAN` et
`Lin_BackUp_Pool_WAN` ont `Maximum Volumes = 2` et un slot occupé par un volume
fantôme en statut `Append`. Au prochain job planifié, Bareos tente d'écrire dans
un fichier inexistant et le job échoue. Même blocage côté Windows LAN avec les
deux volumes en `Error`.

⚠️ `[ATTENTION]` ⚠️

`Win_BackUp_Vol_001` est le seul volume local restant, mais il contient un job
**Incremental** (JobId 33) dont le Full de référence était `Local_BackUp_Vol-0003`,
disparu. Une chaîne incrémentale sans son Full n'est pas restaurable : il n'existe
donc plus aucune restauration possible en LAN. Seul le jeu du VPS
(`VPS_Backup_Vol-0004`, JobId 34 = Full) reste exploitable.

`[NOTE]`

Ces volumes étaient déjà irrécupérables avant la purge. Supprimer leur
enregistrement ne détruit aucune donnée : cela retire seulement une référence morte.

### `- 4.4` Résolution

**a) Supprimer du catalogue les volumes absents du storage**

`delete volume` supprime également les enregistrements de jobs associés.

````
printf "delete volume=Local_BackUp_Vol-0003 yes\n\
delete volume=Local_BackUp_Vol-0006 yes\n\
delete volume=Local_Archive_Vol-0005 yes\n\
delete volume=Lin_Local_BackUp_Vol-0001 yes\n\
delete volume=Lin_Remote_BackUp_Vol-0002 yes\n\
quit\n" | sudo bconsole
````

**Sortie**

````
Deleted 6 jobs and associated records deleted from the catalog (jobids: 23,26,27,28,29,30).
Volume Local_BackUp_Vol-0003 deleted.
Volume Local_BackUp_Vol-0006 deleted.
Deleted 1 jobs and associated records deleted from the catalog (jobids: 16).
Volume Local_Archive_Vol-0005 deleted.
Deleted 2 jobs and associated records deleted from the catalog (jobids: 6,25).
Volume Lin_Local_BackUp_Vol-0001 deleted.
Deleted 2 jobs and associated records deleted from the catalog (jobids: 7,11).
Volume Lin_Remote_BackUp_Vol-0002 deleted.
````

**b) Vérification**

````
printf "list media\nquit\n" | sudo bconsole
````

**c) Reconstruire une chaîne de sauvegarde saine**

La chaîne LAN n'ayant plus de Full de référence, un Full complet est nécessaire.
Il est lancé automatiquement par le schedule du 1er dimanche du mois, ou
manuellement :

````
printf "run job=Win_BackUp_Job_LAN level=Full yes\nquit\n" | sudo bconsole
````

**d) Optionnel — nettoyer les jobs en échec restés au catalogue**

````
printf "delete jobid=1,2,3,4,5,24,31,32\nquit\n" | sudo bconsole
````

### `- 4.5` Résultat

Seuls subsistent les volumes réellement présents sur disque, et les pools Linux
et Archive sont vides — leurs slots sont donc de nouveau disponibles.

````
Pool: Win_Backup_Pool_WAN
|       4 | VPS_Backup_Vol-0004 | Append | 108,203,970,236 | Storage_Remote |

Pool: Win_BackUp_Pool_LAN
|       7 | Win_BackUp_Vol_001  | Append |  39,171,254,650 | Storage_Local  |

Pool: Win_Archive_Pool_LAN     No results to list.
Pool: Lin_BackUp_Pool_WAN      No results to list.
Pool: Lin_BackUp_Pool_LAN      No results to list.
````
