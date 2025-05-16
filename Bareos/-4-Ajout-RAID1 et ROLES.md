
# `Ajout du RAID 1/Pool/Job`

[TUTO](https://docs.bareos.org/TasksAndConcepts/VolumeManagement.html)


---

### Ce tuto à pour but l'implementation et la configuration du RAID1 précedement créer à la solution Bareos.


---

## 1️⃣ `Ajout RAID`
## 2️⃣ `Test Ajout RAID`
## 3️⃣ `Pool`
## 4️⃣ `FileSet`
## 5️⃣ `Job`
## 6️⃣ ``
## 7️⃣ ``
## 8️⃣ ``
## 9️⃣ ``



---
---




<details>
<summary>
<h2>
1️⃣ Ajout RAID 
</h2>
</summary>

### copier le contenu du ficher /etc/bareos/bareos-sd.d/device/FileStorage.conf dans le notre (ici RAID1.conf) et éditer comme ce qui suit:
  
![image](https://github.com/user-attachments/assets/0a191544-c124-4f33-b56b-7961e834a4d2)

### Redémmarrer les services 
      systemctl restart bareos-dir bareos-sd


</details>


---



<details>
<summary>
<h2>
2️⃣ Test
</h2>
</summary>

### Tester la configuration     
    bareos-sd -t

### Résultat attendu : Aucun message d'erreur.

  
</details>


---

## 3️⃣ ``


<details>
<summary>
<h2>
3️⃣ Pool
</h2>
</summary>

[TUTO](https://docs.bareos.org/TasksAndConcepts/AutomatedDiskBackup.html#index-3)

### 📝 Les Pools sont une organisation logique des sauvegardes.

### Création d'un pool persolnalisé, c'est à dire la manière dont on veux faire la sauvegarde :

* ### Full-Storage
* ### Incremental-Storage
* ### Differential-Storage



### Editer le fichier /etc/bareos/bareos-dir.d/pool 
    nano /etc/bareos/bareos-dir.d/pool/RAID1.conf
![image](https://github.com/user-attachments/assets/3e898ae6-d977-4f28-b8f2-4b83980113f0)

### tester la config  
    bareos-dir -t

###  Pas de message d'erreur




  
</details>


---

<details>
<summary>
<h2>
4️⃣ FileSet
</h2>
</summary>

[TUTO](https://docs.bareos.org/Configuration/Director.html#index-298) [TUTOWIN](https://svennd.be/creating-a-windows-fileset-for-bareos/)

### Un FileSet définit les fichiers et répertoires à sauvegarder (ou à exclure) dans une tâche de sauvegarde (Job).
### C’est la liste de fichiers que Bareos va traiter.

### Editer le fichier /etc/bareos/bareos-dir.d/fileset
    nano /etc/bareos/bareos-dir.d/fileset/windowsbackup.conf
![image](https://github.com/user-attachments/assets/7b937ef0-28bc-4d02-92ea-4056a5c63a18)
















</details>


---

## 5️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>

[TUTO](https://docs.bareos.org/TasksAndConcepts/CatalogMaintenance.html#index-15) // [TUTO](https://docs.bareos.org/DeveloperGuide/catalog.html#job)

### Le Job dans Bareos est une tâche qui définit le type d'opération à réaliser, comme une sauvegarde, une restauration, ou une verification des fichiers. Un Job est associé à un FileSet, un Schedule (planification), un Client, un Pool et un Storage.

### Editer le fichier /etc/bareos/bareos-dir.d/job
    nano /etc/bareos/bareos-dir.d/job/windowsbackup.conf


    

</details>


---

## 6️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>


---

## 7️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>


---

## 8️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>


---

## 9️⃣ ``

<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>
