# Test la mise en place des communications SSL.

---

### 1️⃣ Vault
### 2️⃣ Infra
### 3️⃣ Bareos
### 4️⃣ Pihole
### 5️⃣ Cockpit
### 6️⃣ Proxmox

---

- Utilisation de openssl pour tester la connection SSL

---

### 1️⃣ **Vault** 192.168.0.238

`-1.1.` Commande de test
````
openssl s_client -connect vault.sednal.lan:8200
````

`-1.2.` Extrait de la sortie
````
CONNECTED(00000003)
depth=1 CN=Sednal-CA
verify return:1
depth=0 CN=vault.sednal.lan
verify return:1
---
Certificate chain
 0 s:CN=vault.sednal.lan
   i:CN=Sednal-CA
   a:PKEY: RSA, 4096 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Mar  9 01:58:23 2026 GMT; NotAfter: Mar  9 01:58:23 2027 GMT

[...]

subject=CN=vault.sednal.lan
issuer=CN=Sednal-CA
````

---

### 2️⃣ **Infra**

`-2.1.` Commande de test
````
openssl s_client -connect vault.sednal.lan:8200
````

`-2.2.` Extrait de la sortie
````
CONNECTED(00000003)
depth=2 CN = sednal.com
verify return:1
depth=1 CN = sednal.lan Intermediate Authority
verify return:1
depth=0 CN = infra.sednal.lan
verify return:1
---
Certificate chain
 0 s:CN = infra.sednal.lan
   i:CN = sednal.lan Intermediate Authority
   a:PKEY: id-ecPublicKey, 384 (bit); sigalg: RSA-SHA256
   v:NotBefore: Feb 26 12:39:03 2026 GMT; NotAfter: May 27 12:39:33 2026 GMT

[...]

subject=CN = infra.sednal.lan
issuer=CN = sednal.lan Intermediate Authority
````




---

### 3️⃣ Bareos

- Pour Bareos, les différents Daemon comunique en SSl ainsi , que la WebUi.

`-3.1` **DIR**

`-2.2.1` Commande de test
````
openssl s_client -connect bareos.sednal.lan:9101 -CAfile /etc/bareos/ssl/ca/Sednal_Root_All.crt
````

`-2.2.2` Extrait de la sortie
````
Certificate chain
 0 s:CN=bareos-dir.sednal.lan
   i:CN=sednal.lan Intermediate Authority
   a:PKEY: RSA, 4096 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:38:42 2026 GMT; NotAfter: May 27 12:39:09 2026 GMT
 1 s:CN=sednal.lan Intermediate Authority
   i:CN=sednal.com
   a:PKEY: RSA, 2048 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:08:35 2026 GMT; NotAfter: Feb 25 12:09:05 2031 GMT
 2 s:CN=sednal.com
   i:CN=sednal.com
   a:PKEY: RSA, 4096 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:04:22 2026 GMT; NotAfter: Feb 27 12:04:52 2051 GMT

[...]

subject=CN=bareos-dir.sednal.lan
issuer=CN=sednal.lan Intermediate Authority
````


`-3.2` **SD**

`-2.2.1` Commande de test
````
openssl s_client -connect bareos.sednal.lan:9103
````

`-2.2.2` Extrait de la sortie
````
Certificate chain
 0 s:CN=bareos-sd-local.sednal.lan
   i:CN=sednal.lan Intermediate Authority
   a:PKEY: RSA, 4096 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:38:46 2026 GMT; NotAfter: May 27 12:39:15 2026 GMT
 1 s:CN=sednal.lan Intermediate Authority
   i:CN=sednal.com
   a:PKEY: RSA, 2048 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:08:35 2026 GMT; NotAfter: Feb 25 12:09:05 2031 GMT
 2 s:CN=sednal.com
   i:CN=sednal.com
   a:PKEY: RSA, 4096 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:04:22 2026 GMT; NotAfter: Feb 27 12:04:52 2051 GMT
[...]

subject=CN=bareos-sd-local.sednal.lan
issuer=CN=sednal.lan Intermediate Authority
---
````


`-3.3` **FD**

`-2.2.1` Commande de test
````
openssl s_client -connect bareos.sednal.lan:9102
````

`-2.2.2` Extrait de la sortie
````
---
Certificate chain
 0 s:CN=bareos-fd.sednal.lan
   i:CN=sednal.lan Intermediate Authority
   a:PKEY: RSA, 4096 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:38:44 2026 GMT; NotAfter: May 27 12:39:13 2026 GMT
 1 s:CN=sednal.lan Intermediate Authority
   i:CN=sednal.com
   a:PKEY: RSA, 2048 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:08:35 2026 GMT; NotAfter: Feb 25 12:09:05 2031 GMT
 2 s:CN=sednal.com
   i:CN=sednal.com
   a:PKEY: RSA, 4096 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:04:22 2026 GMT; NotAfter: Feb 27 12:04:52 2051 GMT
