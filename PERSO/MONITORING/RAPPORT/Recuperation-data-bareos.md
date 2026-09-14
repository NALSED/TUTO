## Récupération Données sur Bareos 

---

Ici un pipeline, récupérera les informations du job en cours ou termioniné et appliquera les actions suivantes:

- Si job `T` Completed successfully ou `W` Terminated with warnings :

-1- eteint `192.168.0.240` 

-2- Envoi une demande sur `192.168.0.235`, "Voulez vous éteindre 192.168.0.235"

-3- Envoie une demande sur Telegram, idem "Voulez vous éteindre 192.168.0.235"

---
### -1-

- Création path sur `192.168.0.239`
````
mkdir -p $HOME/monitoring/script
mkdir -p $HOME/monitoring/<SI-BESOIN>
````

### -2- Récupération Data sur Bareos `.240` et Transfert vers Infra `.239`.

- Script pour récupérer les status des job en cours / terminé

- Création script sur `192.168.0.239`

````
$HOME/monitoring/script/récupération.sh
````
````
#!/bin/bash

ssh sednal@192.168.0.240 'bash -s' <<'REMOTE_SCRIPT'

bconsole <<END_OF_DATA
wait
@output /home/sednal/bconsole.log
list jobs
@output
quit
END_OF_DATA

tail -3 /home/sednal/bconsole.log | awk '{print $'15' , $'21' }' > /home/sedna1/bconsole_result.log
read LEVEL STATUS < /home/sednal/bconsole_result.log
echo "LEVEL=$LEVEL STATUS=$STATUS"

if [[ "$STATUS" == "T" || "$STATUS" == "W" ]]; then
    scp /home/sednal/bconsole_result.log sednal@192.168.0.239:/home/sednal/bconsole_result.log
    ssh sednal@192.168.0.235 "schtasks /run /tn BackupPopup"
else
    echo "Problème, lors des Backup"
fi

REMOTE_SCRIPT
````


- Script pour tester la présence du fichier résultat et demande de validation extinction
````
$HOME/monitoring/script/test_presence.sh
````

````

````









- Sur 192.168.0.235
````
C:\Scripts\popup_shutdown.vbs
````

````
Set objShell = CreateObject("WScript.Shell")
result = objShell.Popup("Le job de sauvegarde est terminé. Fermer ce poste ?", 300, "Sauvegarde Bareos", 4 + 32)
If result = 6 Or result = -1 Then
    ' Oui (6) ou pas de réponse après 300s (-1) -> extinction
    objShell.Run "shutdown /s /t 300", 0, False
End If
````
