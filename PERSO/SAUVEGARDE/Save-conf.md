## Pour sauvgarder la conf sur pc admin
### Créer fichier de sauvegarde
    mkdir -p /root/backup-configs-bareos

### Copier la configuration
    cp -r /etc/bareos /root/backup-configs-bareos/

### Envoi   
    scp -r /root/backup-configs-bareos sednal@192.168.0.111:C:\Users\sednal

