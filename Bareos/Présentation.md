# Présentation de Bareos

---

## `Ce document à pour but de présenter la solution Bareos.

---

## 1️⃣ `Services`
## 2️⃣ ``
## 3️⃣ ``
## 4️⃣ ``
## 5️⃣ ``
## 6️⃣ ``
## 7️⃣ ``
## 8️⃣ ``
## 9️⃣ ``



---
---

<details>
<summary>
<h2>
1️⃣ `Services`  
</h2>
</summary>

![cartographie de parcours utilisateur](https://github.com/user-attachments/assets/a9e90c68-b42c-4522-b262-428a2a5f6723)


## Composants ou services Bareos

### Bareos est composé des principaux composants ou services suivants : 

* ### Director
* ### Console
* ### File
* ### Storage
* ### Monitor.

---
---

## `Daemon Director`

### Le Director est le programme de contrôle central de tous les autres daemon. 
### Planifie et supervise toutes les opérations de sauvegarde, restauration, vérification et archivage. 
### Utilisation de Director pour planifier les sauvegardes et restaurer les fichiers. 
### ⚠️ Le Director s'exécute en tant que daemon (ou service) en arrière-plan.


---

## `Console`

### La console Bareos ( bconsole ) est le programme qui permet à l'administrateur ou à l'utilisateur de communiquer avec Bareos Director. 
### Elle s'exécute dans une fenêtre shell (interface TTY).

--- 

## `Daemon File ou ordinateur client`

### Le file deamon est un programme qui doit être installé sur chaque machine (cliente) à sauvegarder. À la demande du director Bareos, il recherche les fichiers à sauvegarder et les envoie (leurs données) au daemon de storage Bareos.
### Spécifique au système d'exploitation sur lequel il s'exécute et chargé de fournir les attributs, données,  du fichier lorsque demandé par le director Bareos.

---

## `Daemon Storage`

### Le daemon storage ,à la demande du director , reçoit les données d'un deamon de file et  stock les attributs et données des fichiers sur les supports ou volumes de sauvegarde physiques. En cas de demande de restauration, il est chargé de rechercher les données et de les envoyer au daemon de file.

---

## `Monitor`

### Les services de catalogue regroupent les logiciels responsables de la maintenance des index de fichiers et des bases de données de volumes pour tous les fichiers sauvegardés. Ils permettent de localiser et de restaurer rapidement tout fichier souhaité. Le catalogue conserve un enregistrement de tous les volumes utilisés, de toutes les tâches exécutées et de tous les fichiers enregistrés.


[terminologie](https://docs.bareos.org/IntroductionAndTutorial/WhatIsBareos.html#terminology)



</details>

---

<details>
<summary>
<h2>
2️⃣ ``  
</h2>
</summary>







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






























