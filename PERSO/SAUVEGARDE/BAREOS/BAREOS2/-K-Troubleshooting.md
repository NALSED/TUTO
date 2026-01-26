# Liste des Problémes réglé sur Bareos

---
=> Format

`=== DATE ===`
`=== PROBLEME ===`
`=== RESOLUTION ===`

---

### `=== DATE 26/01/2026 ===`

---
---

### `=== PROBLEME ===`

#### - Impossible pour bareos-dir et bareos-sd de se connecter ensemble.

`message erreur:`

      Connecting to Storage daemon Storage_Remote at 192.168.0.240:9103
      Failed to connect to Storage daemon File.


#### - Echec de connection TLS 


`message erreur:`

        Jan 25 14:18:47 bareos systemd[1]: Started bareos-storage.service - Bareos Storage Daemon service.
        Jan 25 15:36:15 bareos bareos-sd[2925]: lib/tls_openssl_private.cc:421 Connect failure: ERR=error:0A0000FD:SSL routines::binder does not verify
        Jan 25 15:36:15 bareos bareos-sd[2925]: lib/bnet.cc:125 TLS Negotiation failed.

##### Impossible de faire un backup ou archive en local.

---
---

### `=== RESOLUTION ===`

[DOC dépannage](https://docs.bareos.org/Appendix/Troubleshooting.html#troubleshooting) et [DOC débug](https://docs.bareos.org/Appendix/Debugging.html)

la doc de débug va plus loins dans l'analyse notamment avec des outils comme `gdb`


---

1) Utilisation du [traceback](https://docs.bareos.org/Appendix/Debugging.html#traceback) :
Utilisation de la commande suivante pour Désactive les restrictions de sécurité => permettant ainsi à n'importe quel processus de déboguer/tracer n'importe quel autre processus sur le système.

- EXPLICATION :
* Valeurs possibles :

      * 0 : Aucune restriction - n'importe quel processus peut tracer n'importe quel autre
      * 1 : Restriction modérée - seuls les processus parents peuvent tracer leurs enfants
      * 2+ : Restrictions plus strictes

    Ici on va lui mettre 0 comme valeur :
 
          test -e /proc/sys/kernel/yama/ptrace_scope && echo 0 > /proc/sys/kernel/yama/ptrace_scope

---

2) Utilisation de la commande `ps fax` :

- EXPLICATION :
* ps : Affiche les processus
* f : Format arborescence (forest) 
* a : Tous les utilisateurs
* x : Inclut les processus sans terminal (daemons)

            ps fax | grep bareos-dir

Sortie :
            2186 pts/2    S+     0:00                      \_ grep bareos-dir
            1098 ?        Ssl    0:02 /usr/sbin/bareos-dir -f
      

Donc on à maintenant le PID du processus : 1098

---

3) on peux à présent utiliser `btraceback `,  un utilitaire de Bareos qui génère une trace de pile (backtrace) pour diagnostiquer les crashes.
      btraceback /usr/sbin/bareos-dir 2186

Sortie :
      bsmtp: tools/bsmtp.cc:129-0 Fatal malformed reply from localhost: 501 <root>: sender address must contain a domain 

On à donc le probléme => Déclaration DNS non conforme pour le `Bareos-sd`,étant donné que c'est lui qui pose problème. 
Lors du `status` dans `bconsole` il est le seul à présenter des problémes.

---

4) confirmation avec `gdb` et le shell Bareos

Cette commande bascule vers l'utilisateur bareos avec un shell bash
          su - bareos -s /bin/bash

Cette commande lance gdb (débogueur GNU) pour déboguer le daemon bareos-sd

- EXPLICATION :
/usr/sbin/bareos-sd : Le daemon de stockage Bareos
Options de bareos-sd :

-f : Foreground - ne se daemonise pas (reste au premier plan)
-s : No signals - désactive la gestion des signaux (facilite le débogage)
-d 200 : Debug level 200 - active un niveau de verbosité très élevé    
    
          gdb --args /usr/sbin/bareos-sd -f -s -d 200
          (gdb) run

Sortie:
          Local-Sd (10): lib/bnet_server_tcp.cc:246-0 ERROR: Cannot bind address 192.168.0.240 port 9103: ERR=Address already in use.


5) Déclarer le nom de domain référencer sur pfsense dans bareos et rectifier l'erreur vu avec `gdb`

* Ajouter la ligne suivante dans  /etc/bareos/bareos-sd.d/storage/Local-Sd.conf
           Address = bareos.sednal.lan

* Rééditer le fichier de configuration comme ci dessous
Suppression de => `Address = 192.168.0.240`
   
          Storage {
                Name = Storage_Local
                SDPort = 9103
                SD Address = bareos.sednal.lan <= AJOUT
                Password = "fCQqLZbkIZ+IBMpXOWtCZWOjrnxuJWt9ApbKT6PW8U8n"
                Device = Local_Device
                Media Type = File
                }

6) Et pour finir, revenir à la configuration de `/proc/sys/kernel/yama/ptrace_scope` initiale
            test -e /proc/sys/kernel/yama/ptrace_scope && echo 1 > /proc/sys/kernel/yama/ptrace_scope




RESULTAT

      Connecting to Storage daemon Storage_Local at bareos.sednal.lan:9103
       Encryption: TLS_CHACHA20_POLY1305_SHA256 TLSv1.3
      
      Local-Sd Version: 25.0.2~pre67.c4bf7e33b (21 January 2026) Debian GNU/Linux 13 (trixie)
      Daemon started 26-Jan-26 14:41. Jobs: run=0, running=0, Bareos community binary
       Sizes: boffset_t=8 size_t=8 int32_t=4 int64_t=8 bwlimit=0kB/s











