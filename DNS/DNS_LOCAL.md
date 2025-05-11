
# `DNS LOCAL VIA BIND`

---

## 1️⃣ `Installer bind et présentation`
## 2️⃣ `Configuration : named.conf.options`
## 3️⃣ ``
## 4️⃣ ``
## 5️⃣ ``
## 6️⃣ ``
## 7️⃣ ``
## 8️⃣ ``
## 9️⃣ ``



---
---

## 1️⃣ `Installer bind et présentation`

    sudo apt-get update
    sudo apt-get install bind9 dnsutils

### Lister les fichier de bind 
    ls -l /etc/bind

![image](https://github.com/user-attachments/assets/9152d40c-d710-4e85-8872-47957c508322)

### Les principaux fichiers que nous allons utilisés :

## 🟢  Les fichiers "db.<nom>" correspondent aux fichiers de zones intégrés par défaut dans Bind. A copier pour créer ses propres fichiers

## 🔵 Le fichier "named.conf" est le fichier de configuration principal de Bind9. Il contient des directives "include" pour charger 3 autres fichiers :

## 🔴 "named.conf.options" contient les options de configuration de Bind => Copier pour faire une backup.
## 🔴 "named.conf.local" sert à déclarer des zones => Copier pour faire une backup.
## 🔴 "named.conf.default-zones" contient la définition des zones incluses par défaut avec Bind.

### Copier les fichiers named.conf.options et named.conf.local

    cp named.conf.options /home/sednal/Documents/Bkp_DNS 
    cp named.conf.local /home/sednal/Documents/Bkp_DNS 
---

## 2️⃣ `Configuration : named.conf.options`

### La syntaxe est dispo ici [It-Connect](https://www.it-connect.fr/dns-avec-bind-9/)
### Conf dans l'ordre : 

### Avant le bloc Option
![Screenshot from 2025-05-11 19-16-17](https://github.com/user-attachments/assets/1a770200-9cd9-4ce5-8cc2-86f35f65d2ad)

### Bloc option:
![Screenshot from 2025-05-11 19-05-20](https://github.com/user-attachments/assets/5b4c59ad-370d-4646-8753-9929443e8ed5)

![Screenshot from 2025-05-11 19-19-54](https://github.com/user-attachments/assets/392587b9-6b34-4bdd-b1d4-a66ffe4a09e2)

    sudo named-checkconf

### Si la commande est ok pas de messages d'erreurs.


---

## 3️⃣ ``

---

## 4️⃣ ``

---

## 5️⃣ ``

---

## 6️⃣ ``

---

## 7️⃣ ``

---

## 8️⃣ ``

---

## 9️⃣ ``
