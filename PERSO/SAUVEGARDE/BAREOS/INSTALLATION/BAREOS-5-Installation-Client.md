
# `Installation Client `

---

[TUTO](https://docs.bareos.org/TasksAndConcepts/TheWindowsVersionOfBareos.html#windows-installation) et surtout [TUTO svennd](https://svennd.be/adding-a-linux-client-to-bareos/)

---

## 1️⃣ `Installation Bareos win`
## 2️⃣ `Instalation client Bareos Linux`

---
---

<details>
<summary>
<h2>
1️⃣ Installation Bareos win
</h2>
</summary>

### Télécharger le .exe [ici](https://download.bareos.org/current/windows/)
### Executer le programme
### Choisir Minimal 
![image](https://github.com/user-attachments/assets/65dfa420-578a-40fe-a7a3-f21befa8404b)

### Renseigner les infos demandées:
### ⚠️Le champs `Password` sera demandé dans le fichier de configuration => /etc/bareos/bareos-dir.d/client/<NOM-DU-FICHIER-DE-CONF.conf>
### 📝 le champs Client Monitor Password sert à utiliser Bareos Monitor(Webui), et est stoquer sur le client
![image](https://github.com/user-attachments/assets/11617c20-9e3b-442e-b272-2b3d402f6304)


### erreur ici clientwin1 et password sednal


### Autoriser le port 9102 sur le client (ouvrir powershell en admin)
      New-NetFirewallRule -DisplayName "Bareos FD" -Direction Inbound -LocalPort 9102 -Protocol TCP -Action Allow
![image](https://github.com/user-attachments/assets/a37dd36e-9c6d-4587-9483-865ad6d68ae4)





</details>

---

<details>
<summary>
<h2>
2️⃣ Instalation client Bareos Linux
</h2>
</summary>

[TUTO](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosClient.html#installing-the-bareos-universal-linux-client)

### Verifier la version de l'OS
           hostnamectl 

### Instaler gnupg (clé)
          apt update && apt upgrade
          apt install -y gnupg  

### Télécharger le script et l'exécuter
      wget https://download.bareos.org/current/VERIFIER LA VERSION VOIR ⚠️PROLEME RENCONTE ⚠️
      chmod +x add_bareos_repositories.sh
      ./add_bareos_repositories.sh
      apt update

<details>
<summary>
<h2>
⚠️PROLEME RENCONTE ⚠️
</h2>
</summary>

### Impossible d'installer bareos-fd sur un rasberrypi sous debian
### Chapitre APRES Télécharger le script et l'exécuter ⬆️
### Message
![image](https://github.com/user-attachments/assets/ab149f41-33f0-43f3-b84e-46be7344a276)

### 1) bien regarder la version du script dans [current](https://download.bareos.org/current/) 
### 2) Debian 12 et 11 ne fontionne pas malgrés :
![image](https://github.com/user-attachments/assets/a6a5e6c3-eb47-4204-87a8-facadd1052d9)

### 3) Je choisi donc d'utiliser `Universal Linux Client (ULC)` [voir](https://docs.bareos.org/IntroductionAndTutorial/InstallingBareosClient.html#installing-the-bareos-universal-linux-client)

### Bien verifier l'architecture,avec `hostnamectl` 

### Et aussi la version de `Openssl` ici OpenSSL 3.0.15 3 Sep 2024

### DONC => cette [VERSION](https://download.bareos.org/current/ULC_deb_OpenSSL_3.0/)

### 4) Une fois l'execution du script, nouveau probléme..
![image](https://github.com/user-attachments/assets/3e9415f0-5c55-4a9b-8287-574bc62c594f)
### lsof (List Open Files) est un utilitaire sur les systèmes Unix/Linux.
### n'est pas installé donc 
![image](https://github.com/user-attachments/assets/921309d9-6307-43db-93e5-89245ce73bcd)

### 5) Probléme avec sources.list...
### Voir les listes enregistrée et la surprise
![image](https://github.com/user-attachments/assets/beae489e-3eff-4a4f-a619-9824aacc9673)

### 6) Rédiger les listes:
            nano sources.list
            deb http://deb.debian.org/debian/ bookworm main contrib non-free
            deb-src http://deb.debian.org/debian/ bookworm main contrib non-free

### 7) Instaler lsof
      apt install lsof

![image](https://github.com/user-attachments/assets/0046784d-1d09-4bf3-abb5-788c3bac52b9)
      
### 8) Enfin Bareos-fd
      apt install bareos-filedaemon
![image](https://github.com/user-attachments/assets/6e2bf99a-cd76-4c0e-86e7-ddf73bc54201)

### BINGO



</details>

### Demarrer le service
            systemctl start bareos-fd
            systemctl status bareos-fd

![image](https://github.com/user-attachments/assets/897030ca-017f-415e-b34b-22b557441cf4)

### SUR le `serveur`:
      bconsole
      configure add client name=DNS1 address=192.168.0.241 password=sednal
![image](https://github.com/user-attachments/assets/790e4937-c00e-4035-ad2d-d16757339343)

### copier la resource créer DEPUIS le `serveur`, SUR le `client` :  
      scp /etc/bareos/bareos-dir-export/client/DNS1/bareos-fd.d/director/bareos-dir.conf root@192.168.0.241:/etc/bareos/bareos-fd.d/director/
      systemctl start bareos-fd

            
### SUR le `client` vérifier que le port 9102 est ouvert
            ss -tulpn
![image](https://github.com/user-attachments/assets/f4c4a75a-0444-415d-a4e6-0bae17c298aa)

![image](https://github.com/user-attachments/assets/de605070-9296-4a61-b8d3-cb974c4ca038)

### Pas d'erreur


### Vérifier SUR le `serveur`:
      bconsole      
      status client

### Sortie attendu 
![image](https://github.com/user-attachments/assets/9ba42ef5-39a9-4f7b-9123-c2223ae19fcd)

### 


</details>


