# Prérequis debian 12

#### 1) sudo installé et configuré

        su -
        apt update && apt install sudo
        usermod -aG sudo [USER]
        nano  /etc/hosts
        # ajouter
        127.0.1.1    origin

#### 2) 
        chmod  +x g_cert.sh
        ./g_cert.sh

###  3) Installer  rsync sur les deux machine
                 rsync -av -e ssh /home/sednal/CODE sednal@192.168.0.247:/home/sednal
