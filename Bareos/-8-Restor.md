
# `Restauration des fichier sauver`


## Dans les 7 chhapitre précédent nous avon vu comment mettre en place et faire des backups avec la solution bareos.
## Ici nous allons voir comment restorer ces données.

---
### Suivre le même mode opératoire de dans le précédent chapitre, tout se passe dans /etc/bareos/bareos-dir.d
### Suivre l'order des chapitre pour évviter les erreurs, par rapport au fichier job, qui sera réalisé en dernier.

---

## 1️⃣ `FileSet`
## 2️⃣ `Storage`
## 3️⃣ `Pool`
## 4️⃣ `Job`
## 5️⃣ `Lancer la restauration`
## 6️⃣ ``
## 7️⃣ ``
## 8️⃣ ``
## 9️⃣ ``



---



<details>
<summary>
<h2>
1️⃣ FileSet 
</h2>
</summary>

### Ici le fichier sera créer pour récupérer les backups précédement fait
### Editer dans le dossier /etc/bareos/bareos-dir.d/fileset
   nano /etc/bareos/bareos-dir.d/fileset/restor1.conf
![image](https://github.com/user-attachments/assets/251ccf82-170a-4b87-841b-77fbee9697a0)

### La ligne  `File = /var/lib/bareos/storage/RAID1Vol-0002 # database dump` ,  correspond aux Backups.



</details>


---




<details>
<summary>
<h2>
2️⃣ Storage
</h2>
</summary>

### La ressource Stockage définit les deamon de stockage qui peuvent être utilisés par le director.
### Ici 192.168.0.173 et RAID1
### Editer dans le dossier /etc/bareos/bareos-dir.d/storage
   nano /etc/bareos/bareos-dir.d/storage/restorfile.conf
![image](https://github.com/user-attachments/assets/cda2ae02-ae14-4ba0-b62e-885b3106d81b)

</details>


---



<details>
<summary>
<h2>
3️⃣ Pool
</h2>
</summary>
 
### Ici le type d'action à réaliser.
### Editer dans le dossier /etc/bareos/bareos-dir.d/pool
         nano /etc/bareos/bareos-dir.d/pool/restop.conf
![image](https://github.com/user-attachments/assets/0e27356f-68a5-4028-af7d-05d5c09293c8)



</details>


---




<details>
<summary>
<h2>
4️⃣ Job
</h2>
</summary>

### Dans ce fichier l'action à réaliser
### Editer dans le dossier /etc/bareos/bareos-dir.d/job
      nano /etc/bareos/bareos-dir.d/job/restorwin.conf
![image](https://github.com/user-attachments/assets/5af5d17e-bfed-4572-87ae-93cafd63c3c3)

### Tester la config
      bareos-dir -t
      systemctl restart bareos-dir


</details>


---




<details>
<summary>
<h2>
## 5️⃣ Lancer la restauration
</h2>
</summary>

### Lancer la restauration
### Accéder à la console
      bconsole
### Lancer la restauration
      restore
### Ici 1 on liste les dernier Job
      ![image](https://github.com/user-attachments/assets/08c04ce3-337d-42cd-9191-037a482f5e18)
### On choisi le 8 c'est la dernière sauvegarde pour le client windows



</details>


---



<details>
<summary>
<h2>
  
</h2>
</summary>
blabla
</details>


---




<details>
<summary>
<h2>

</h2>
</summary>
blabla
</details>


---



<details>
<summary>
<h2>

</h2>
</summary>
blabla
</details>


---



<details>
<summary>
<h2>
  
</h2>
</summary>
blabla
</details>
