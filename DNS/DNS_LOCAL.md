
# `DNS LOCAL VIA BIND`

---

## 1️⃣ `Installer bind et présentation`
## 2️⃣ `Configuration : named.conf.options`
## 3️⃣ `Configuration : named.conf.local`
## 4️⃣ `Configuration : db.local`
## 5️⃣ ``
## 6️⃣ ``
## 7️⃣ ``
## 8️⃣ ``
## 9️⃣ ``



---
---

## 1️⃣ `Installer bind et présentation`

    sudo apt-get update
    sudo apt-get install bind9 dnsutils

### Lister les fichier de bind 
    ls -l /etc/bind

![image](https://github.com/user-attachments/assets/9152d40c-d710-4e85-8872-47957c508322)

### Les principaux fichiers que nous allons utilisés :

## 🟢  Les fichiers "db.<nom>" correspondent aux fichiers de zones intégrés par défaut dans Bind. A copier pour créer ses propres fichiers

## 🔵 Le fichier "named.conf" est le fichier de configuration principal de Bind9. Il contient des directives "include" pour charger 3 autres fichiers :

## 🔴 "named.conf.options" contient les options de configuration de Bind => Copier pour faire une backup.
## 🔴 "named.conf.local" sert à déclarer des zones => Copier pour faire une backup.
## 🔴 "named.conf.default-zones" contient la définition des zones incluses par défaut avec Bind.

### Copier les fichiers named.conf.options et named.conf.local

    cp named.conf.options /home/sednal/Documents/Bkp_DNS 
    cp named.conf.local /home/sednal/Documents/Bkp_DNS 
---

## 2️⃣ `Configuration : named.conf.options`

### La syntaxe est dispo ici [It-Connect](https://www.it-connect.fr/dns-avec-bind-9/)
### Conf dans l'ordre : 

### Avant le bloc Option
![Screenshot from 2025-05-12 10-45-28](https://github.com/user-attachments/assets/d4bd27d1-da68-495b-b9bb-69e94b24a8e8)

### Bloc option:
![Screenshot from 2025-05-11 19-05-20](https://github.com/user-attachments/assets/5b4c59ad-370d-4646-8753-9929443e8ed5)

![Screenshot from 2025-05-11 19-19-54](https://github.com/user-attachments/assets/392587b9-6b34-4bdd-b1d4-a66ffe4a09e2)

    sudo named-checkconf

### Pas de retour si aucunes erreurs dans la fichier de conf.


---

## 3️⃣ `Configuration : named.conf.local`

### DECLARATION DE LA ZONE DNS

        zone "sednal.local" {
            type master;
            file "/etc/bind/db.sednal.local";
            allow-update { none; };
        };
---

## 4️⃣ `Configuration : db.local`

### Déclaration de la zone

### Copier le fichier de base en cas d'erreurs
        cp /etc/bind/db.local /home/sednal/Documents/Bkp_DNS/

### Copier le fichier de base dans le fichier déclaré plus haut (db.sednal.local)
        sudo cp /etc/bind/db.local /etc/bind/db.sednal.local


### Editer le fichier : /etc/bind/db.sednal.local
        sudo nano /etc/bind/db.sednal.local
                ;
        ; BIND data file for sednal.local
        ;
        $TTL    604800
        @       IN      SOA     srv-dns.sednal.local. admin.sednal.local. (
                                      2         ; Serial
                                 604800         ; Refresh
                                  86400         ; Retry
                                2419200         ; Expire
                                 604800 )       ; Negative Cache TTL
        ;
        @       IN      NS      srv-dns.sednal.local.
        srv-dns IN      A       192.168.0.122
        dns     IN      CNAME   srv-dns
        ;
        srv-pihole IN   A       192.168.0.241
        pihole  IN      CNAME   srv-pihole
        ;
        srv-web IN      A       192.168.0.244
        serveur_web IN  CNAME   srv-web
        ;
        srv-plex IN     A       192.168.0.245
        serveur_plex IN CNAME   srv-plex
        ;
        service-routeur IN A    192.168.0.1
        routeur2 IN     CNAME   service-routeur
        ;
        service-wifi IN A       192.168.0.100
        wifi     IN     CNAME   service-wifi
       
<details>
<summary>
<h2>
:arrow_forward: 📝 EXPLICATION
</h2>
</summary>

* "$TTL 604800" correspond à la durée de vie des informations fournies en seconde

* @ : désigne la racine de la zone, => sednal.local.

* "SOA"Start Of Authority, soit les paramètres principaux de la zone => serveur qui a autorité sur la zone, puis l’adresse e-mail du contact technique dont le caractère « @ » est remplacé par un «.». La valeur "srv-dns.sednal.local." sert à indiquer le serveur DNS primaire (même si c'est pihole en réalité)

* Serial "1" : numéro de série de la zone. À incrémenter chaque fois que le fichier de zone est modifié pour notifier les serveurs secondaires d'une mise à jour.
 
 * Refresh "604800" : c’est le délai de rafraichissement pour la synchronisation des configurations entre plusieurs serveurs DNS.
 
 * Retry "86400" : c’est le délai au bout duquel un serveur DNS secondaire devra retenter une synchronisation si celle qu'il a faite au bout du temps "refresh" a échoué.
 
 * Expire "2419200" : si toutes les tentatives de synchronisation échouent, un serveur DNS secondaire considérera qu'il ne peut plus répondre aux requêtes concernant cette zone une fois que le temps est écoulé. Par défaut, le temps est de "2419200" secondes, soit 28 jours.

* Negative Cache TTL "86400" : durée de conservation dans le cache de l'information "NXDOMAIN" lorsqu'un incident se produit (échec de résolution).

ICI je fait un enregistrement CNAME pour pointer via les cous domain indiqué dans le fichier de conf.























</details>






       
### Tester le config
        named-checkzone sednal.local /etc/bind/db.sednal.local

### Sortie attendu
![image](https://github.com/user-attachments/assets/ea3ed0d0-c04a-4fe9-a471-76407f43ead7)


---

## 5️⃣ ``

---

## 6️⃣ ``

---

## 7️⃣ ``

---

## 8️⃣ ``

---

## 9️⃣ ``
