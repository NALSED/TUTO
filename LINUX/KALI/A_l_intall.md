## A chaque instalation de kali

### En 4 points
---
### 1️⃣ `Mise a jour et install`
### 2️⃣ `sshd`
### 3️⃣ `UFW`
### 4️⃣ `Kali tweaks`

---
---
### 1️⃣ `Mise a jour et install` ⚠️1h:⚠️
        sudo apt update && sudo apt full-upgrade -y
        sudo apt install kali linux-everything

 ### 2️⃣ `ssh / sshd`
     sudo nano /etc/ssh/sshd_config

### Editer comme ⬇️
![image](https://github.com/user-attachments/assets/11a94ff4-fa2e-490d-a8c3-0d16db61c704)

### Et si pas besoin de ssh
        sudo service ssh stop

### 3️⃣ `UFW`
        sudo apt install ufw
        sudo ufw enable


### 4️⃣ `Kali tweaks`

![image](https://github.com/user-attachments/assets/75649a79-9754-4930-9479-0c3b25c8d3b8)

### Configurer comme ci dessous ⬇️

![image](https://github.com/user-attachments/assets/fc4413dd-341e-4bb1-8ea4-0a9e3bda89c6)

### OK




















