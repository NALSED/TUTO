# Utilisation de NFtables:
***
## SOMMAIRE :

1️⃣`Fontionnement`

2️⃣ `Commande`

3️⃣
***
***
1️⃣`Fontionnement`

![image](https://github.com/user-attachments/assets/88b4ef36-99da-4c3f-9372-1d9187526ea4)

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

2️⃣ `Commande`

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




#### 1) Tables

         #Créer
        nft add table mon_filtreIPv4
        #Liste les tables IVv4 ou IPv6
        nft list tables ip/ip6
        #Supprime
        nft delete table mon_filtreIPv4


### 2) Chaines

        # ajouter la chaine en input piotité 0
        nft add chain ip mon_filtreIPv4 input { type filter hook input priority 0 \; }
        #idem en output
        nft add chain ip mon_filtreIPv4 output { type filter hook output priority 0 \; }
        # lister 
        nft list table ip mon_filtreIPv4
        # deuxième table
        nft add table ip filtre2

### 3 ) Régles






























