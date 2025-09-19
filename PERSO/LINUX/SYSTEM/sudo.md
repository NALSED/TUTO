# Si sudo n'est pas présent

      su -
      apt update
      apt install sudo
      usermod -aG docker sednal
      nano  /etc/hosts
      # ajouter
      127.0.1.1    origin
