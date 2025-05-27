
# `DNS LOCAL VIA BIND`

---
![image](https://github.com/user-attachments/assets/7934ad91-7f2b-482f-a3a7-3523cf6df6cc)



# routeur 192.168.0.1
# DNS1_PiHole 192.168.0.241
# DNS2_bind9 192.168.0.122
# plex 192.168.0.245
# Serveur_Web 192.168.0.133
# wifi 192.168.0.100

---

## 1️⃣ `Installer bind et présentation`
## 2️⃣ `Configuration : named.conf.options`
## 3️⃣ `Configuration : named.conf.local`
## 4️⃣ `Configuration : db.local`
## 5️⃣ `Configuration : named.conf.lan `
## 6️⃣ `Test`
## 7️⃣ `Récap`
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

        zone "sednal.lan" {
            type master;
            file "/etc/bind/db.sednal.lan";
            allow-update { none; };
        };
---

## 4️⃣ `Configuration : db.lan`

### Déclaration de la zone

### Copier le fichier de base en cas d'erreurs
        cp /etc/bind/db.local /home/sednal/Documents/Bkp_DNS/

### Copier le fichier de base dans le fichier déclaré plus haut (db.sednal.lan)
        sudo cp /etc/bind/db.local /etc/bind/db.sednal.lan

## ⚠️Utilisation de .lan car .local peux provoquer des conflits, avec des appareils Apple ou Linux qui supportent mDNS.

### Editer le fichier : /etc/bind/db.sednal.lan

            ; BIND data file for sednal.lan
            ;
            $TTL    604800
            @       IN      SOA     dns-secondaire.sednal.lan. admin.sednal.lan. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
            ;
            @       IN      NS      dns-secondaire.sednal.lan.

            ;DNS Secondaire Bind9
            dns-secondaire IN      A       192.168.0.210
            dns     IN CNAME     dns-secondaire.sednal.lan.
            ;Services Infra
            ;
            pihole  IN      A        192.168.0.241 ;DSN Principale
            ;
            srv-web IN      A        192.168.0.122 ;Serveur apache
            www     IN      CNAME    srv-web.sednal.lan.
            ;
            plex    IN      A        192.168.0.122
            ;
            bareos  IN      A        192.168.0.122 ;Sauvegarde
            ;
            cockpit IN      A        192.168.0.122 ;Administration serveur debian
            ;
            wifi    IN      A        192.168.0.100
            ;
        
<details>
<summary>
<h2>
:arrow_forward: 📝 EXPLICATION
</h2>
</summary>

* "$TTL 604800" correspond à la durée de vie des informations fournies en seconde

* @ : désigne la racine de la zone, => sednal.lan.

* "SOA"Start Of Authority, soit les paramètres principaux de la zone => serveur qui a autorité sur la zone, puis l’adresse e-mail du contact technique dont le caractère « @ » est remplacé par un «.». La valeur "srv-dns.sednal.local." sert à indiquer le serveur DNS primaire (même si c'est pihole en réalité)

* Serial "1" : numéro de série de la zone. À incrémenter chaque fois que le fichier de zone est modifié pour notifier les serveurs secondaires d'une mise à jour.
 
 * Refresh "604800" : c’est le délai de rafraichissement pour la synchronisation des configurations entre plusieurs serveurs DNS.
 
 * Retry "86400" : c’est le délai au bout duquel un serveur DNS secondaire devra retenter une synchronisation si celle qu'il a faite au bout du temps "refresh" a échoué.
 
 * Expire "2419200" : si toutes les tentatives de synchronisation échouent, un serveur DNS secondaire considérera qu'il ne peut plus répondre aux requêtes concernant cette zone une fois que le temps est écoulé. Par défaut, le temps est de "2419200" secondes, soit 28 jours.

* Negative Cache TTL "86400" : durée de conservation dans le cache de l'information "NXDOMAIN" lorsqu'un incident se produit (échec de résolution).

ICI je fait un enregistrement CNAME pour pointer via les cous domain indiqué dans le fichier de conf.

</details>
       
### Tester le config
        named-checkzone sednal.local /etc/bind/db.sednal.lan

### Sortie attendu
![image](https://github.com/user-attachments/assets/ea3ed0d0-c04a-4fe9-a471-76407f43ead7)


---

## 5️⃣ `Configuration : named.conf.local `

### Ici nous allons configuré une recherche inversée pour le réseau 192.168.0.0/24 pour obtenir un nom d'hôte à partir d'une adresse IP.

### Edition de la zone inverse

        zone "0.168.192.in-addr.arpa" {
            type master;
            file "/etc/bind/db.reverse.sednal.lan";
            allow-update { none; };

### Edition du fichier db.reverse.sednal.lan depuis db.sednal.lan
        sudo cp /etc/bind/db.sednal.lan /etc/bind/db.reverse.sednal.lan
        sudo nano /etc/bind/db.reverse.sednal.lan

### Editer les services comme ceci

        ;
        ; BIND data file for 0.168.192.in-addr.arpa
        ;
        $TTL    604800
        @       IN      SOA     dns-secondaire.sednal.lan. admin.sednal.lan. (
                                      2         ; Serial
                                 604800         ; Refresh
                                  86400         ; Retry
                                2419200         ; Expire
                                 604800 )       ; Negative Cache TTL
        ;
        @       IN      NS      dns-secondaire.sednal.lan.
        210     IN      PTR     dns-secondaire.sednal.lan.
        241     IN      PTR     pihole.sednal.lan.
        122     IN      PTR     srv-web.sednal.lan.
        141     IN      PTR     plex.sednal.lan.
        100     IN      PTR     wifi.sednal.lan.

### Tester le fichier

        named-checkzone 0.168.192.in-addr.arpa /etc/bind/db.reverse.sednal.lan

### Résultat attendu

![image](https://github.com/user-attachments/assets/47df5bda-94aa-42f7-b612-1648b164ddd8)

### Démarage et autorisation de bind9

        sudo systemctl start bind9
        sudo systemctl enable named.service
        sudo systemctl status bind9

### Dans resolv.conf 

    search sednal.lan
    domain sednal.lan









---

## 6️⃣ `Test`

### Test réalisé sur le PC admin

![image](https://github.com/user-attachments/assets/826dac50-5a4c-425b-a4a0-a7997df235b0)


---

## 7️⃣ `Récap`

## 1️⃣ Instalation

---

## 2️⃣ Déclarer les options sur le serveur DNS (Configuration de base)


---

## 3️⃣ Déclaration de zone (on pourrai faire la zonne simple et inversé en même temps)

### * Faire un backup du document de base `named.conf.local`
### * Dans `named.conf.local` déclarer la zone simple => `db.sednal.local`
### * Editer la zone simple db.sednal.local et vérif
### * Copier la zone simple `db.sednal.local` dans le fichier de zone inverse `db.reverse.sednal.local`, pour éviter une typo et gagne du temps.
 
### Fichier `named.conf.local`
![image](https://github.com/user-attachments/assets/1aa6150a-0b08-4e53-ac61-46a0b9c21f39)

### * Editer la zone inverse `db.reverse.sednal.local` et vérif.
### Test


