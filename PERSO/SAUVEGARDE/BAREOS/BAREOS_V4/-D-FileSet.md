# Configuration du fichier FileSet

---

[FILESET-BAREOS](https://docs.bareos.org/Configuration/Director.html#fileset-resource)

---

## `-1-` LAN

### `- 1.1` Win_BackUp_FileSet_LAN.conf

````
vim /etc/bareos/bareos-dir.d/fileset/Win_BackUp_FileSet_LAN.conf
````

````
FileSet {
    Name = Win_BackUp_FileSet_LAN
    Enable VSS = yes

    Include {
        Options {
            noatime = yes
            ignore case = yes
            signature = MD5
        }
        File = "F:/save"
        File = "C:/Users/sednal/.ssh"
        File = "C:/Users/sednal/.vscode"
        File = "C:/Users/sednal/.docker"
        File = "C:/Users/sednal/.VirtualBox"
        File = "C:/Users/sednal/Cisco Packet Tracer 8.2.2"
        File = "C:/Users/sednal/PY313"
    }
    Exclude {
        File = "C:/Users/sednal/Default"
        File = "C:/$WINDOWS.~BT"
        File = "C:/$Windows.~WS"
        File = "C:/PerfLogs"
        File = "C:/ProgramData"
        File = "C:/Programmes"
        File = "C:/Programmes(x86)"
        File = "C:/Windows"
    }
}
````

⚠️ `[ATTENTION]` ⚠️

Le disque de données est désormais monté en `F:` et non plus en `A:`.
Un changement de lettre de lecteur ne provoque **aucune erreur** côté Bareos :
le job se termine en `OK`, mais les données ne sont plus sauvegardées.
Vérifier la lettre après chaque remontage du disque.

### `- 1.2` Win_Archive_FileSet_LAN.conf

````
vim /etc/bareos/bareos-dir.d/fileset/Win_Archive_FileSet_LAN.conf
````

````
FileSet {
    Name = Win_Archive_FileSet_LAN
    Enable VSS = yes

    Include {
        Options {
            noatime = yes
            ignore case = yes
            signature = SHA256
        }
        File = "A:/clonage/"
    }
}
````

### `- 1.3` Lin_BackUp_FileSet_LAN.conf

````
vim /etc/bareos/bareos-dir.d/fileset/Lin_BackUp_FileSet_LAN.conf
````

````
FileSet {
    # Nom du FileSet
    Name = Lin_BackUp_FileSet_LAN
    Include {
        Options {
            signature = SHA256
            noatime = yes
        }
        File = "/etc/bareos"
        File = "/home/sednal/.ssh"
        File = "/home/sednal/.psql_history"
        File = "/home/sednal/VPS_Mail_BackUp"
    }
    Exclude {
        File = "/etc/bareos/.bash_logout"
        File = "/home/sednal/.bconsole_history"
        File = "/home/sednal/.lesshst"
        File = "/home/sednal/.profile"
        File = "/home/sednal/.vscode-server"
        File = "/home/sednal/.bash_history"
        File = "/home/sednal/.bashrc"
        File = "/home/sednal/.cache"
        File = "/home/sednal/.cache.dotnet"
        File = "/home/sednal/.sudo_as_admin_successful"
        File = "/home/sednal/.wget-hsts"
    }
}
````

`[NOTE]`

`File = "/home/sednal/VPS_Mail_BackUp"` est le dépôt des sauvegardes du serveur
mail rapatriées depuis le VPS par le `RunBeforeJob` du job `Lin_BackUp_Job_LAN`.
Voir [Sauvegarde du serveur mail](../../../VPS/MAIL/SAVE/README.md).

---

## `-2-` WAN

### `- 2.1` Win_BackUp_FileSet_WAN.conf

````
vim /etc/bareos/bareos-dir.d/fileset/Win_BackUp_FileSet_WAN.conf
````

````
FileSet {
    Name = Win_BackUp_FileSet_WAN
    Enable VSS = yes

    Include {
        Options {
            noatime = yes
            ignore case = yes
            signature = MD5
        }
        File = "F:/save/backup  config"
        File = "F:/save/Bash"
        File = "F:/save/PKI"
        File = "F:/save/Python"
        File = "F:/save/WCS"
        File = "C:/Users/sednal/.ssh"
        File = "C:/Users/sednal/.vscode"
        File = "C:/Users/sednal/.docker"
        File = "C:/Users/sednal/.VirtualBox"
        File = "C:/Users/sednal/Cisco Packet Tracer 8.2.2"
        File = "C:/Users/sednal/PY313"
    }
    Exclude {
        File = "C:/Users/sednal/Default"
        File = "C:/$WINDOWS.~BT"
        File = "C:/$Windows.~WS"
        File = "C:/PerfLogs"
        File = "C:/ProgramData"
        File = "C:/Programmes"
        File = "C:/Programmes(x86)"
        File = "C:/Windows"
        File = "F:/save/WCS/challengeTSSR"
        File = "F:/save/WCS/WSC/ISO + logiciel"
    }
}
````

`[NOTE]`

Chemins corrigés suite au changement de lettre de lecteur :

````
Win_BackUp_FileSet_LAN :  File = "F:/save"
Win_BackUp_FileSet_WAN :  File = "F:/save/WCS/challengeTSSR"        (Exclude)
                          File = "F:/save/WCS/WSC/ISO + logiciel"   (Exclude)
````

### `- 2.2` Lin_BackUp_FileSet_WAN.conf

````
vim /etc/bareos/bareos-dir.d/fileset/Lin_BackUp_FileSet_WAN.conf
````

````
FileSet {
    # Nom du FileSet
    Name = Lin_BackUp_FileSet_WAN
    Include {
        Options {
            signature = SHA256
            noatime = yes
        }
        File = "/etc/bareos"
        File = "/home/sednal/.ssh"
        File = "/home/sednal/.psql_history"
    }
    Exclude {
        File = "/etc/bareos/.bash_logout"
        File = "/home/sednal/.bconsole_history"
        File = "/home/sednal/.lesshst"
        File = "/home/sednal/.profile"
        File = "/home/sednal/.vscode-server"
        File = "/home/sednal/.bash_history"
        File = "/home/sednal/.bashrc"
        File = "/home/sednal/.cache"
        File = "/home/sednal/.cache.dotnet"
        File = "/home/sednal/.sudo_as_admin_successful"
        File = "/home/sednal/.wget-hsts"
    }
}
````

⚠️ `[ATTENTION]` ⚠️

Ce FileSet reprend `Lin_BackUp_FileSet_LAN` **sans** la ligne
`File = "/home/sednal/VPS_Mail_BackUp"`.

Sans ce FileSet dédié, `Lin_BackUp_Job_WAN` renverrait les sauvegardes du VPS
sur le VPS lui-même : aucun intérêt en hors-site, et volume transféré multiplié
par 4000 (117 Mo au lieu de 28 Ko).
