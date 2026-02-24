# Fichier de configuration de chaque client pour implémentation SSL.

---

`[RAPPEL]`

- **Vault PKI** : 192.168.0.238
- **Serveur Web / Infra** : 192.168.0.239
  - Apache2
- **Serveur Bareos** : 192.168.0.240
  - Bareos-dir
  - Bareos-fd
  - Bareos-sd
  - Bareos-WebUI
  - PostgreSQL
- **DNS** : 192.168.0.241
  - Pihole
  - Upsnap
  - Cockpit
- **Proxmox** : 192.168.0.242
- **VPS** : 176.31.163.227
  - Bareos-sd

---

- **Vault PKI** : 192.168.0.238 : Service SSL `OK`

---

# **Serveur Web / Infra** : 192.168.0.239

[SOURCE](https://www.it-connect.fr/configurer-le-ssl-avec-apache-2%EF%BB%BF/)

### 1️⃣ Intégration des chemins des certificats

-1.1. Modifier les chemins des certificats dans le fichier de configuration
```
sudo nano /etc/apache2/sites-available/default-ssl.conf
```

-1.2. Remplacer les lignes :
```
SSLCertificateFile      /etc/ssl/certs/ssl-cert-snakeoil.pem
SSLCertificateKeyFile   /etc/ssl/private/ssl-cert-snakeoil.key
```
Par :
```
# === RSA ===
SSLCertificateFile      /etc/infra/Cert/infra_rsa.crt
SSLCertificateKeyFile   /etc/infra/Keys/infra_rsa.key
# === ECDSA ===
SSLCertificateFile      /etc/infra/Cert/infra_ecdsa.crt
SSLCertificateKeyFile   /etc/infra/Keys/infra_ecdsa.key
```

```
sudo a2enmod ssl
sudo a2ensite default-ssl
sudo service apache2 reload
```

---

# **Serveur Bareos** : 192.168.0.240

[SOURCE](https://docs.bareos.org/TasksAndConcepts/TransportEncryption.html#example-tls-configuration-files)

### 1️⃣ Intégration des chemins des certificats

`1` **Bareos Director**

-1.1. Éditer le fichier `Director`
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

-1.3. Éditer le fichier `Storage_Local`
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

-1.5. Éditer le fichier `Storage_Remote`
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

-1.7. Éditer le fichier `win`
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

-1.9. Éditer le fichier `lin`
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

-1.11. Éditer le fichier `Local-Sd`
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

-1.13. Éditer le fichier `Director-Sd` (sur 192.168.0.240)
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

-1.16. Éditer le fichier `Remote-Sd`
```
sudo nano /etc/bareos/bareos-sd.d/storage/Remote_Sd.conf
```

-1.17. Ajouter les lignes
```
    TLS Enable = yes
    TLS CA Certificate File = /etc/ssl/CA/Sednal_Root_All.crt
    TLS Certificate = /etc/ssl/Cert/vps_rsa.crt
    TLS Key = /etc/ssl/Keys/vps_rsa.key
    TLS Verify Peer = no
```

-1.18. Éditer le fichier `Director-Sd` (176.31.163.227)
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

-1.20. Éditer le fichier `myself`
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

-1.22. Éditer le fichier `Director-fd`
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

-1.25. Éditer le fichier `directors.ini`
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

---

`5` **PostgreSQL**

[DOC](https://www.postgresql.org/docs/current/ssl-tcp.html#SSL-SETUP)

-1.27. Éditer le fichier `postgresql.conf`
```
sudo nano /etc/postgresql/18/main/postgresql.conf
```

-1.28. Ajouter les lignes
```
ssl = on
ssl_cert_file = '/etc/bareos/ssl/Cert/post/postgresql_rsa.crt'
ssl_key_file  = '/etc/bareos/ssl/Keys/post/postgresql_rsa.key'
ssl_ca_file   = '/etc/bareos/ssl/CA/Sednal_Root_All.crt'
```

-1.29. Redémarrage des services
```
sudo systemctl restart bareos-dir
sudo systemctl restart bareos-sd
sudo systemctl restart bareos-fd
sudo systemctl restart postgresql
```

-1.30. Vérification
```
sudo systemctl status bareos-dir
sudo systemctl status bareos-sd
sudo systemctl status bareos-fd
sudo systemctl status postgresql
```

### 2️⃣ Ajouter `sednal` et `postgres` au groupe `bareos`
```
sudo usermod -aG bareos sednal
sudo usermod -aG bareos postgres
```

---

# **DNS** : 192.168.0.241

### 1️⃣ Intégration des chemins des certificats

**I) Pihole**

-1.1. Éditer le fichier `pihole.toml`
```
sudo nano /etc/pihole/pihole.toml
```

-1.2. Ajouter les lignes dans la section `[webserver]`
```
ssl_cert = "/etc/ssl/Pihole/Cert/pihole_rsa.crt"
ssl_key  = "/etc/ssl/Pihole/Keys/pihole_rsa.key"
```

-1.3. Redémarrer le service
```
sudo systemctl restart pihole-FTL
```

---

**II) Upsnap**

-1.4. Éditer le fichier de configuration
```
sudo nano /home/sednal/Upsnap/docker-composer.yml
```

-1.5. Ajouter les lignes
```
services:
  upsnap:
    container_name: upsnap
    image: ghcr.io/seriousm4x/upsnap:4
    network_mode: host
    restart: unless-stopped
    volumes:
      - /srv/appdata/upsnap/data:/app/pb_data
      - /etc/ssl/Upsnap/Cert/upsnap_rsa.crt:/app/cert.crt:ro
      - /etc/ssl/Upsnap/Keys/upsnap_rsa.key:/app/cert.key:ro
    environment:
      - UPSNAP_SCAN_RANGE=192.168.0.1/24
      - TZ=Asia/Yerevan
      - UPSNAP_SSL_CERT=/app/cert.crt
      - UPSNAP_SSL_KEY=/app/cert.key
```

-1.6. Redémarrer le service
```
sudo systemctl restart upsnap
```

---

**III) Cockpit**

