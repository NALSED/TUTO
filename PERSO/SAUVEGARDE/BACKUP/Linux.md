# Configuration Backup Linux

---

### Ce Tuto commence, avec RAID, PostGreSQL, Baros opérationel sur Serveur et Client  => [TUTO/Install et Conf](https://github.com/NALSED/TUTO/tree/main/PERSO/Bareos)

---

## `SOMMAIRE` : 

* ### 1️⃣ `Serveur Sauvegarde`

   * ### 1) Client

   * ### 2) Pool

   * ### 3 ) FileSet

   * ### 4) Schedule

   * ### 5) Storage

   * ### 6) Job

---

* ### 2️⃣ `DNS 1`

   * ### 1) Client

   * ### 2) Pool

   * ### 3 ) FileSet

   * ### 4) Schedule

   * ### 5) Storage

   * ### 6) Job

---

* ### 3️⃣ `DNS 2`

   * ### 1) Client

   * ### 2) Pool

   * ### 3 ) FileSet

   * ### 4) Schedule

   * ### 5) Storage

   * ### 6) Job

---

* ### 4️⃣ `Serveur Web`

   * ### 1) Client

   * ### 2) Pool

   * ### 3 ) FileSet

   * ### 4) Schedule

   * ### 5) Storage

   * ### 6) Job
 
---
---



<details>
<summary>
<h2>
1️⃣ Serveur Sauvegarde
</h2>
</summary>

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

    # 1 job par volume
        Maximum Volume Jobs = 1

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

					  File = "A:/app"
                        		  File = "A:/tse"
			    		  File = "A:/VM"
                         		  File = "A:/WCS"
                        		  File = "C:/Users/sednal/Documents"
                         	  	  File = "C:/Users/sednal/.ssh"
                          		  File = "C:/Users/sednal/Tor Browser"
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
    }

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
</details>

---

<details>
<summary>
<h2>
2️⃣ DNS 1
</h2>
</summary>

### Ce Tuto commence après l'intallation du client sur le rasberry-pi voir [ici](https://github.com/NALSED/TUTO/blob/main/PERSO/Bareos/-5-Installation-Client.md#2%EF%B8%8F%E2%83%A3-instalation-client-bareos-linux-1)



### 1) Client /etc/bareos/bareos-dir.d/client/dns1.conf

      	Client {
        	Name = DNS1-fd
       		Address = 192.168.0.241
        	FDPort = 9102
        	Catalog = MyCatalog
        	Password = "sednal"
        	}


---

### 2) Pool FULL un par mois /etc/bareos/bareos-dir.d/pool/pooldns1.conf

    Pool {
        Name = pooldns1
        Pool Type = Backup
        Recycle = yes
        AutoPrune = yes

    # Garder les volumes (Full et Incrémentaux) pendant 60 jours
    Volume Retention = 60 days

    # Un volume peut être utilisé pendant 30 jours
        Volume Use Duration = 30 days

    # Maximum de 12 volumes
        Maximum Volumes = 12

    # 1 job par volume
        Maximum Volume Jobs = 1

    # Format du label des volumes
        Label Format = BackupDns1-
    }  


--- 
### 3 ) FileSet /etc/bareos/bareos-dir.d/fileset/dns1backup.conf

     	FileSet {

        # Nom du FileSet
        Name = dns1backup
                # A inclure pour la sauvegarde
                Include {

                        Options {
                        # Ne met pas à jour l'horodatage des fichiers
                        noatime = yes
                        # Utilise MD5 pour vérifier les fichiers
                        signature = MD5

                                }
                                File = /home/sednal
                                }
                # Exclu de la sauvegarde
                Exclude {
                        File = /home/sednal/.wget-hsts
                        File = /home/sednal/.bash_history
                        File = /home/sednal/.profile
                        File = /home/sednal/.bashrc
                        File = /home/sednal/.bash_logout
                        File = /home/sednal/.local
                        File = /home/sednal/.lesshst

                        }



        }


---

### 4) Schedule /etc/bareos/bareos-dir.d/schedule/schdns1.conf


		Schedule {
        		Name = schdns1

        		# Full chaque 1er dimanche du mois
        		Run = Full 1st sun at 12:00

        		# Incrémental les autres dimanches
        		Run = Incremental 2nd-5th sun at 12:00
        		}
---
### 5) Storage /etc/bareos/bareos-dir.d/storage/stordns1.conf

    Storage {
      Name = stordns1
      Address = 192.168.0.141                # N.B. Use a fully qualified name here (do not use "localhost" here).
      Password = "ZsjQIPmoToPcOM7NSAXu5R84VyRSsD68osZfCHCdu+D/"
      Device = RAID
      Media Type = File
    }


---

### 6) Job /etc/bareos/bareos-dir.d/job/jobdns1.conf



	Job {
                Name = jobdns1
                Type = Backup
                Client = dns1-fd
                FileSet = dns1backup
                Schedule = schdns1
                Storage = stordns1
                Pool = pooldns1
                Messages = Standard
                Priority = 10
                }

</details>

---

<details>
<summary>
<h2>
2️⃣ DNS 2
</h2>
</summary>

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

    # 1 job par volume
        Maximum Volume Jobs = 1

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

					  File = "A:/app"
                        		  File = "A:/tse"
			    		  File = "A:/VM"
                         		  File = "A:/WCS"
                        		  File = "C:/Users/sednal/Documents"
                         	  	  File = "C:/Users/sednal/.ssh"
                          		  File = "C:/Users/sednal/Tor Browser"
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
    }

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
</details>

---

<details>
<summary>
<h2>
4️⃣ Serveur Web
</h2>
</summary>

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

    # 1 job par volume
        Maximum Volume Jobs = 1

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

					  File = "A:/app"
                        		  File = "A:/tse"
			    		  File = "A:/VM"
                         		  File = "A:/WCS"
                        		  File = "C:/Users/sednal/Documents"
                         	  	  File = "C:/Users/sednal/.ssh"
                          		  File = "C:/Users/sednal/Tor Browser"
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
    }

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
</details>
