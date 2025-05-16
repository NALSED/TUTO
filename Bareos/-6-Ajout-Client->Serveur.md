
# `Ajout du Client WIN sur le Serveur Bareos Debian`

[TUTO](https://docs.bareos.org/Configuration/Director.html#client-resource)

---

Ce tuto explique comment autoriser la connection Serveur/Client
---

## 1️⃣ `Ajout`
## 2️⃣ `Tets`




---
---

<details>
<summary>
<h2>
1️⃣ Ajout
</h2>
</summary>

### Editer un fichier de .conf personalisé (ici clientWIN1.conf) :
      nano /etc/bareos/bareos-dir.d/client/clientWIN1.conf
![image](https://github.com/user-attachments/assets/b3d6401c-b998-4439-8ea4-5198e520b530)




</details>


---

<details>
<summary>
<h2>
2️⃣ Tets
</h2>
</summary>

### Redemarrer service bareos-dir
      systemctl restart bareos-dir
      systemctl status bareos-dir

### résultat attendu
![image](https://github.com/user-attachments/assets/63ba94b9-3f42-4d85-b492-38b3e371e3f8)

### Test de connection client serveur
            bconsole
            status client=nom_du_client-fd

### Résultat attendu
![image](https://github.com/user-attachments/assets/3c35094b-e4e3-49af-b1f5-5afdae32a802)
      
</details>

