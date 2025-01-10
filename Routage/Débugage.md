

# debian ne télécharge pas les paquet

### Regarder le fichier  /etc/resolv.conf
### Et vérifier le nom du DNS

# Pas internet

1) Cable

2) Cartes Réseaux // Vlan

3) Adresse IP 

     nano /etc/network/interfaces      

        systemctl restart networking.service

5) routage en place 

      nano /etc/sysctl.conf

![image](https://github.com/user-attachments/assets/5852c7e9-9c6c-41ee-aea1-2e2abd10f51f)

6) fichier nft

![image](https://github.com/user-attachments/assets/f8f05654-d6e0-4a68-81c0-9aadcb91c50a)

5) route ip
      ip route
      ip route add 10.0.1.0/24 via 10.0.99.253

#





















