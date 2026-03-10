# Maintenance Certificats SSL Infra `sednal.lan`

---

`[RAPPEL]` 

- Les certificats finaux on comme TTL = 90 jours, un script de renouvelement, activer par systemd et timer est éxécuté tous les 80 jours.

`[DATE]` 

- Expiration Certificat :
- Root : `2051`
- Inter : `2031`
- Finaux : `Mai 2026`

En cas de doute utiliser la commande :
````
openssl s_client -connect [NOM DU SERVICE]
````

---

`[OPERATION]`

### **-1-** 

`192.168.0.240` => Concaténation .crt + .key, pour `Bareos WebUi`
```
cat /etc/bareos/ssl/cert/web/bareos_rsa.crt \
    /etc/bareos/ssl/keys/web/bareos_rsa.key \
    > /etc/bareos/ssl/web/bareos_webui.pem
```

```
chmod 640 /etc/bareos/ssl/web/bareos_webui.pem
```

```
chown bareos:bareos /etc/bareos/ssl/web/bareos_webui.pem
```

---

### **-2-** 

`192.168.0.241` 

- Créer le fichier PEM combiné cert + clé pour `Pihole`
```
cp /etc/pihole/ssl/cert/pihole_rsa.crt /etc/pihole/ssl/cert/cert_key_tls.pem
```

```
cat /etc/pihole/ssl/keys/pihole_rsa.key >> /etc/pihole/ssl/cert/cert_key_tls.pem
```

```
chown pihole:pihole /etc/pihole/ssl/cert/cert_key_tls.pem
```

```
chmod 600 /etc/pihole/ssl/cert/cert_key_tls.pem
```

- Créer le fichier PEM combiné cert + clé pour `Cockpit`

[DOC](https://cockpit-project.org/guide/latest/https.html#https-certificates)


`[NOTE]` Ici utilisation du certificat signé RSA pour Cockpit, les deux fichier .crt et .key doivent avoir le même nom.
```
sudo cp /etc/cockpit/ssl/cert/cockpit_rsa.crt /etc/cockpit/ssl/keys/cockpit_rsa.key /etc/cockpit/ws-certs.d/
```

```
sudo chmod 640 /etc/cockpit/ws-certs.d/cockpit_rsa.crt
```

```
sudo chmod 640 /etc/cockpit/ws-certs.d/cockpit_rsa.key
```

```
sudo chown root:cockpit-ws /etc/cockpit/ws-certs.d/cockpit_rsa.crt
```

```
sudo chown root:cockpit-ws /etc/cockpit/ws-certs.d/cockpit_rsa.key
```

````
sudo systemctl restart cockpit
````

---

### **-3-** 

`192.168.0.242` copie des certificats dans les fichier cibles pour `Proxmox`

```
cp /etc/proxmox/ssl/cert/proxmox_rsa.crt /etc/pve/local/pve-ssl.pem
cp /etc/proxmox/ssl/keys/proxmox_rsa.key /etc/pve/local/pve-ssl.key
```

---

### **-4-**

`Redémarrer les services`

`Infra` 192.168.0.239
```
sudo systemctl reload nginx
```

---

`Bareos` 192.168.0.240


```
sudo systemctl restart bareos-dir
sudo systemctl restart bareos-sd
sudo systemctl restart bareos-fd
sudo systemctl restart postgresql
```
---

`Pihole` 192.168.0.241
```
sudo systemctl restart pihole-FTL
```

---



`Cockpit` 192.168.0.241
```
sudo systemctl restart cockpit
```

---

`Proxmox` 192.168.0.242
```
sudo systemctl restart pveproxy
```


---


`Vps` 176.31.163.227
```
sudo systemctl restart bareos-sd
```

---




