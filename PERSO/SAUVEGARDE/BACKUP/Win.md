# Configuration Backup Windows

---

### Ce Tuto commence, avec RAID, PostGreSQL, Baros opérationel sur Serveur et Client  => [TUTO/Install et Conf](https://github.com/NALSED/TUTO/tree/main/PERSO/Bareos)

---

## 📝 Fichier de configuration :

### `SOMMAIRE :`

### 1) Client

### 2) Pool

### 3 ) FileSet

### 4) Schedule

### 5) Storage

### 6) Job


----


### 1) Client /etc/bareos/bareos-dir.d/client/client.conf

      Client {
              Name = client-fd
              Address = 192.168.0.111
              FDPort = 9102
              Catalog = MyCatalog
              Password = "lz9moCPhP0fkvRz/s/N5Emm8vOiLS8xW+//uLVxQHDvg"
              }

---

### 2) Pool FULL un par mois /etc/bareos/bareos-dir.d/pool/poolwin.conf

    Pool {
        Name = poolwin
        Pool Type = Backup
        Recycle = yes
        AutoPrune = yes

    # Garder les volumes (Full et Incrémentaux) pendant 60 jours
    Volume Retention = 60 days

    # Un volume peut être utilisé pendant 30 jours
        Volume Use Duration = 30 days

    # Maximum de 12 volumes
        Maximum Volumes = 12

    # Le volume deviens recyclable après 1 jour, donc à la prochaine sauvegarde
    Volume Retention = 1d
    
    # Recyclage des volumes
    Recycle = yes

    # Format du label des volumes
        Label Format = BackupWin-
    }  


--- 
### 3 ) FileSet /etc/bareos/bareos-dir.d/fileset/winbackup.conf

     		 FileSet {
 		# Nom du FileSet
		 Name = winbackup

		 # Specifique à windows, copie les fichier cachés
 		Enable VSS = yes

  		# A inclure pour la sauvegarde
       		 Include {

		 		Options {
				
					# Utilise MD5 pour vérifier les fichiers
               				signature = MD5

               				# Ne met pas à jour l'horodatage des fichiers
                			noatime = yes

                			# Ignore la case
                			ignore case = yes

			 		}

					 File = "A:/save"
                       			 File = "C:/Users/sednal/Documents"
                      			 File = "C:/Users/sednal/.ssh"
                      			 File = "C:/Users/sednal/Tor Browser"
                       			 File = "S:/"
                      			 File = "D:/"

					}


					# exclu de la sauvegarde
                        		Exclude {

                         		 File = "C:/Users/sednal/Default"
                        		 File = "C:/$WINDOWS.~BT"
                         		 File = "C:/$Windows.~WS"
                         		 File = "C:/PerfLogs"
                         		 File = "C:/ProgramData"
                         		 File = "C:/Programmes"
                        		 File = "C:/Programmes(x86)"
                         		 File = "C:/Windows"
                                		}

				}

---

### 4) Schedule /etc/bareos/bareos-dir.d/schedule/schwin.conf


		Schedule {
        Name = schwin

        # Full chaque 1er dimanche du mois
        Run = Full 1st sun at 13:00

        # Incrémental les autres dimanches
        Run = Incremental 2nd-5th sun at 13:00
        }

---
### 5) Storage /etc/bareos/bareos-dir.d/storage/storwin.conf

    Storage {
      Name = storwin
      Address = 192.168.0.141                # N.B. Use a fully qualified name here (do not use "localhost" here).
      Password = "ZsjQIPmoToPcOM7NSAXu5R84VyRSsD68osZfCHCdu+D/"
      Device = RAID
      Media Type = File

---

### 6) Job /etc/bareos/bareos-dir.d/job/jobwin.conf



		Job {
        		Name = jobwin
        		Type = Backup
        		Client = client-fd
        		FileSet = winbackup
        		Schedule = schwin
        		Storage = storwin
        		Pool = poolwin
        		Messages = Standard
        		Priority = 10
   		}



