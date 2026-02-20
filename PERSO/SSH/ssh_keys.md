# Connection SSH sans clés

## Win => debian

### 1️⃣ Générer clé sur `WINDOWS` 

### executer powershell en admin
### vérifier l'état de sshd // créer la clé
    get-service sshd | Set-Service -StartupType automatic
    get-service sshd

### Si le service est arrêté 
    Restart-Service sshd

### Normalement sortie
![image](https://github.com/user-attachments/assets/ccbf4b8b-7824-4c50-b050-a8264791c22e)

### Créer la clé
    ssh-keygen -t ed25519
### Elle se trouve dans C:\Users\sednal/.ssh/id_ecdsa.pub 

---


### 2️⃣ Copier la clé sur `DEBIAN`

### Vérifier l'existance de dossier => /home/sednal/.ssh 
### Si inexistant
    ssh-keygen
    # qui générera le dossier ssh avec 
    -rw-r--r-- 1 sednal sednal  184 May 13 12:52 authorized_keys
    -rw------- 1 sednal sednal 2602 May 13 12:47 id_rsa
    -rw-r--r-- 1 sednal sednal  565 May 13 12:47 id_rsa.pub

### Si probléme lors de la création
     nano /home/sednal/.ssh/authorized_keys
    
### copier le fichier C:\Users\sednal\.ssh\id_ecdsa dans /home/sednal/authorized_keys











    
