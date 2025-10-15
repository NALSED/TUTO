# Configuration Bareos2

## Ce Tuto commence  après l'installation et la configuration de [PostgreSQL](https://github.com/NALSED/TUTO/blob/main/PERSO/SAUVEGARDE/BAREOS/INSTALLATION/BAREOS-2-Installation.md#i-instalation)


---
## 1️⃣ RAPPEL:
### `PostgreSQL` 
<img width="405" height="61" alt="image" src="https://github.com/user-attachments/assets/eb112749-9760-4e6e-bfee-ad1a1b3db285" />

### `Bareos`
### Configuring bareos-database-common password  => classic

--- 
## 2️⃣  BACKUP

== Sauvegarde logique (méthode la plus simple)
backup  postgresql
pg_dump -U bareos -F c -b -v -f /mnt/backup_db/bareos_catalog_$(date +%F_%H-%M).backup bareos
restor

Explications :

-U bareos → utilisateur PostgreSQL.

-F c → format personnalisé (compressé, recommandé).

-b → inclut les blobs (objets binaires).

-v → mode verbeux.

-f → fichier de sortie.

pg_restore -U bareos -d bareos -v /var/backups/bareos_catalog.backup

----


=== Sauvegarde physique (complète)

Méthode pg_basebackup

Active la réplication et le mode archive dans postgresql.conf :

wal_level = replica
archive_mode = on
archive_command = 'cp %p /var/lib/postgresql/wal_archive/%f'


Redémarre PostgreSQL.

Lance la sauvegarde :

pg_basebackup -U postgres -D /backups/pg_data -F tar -z -P


-D → dossier de destination

-F tar → format TAR

-z → compression

-P → progression affichée

Cette méthode crée une copie exacte du cluster PostgreSQL, que tu peux restaurer intégralement.
