# Configuration du  Fichhier FileSet

---

[FILESET-BAREO](https://docs.bareos.org/Configuration/Director.html#fileset-resource)

---

## 1️⃣ LAN

### 1.1) BackUp WIN =>/etc/bareos/bareos-dir.d/fileset/`Win_BackUp_FileSet.conf`
    FileSet {
      Name = Win_BackUp_FileSet
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



### 1.2) Archive WIN => /etc/bareos/bareos-dir.d/fileset/`Win_Archive_FileSet.conf`
    FileSet {
      Name = Win_Archive_FileSet
      Enable VSS = yes
        Include {
                Options{
                        noatime = yes
                        ignore case = yes
                        signature = SHA256
                        }
                File = "A:/clonage"
                }


### 1.3) BacUp Linux => /etc/bareos/bareos-dir.d/fileset/`Lin_BackUp_FileSet.conf`

        FileSet {
                Name =  Lin_BackUp_FileSet
                Include {
        
                         Options {
                                signature = MD5
                                noatime = yes
                                }
        
                        File = "/home/sednal/Youtube"
                        File = "/etc/ca-certificates"
                        File = "/etc/ca-certificates.conf"
                        File = "/etc/nftables.conf"
                        File = "/etc/nginx"
                        File = "/etc/pihole"
                        }
                Exclude {
                        File = "/home/sednal/.bash_history"
                        File = "/home/sednal/.bash_logout"
                        File = "/home/sednal/.bashrc"
                        File = "/home/sednal/.local"
                        File = "/home/sednal/.profile"
                        }
        
                }

---

## 2️⃣ WAN

### 2.1) BackUp => /etc/bareos/bareos-dir.d/fileset/``
