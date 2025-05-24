# Réalisation d'un point de montage avec >indows 11
## :disappointed_relieved: Windows ne permet pas officiellement de copier ou déplacer un point de restauration..
## Ce point de restauration restera donc sur le PC Admin.
---
## 1) Créer un point de restauration

## 2) Atomatiser la création d'un point de montage

---
---

# 1) Créer un point de restauration

## Deux solution :

### 1️⃣
### Paramètres => Système
![image](https://github.com/user-attachments/assets/bc4bdc6b-c280-4efc-957b-81e28e958889)

### Puis Protection du Système
![image](https://github.com/user-attachments/assets/f1156f65-f696-4410-80a9-f74390abb9f0)

### 2️⃣
### Powershell
     systempropertiesprotection

### On arrive sur cette fenétre
![image](https://github.com/user-attachments/assets/55c9651d-6123-4375-97d9-127fc4734d37)

### OK

### Créer 
![image](https://github.com/user-attachments/assets/dd0665aa-1fc0-4428-b814-3d913240a1a6)

### Renseigner le champs
![image](https://github.com/user-attachments/assets/38005216-cf6d-43d6-aef6-975076c159ed)

---

# 2) Atomatiser la création d'un point de restauration


## "Script" C:\Users\sednal\Resto.ps1
     Checkpoint-Computer -Description "PointAuto" -RestorePointType "MODIFY_SETTINGS"


## 2.2) `Général`

### 2.2.1) Planificateur de tâches (win + R)
          taskschd.msc

### 2.2.2) En haut à gauche => Action => Créer un tache ...
### 2.2.3) Donner un  nom à la tache, cocher Executer avec les autorisarions maximales 
          RESTO_POINT
## 2.3) `Déclencheurs` 

### 2.3.1) Nouveau...
### Ici la taache sera réalisée :
* ### Chaque mois
* ### Le premier
* ### Sera arrêtée si elle dure plus trente minutes
![image](https://github.com/user-attachments/assets/e5bf9580-59c0-4098-8356-15ba4d51c02f)

## 2.4 ) `Actions`

### 2.4.1) Nouveau...
### Action : Démarrer un programme
### Programme/script : powershell.exe
### Arguments :
          Checkpoint-Computer -Description "PointAuto" -RestorePointType "MODIFY_SETTINGS"

![image](https://github.com/user-attachments/assets/e50b4e53-37bb-4e72-a298-b28de8368517)

## 2.5 ) `Conditions`
### Décocher "Démarrer la tâche uniquement si l’ordinateur est sur secteur"
![image](https://github.com/user-attachments/assets/8280b19c-9119-4f2b-bf56-c96e5a8cef97)
















