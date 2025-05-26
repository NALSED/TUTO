# Configuration Backup Linux

---

### Ce Tuto commence, avec RAID, PostGreSQL, Baros opérationel sur Serveur et Client  => [TUTO/Install et Conf](https://github.com/NALSED/TUTO/tree/main/PERSO/Bareos)

---

## `SOMMAIRE` : 

* ## 1️⃣ `Serveur Sauvegarde`

   * ### 1) Client

   * ### 2) Pool

   * ### 3 ) FileSet

   * ### 4) Schedule

   * ### 5) Storage

   * ### 6) Job

---

* ## 2️⃣ `DNS 1`

   * ### `I DNS1`
  
      * ### 1) Client

      * ### 2) Pool

      * ### 3 ) FileSet

      * ### 4) Schedule

      * ### 5) Storage

      * ### 6) Job
    
    * ### `II DNS2 `
       * ### BackUp
       * ### Snapshot
    
    * ### `III WEB`
       * ### BackUp
       * ### Snapshot


---

* ## 3️⃣ `DNS 2`

   * ### 1) Installation 
 
   * ### 2) Configuration 
   

---

* ## 4️⃣ `Serveur Web`

    * ### 1) Installation de Crontab
 
    * ### 2) Configuration Crontab
   
 
   
---
---



<details>
<summary>
<h2>
1️⃣ Serveur Sauvegarde
</h2>
</summary>

# IP `192.168.0.141`

### 1) Client /etc/bareos/bareos-dir.d/client/bareos-fd.conf

	Client {
  		Name = bareos-fd
  	Description = "Client resource of the Director itself."
  	Address = localhost
  	Password = "ovLMok3+oAco4yStWjc7IDCdll89/ecfz3vhXEconEoB"          # password for FileDaemon
		}

---

### 2) Pool FULL un par mois /etc/bareos/bareos-dir.d/pool/poolsaveback.conf

    Pool {
        Name = poolsaveback
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
        Label Format = BackupSave-
    }


--- 
### 3 ) FileSet /etc/bareos/bareos-dir.d/fileset/filesaveback.conf

     		 FileSet {
                # Nom du FileSet
                Name = filesaveback


                # A inclure pour la sauvegarde
                Include {

                        Options {

                                # Utilise MD5 pour vérifier les fichiers
                                signature = MD5

                                # Ne met pas à jour l'horodatage des fichiers
                                noatime = yes



                                }

                                File = "/home/sednal/bareos"
                                File = "/etc/bareos"
                                }


                                # exclu de la sauvegarde
                                Exclude {

                                        File = "/etc/bareos/.rndpwd"
                                        File = "/home/sednal/.bash_history"
                                        File = "/home/sednal/.bash_logout"
                                        File = "/home/sednal/.bashrc"
                                        File = "/home/sednal/.local"
                                        File = "/home/sednal/.profile"
                                        File = "/home/sednal/.wget-hsts"
					File = "/home/sednal/SnapshotSave"
                                        }

        }

---

### 4) Schedule /etc/bareos/bareos-dir.d/schedule/schsaveback.conf


		Schedule {
                        Name = schsaveback

                        # Full chaque 1er dimanche du mois
                        Run = Full 1st sun at 12:30

                        # Incrémental les autres dimanches
                        Run = Incremental 2nd-5th sun at 12:30
                        }



---
### 5) Storage /etc/bareos/bareos-dir.d/storage/storsaveback.conf

    Storage {
      Name = storsaveback
      Address = 192.168.0.141                # N.B. Use a fully qualified name here (do not use "localhost" here).
      Password = "ZsjQIPmoToPcOM7NSAXu5R84VyRSsD68osZfCHCdu+D/"
      Device = RAID
      Media Type = File
    }

---

