# Configuration du  Fichier FileSet

---

[FILESET-BAREO](https://docs.bareos.org/Configuration/Director.html#fileset-resource)

---

## 1️⃣ LAN

### 1.1) BackUp WIN =>/etc/bareos/bareos-dir.d/fileset/`Win_BackUp_FileSet_LAN.conf`
    
    FileSet {
      Name = Win_BackUp_FileSet_LAN
      Enable VSS = yes
        Include {
                Options{
                        noatime = yes
                        ignore case = yes
                        signature = MD5
                        }
                File = "A:/save"
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



### 1.2) Archive WIN => /etc/bareos/bareos-dir.d/fileset/`Win_Archive_FileSet_LAN.conf`
    FileSet {
      Name = Win_Archive_FileSet_LAN
      Enable VSS = yes
        Include {
                Options{
                        noatime = yes
                        ignore case = yes
                        signature = SHA256
                        }
                File = "A:/clonage/"
                }
        }
### 1.3) Archive LIN => /etc/bareos/bareos-dir.d/fileset/`Lin_Archive_FileSet_LAN.conf`
    


            FileSet {
            
            Name =  Lin_BackUp_FileSet_LAN
            
            
            Include {
                Options {
                    # Utilise SHA256 pour vérifier les fichiers
                    signature = SHA256
            
                    # Ne met pas à jour l'horodatage des fichiers
                    noatime = yes
                }
            
                File = "/home/sednal/BackUp_SQL_Bareos"
                File = "/home/sednal/BackUp_Conf_Bareos"
                File = "/etc/bareos"
                File = "/home/sednal/.ssh"
                File = "/home/sednal/.psql_history"
            }
            
            # Exclu de la sauvegarde
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


---

## 2️⃣ WAN

### 2.1) BackUp => /etc/bareos/bareos-dir.d/fileset/`Win_BackUp_FileSet_WAN.conf`
             FileSet {
                  Name = Win_BackUp_FileSet_WAN
                  Enable VSS = yes
                    Include {
                            Options{
                                    noatime = yes
                                    ignore case = yes
                                    signature = MD5
                                    }
                            File = "A:/save/backup  config"
                            File = "A:/save/Bash"
                            File = "A:/save/PKI"
                             File = "A:/save/Python"
                             File = "A:/save/WCS"
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
                               File = "A:/save/WCS/challengeTSSR"
                               File = "A:/save/WCS/WSC/ISO + logiciel"
            
                            }
            
                        }
