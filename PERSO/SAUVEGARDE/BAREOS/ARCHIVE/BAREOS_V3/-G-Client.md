# Fichier Client

---

###  Windows

#### 1.1) Installation du client windows avec la  [resource](https://docs.bareos.org/TasksAndConcepts/TheWindowsVersionOfBareos.html#windows-configuration-files) Bareos [télécharger](https://download.bareos.org/current/windows/).
#### Suivre les instructions :

<img width="496" height="379" alt="image" src="https://github.com/user-attachments/assets/66824ac9-3bee-46e7-b294-017770cb83e4" />

#### /etc/bareos/bareos-dir.d/client/win.conf
        
        Client {
          Name = win
          Address = 192.168.0.235
          Password = "f5YTRea7kMJN+vHuA6Biyfs0EKf+9HqGAH2z8fbkMoyw"
          }

#### Edition Powershell en admin

                  New-NetFirewallRule -DisplayName "Bareos FD" -Direction Inbound -LocalPort 9102 -Protocol TCP -Action Allow

---

### Linux

        Client {
        Name = lin
        Address =  192.168.0.240
        Password = "g+zMZtRMq3ez+8afC2nUUkmAk1ChXq4dBazhjsUl6rCu"

        }



