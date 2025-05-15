# `Instalation de Bareos sur Debian 12`

---

### Ce tuto à pour but de présenter la mise en place d'un raid 1 ainsi que l'instalation de Bareos

---

## 1️⃣ `Raid1`
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
1️⃣ Raid1
</h2>
</summary>


## ✏️ Petit point sur le RAID Logiciel ou Matériel (ici nous ferons un RAID logiciel)

### :open_file_folder: `Logiciel` 
### Administré par un logiciel au niveau du BIOS, installé sur un système d'exploitation

### :computer: `Matériel`
### Un contrôleur RAID gère et exécute toutes les tâches liées au RAID indépendamment du système d'exploitation.

---

## I) `Vérification des disques(Inutile sur VM)`
## II) `Préparation des disques`
## III) `Création du RAID 1`
## IV) `Création du point de montage`

---
---

## I) `Vérification des disques(Inutile sur VM)`

### 1.1) Installer l'outil de vérif (smatmontools)
  sudo apt update && apt upgrade
  sudo apt-get install smartmontools

### 1.2) lister les disques
  lsblk
### Ici la vérification se portera sur `sdb` et `sdc`
![image](https://github.com/user-attachments/assets/58305804-b5f4-47dc-8157-d3ba28c7c189)

### 1.3) Vérification
  sudo smartctl -t short /dev/sdX # Remplacer X par le bon disques

### 1.4) Résultat 
  sudo smartctl -l selftest /dev/sdX # Remplacer X par le bon disques
### Résultat attendu => « Completed without error »

---
---




## II) Préparation des disques

### Ici utilisation de gdisk pour faire du GPT (fdisk => MBR)
  gdisk /dev/sdb

### Dans gdisk en achainement des commandes 

* ### `o` pour créer une nouvelle table de partition GPT puis sur Entrée (confirmer avec Y et Entrée)

* ### On appuie sur `n` pour créer une nouvelle partition. Pour le numéro de partition, laissez par défaut. Pour ma part, c’est 1 puisque mes disques ne contiennent pas d’autres partitions. Il y a de fortes chances pour que ce soit la même chose chez vous.

* ### Pour le choix du `First Sector`, laissez le `choix par défaut`. Cela devrait vous créer une partition à partir du secteur `2048`.

* ### Idem pour le `last secto`, laissez par `défaut`.

* ### Pour le `code de la partition`, entrez `fd00` cela correspond à Linux RAID

* ### Appuyez sur `w` pour enregistrer les changements et quitter gdisk (confirmer avec Y et Entrée)


















## III) Création du RAID 1
## IV) Création du point de montage




























  
</details>


---

## 2️⃣ ``


<details>
<summary>
<h2>
:arrow_forward: Les différents types de RAID.  
</h2>
</summary>
blabla
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