### 6) Job /etc/bareos/bareos-dir.d/job/jobsaveback.conf



		Job {
                Name = jobsaveback
                Type = Backup
                Client = bareos-fd
                FileSet = filesaveback
                Schedule = schsaveback
                Storage = storsaveback
                Pool = poolsaveback
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

## Cette partie contient plusieurs sous-partie, du fait du transferts des Sauvegardes et Snapshot de DNS2 et WEB ers DNS1.
## Ces sous partie seront organisées de la manières suivante :

* ## `I) DNS1` Backup Uniquement , snapshot dispo [ici](https://github.com/NALSED/TUTO/blob/main/PERSO/SAUVEGARDE/SNAPSHOT/Linux.md#ii-sauvegarde-sur-serveur-bareos-3)

* ## `II) DNS2`=> BackUp et Snapshot Réalisé ici car les données sont à présente et "Récoltable" par Bareos sur DNS1

* ## `III) WEB`=> BackUp et Snapshot Réalisé ici car les données sont à présente et "Récoltable" par Bareos sur DNS1


<details>
<summary>
<h2>
I) DNS1
</h2>
</summary>

# IP `192.168.0.241`

### Ce Tuto commence après l'intallation du client sur le rasberry-pi voir [ici](https://github.com/NALSED/TUTO/blob/main/PERSO/Bareos/-5-Installation-Client.md#2%EF%B8%8F%E2%83%A3-instalation-client-bareos-linux-1)



### 1) Client /etc/bareos/bareos-dir.d/client/DNS1.conf

      	Client {
        	Name = DNS1
       		Address = 192.168.0.241
        	FDPort = 9102
        	Catalog = MyCatalog
        	Password = "sednal"
        	}


---

### 2) Pool FULL un par mois fev jun et oct  /etc/bareos/bareos-dir.d/pool/pooldns1back.conf

    Pool {
        Name = pooldns1back
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
        Label Format = BackupDns1-
    }  


--- 
### 3 ) FileSet /etc/bareos/bareos-dir.d/fileset/filedns1back.conf

     	FileSet {

        # Nom du FileSet
        Name = filedns1back
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
                        File = /home/sednal/TotalDNS2
                        File = /home/sednal/SnapshotDNS1
                        File = /home/sednal/TotalWeb
                        }



        }



        }


---

### 4) Schedule /etc/bareos/bareos-dir.d/schedule/schdns1back.conf


		Schedule {
        		Name = schdns1back

        		# Full chaque 1er dimanche du mois de fevrier juin et octobre
       			 Run = Full 1st sun at 10:30 feb
        		 Run = Full 1st sun at 10:30 jun
        		 Run = Full 1st sun at 10:30 oct
       			 }
---
### 5) Storage /etc/bareos/bareos-dir.d/storage/stordns1back.conf

    Storage {
      Name = stordns1back
      Address = 192.168.0.141                # N.B. Use a fully qualified name here (do not use "localhost" here).
      Password = "ZsjQIPmoToPcOM7NSAXu5R84VyRSsD68osZfCHCdu+D/"
      Device = RAID
      Media Type = File
    }


---

### 6) Job /etc/bareos/bareos-dir.d/job/jobdns1back.conf



	Job {
                Name = jobdns1back
                Type = Backup
                Client = DNS1
                FileSet = filedns1back
                Schedule = schdns1back
                Storage = stordns1back
                Pool = pooldns1back
                Messages = Standard
                Priority = 10
                }

</details>

---

<details>
<summary>
<h2>
II) DNS2  
</h2>
</summary>

## I) BackUp DNS2
## II) SnapShot DNS2
---

## `I) BackUp DNS2`

### 1) Client /etc/bareos/bareos-dir.d/client/dns1.conf

      	Client {
        	Name = DNS1
       		Address = 192.168.0.241
        	FDPort = 9102
        	Catalog = MyCatalog
        	Password = "sednal"
        	}

---

### 2) Pool FULL un par mois fev jun et oct  /etc/bareos/bareos-dir.d/pool/pooldns2back.conf

		Pool {
       			 Name = pooldns2back
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
        		 Label Format =  BackDns2-
    			}

---

