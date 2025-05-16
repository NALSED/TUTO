
# `Ajout du RAID 1/Pool/Job`

[TUTO](https://docs.bareos.org/TasksAndConcepts/VolumeManagement.html)


---

### Ce tuto à pour but l'implementation et la configuration du RAID1 précedement créer à la solution Bareos.


---

## 1️⃣ `Ajout RAID`
## 2️⃣ `Test Ajout RAID`




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
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>


---

## 4️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
</details>


---

## 5️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
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
