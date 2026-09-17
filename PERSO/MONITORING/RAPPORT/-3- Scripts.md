## Récupération Données sur Bareos

---
`[NOTE]`

Scripts côté Bareos et Windows, pousse vers le pipeline n8n -voir [-2-Pipeline.md](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/-1-%20N8N/-2-Pipeline.md).

---
### -1- Script de récupération du statut (`192.168.0.240`)

- se script est déclenché par `.service` et `.timer`

`- 1.1` Créer le script
````
vim $HOME/monitoring/script/recup-status-bareos.sh
````

`- 1.2` Edition
````
#!/bin/bash

TOKEN_N8N="<token webhook>"
URL_N8N="https://n8n.nalsed.fr/webhook/<chaine-aleatoire-longue>"

# === TEXT ===

TEXT_IT=$'=== Bareos [ 192.168.0.240 ] ===\n🟢 Sauvegarde Incrémentale réussie 🟢\n\nSouhaitez-vous éteindre [ 192.168.0.235 ] ?'

TEXT_IW=$'=== Bareos [ 192.168.0.240 ] ===\n🟡 Sauvegarde Incrémentale réussie, avec Warning 🟡\n\nSouhaitez-vous éteindre [ 192.168.0.235 ] ?'

TEXT_FT=$'=== Bareos [ 192.168.0.240 ] ===\n🟢 Sauvegarde Full réussie 🟢\n\nSouhaitez-vous éteindre [ 192.168.0.235 ] ?'

TEXT_FW=$'=== Bareos [ 192.168.0.240 ] ===\n🟡 Sauvegarde Full réussie, avec Warning 🟡\n\nSouhaitez-vous éteindre [ 192.168.0.235 ] ?'

TEXT_E=$'=== Bareos [ 192.168.0.240 ] ===\n🔴 Échec de la sauvegarde 🔴\n\nSouhaitez-vous éteindre [ 192.168.0.235 ] ?'

# === Récupération du statut ===

bconsole <<'END_OF_DATA' >/dev/null 2>&1
wait
@output /home/sednal/bconsole.log
list jobs
@output
quit
END_OF_DATA

tail -3 /home/sednal/bconsole.log | awk '{print $15, $21}' > /home/sednal/bconsole_result.log
read -r LEVEL STATUS < /home/sednal/bconsole_result.log

# === Choix du message et du popup ===

case "$LEVEL $STATUS" in
    "I T") TEXT="$TEXT_IT" ; POPUP=ok  ;;
    "I W") TEXT="$TEXT_IW" ; POPUP=ok  ;;
    "F T") TEXT="$TEXT_FT" ; POPUP=ok  ;;
    "F W") TEXT="$TEXT_FW" ; POPUP=ok  ;;
    *)     TEXT="$TEXT_E"  ; POPUP=nok ;;
esac

# === Popup local sur 235 ===

ssh sednal@192.168.0.235 "ssh sednal@192.168.0.235 "schtasks /run /tn Popup_Bareos_${POPUP}""

# === Envoi à n8n ===

curl -s -X POST \
  -H "Content-Type: application/json" \
  -H "Bareos-Token: ${TOKEN_N8N}" \
  --data-raw "$(jq -n --arg l "$LEVEL" --arg s "$STATUS" --arg t "$TEXT" \
        '{level:$l, status:$s, text:$t}')" \
  "$URL_N8N"
````

`- 1.3` Execution
````
chmod +x $HOME/monitoring/script/recup-status-bareos.sh
````

---

### -2- Déclenchement du script `` sur `192.168.0.240` via `.service` et `.timer`

**.service**

`- 2.1` Création
````
sudo vim /etc/systemd/system/bareos-status.service
````

`- 2.2` Edition
````
[Unit]
Description= Permet de lancer le script de récupération status Bareos

[Service]
Type=oneshot
User=sednal
ExecStart=/home/sednal/monitoring/script/recup-status-bareos.sh
````



**.timer**

`- 2.3` Création
````
sudo vim /etc/systemd/system/bareos-status.timer
````

`- 2.4` Edition
````
[Unit]
Description=Démarre le service : bareos-status.service

[Timer]
OnCalendar= Sun *-*-* 12:20:00

[Install]
WantedBy=timer.target
````

`- 2.5` Démarrage service + timer
````
sudo systemctl daemon-reload
sudo systemctl enable --now bareos-status.timer
systemctl list-timers bareos-status.timer
````


---
### -3- Scripts popup sur `192.168.0.235`

`=== réussite ===`
````
notepad C:\Scripts\popup_shutdown_ok.vbs
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
notepad C:\Scripts\popup_shutdown_nok.vbs
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
