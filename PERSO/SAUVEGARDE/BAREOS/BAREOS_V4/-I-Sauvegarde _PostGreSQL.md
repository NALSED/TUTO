# Sauvegarde de la base de données PostGreSQL

---

Ici on utilise le mécanisme natif de Bareos plutôt que `cron`.

Le Director déclenche lui-même le dump juste avant de sauvegarder le catalogue,
via `RunBeforeJob`, puis efface le dump via `RunAfterJob`.

Avantages sur une tâche cron :

- pas de problème d'authentification PostgreSQL (le script lit `MyCatalog.conf`)
- le dump est garanti frais au moment où il est sauvegardé
- le dump ne reste pas sur le disque entre deux exécutions

`[NOTE]`

En Bareos 25 le script est `make_catalog_backup` (shell).
L'ancien `make_catalog_backup.pl` (Perl) n'existe plus.

---

## `-1-` Vérification préalable du script

### `- 1.1` Lancer le script

````
sudo -u bareos /usr/lib/bareos/scripts/make_catalog_backup MyCatalog
ls -la /var/lib/bareos/*.sql
````

**SORTIE ATTENDUE**

````
-rw-rw-r-- 1 bareos bareos 38985603 /var/lib/bareos/bareos.sql
````

---

## `-2-` Configuration

### `- 2.1` Catalog_FileSet.conf

````
vim /etc/bareos/bareos-dir.d/fileset/Catalog_FileSet.conf
````

````
FileSet {
    Name = Catalog_FileSet
    Include {
        Options {
            signature = MD5
        }
        File = "/var/lib/bareos/bareos.sql"
        File = "/etc/bareos"
    }
}
````

### `- 2.2` BackupCatalog.conf

````
vim /etc/bareos/bareos-dir.d/job/BackupCatalog.conf
````

````
Job {
    Name = BackupCatalog
    Type = Backup
    Client = lin
    FileSet = Catalog_FileSet
    Schedule = Lin_Schedule_LAN
    Storage = Storage_Local
    Pool = Lin_BackUp_Pool_LAN
    Messages = Standard
    Level = Full
    Priority = 30
    RunBeforeJob = "/usr/lib/bareos/scripts/make_catalog_backup MyCatalog"
    RunAfterJob  = "/usr/lib/bareos/scripts/delete_catalog_backup"
    Write Bootstrap = "/var/lib/bareos/%n.bsr"
}
````

`[NOTE]`

`Priority = 30` : le catalogue est sauvegardé en dernier, après les jobs
LAN (10) et WAN (20), afin de refléter les jobs du jour.

`[NOTE]`

`Write Bootstrap` produit un fichier `.bsr` permettant de restaurer le
catalogue même si la base PostgreSQL est entièrement perdue. Sans lui, la
sauvegarde du catalogue est difficilement exploitable.

---

## `-3-` Activation

### `- 3.1` Recharger le Director

````
sudo bareos-dir -t -f
printf "reload\nshow job=BackupCatalog\nquit\n" | sudo bconsole
````

---

## `-4-` Supprimer l'ancienne tâche cron

### `- 4.1` Éditer la crontab root

L'ancienne méthode `pg_dump` lancée par `cron` est à retirer de la crontab root :

````
sudo crontab -e
````

Ligne à supprimer :

````
55 11 * * 0 /usr/bin/pg_dump -U bareos -F c -b -v -f /home/sednal/BackUp_SQL_Bareos_$(date +\%F_\%H-\%M).backup bareos
````

⚠️ `[ATTENTION]` ⚠️

Cette ligne ne fonctionnait pas : `pg_dump -U bareos` lancé par root est
rejeté par l'authentification `peer` de PostgreSQL, et le fichier était écrit
**à côté** du dossier `/home/sednal/BackUp_SQL_Bareos/` (préfixe au lieu de chemin),
donc hors du périmètre du FileSet.
