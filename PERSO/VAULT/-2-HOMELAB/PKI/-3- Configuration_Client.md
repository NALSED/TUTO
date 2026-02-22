# Fichier de configuration de chaque client pour implémentation SSL.

---

`[RAPPEL]`

- **Vault PKI** : 192.168.0.238
- **Serveur Web / Infra** : 192.168.0.239
- **Serveur Bareos** : 192.168.0.240
- **DNS** : 192.168.0.241
- **Proxmox** : 192.168.0.242
- **Vps** : 176.31.163.227

---

- **Vault PKI** : 192.168.0.238 : Service SSL `OK`

---

- **Serveur Web / Infra** : 192.168.0.239
[SOURCE](https://www.it-connect.fr/configurer-le-ssl-avec-apache-2%EF%BB%BF/)

### 1️⃣ Intégration des chemins des certificats

-1.1. Changement des chemins pour les certificats dans le fichier de configuration
```
sudo nano /etc/apache2/sites-available/default-ssl
```

-1.2. Remplacer les lignes :
```
SSLCertificateFile      /etc/ssl/certs/ssl-cert-snakeoil.pem
SSLCertificateKeyFile   /etc/ssl/private/ssl-cert-snakeoil.key
```
Par
```
# === RSA ===
SSLCertificateFile      /etc/infra/Cert/infra_rsa.crt
SSLCertificateKeyFile   /etc/infra/Keys/infra_rsa.key
# === ECDSA ===
SSLCertificateFile      /etc/infra/Cert/infra_ecdsa.crt
SSLCertificateKeyFile   /etc/infra/Keys/infra_ecdsa.key
```

-1.3. Activer le module SSL et le site SSL
```
a2enmod ssl
a2ensite default-ssl
service apache2 reload
```

### 2️⃣ Autorisation sudo sans mot de passe pour installer/supprimer des certificats CA

-2.1. Editer
```
sudo visudo
```

-2.2. Ajouter
```
sednal ALL=(ALL) NOPASSWD: /usr/sbin/update-ca-certificates
sednal ALL=(ALL) NOPASSWD: /bin/cp
sednal ALL=(ALL) NOPASSWD: /usr/bin/rm
```

---

# **Serveur Bareos** : 192.168.0.240

[SOURCE](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#example-tls-configuration-files)

### 1️⃣ Intégration des chemins des certificats

`1` **Bareos Director**

-1.1. Editer le fichier `Director`
```
sudo nano /etc/bareos/bareos-dir.d/director/bareos-dir.conf
```

-1.2. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/bareos/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/bareos/ssl/Cert/dir/bareos-dir_rsa.crt
    TLS Key = /etc/bareos/ssl/Keys/dir/bareos-dir_rsa.key
    TLS Verify Peer = yes
    TLS Allowed CN = "bareos.sednal.lan"
```

-1.3. Editer le fichier `Storage_Local`
```
sudo nano /etc/bareos/bareos-dir.d/storage/Storage_Local.conf
```

-1.4. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/bareos/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/bareos/ssl/Cert/sd/local/bareos-sd-local_rsa.crt
    TLS Key = /etc/bareos/ssl/Keys/sd/local/bareos-sd-local_rsa.key
    TLS Allowed CN = bareos.sednal.lan
```

-1.5. Editer le fichier `Storage_Remote`
```
sudo nano /etc/bareos/bareos-dir.d/storage/Storage_Remote.conf
```

-1.6. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/bareos/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/bareos/ssl/Cert/sd/remote/bareos-sd-remote_rsa.crt
    TLS Key = /etc/bareos/ssl/Keys/sd/remote/bareos-sd-remote_rsa.key
    TLS Allowed CN = vps.sednal.lan
```

-1.7. Editer le fichier `win`
```
sudo nano /etc/bareos/bareos-dir.d/client/win.conf
```

-1.8. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/bareos/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/bareos/ssl/Cert/client/win/win_rsa.crt
    TLS Key = /etc/bareos/ssl/Keys/client/win/win_rsa.key
    TLS Allowed CN = win.sednal.lan
```

-1.9. Editer le fichier `lin`
```
sudo nano /etc/bareos/bareos-dir.d/client/lin.conf
```

-1.10. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/bareos/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/bareos/ssl/Cert/client/lin/lin_rsa.crt
    TLS Key = /etc/bareos/ssl/Keys/client/lin/lin_rsa.key
    TLS Allowed CN = lin.sednal.lan
```

---

`2` **Bareos Storage Daemon — sur 192.168.0.240**

-1.11. Editer le fichier `Local-Sd`
```
sudo nano /etc/bareos/bareos-sd.d/storage/Local-Sd.conf
```

-1.12. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/bareos/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/bareos/ssl/Cert/sd/local/bareos-sd-local_rsa.crt
    TLS Key = /etc/bareos/ssl/Keys/sd/local/bareos-sd-local_rsa.key
    TLS Verify Peer = no
```

-1.13. Editer le fichier `Director-Sd` (sur 192.168.0.240)
```
sudo nano /etc/bareos/bareos-sd.d/director/bareos-dir.conf
```

-1.14. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/bareos/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/bareos/ssl/Cert/sd/local/bareos-sd-local_rsa.crt
    TLS Key = /etc/bareos/ssl/Keys/sd/local/bareos-sd-local_rsa.key
    TLS Verify Peer = yes
    TLS Allowed CN = "bareos.sednal.lan"
```

---

`2b` **Bareos Storage Daemon Remote — sur 176.31.163.227**

-1.15. Se connecter au Storage Remote
```
ssh debian@176.31.163.227
```

-1.16. Editer le fichier `Remote-Sd`
```
sudo nano /etc/bareos/bareos-sd.d/storage/Remote-Sd.conf
```

-1.17. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/ssl/Cert/vps_rsa.crt
    TLS Key = /etc/ssl/Keys/vps_rsa.key
    TLS Verify Peer = no
```

-1.18. Editer le fichier `Director-Sd` (sur VPS)
```
sudo nano /etc/bareos/bareos-sd.d/director/bareos-dir.conf
```

-1.19. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/ssl/Cert/vps_rsa.crt
    TLS Key = /etc/ssl/Keys/vps_rsa.key
    TLS Verify Peer = yes
    TLS Allowed CN = "bareos.sednal.lan"
```

---

`3` **Bareos File Daemon — sur 192.168.0.240**

-1.20. Editer le fichier `myself`
```
sudo nano /etc/bareos/bareos-fd.d/client/myself.conf
```

-1.21. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/bareos/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/bareos/ssl/Cert/fd/bareos-fd_rsa.crt
    TLS Key = /etc/bareos/ssl/Keys/fd/bareos-fd_rsa.key
    TLS Allowed CN = bareos.sednal.lan
```

-1.22. Editer le fichier `Director-fd`
```
sudo nano /etc/bareos/bareos-fd.d/director/bareos-dir.conf
```

-1.23. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/bareos/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/bareos/ssl/Cert/fd/bareos-fd_rsa.crt
    TLS Key = /etc/bareos/ssl/Keys/fd/bareos-fd_rsa.key
    TLS Verify Peer = yes
    TLS Allowed CN = "bareos.sednal.lan"
```

---

`4` **Bareos WebUI**

-1.24. Créer le fichier PEM combiné cert + clé (requis par WebUI)
```
cat /etc/bareos/ssl/Cert/web/bareos_rsa.crt \
    /etc/bareos/ssl/Keys/web/bareos_rsa.key \
    > /etc/bareos/ssl/web/bareos_webui.pem
chmod 640 /etc/bareos/ssl/web/bareos_webui.pem
chown bareos:bareos /etc/bareos/ssl/web/bareos_webui.pem
```

-1.25. Editer le fichier `directors.ini`
```
sudo nano /etc/bareos-webui/directors.ini
```

-1.26. Ajouter les lignes
```
;------------------------------------------------------------------------------
; Section bareos.sednal.lan
;------------------------------------------------------------------------------
[bareos.sednal.lan]
enabled = "yes"
diraddress = "bareos.sednal.lan"
dirport = 9101
tls_verify_peer = false
server_can_do_tls = true
server_requires_tls = false
client_can_do_tls = true
client_requires_tls = true
ca_file = "/etc/bareos/ssl/CA/Sednal_Root_All.crt"
cert_file = "/etc/bareos/ssl/web/bareos_webui.pem"
```

`5` **PostGreSQL**
```

```



### 2️⃣ Autorisation sudo sans mot de passe pour installer/supprimer des certificats CA
-1.1. Editer
```
sudo visudo
```

-1.2. Ajouter 
```
# User alias specification
sednal ALL=(ALL) NOPASSWD: /usr/sbin/update-ca-certificates
sednal ALL=(ALL) NOPASSWD: /bin/cp
sednal ALL=(ALL) NOPASSWD: /usr/bin/rm
---

# **DNS** : 192.168.0.241
### 1️⃣ Intégration des chemins des certificats
```

```


### 2️⃣ Autorisation sudo sans mot de passe pour installer/supprimer des certificats CA
-1.1. Editer
```
sudo visudo
```

-1.2. Ajouter 
```
# User alias specification
sednal ALL=(ALL) NOPASSWD: /usr/sbin/update-ca-certificates
sednal ALL=(ALL) NOPASSWD: /bin/cp
sednal ALL=(ALL) NOPASSWD: /usr/bin/rm
---

# **Proxmox** : 192.168.0.242
### 1️⃣ Intégration des chemins des certificats
```

```


### 2️⃣ Autorisation sudo sans mot de passe pour installer/supprimer des certificats CA
-1.1. Editer
```
sudo visudo
```

-1.2. Ajouter 
```
# User alias specification
sednal ALL=(ALL) NOPASSWD: /usr/sbin/update-ca-certificates
sednal ALL=(ALL) NOPASSWD: /bin/cp
sednal ALL=(ALL) NOPASSWD: /usr/bin/rm
---

 # **Vps** : 176.31.163.227
### 1️⃣ Intégration des chemins des certificats
```

```


### 2️⃣ Autorisation sudo sans mot de passe pour installer/supprimer des certificats CA
-1.1. Editer
```
sudo visudo
```

-1.2. Ajouter 
```
# User alias specification
sednal ALL=(ALL) NOPASSWD: /usr/sbin/update-ca-certificates
sednal ALL=(ALL) NOPASSWD: /bin/cp
sednal ALL=(ALL) NOPASSWD: /usr/bin/rm
