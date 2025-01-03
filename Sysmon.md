# Sysmon

 ## 1️⃣ `Installation`
* ### [Télécharger](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon) Sysmon  
* ### Décompresser le fichier
* ### Dans PS allez dans le dossier Sysmon
          .\Sysmon.exe -i -accepteula
![image](https://github.com/user-attachments/assets/ddfde7a5-ea3f-45fb-a92d-7eba6a1f726f)
* ### Vérifier état de Sysmon 
        Get-Service -Name Sysmon
![image](https://github.com/user-attachments/assets/157843cb-abd6-4d36-bdc6-33521004862b)
## 2️⃣ `Event Viewer`
* ### Journal de log de Sysmon
> Applications and services Logs => Microsoft => Windows => Sysmon
### Information Logs
---
### 1 Où trouver les processid des Logs :
* ### Task manager Details et Services => PID
* ### Ressource Monitor
### 2 Extraire des infos PS :
      tasklist
### Donne la listes des Process en court ( des options sont possibles /svc /apps etc.. ) 
---
      tasklist /svc /FI "ImageName eq notepad*"
### Pour isoler notpad (quand il fonctionne)
---
       tasklist | select-string -pattern "3000"
### Isoler un PID
#### [Sources 1](https://learn.microsoft.com/fr-fr/windows-hardware/drivers/debugger/finding-the-process-id) [Sources 2](https://windowscentral.com/how-find-out-application-process-id-windows-10)
# Log Parser