### 3 ) FileSet /etc/bareos/bareos-dir.d/fileset/filedns2back.conf

			FileSet {

        			# Nom du FileSet
        			Name = filedns2back
                		# A inclure pour la sauvegarde
                		Include {

                       		 Options {
                        		# Ne met pas à jour l'horodatage des fichiers
                        		noatime = yes
                        		# Utilise MD5 pour vérifier les fichiers
                        		signature = MD5

                                	}
                                	File = /home/sednal/TotalDNS2/BackupDNS2
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
                        	File = /home/sednal/TotalWeb
                        	File = /home/sednal/TotalDNS2/SnapshotDNS2
                        	File = /home/sednal/youTube_ads_4_pi-hole
                        	File = /home/sednal/SnapshotDNS1
			 	}



        	}


---

### 4) Schedule /etc/bareos/bareos-dir.d/schedule/schdns2back.conf


		Schedule {
        		Name = schdns2back

        		# Full chaque 1er dimanche du mois
        		Run = Full 1st sun at 11:30 feb
        		Run = Full 1st sun at 11:30 jun
        		Run = Full 1st sun at 11:30 oct
        		}


---

### 5) Storage /etc/bareos/bareos-dir.d/storage/stordns2back.conf

    Storage {
      Name = stordns2back
      Address = 192.168.0.141                # N.B. Use a fully qualified name here (do not use "localhost" here).
      Password = "ZsjQIPmoToPcOM7NSAXu5R84VyRSsD68osZfCHCdu+D/"
      Device = RAID
      Media Type = File
    }

---

### 6) Job /etc/bareos/bareos-dir.d/job/jobdns2back.conf



	Job {
                Name = jobdns2back
                Type = Backup
                Client = DNS1
                FileSet = filedns2back
                Schedule = schdns2back
                Storage = stordns2back
                Pool = pooldns2back
                Messages = Standard
                Priority = 10
                }


---
---

## `II) SnapShot DNS2` 

### 1) Client /etc/bareos/bareos-dir.d/client/dns1.conf

      	Client {
        	Name = DNS1
       		Address = 192.168.0.241
        	FDPort = 9102
        	Catalog = MyCatalog
        	Password = "sednal"
        	}

---

### 2) Pool FULL un par mois fev jun et oct  /etc/bareos/bareos-dir.d/pool/pooldns2snap.conf

		Pool {
        		Name = pooldns2snap
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
        	Label Format = SnapDns2-
    		}

---

### 3 ) FileSet /etc/bareos/bareos-dir.d/fileset/filedns2snap.conf

			FileSet {

        			# Nom du FileSet
        			Name = filedns2snap
                		# A inclure pour la sauvegarde
                		Include {

                        		Options {
                        		# Ne met pas à jour l'horodatage des fichiers
                        		noatime = yes
                        		# Utilise MD5 pour vérifier les fichiers
                       		 signature = MD5

                                		}
                                	File = /home/sednal/TotalDNS2/SnapshotDNS2/
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
                        File = /home/sednal/TotalDN2/BackupDNS2
                        File = /home/sednal/TotalWeb
                        File = /home/sednal/SnapshotDNS1
                        File = /home/sednal/youTube_ads_4_pi-hole

                        }



       		 }


---

### 4) Schedule /etc/bareos/bareos-dir.d/schedule/schdns2snap.conf


		Schedule {
        		Name = schdns2snap

        		# Full chaque 1er dimanche du mois
        		Run = Full 1st sun at 11:00 feb
        		Run = Full 1st sun at 11:00 jun
        		Run = Full 1st sun at 11:00 oct
        		}


---

### 5) Storage /etc/bareos/bareos-dir.d/storage/stordns2snap.conf

    Storage {
      Name = stordns2snap
      Address = 192.168.0.141                # N.B. Use a fully qualified name here (do not use "localhost" here).
      Password = "ZsjQIPmoToPcOM7NSAXu5R84VyRSsD68osZfCHCdu+D/"
      Device = SNAP
      Media Type = File
    }

---

### 6) Job /etc/bareos/bareos-dir.d/job/jobdns2snap.conf



	 Job {
                Name = jobdns2snap
                Type = Backup
                Client = DNS1
                FileSet = filedns2snap
                Schedule = schdns2snap
                Storage = stordns2snap
                Pool = pooldns2snap
                Messages = Standard
                Priority = 10
                }


