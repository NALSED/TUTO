## `-0-` Prérequis

---

### `-1-` Shell SSH de `192.168.0.235` en PowerShell

`- 1.1` Vérifier le chemin du binaire, PowerShell **en administrateur** sur `235`
````
Test-Path "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
````

- Doit renvoyer `True`

`- 1.2` Écrire la valeur de registre et redémarrer le service
````
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

Restart-Service sshd
````

`- 1.3` Contrôle depuis le VPS — l'invite doit être `PS C:\Users\sednal>`
````
ssh sednal@192.168.0.235
````

- Réversible :
````
Remove-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell
Restart-Service sshd
````

---

### `-2-` Tâches planifiées pour les popups sur `192.168.0.235`

`- 2.1` PowerShell  `sednal`, pas en administrateur
````
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive

$actionOk  = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "C:\Scripts\popup_shutdown_ok.vbs"
Register-ScheduledTask -TaskName "Popup_Bareos_ok" -Action $actionOk -Principal $principal -Force

$actionNok = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "C:\Scripts\popup_shutdown_nok.vbs"
Register-ScheduledTask -TaskName "Popup_Bareos_nok" -Action $actionNok -Principal $principal -Force
````

`- 2.2` Test depuis le VPS
````
ssh sednal@192.168.0.235 "schtasks /run /tn Popup_Bareos_ok"
````

`[NOTE]`

- Un `wscript` lancé directement par SSH s'exécute dans la session SSH, pas dans la session de bureau. 

---

### `-3-` Encodage des `.vbs` sur `192.168.0.235`

`- 3.1` PowerShell sur `235`
````
$f = "C:\Scripts\popup_shutdown_ok.vbs"
$c = Get-Content $f -Encoding UTF8
Set-Content $f -Value $c -Encoding Default

$f = "C:\Scripts\popup_shutdown_nok.vbs"
$c = Get-Content $f -Encoding UTF8
Set-Content $f -Value $c -Encoding Default
````

---

### `-4-` Règle sudo sur `192.168.0.240`

`- 4.1` Créer la règle
````
sudo visudo -f /etc/sudoers.d/n8n-shutdown
````

- Éditer
````
sednal ALL=(root) NOPASSWD: /sbin/shutdown
````

`- 4.2` Droits et contrôle de syntaxe
````
sudo chmod 0440 /etc/sudoers.d/n8n-shutdown
sudo visudo -c
````

`- 4.3` Test sans rien déclencher
````
sudo -k
sudo -n -l /sbin/shutdown
````

- Doit renvoyer `/sbin/shutdown`, et non `sudo: a password is required`
