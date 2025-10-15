# Configuration Bareos2

## Ce Tuto commence  après l'installation et la configuration de [PostgreSQL](https://github.com/NALSED/TUTO/blob/main/PERSO/SAUVEGARDE/BAREOS/INSTALLATION/BAREOS-2-Installation.md#i-instalation)


---
## 1️⃣ RAPPEL:
### `PostgreSQL` 
<img width="405" height="61" alt="image" src="https://github.com/user-attachments/assets/eb112749-9760-4e6e-bfee-ad1a1b3db285" />

### `Bareos`
### Configuring bareos-database-common password  => classic

--- 
## 2️⃣ BACKUP :

### I) `Plan Synoptique`
                                      +-----------------------+
                                      |       PC Admin        |
                                      +-----------------------+
                                      |      192.168.0.111    |
                                      | Interface Bareos/SSH  |
                                      +-----------+-----------+
                                                  |
                                                  v
                                      +-------------------------+
                                      |     Bareos Director     |
                                      |     192.168.0.240       |
                                      +-----------+-------------+
                                                  |
                                                  | 
                                                  v
                                      +-------------------------+
                                      | PostgreSQL Catalog      |
                                      | 192.168.0.240           |
                                      | Dump automatique        |
                                      | via cron/script         |
                                      +-----------+-------------+
                                                  |
                                                  v
                                         +----------------+
                                         | Storage Local  |
                                         | (bareos-sd)    |
                                         | Local Backup   |
                                         +----------------+
                                                  |
                           -----------------------/--------------------------
                           |                      ^   Tunel autoSSH +cron   |
                           v                      |                         v
                  +----------------+              |               +-------------------+
                  | Local Backup   |              |               |   Remote Backup   |
                  +----------------+              |               +-------------------+
                  |  192.168.0.240 |              |               | WAN 176.31.163.227|
                  | Redondance     |              |               | Stockage distant  |
                  +----------------+              |               +-------------------+
                           ^                      |                          ^
                           |                      |                          |
                           |                      ----------------------------
          +----------------+----------------+         Tunel autoSSH + cron   |                           
          |      Clients à sauvegarder      |                                |                   
          +---------------------------------+                                |
          | 192.168.0.111 PC Admin          |                        +----------------+
          | 192.168.0.241 Raspberry Pi 1    |                        | Client distant |
          | - Unbound + Pi-hole +           |                        +----------------+
          | gestioninfra                    |                        | 176.31.163.227 |
          | (Future) 2ème Raspberry Pi      |                        |    système     |
          | - Gcert + Site Web              |                        +----------------+
          +---------------------------------+                        
                                                                      
### II) `WebUi Bareos`                        
#### Install + Activer php-fpm pour Apache2       
#### Activer PHP-FPM pour Apache2 sert à améliorer la gestion et les performances de PHP sur le serveur web.  
        # install
        apt-get install bareos-webui -y
        # Activer php-fpm
        a2enmod proxy_fcgi setenvif
        a2enconf php8.1-fpm
        systemctl reload apache2
        service php8.4-fpm status 

<img width="1494" height="364" alt="image" src="https://github.com/user-attachments/assets/c4b6f46b-7634-4e88-9fd5-18ce3f542754" />

#### Config WebUi 
      cp /etc/bareos/bareos-dir.d/console/admin.conf.example /etc/bareos/bareos-dir.d/console/admin.conf
      nano /etc/bareos/bareos-dir.d/console/admin.conf

<img width="436" height="364" alt="image" src="https://github.com/user-attachments/assets/38082443-ea43-4d5f-8f1b-0a1f41b6953a" />

#### Vérifier que le fichier /etc/bareos/bareos-dir.d/profile/webui-admin.conf est présent et correct

<img width="1188" height="306" alt="image" src="https://github.com/user-attachments/assets/89e0ca19-e655-45c7-9676-b011786241a1" />

#### Redemarrer les services 
    systemctl restart apache2 && systemctl restart php8.4-fpm && systemctl restart bareos-director
    
#### Accés => `http://192.168.0.240/bareos-webui/`






















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
