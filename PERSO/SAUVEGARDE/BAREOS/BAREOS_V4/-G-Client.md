# Configuration du fichier Client

---

[CLIENT-BAREOS](https://docs.bareos.org/Configuration/Director.html#client-resource)

---

## `-1-` Windows

### `- 1.1` Installation du client

Installation du client Windows avec la
[ressource](https://docs.bareos.org/TasksAndConcepts/TheWindowsVersionOfBareos.html#windows-configuration-files)
Bareos à [télécharger](https://download.bareos.org/current/windows/).

Suivre les instructions :

<img width="496" height="379" alt="image" src="https://github.com/user-attachments/assets/66824ac9-3bee-46e7-b294-017770cb83e4" />

### `- 1.2` win.conf

````
vim /etc/bareos/bareos-dir.d/client/win.conf
````

````
Client {
    Name = win
    Address = 192.168.0.235
    Password = "[PASSWORD]"
}
````

### `- 1.3` Règle de pare-feu Windows

À exécuter dans PowerShell en administrateur :

````
New-NetFirewallRule -DisplayName "Bareos FD" -Direction Inbound -LocalPort 9102 -Protocol TCP -Action Allow
````

---

## `-2-` Linux

### `- 2.1` lin.conf

````
vim /etc/bareos/bareos-dir.d/client/lin.conf
````

````
Client {
    Name = lin
    Address = 192.168.0.240
    Password = "[PASSWORD]"
}
````
