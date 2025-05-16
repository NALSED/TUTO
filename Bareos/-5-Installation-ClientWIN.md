
# `Instalation Client Windows`

---

[TUTO](https://docs.bareos.org/TasksAndConcepts/TheWindowsVersionOfBareos.html#windows-installation)

---

## 1️⃣ `Installation Bareos`


---
---

<details>
<summary>
<h2>
1️⃣ `Installation Bareos`
</h2>
</summary>

### Télécharger le .exe [ici](https://download.bareos.org/current/windows/)
### Executer le programme
### Choisir Minimal 
![image](https://github.com/user-attachments/assets/65dfa420-578a-40fe-a7a3-f21befa8404b)

### Renseigner les infos demandées
![image](https://github.com/user-attachments/assets/11617c20-9e3b-442e-b272-2b3d402f6304)

### Autoriser le port 9102 sur le client (ouvrir powershell en admin)
      New-NetFirewallRule -DisplayName "Bareos FD" -Direction Inbound -LocalPort 9102 -Protocol TCP -Action Allow
![image](https://github.com/user-attachments/assets/a37dd36e-9c6d-4587-9483-865ad6d68ae4)





</details>


