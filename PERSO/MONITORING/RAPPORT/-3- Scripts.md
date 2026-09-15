## Récupération Données sur Bareos

---
`[NOTE]`

Scripts côté Bareos et Windows, appelés par le pipeline n8n -voir [-2-Pipeline.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/N8N/-2-Pipeline.md).

---
### -1- Script de récupération du statut (`192.168.0.240`)

````
bconsole <<END_OF_DATA
wait
@output /home/sednal/bconsole.log
list jobs
@output
quit
END_OF_DATA

tail -3 /home/sednal/bconsole.log | awk '{print $15 , $21}' > /home/sednal/bconsole_result.log
read LEVEL STATUS < /home/sednal/bconsole_result.log
echo "LEVEL=$LEVEL STATUS=$STATUS"
````

`[NOTE]`

Le node SSH n8n exécute cette commande directement sur `.240` et récupère `LEVEL=... STATUS=...` en sortie — c'est le IF node n8n qui décide ensuite OK/erreur, pas ce script.

---
### -2- Scripts popup sur `192.168.0.235`

Déclenchés par le node SSH n8n (voir [[Notification-shutdown-bareos]]) :
````
ssh sednal@192.168.0.235 "wscript C:\Scripts\popup_shutdown_ok.vbs"
````
ou
````
ssh sednal@192.168.0.235 "wscript C:\Scripts\popup_shutdown_nok.vbs"
````

`=== réussite ===`
````
C:\Scripts\popup_shutdown_ok.vbs
````
````
Set objShell = CreateObject("WScript.Shell")
result = objShell.Popup("Le job de sauvegarde est terminé avec succés. Fermer ce poste ?", 300, "Sauvegarde Bareos", 4 + 32)
If result = 6 Or result = -1 Then
    objShell.Run "shutdown /s /t 300", 0, False
ElseIf result = 7 Then
    objShell.Run "shutdown /a", 0, False
End If
````

`=== Echec ===`
````
C:\Scripts\popup_shutdown_nok.vbs
````
````
Set objShell = CreateObject("WScript.Shell")
result = objShell.Popup("Un probléme est survenue lors du BackUp sur Bareos-Server. Fermer ce poste ?", 300, "Sauvegarde Bareos", 4 + 32)
If result = 6 Or result = -1 Then
    objShell.Run "shutdown /s /t 300", 0, False
ElseIf result = 7 Then
    objShell.Run "shutdown /a", 0, False
End If
````
