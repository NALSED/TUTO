
# `Restauration des fichier sauver`


## Dans les 7 chapitre précédent nous avon vu comment mettre en place et faire des backups avec la solution bareos.
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

![image](https://github.com/user-attachments/assets/f47e18c1-881b-4e1b-9c50-587ace0f8cdd)

### La ligne  `File = mnt/backup/RAID1Vol-0005 # database dump` ,  correspond aux Backups.



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
5️⃣ Lancer la restauration
</h2>
</summary>

### Pour le test je retire le  dossier `testbareos` de la machine cliente. 

### Lancer la restauration
### Accéder à la console
      bconsole
### Lancer la restauration
      restore
### Ouvre le menu de restauration
### Je tape `1` pour lister les jobid.

![image](https://github.com/user-attachments/assets/47cf778f-b332-4303-acd5-92cc1695f765)

### Et c'est le numéro 13 qui nous intéresse.
### A ajuster en fonction des besoin, mais ici je souhaite restaurer les données les plus rescente de mon client
### Donc je choisi `5`
![image](https://github.com/user-attachments/assets/6bc1dc18-9d06-4d7f-aa11-6a4c3fe07317)

### j'entre dans un nouveau shell
![image](https://github.com/user-attachments/assets/8a7e1796-1467-48db-a175-3d1fae7cd5c5)

### Ici il s'agit de choisir la quantité de données à restaurer
### je choisi tout
      mark *
![image](https://github.com/user-attachments/assets/8738f6de-933b-4ebc-8910-4a6a94b38cb8)

### Une fois fini 
      done

### Choisir le client souhaité
![image](https://github.com/user-attachments/assets/7958311a-f20c-47ad-961f-d0a6753658fd)

### Une fois la tache réalisée, vériffication
      message
![image](https://github.com/user-attachments/assets/60512752-cf93-413b-910d-ede5c724622e)

### Retour du dossier chez le client
![image](https://github.com/user-attachments/assets/41d86b0f-b512-427f-b147-dc3227fcbb08)

</details>


---