</details>

---


<details>
<summary>
<h2>
III) WEB 
</h2>
</summary>

## I) BackUp Web
## II) SnapShot Web

 ---

## `I) BackUp Web`

### 1) Client /etc/bareos/bareos-dir.d/client/dns1.conf

      	Client {
        	Name = DNS1
       		Address = 192.168.0.241
        	FDPort = 9102
        	Catalog = MyCatalog
        	Password = "sednal"
        	}

---

### 2) Pool FULL un par mois fev jun et oct  /etc/bareos/bareos-dir.d/pool/poolwebback.conf

		Pool {
       			 Name = poolwebback
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
        		 Label Format = BackWeb-
    			}

---

### 3 ) FileSet /etc/bareos/bareos-dir.d/fileset/filewebback.conf

			FileSet {

        			# Nom du FileSet
        			Name = filewebback
                		# A inclure pour la sauvegarde
                		Include {

                        	Options {
                       		# Ne met pas à jour l'horodatage des fichiers
                        	noatime = yes
                        	# Utilise MD5 pour vérifier les fichiers
                        	signature = MD5

                                	}
                                	File = /home/sednal/TotalWeb/BackupWeb
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
                        	File = /home/sednal/TotalDNS2
                        	File = /home/sednal/TotalWeb/SnapshotWeb
                        	File = /home/sednal/youTube_ads_4_pi-hole
                        	File = /home/sednal/SnapshotDNS1
			  		}



        				}


        		}


---

### 4) Schedule /etc/bareos/bareos-dir.d/schedule/schwebback.conf


		Schedule {
        		Name = schwebback

        		# Full chaque 1er dimanche du mois de fevrier juin et octobre
        		Run = Full 1st sun at 09:30 feb
        		Run = Full 1st sun at 09:30 jun
		        Run = Full 1st sun at 09:30 oct
        		}


---

### 5) Storage /etc/bareos/bareos-dir.d/storage/storwebback.conf

    Storage {
      Name = storwebback
      Address = 192.168.0.141                # N.B. Use a fully qualified name here (do not use "localhost" here).
      Password = "ZsjQIPmoToPcOM7NSAXu5R84VyRSsD68osZfCHCdu+D/"
      Device = RAID
      Media Type = File
    }

---

### 6) Job /etc/bareos/bareos-dir.d/job/jobwebback.conf



	Job {
                Name = jobwebback
                Type = Backup
                Client = DNS1
                FileSet = filedns1snap
                Schedule = schdns1snap
                Storage = stordns1snap
                Pool = pooldns1snap
                Messages = Standard
                Priority = 10
                }

---
---

## `II) SnapShotWeb`

### 1) Client /etc/bareos/bareos-dir.d/client/dns1.conf

      	Client {
        	Name = DNS1
       		Address = 192.168.0.241
        	FDPort = 9102
        	Catalog = MyCatalog
        	Password = "sednal"
        	}

---

### 2) Pool FULL un par mois fev jun et oct  /etc/bareos/bareos-dir.d/pool/poolwebsnap.conf

			Pool {
        			Name = poolwebsnap
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
        		Label Format = SnapWeb-
    			}

---

### 3 ) FileSet /etc/bareos/bareos-dir.d/fileset/filewebsnap.conf

			FileSet {

       			 # Nom du FileSet
        		Name = filewebsnap
               		# A inclure pour la sauvegarde
               		 Include {

                        Options {
                        # Ne met pas à jour l'horodatage des fichiers
                        noatime = yes
                        # Utilise MD5 pour vérifier les fichiers
                        signature = MD5

                                }
                                File = /home/sednal/TotalWeb/SnapshotWeb/
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
                        File = /home/sednal/TotalDNS2
                        File = /home/sedna/SnapshotDNS1
                        File = /home/sednal/youTube_ads_4_pi-hole
                        File = /home/sednal/TotalWeb/BackupWeb
                        }



        }



---

