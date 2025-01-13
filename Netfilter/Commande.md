# Utilisation de NFtables:
***
## SOMMAIRE :

# 1️⃣`Fontionnement`

# 2️⃣ `Commande`

# 3️⃣ `Exemples cas pratique`

***
***
# 1️⃣`Fontionnement`

![image](https://github.com/user-attachments/assets/88b4ef36-99da-4c3f-9372-1d9187526ea4)


## table => Chain => rules

### `Hook NF_IP_PRE_ROUTING` qui correspond à la chaine PREROUTING dans nftables
### Dans ce crochet, les paquets sont analysés dans leur forme brute, sans traitement préalable du système. On peut alors déterminer si on autorise le paquet à entrer plus loin dans le système ou non.

### `Hook NF_IP_LOCAL_IN` qui correspond à la chaine INPUT dans nftables
### Ici, les paquets sont prêt à être envoyés à la couche applicative, c’est-à-dire aux applications qui les traiteront (exemple : un serveur web ou un service FTP).

### `Hook NF_IP_FOWARD` qui correspond à la chaine FORWARD dans nftables
### Lorsque ce hook est utilisé, c'est que les paquets n'iront pas vers la couche applicative, mais seront redirigés vers une autre interface réseau. Par exemple dans le cas où le système est un routeur.

### `Hook NF_IP_LOCAL_OUT` qui correspond à la chaine OUTPUT dans nftables
### Il s'agit ici du même fonctionnement que la chaine INPUT, mais en sortie de la couche applicative. On va donc autoriser ou non un paquet à sortir vers l'interface réseau.

### `Hook NF_IP_POSTROUTING` qui correspond à la chaine "POSTROUTING" dans nftables
### On retrouve ici le même principe que la chaine PREROUTING" mais pour la sortie des paquets. Les paquets analysés sont ici de nouveau dans leur forme brute.

### Diff chaine/base chaine : Une base chain est une chaine qui va directement se rattacher à un hook alors qu'une simple chaine n'est par défaut pas rattachée à un hook.

## ⚠️ L'ordre des règles a une importance, il faut donc mettre les règles les plus restrictives en dernier. ⚠️

# 2️⃣ `Commande`

## [DETAILS COMMANDE](https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes)

### Syntaxe fichier Nano

        table ip mon_filtreIPv4 { #Nom de la table et famille IP
            chain input { # Chaine et la régles de cette chaine est entre {}
                type filter hook input priority filter; policy accept; # Type de filtre en input, avec priorité 0
                tcp dport 80 accept # Régle sur le protocole TCP port 80 est accépté en input
                tcp dport 443 accept # Régle sur le protocole TCP port 443 est accépté en input
                drop # Pour finir la chaine
            }

            chain output {
                type filter hook output priority filter; policy accept;
                tcp sport 80 accept
                tcp sport 443 accept
                drop 
            }
        }

#### Et voila comment la régle ci dessus est édité dans le prompt 
        
        root@debian:~# nft add rule mon_filtreIPv4 chain_in dport 80 accept
        root@debian:~# nft add rule mon_filtreIPv4 chain_in dport 443 accept
        root@debian:~# nft add rule mon_filtreIPv4 chain_in drop
        root@debian:~# nft add rule mon_filtreIPv4 chain_out sport 80 accept
        root@debian:~# nft add rule mon_filtreIPv4 chain_out sport 443 accept
        root@debian:~# nft add rule mon_filtreIPv4 chain_out drop

***


***

## 1) Tables

         #Créer
        nft add table mon_filtreIPv4
        #Liste les tables IVv4 ou IPv6
        nft list tables ip/ip6
        #Supprime
        nft delete table mon_filtreIPv4

***

## 2) Chaines

        # ajouter la chaine en input piotité 0
        nft add chain ip mon_filtreIPv4 input { type filter hook input priority 0 \; }
        #idem en output
        nft add chain ip mon_filtreIPv4 output { type filter hook output priority 0 \; }
        # lister 
        nft list table ip mon_filtreIPv4
        # deuxième table
        nft add table ip filtre2

***

## 3 ) insérer un Régle

### Utiliser `a`=> nft `a` list table ip mon_filtreIPv4 : pour lister les identifiants des règles. ( #handle)
 
 
 
 
 
 <details>
<summary>
<h2>
↔️ Utilisation :
</h2>
</summary>
 
         table ip mon_filtreIPv4 { # handle 4
                chain input { # handle 1
                type filter hook input priority filter; policy accept;
                tcp dport 80 accept # handle 4
                tcp dport 443 accept # handle 5
        drop # handle 6
    }

### Si on peux rajouter des régle en repectant l'ordre en fontion de la contrainte des régle :

                nft add rule mon_filtreIPv4 input position 5 tcp dport 22 accept # ajoute une régle qui accept, sur la chaine mon_filtreIPv4 en input , en 5 eme position, concernant le protocol tcp sur le port 22
                nft add rule mon_filtreIPv4 output position 8 tcp sport 22 accept

###  Avec `add` l'insertion de la règle se fera juste après la position ciblée

                nft insert rule mon_filtreIPv4 output position 11 tcp sport 23 accept

### Avec `insert` Pour l'insérer avant



</details>


### Supprimer un régle

                        nft -a list table ip mon_filtreIPv4 #lister les régle
                        nft delete rule mon_filtreIPv4 output handle 22 # Supprimer

### Bannir via nftables

                                nft add rule mon_filtreIPv4 input ip saddr 192.168.10.1 drop
                                nft add rule mon_filtreIPv4 output ip daddr 192.168.10.1 drop

### ⚠️ préciser la chaine input ou output en fonction de celle visée puis utiliser ip suivi de `saddr` pour source address ou `daddr` pour destination addres
### Pour bloquer une plage d'adresse ajouter le CIDR

### Gérer [Les flag TCP et ICMP](https://www.it-connect.fr/chapitres/gerer-les-flags-tcp-et-licmp-avec-nftables/)

***
 
## 4 ) Les logs

### Il est possible avec NFtables de réaliser plusieurs actions par régles
### Ici => Bloquer les comunications avec 192.16.10.1 et au serveur DNS 8.8.8.8 => et mettre le tout dans les logs  `/var/log/kern.log`

                        nft add rule mon_filtreIPv4 input ip saddr 192.168.10.1 log drop #Bloque les comunications avec 192.16.10.1


                                table ip mon_filtre {
                                    chain output {
                                        type filter hook output priority filter; policy accept;
                                        ip daddr 8.8.8.8 log drop #Bloquer les comunications au serveur DNS 8.8.8.8
                                    }
                                }


### Test de communication : 

                        root@debian:~# nslookup <NOM DE DOMAIN> 8.8.8.8

### Accés au Logs: 

                         tail -n 1 /var/log/kern.log 

### Résultats : 

> Jan 9 15:30:30 debian kernel: [32255.907870] IN= OUT=ens33 SRC=192.168.34.7 DST=8.8.8.8 LEN=59 TOS=0x00 PREC=0x00 TTL=64 ID=7996 PROTO=UDP SPT=39219 DPT=53 LEN=39

## 5) Nat

### `NAT Classique:`
### [Voir](https://github.com/NALSED/Future-R-vision/blob/main/Routage/routage%20r%C3%A9da/proc%C3%A9dure.md)

### `Nat Unidirectionnel`
### Tous les paquets qui viennent de la plage IP du réseau du client A (192.168.1.0/24) et sortant par l'interface eth1 (celle qui se trouve du côté du réseau B) auront leur adresse IP source réécrite en 192.168.2.1, l'adresse IP de l'interface du réseau B :

                                nft add rule mon_filtreIPv4 postrouting ip saddr 192.168.1.0/24 oif eth1 snat 192.168.2.1

### Elle est dite unidirectionnel car pe hook prerouting n'est pas configuré.


### `Destination NAT`

### Créer  du NAT avec des execption ou régles.

![image](https://github.com/user-attachments/assets/064e0f24-35ac-405a-8771-8dac50063593)

Exemple :

<details>
<summary>
<h2>
Destination NAT
</h2>
</summary>

### ↔️ Créer  du NAT avec des execption ou régles.

![image](https://github.com/user-attachments/assets/064e0f24-35ac-405a-8771-8dac50063593)

### Exemple :

## En s'appuiyant sur le schema ci dessus créer la régle suivante :

### Grâce au destination NAT, les paquets arrivant sur le routeur Linux avec pour port destination le port 21 auront l'IP de destination 192.168.2.1. Nous allons donc créer une règle qui dit que quand l'IP de destination est 192.168.2.1 et que le port visé est le port 21, nous allons rediriger ces paquets vers l'IP 192.168.1.102, toujours sur le port 21


                                 nft add table mon_filtreIPv4
                                 nft add chain mon_filtreIPv4 prerouting { type nat hook prerouting priority 0 \; }
                                 nft add chain mon_filtreIPv4 postrouting { type nat hook postrouting priority 0 \; }
                                 nft add rule mon_filtreIPv4 prerouting iif eth1 tcp dport 21 dnat 192.168.1.102



</details>

## 6) Mode d'édition

### 1° `La méthode interactive`

### Entrer dans le mode interactif de nftables en utilisant l'option -i 

                        root@debian# nft -i
                        nft> list tables
                        table ip nat
                        nft> list table nat
                        table ip nat {
                           chain prerouting {
                              type nat hook
                        [...]
                        nft> quit




### 2° `La méthode fichier`

### La méthode fichier permet de faire lire à nftables un fichier dont le contenu contiendra nos tables, chaines et règles. Cela se peut se faire via l'option -f qui va lire le fichier

                        nft -f nftables.rules


### 3° `nano` 

### Utiliser l'éditeur nano affind'éditer une régle préalablement créer.


## 7) Sauvegarde/Restauration/Application

### 1° Sauvegarde

### Les régles de ma table `mon_filtreIPv4` sont sauvegardées dans le fichier `nftables.rules`                        
                        
                        nft list table mon_filtreIPv4 > nftables.rules

### 2° Restauration

                        nft –f nftables.rules

### 3° Application au démarrage

### Utiliser la syntaxe suivante dans `/etc/network/interfaces` :

                        auto eth0
                        iface eth0 inet static
                                        address 192.168.10.135
                                        netmask 255.255.255.0
                                        pre-up nft –f /root/nftables/nftables.rules




## 8) ⚠️Template⚠️

### Il est possible dans NFtables d'accéder à des fichier template.

                        nft –f chemin_nftables/files/nftables/fichier_preconf


### Pour les lister 

                        ls -al /usr/share/doc/nftables/examples


### Création de template

                        nft list table ma_table > files/nftables/nom_fichier


# 3️⃣ `Exemples cas pratique`

[IT](https://www.it-connect.fr/modules/cas-pratique-nftables-en-contexte-reel/)












