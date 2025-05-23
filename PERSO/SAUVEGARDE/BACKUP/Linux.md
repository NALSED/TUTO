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

   * ### 1) Installation de Crontab
 
   * ### 2) Configuration Crontab
   

---

* ### 4️⃣ `Serveur Web`

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

### 1) Client /etc/bareos/bareos-dir.d/client/bareos-fd.conf

	Client {
  		Name = bareos-fd
  	Description = "Client resource of the Director itself."
  	Address = localhost
  	Password = "ovLMok3+oAco4yStWjc7IDCdll89/ecfz3vhXEconEoB"          # password for FileDaemon
		}

---

### 2) Pool FULL un par mois /etc/bareos/bareos-dir.d/pool/poolsave.conf

    Pool {
        Name = poolsave
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
        Label Format = BackupSave-
    }


--- 
### 3 ) FileSet /etc/bareos/bareos-dir.d/fileset/savebackup.conf

     		 FileSet {
                # Nom du FileSet
                Name = savebackup


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

                                        }

        }

---

### 4) Schedule /etc/bareos/bareos-dir.d/schedule/schsave.conf


		Schedule {
                        Name = schsave

                        # Full chaque 1er dimanche du mois
                        Run = Full 1st sun at 10:00

                        # Incrémental les autres dimanches
                        Run = Incremental 2nd-5th sun at 10:00
                        }



---
### 5) Storage /etc/bareos/bareos-dir.d/storage/storsave.conf

    Storage {
      Name = storsave
      Address = 192.168.0.141                # N.B. Use a fully qualified name here (do not use "localhost" here).
      Password = "ZsjQIPmoToPcOM7NSAXu5R84VyRSsD68osZfCHCdu+D/"
      Device = RAID
      Media Type = File
    }

---

### 6) Job /etc/bareos/bareos-dir.d/job/jobsave.conf



		Job {
                Name = jobsave
                Type = Backup
                Client = bareos-fd
                FileSet = savebackup
                Schedule = schsave
                Storage = storsave
                Pool = poolsave
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
		55 9 * * 0 cp -r /etc/bind /home/sednal/BackupDns2


### 2.2) Ecraser le contenu de TotalDns2 sur la machine distante
		
		50 10 * * 0 ssh sednal@192.168.0.241 'rm -rf /home/sednal/TotalDns2'

### 2.3) Copier sur DNS1
		00 11 * * 0 rsync -a /home/sednal/TotalDns2/ sednal@192.168.0.241:/home/sednal/TotalDns2/


### 2.4) 📝 FICHIER CRON COMPLET
![image](https://github.com/user-attachments/assets/9cb44d55-be45-4edd-b6d7-b174aab1993c)


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

### 1) Installation de Crontab

### Installation
	sudo apt install cron
	crontab -e
![image](https://github.com/user-attachments/assets/3b481e6e-7362-43f9-b919-92d6e9f88d67)

### Choisir l'éditeur => 1
### si erreur
  	select-editor # et changer

### Création des dossier de sauvegarde et snapshot
	mkdir TotalDns2
 	mkdir BackupDns2 SnapshotDns2


---

### 2) Configuration Crontab

### Copie de la configuration serveur web  
	55 09 * 1-12 sun cp /var/www/html/index.html  next.html  /home/sednal/total/save
	00 10 * 1-12 sun scp /home/sednal/total sednal@192.168.0.241:/home/sednal



















</details>
