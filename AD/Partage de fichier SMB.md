# Partage de fichier via SMB sur Win 2022 (Présent ADDS DNS)

## Installer "Files and storage Service => via Tools
---
---
## Création du dossier de partage à la racine de C:
![ad1](https://github.com/user-attachments/assets/05e985b3-0a4d-435b-8e08-a4e58b461024)
### Modifier les régle pour que tout les Utilisateur du domaine est accés en lecture seul à Document_Entreprise
### (Pour les modifications de régle dossier de référer au Document Partage AD)
![ad1](https://github.com/user-attachments/assets/d8dff58f-a29b-49e3-891c-ebfef7b6ab8e)
---

## Configuration de l'AD
### Création de Client1 dans l'OU User2
![ad1](https://github.com/user-attachments/assets/0cdf2258-0e3f-4c04-b949-43d7f2365574)
### Création d'un OU GrpDeTravail puis des groupes :
* ### RH
* ### Comptabilité
* ### Direction
![ad1](https://github.com/user-attachments/assets/3dad570c-8e68-44f5-ada7-60ee8f05fe4a)

---
## Configurer le serveur SMB.
### :one Créer un nouveau partage SMB 
### SERVEUR => Disk => Volumes => C: clic droit puis "New Shares"
![ad1](https://github.com/user-attachments/assets/81949bab-44f7-499e-8da5-a05495659590)
### SMB Share- Quick
![ad1](https://github.com/user-attachments/assets/082b6bfb-c7dc-45fb-bfe1-086ebe787f25)
### Rentrer le nom du dossier de partage créer à la racine ⬇️
![ad1](https://github.com/user-attachments/assets/fa0163f0-a99c-4f12-890e-204978038735)
### Configuration d'un partage Docs dans le deossier à la racine :
![ad1](https://github.com/user-attachments/assets/be4e42a9-704f-4514-827e-097b83021cfe)
### Choisir l'option voulu
### Créer le partage.

## Gestion des Autorisations
### (Comme dans expliqué dans la section partage AD)
### Autorisation⬇️
### RH

![ad1](https://github.com/user-attachments/assets/42e89c18-63bc-4ead-8cf2-41043b81e5ee)
### Comptabilité

![ad1](https://github.com/user-attachments/assets/a2bad913-6dc7-4549-a12c-d897c9c84084)
### Direction

![ad1](https://github.com/user-attachments/assets/8154c87a-3878-4692-bf58-62f304a9fd52)

### Vérification avec Powershell des partages
  Get-SmbShare
### Résultat 
![ad1](https://github.com/user-attachments/assets/aca750f6-f644-4683-8752-b28af9620e47)

## Configuration de la connection client serveur au partage :
  New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\NOM_DU_SERVEUR\NOM_DU_PARTAGE" -Persist
  New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\WIN-35VEAKCKMFU\Docs" -Persist
![ad1](https://github.com/user-attachments/assets/e1c38cb5-b16a-44c3-89d4-fed1925b5450)