[...]

subject=CN=bareos-fd.sednal.lan
issuer=CN=sednal.lan Intermediate Authority
````


`-3.4` **WebUi**

`-2.2.1` Commande de test
````
openssl s_client -connect bareos.sednal.lan:443
````

`-2.2.2` Extrait de la sortie
````
Certificate chain
 0 s:CN=bareos.sednal.lan
   i:CN=sednal.lan Intermediate Authority
   a:PKEY: RSA, 4096 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:38:49 2026 GMT; NotAfter: May 27 12:39:17 2026 GMT
 1 s:CN=sednal.lan Intermediate Authority
   i:CN=sednal.com
   a:PKEY: RSA, 2048 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:08:35 2026 GMT; NotAfter: Feb 25 12:09:05 2031 GMT
 2 s:CN=sednal.com
   i:CN=sednal.com
   a:PKEY: RSA, 4096 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:04:22 2026 GMT; NotAfter: Feb 27 12:04:52 2051 GMT

[...]

subject=CN=bareos.sednal.lan
issuer=CN=sednal.lan Intermediate Authority
````


`-3.5` **PostGreSQL**

`-2.2.1` Commande de test
````
openssl s_client -connect 192.168.0.240:443 -starttls postgres
````

`-2.2.2` Extrait de la sortie
````
depth=2 CN=sednal.com
verify return:1
depth=1 CN=sednal.lan Intermediate Authority
verify return:1
depth=0 CN=postgresql.sednal.lan
verify return:1
---
Certificate chain
 0 s:CN=postgresql.sednal.lan
   i:CN=sednal.lan Intermediate Authority
   a:PKEY: RSA, 4096 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:38:55 2026 GMT; NotAfter: May 27 12:39:24 2026 GMT
 1 s:CN=sednal.lan Intermediate Authority
   i:CN=sednal.com
   a:PKEY: RSA, 2048 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:08:35 2026 GMT; NotAfter: Feb 25 12:09:05 2031 GMT
 2 s:CN=sednal.com
   i:CN=sednal.com
   a:PKEY: RSA, 4096 (bit); sigalg: sha256WithRSAEncryption
   v:NotBefore: Feb 26 12:04:22 2026 GMT; NotAfter: Feb 27 12:04:52 2051 GMT

[...]

Certificate chain
 0 s:CN = cockpit.sednal.lan
   i:CN = sednal.lan Intermediate Authority
---

[...]

subject=CN=postgresql.sednal.lan
issuer=CN=sednal.lan Intermediate Authority
````



---

### 4️⃣ Pihole

`-4.1. `**PIHOLE**

`-4.1.1` Commande de test
````
openssl s_client -connect vault.sednal.lan:8200
````

`-4.1.2` Extrait de la sortie
````
CONNECTED(00000003)
depth=2 CN = sednal.com
verify return:1
depth=1 CN = sednal.lan Intermediate Authority
verify return:1
depth=0 CN = pihole.sednal.lan
verify return:1
---
Certificate chain
 0 s:CN = pihole.sednal.lan
   i:CN = sednal.lan Intermediate Authority
---

[...]

subject=CN = pihole.sednal.lan
issuer=CN = sednal.lan Intermediate Authority
````


---

### 5️⃣ Cockpit


`5.2 `**COCKPIT**

`-5.2.1` Commande de test
````
openssl s_client -connect cockpit.sednal.lan:9090
````

`-5.2.2` Extrait de la sortie
````
CONNECTED(00000003)
depth=2 CN = sednal.com
verify return:1
depth=1 CN = sednal.lan Intermediate Authority
verify return:1
depth=0 CN = cockpit.sednal.lan
verify return:1
---
Certificate chain
 0 s:CN = cockpit.sednal.lan
   i:CN = sednal.lan Intermediate Authority
---

[...]

subject=CN = cockpit.sednal.lan

issuer=CN = sednal.lan Intermediate Authority
````

---

### 6️⃣ Proxmox

`-6.1.` Commande de test
````
openssl s_client -connect proxmox.sednal.lan:8006
````

`-6.2.` Extrait de la sortie
````
CONNECTED(00000003)
depth=2 CN = sednal.com
verify return:1
depth=1 CN = sednal.lan Intermediate Authority
verify return:1
depth=0 CN = proxmox.sednal.lan
verify return:1
---
Certificate chain
 0 s:CN = proxmox.sednal.lan
   i:CN = sednal.lan Intermediate Authority
   a:PKEY: rsaEncryption, 4096 (bit); sigalg: RSA-SHA256
   v:NotBefore: Feb 26 12:39:01 2026 GMT; NotAfter: May 27 12:39:29 2026 GMT

[...]

subject=CN = proxmox.sednal.lan
issuer=CN = sednal.lan Intermediate Authority
````
