# Si sudo n'est pas présent

      su -
      apt update && apt install sudo && usermod -aG sudo sednal
  
      nano  /etc/hosts
      # ajouter
      127.0.1.1    origin
