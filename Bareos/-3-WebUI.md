# `Instalation WebUi Bareos`

---

# Ce tuto à pour but l'installation, la configutation et le test de la mise enb place d'une WebUi pour la solution Bareos.

---

[TUTO](https://docs.bareos.org/IntroductionAndTutorial/BareosWebui.html)

## 1️⃣ `Instalation`
## 2️⃣ `Configuration`




---
---

<details>
<summary>
<h2>
1️⃣ Instalation
</h2>
</summary>

### Instalation des paquet WebUi Bareos
    apt-get install bareos-webui -y

### Activer `php-fpm` pour Apache2
    a2enmod proxy_fcgi setenvif
    a2enconf php8.1-fpm
    systemctl reload apache2
    service php8.2-fpm status

### Sortie attendu:
![image](https://github.com/user-attachments/assets/7195711d-0894-44a5-b827-2ba414664030)


</details>


---


<details>
<summary>
<h2>
2️⃣ Configuration
</h2>
</summary>

### Copier le fichier d'exemple de conf 
    cp /etc/bareos/bareos-dir.d/console/admin.conf.example admin.conf
    nano admin.conf

### De base on se connect avec "user = admin // password = admin"
### changer le mot de passe et TLS Enable = false

![image](https://github.com/user-attachments/assets/f40ead2f-f399-4a5c-bcac-a79ab1e35946)

### vérifier que le fichier /etc/bareos/bareos-dir.d/profile/webui-admin.conf est présent et correct
![image](https://github.com/user-attachments/assets/bf265e7c-4ea1-4599-ae3f-129f9ea1849e)

### Redemmarer les services 
    systemctl restart apache2
    systemctl restart php8.2-fpm
    systemctl restart bareos-director


### Accés à Bareos WebUi => Dans un navigateur <IP-SERVEUR>/bareos-webui
![image](https://github.com/user-attachments/assets/261dbe72-bc50-4bfa-8884-6035d1a27d60)

### Entrer login et password défini dans => /etc/bareos/bareos-dir.d/console/admin.conf
![image](https://github.com/user-attachments/assets/7fb5d384-90d6-4bf8-a0e2-97c1c374be9f)






















</details>


