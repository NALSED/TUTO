# Différente manière de  régler l'heure ou debug des probléme lié à l'heure et date d'une machine

---
---

## `Debian 12`

### `changer le fuseau horaire`
      sudo timedatectl set-timezone Asia/Yerevan

---
---

### Si la commaande ne fonbtionne pas utiliser la suite de commande

       sudo ln -sf /usr/share/zoneinfo/Asia/Yerevan /etc/localtime

- `ln` : crée un lien (raccourci vers un fichier)
- `-s` : crée un **lien symbolique** (similaire à un raccourci, pas une copie)
- `-f` : force la suppression du fichier ou lien cible s’il existe déjà
- `/usr/share/zoneinfo/Asia/Yerevan` : fichier source contenant la configuration du fuseau horaire Yerevan
- `/etc/localtime` : fichier cible que le système utilise pour connaître le fuseau horaire local

 
### Cette commande met à jour le fuseau horaire du système en remplaçant `/etc/localtime` par un lien vers la bonne zone horaire.

---

      ls -l /etc/localtime

### Permet de vérifier que `/etc/localtime` pointe bien vers `/usr/share/zoneinfo/Asia/Yerevan`.

---





         sudo systemctl restart chronyd # Ici pour Oracle si debian renplacer chronyd par ntpd ou systemd-timesyncd














