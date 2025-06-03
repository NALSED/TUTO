# Descriptif de l'infra

---

##  DATE :  03/06/2025

---

# `PC ADMIN`
* ## IP 192.168.0.111
* ## DNS 192.168.0.241
* ## GATEWAY 192.168.0.1

## `SERVICES`
* ### Gestion de l'infra via `intranet` (www.lan/index.html) 

![image](https://github.com/user-attachments/assets/91aca8e8-17a6-44ae-bd8a-ec5f4b879e04)

![image](https://github.com/user-attachments/assets/36137fa0-87a8-439e-a454-d6e73ce22fad)

* ### Certificats TLS/SSL => Docker 192.168.0.103 (certif à renouveler tous les ans => C:\cert-docker) 
* ### Bareos FD

---


# `DNS1` : 
* ## IP 192.168.0.241
* ## DNS 8.8.8.8
* ## GATEWAY 192.168.0.1

## `SERVICES`
* ### `Pihole`
* ### Enregistrement A de l'infrapour serveur web 192.168.0.122

---

# `WEB` : 
* ## IP 192.168.0.122
* ## DNS 8.8.8.8
* ## GATEWAY 192.168.0.1

## `SERVICES`
* ### interface web des services :
    * ### Pihole 192.168.0.241
    * ### Plex 192.168.0.141
    * ### Bareos 192.168.0.141
    * ### Cockpit 192.168.0.141
* ### Reverse Proxy
* ### WOL pour allumer  Serveur 192.168.0.141
* ### envoie Snapshot  et Back Upsur DNS1 via Cron

---

# `SERVEUR` : 
* ## IP 192.168.0.141
* ## DNS 8.8.8.8
* ## GATEWAY 192.168.0.1

## `SERVICES`
* ### Bareos + Sauvegardesautomatisées de l'infra
* ### Plex + bibliothéque + dossier partagé avec 192.168.0.111
* ### Cockpit
* ### /dev :
    * ### RAID1 2 x 1To  => BackUp  infra
    * ### 1 TO partitionné : 300 Gb plex  / 600 Gb SnapShot


 --- 

 # `Docker` : 
* ## IP 192.168.0.101
* ## DNS 8.8.8.8
* ## GATEWAY 192.168.0.1

## `SERVICES`
* ### Docker avec certification avec 192.168.0.111(a renouveler tous les an)






