-1.7. Créer le fichier PEM combiné cert + clé
```
cat /etc/ssl/Cockpit/Cert/cockpit_rsa.crt \
    /etc/ssl/Cockpit/Keys/cockpit_rsa.key \
    > /etc/cockpit/ws-certs.d/cockpit.cert
chmod 640 /etc/cockpit/ws-certs.d/cockpit.cert
chown root:cockpit-ws /etc/cockpit/ws-certs.d/cockpit.cert
```

-1.8. Redémarrer le service
```
sudo systemctl restart cockpit
```


---

# **Proxmox** : 192.168.0.242

### 1️⃣ Intégration des chemins des certificats

-1.1. Copier les fichiers vers Proxmox
```
cp /etc/ssl/proxmox/Cert/proxmox_rsa.crt /etc/pve/local/pve-ssl.pem
cp /etc/ssl/proxmox/Keys/proxmox_rsa.key /etc/pve/local/pve-ssl.key
```

-1.2. Redémarrer le service
```
sudo systemctl restart pveproxy
```

---

# **VPS** : 176.31.163.227

### 1️⃣ Intégration des chemins des certificats

-1.1. Éditer le fichier de configuration du Storage Daemon
```
sudo nano /etc/bareos/bareos-sd.d/storage/Remote-Sd.conf
```

-1.2. Vérifier les chemins
```
TLS Certificate = /etc/ssl/Cert/vps_rsa.crt
TLS Key         = /etc/ssl/Keys/vps_rsa.key
```

-1.3. Redémarrer le service
```
sudo systemctl restart bareos-sd
```

---
---
## 1️⃣ Ajouter `CA Root ` au magasin de certificats sur chaque machine
````
sudo cp [ADAPTER LE CHEMIN]/CA/Sednal_Root_All.crt /usr/local/share/ca-certificates/
```

```
sudo update-ca-certificates --fresh
````
 
 
### 2️⃣ => # ⚠️ RELOAD TOUS LES SERVICES **APRES -4- Configuration_PKI**⚠️


### Infra 192.168.0.239

```
sudo a2enmod ssl
sudo a2ensite default-ssl
sudo service apache2 reload
```

### Bareos 192.168.0.240

-1. Créer le fichier PEM combiné cert + clé (requis par WebUI)
```
cat /etc/bareos/ssl/Cert/web/bareos_rsa.crt \
    /etc/bareos/ssl/Keys/web/bareos_rsa.key \
    > /etc/bareos/ssl/web/bareos_webui.pem
chmod 640 /etc/bareos/ssl/web/bareos_webui.pem
chown bareos:bareos /etc/bareos/ssl/web/bareos_webui.pem
```

-2. Redémarrage des services
```
sudo systemctl restart bareos-dir
sudo systemctl restart bareos-sd
sudo systemctl restart bareos-fd
sudo systemctl restart postgresql
```

-3. Vérification
```
sudo systemctl status bareos-dir
sudo systemctl status bareos-sd
sudo systemctl status bareos-fd
sudo systemctl status postgresql
```

### DNS 192.168.0.241

-1. pihole

Redémarrer le service
```
sudo systemctl restart pihole-FTL
```

-2. upsnap

Redémarrer le service
```
sudo systemctl restart upsnap
```

-3. cockpit

```
cat /etc/ssl/Cockpit/Cert/cockpit_rsa.crt \
    /etc/ssl/Cockpit/Keys/cockpit_rsa.key \
    > /etc/cockpit/ws-certs.d/cockpit.cert
chmod 640 /etc/cockpit/ws-certs.d/cockpit.cert
chown root:cockpit-ws /etc/cockpit/ws-certs.d/cockpit.cert
```

Redémarrer le service
```
sudo systemctl restart cockpit
```

### Proxmox 192.168.0.242 

Copier les fichiers vers Proxmox
```
cp /etc/ssl/proxmox/Cert/proxmox_rsa.crt /etc/pve/local/pve-ssl.pem
cp /etc/ssl/proxmox/Keys/proxmox_rsa.key /etc/pve/local/pve-ssl.key
```

Redémarrer le service
```
sudo systemctl restart pveproxy
```






