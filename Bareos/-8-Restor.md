
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
## 4️⃣ ``
## 5️⃣ ``
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
 
### Ici  



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
