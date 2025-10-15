# Disque Utilisé pour la sauegarde des Snapshot de l'infra.

---

### Ici le point de montage /mnt/snapshot sera utilisé pour stocker l'ensemble des snapshot via  Bareos
![image](https://github.com/user-attachments/assets/99d3e823-d044-437e-a508-d7c3f66601ba)

## `Fichier Bareos`

### Editer dans  /etc/bareos/bareos-sd.d/device/ pour déclarer le volume
      nano /etc/bareos/bareos-sd.d/device/SNAP.conf
### Fichier :
      Device  {
        Name = SNAP
        Media Type = File
        Archive Device = /mnt/snapshot
        Label Media = yes
        Random Access = yes
        Automatic Mount = yes
        Removable Media = no
        Always Open = yes
        }

### DROITS      
      chown bareos:bareos /etc/bareos/bareos-sd.d/device/RAID.conf /etc/bareos/bareos-sd.d/device/SNAP.conf
      chmod 640 /etc/bareos/bareos-sd.d/device/RAID.conf /etc/bareos/bareos-sd.d/device/SNAP.conf