### 4) Schedule /etc/bareos/bareos-dir.d/schedule/schwebsnap.conf


		Schedule {
        		Name = schwebsnap

       		 	# Full chaque 1er dimanche du mois de fevrier juin et octobre
        		Run = Full 1st sun at 09:00 feb
        		Run = Full 1st sun at 09:00 jun
        		Run = Full 1st sun at 09:00 oct
        }


---

### 5) Storage /etc/bareos/bareos-dir.d/storage/storwebsnap.conf

    Storage {
      Name = storwebsnap
      Address = 192.168.0.141                # N.B. Use a fully qualified name here (do not use "localhost" here).
      Password = "ZsjQIPmoToPcOM7NSAXu5R84VyRSsD68osZfCHCdu+D/"
      Device = SNAP
      Media Type = File
    }
---

### 6) Job /etc/bareos/bareos-dir.d/job/jobwebsnap.conf



	Job {
                Name = jobwebsnap
                Type = Backup
                Client = DNS1
                FileSet = filewebsnap
                Schedule = schwebsnap
                Storage = storwebsnap
                Pool = poolwebsnap
                Messages = Standard
                Priority = 10
                }

      





















 
</details>











</details>

---

<details>
<summary>
<h2>
2️⃣ DNS 2
</h2>
</summary>

# IP `192.168.0.210`

### 1) Installation de Crontab
 
### Installation
	sudo apt install cron
	crontab -e
![image](https://github.com/user-attachments/assets/3b481e6e-7362-43f9-b919-92d6e9f88d67)

### Choisir l'éditeur => 1
### si erreur
  	select-editor # et changer


---





### 2) Configuration Crontab


### 2.1) Copie des backup
		0 2 1 2,6,10 * cp -r /etc/bind/ /home/sednal/TotalDNS2/BackupDns2 >> /var/log/backupdns2.log 2>&1
	

### 2.3) Copier sur DNS1
		0 3 1 2,6,10 *  rsync -a /home/sednal/TotalDNS2/ sednal@192.168.0.241:/home/sednal/TotalDns2/ >> /var/log/rsynctotaldns2.log 2>&1


### 2.4) 📝 FICHIER CRON COMPLET
![image](https://github.com/user-attachments/assets/07e82874-bc73-4f26-9696-c01cf32c6e66)






### ⚠️ UN DOSSIER IDENTIQUE A CELUI DE DNS2 DOIT ETRE CREER SUR DNS1
### Sur DNS1
     chown -R sednal:sednal /home/sednal/TotalDNS2
     chmod -R u+rwX /home/sednal/TotalDNS2

### Sans ça les copies Rsync ne fontionnerons pas...


 

</details>

---

<details>
<summary>
<h2>
4️⃣ Serveur Web
</h2>
</summary>

# IP `192.168.0.122`

### Installation
	sudo apt install cron
	crontab -e
![image](https://github.com/user-attachments/assets/3b481e6e-7362-43f9-b919-92d6e9f88d67)

### Choisir l'éditeur => 1
### si erreur
  	select-editor # et changer


---

### 2) Configuration Crontab


### 2.1) Copie des backup
		0 2 1 2,6,10 * cp -r /var/www/html/ /home/sednal/BackupWeb >> /var/log/backupweb.log 2>&1


### 2.3) Copier sur DNS1
		40 3 1 2,6,10 *  rsync -a /home/sednal/TotalWeb/ sednal@192.168.0.241:/home/sednal/TotalWeb/ >> /var/log/rsynctotalweb.log 2>&1

### 2.4) 📝 FICHIER CRON COMPLET
![image](https://github.com/user-attachments/assets/cf679e0a-c58e-45b5-814f-5e79ed6d815a)



### ⚠️ UN DOSSIER IDENTIQUE A CELUI DE DNS2 DOIT ETRE CREER SUR DNS1
### Sur DNS1
     chown -R sednal:sednal /home/sednal/TotalDNS2
     chmod -R u+rwX /home/sednal/TotalDNS2

### Sans ça les copies Rsync ne fontionnerons pas...




















</details>
