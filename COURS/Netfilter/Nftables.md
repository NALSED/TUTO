# Netfilter

***

## SOMMAIRE

### 1️⃣`Labo`
### 2️⃣`Consigne`
### 3️⃣`NFtables`

***
***

### 1️⃣`Labo`

SRVLX_NFTABLES
|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|enp0s3 | 172.10.0.10/24|fe80::a00:27ff:fe4e:a8c7/64|
|enp0s8|192.168.0.100/24|fe80::a00:27ff:fe75:cc9c/64|

CLILX_NFTABLES
|Interface|IPv4|IPv6|
|:-:|:-:|:-:|
|enp0s3 |172.10.0.5/24|fe80::a00:27ff:fe95:b706/64|







### 2️⃣`Consigne`

#### 1)Commence par bloquer tous les trafics en entrée et en sortie. À ce stade, la machine ne devrait plus pouvoir communiquer du tout.

#### 2) Autorise les communications locales. Il est maintenant possible sur la machine de communiquer avec localhost/ip6-localhost

#### 3) Autorise maintenant icmp et icmpv6 en entrée comme en sortie. Il redevient possible de joindre la machine avec ping.

#### ✏️ Remarque :Cette machine est un serveur qui n'a pas besoin d'initier elle-même des connexions, elle se contente de répondre aux demandes. Une exception néanmoins doit être faite pour le protocole DNS. Particularité des requêtes DNS, on peut savoir à l'avance avec quel·s serveur·s la machine doit pouvoir communiquer : les serveurs DNS récursifs de sa configuration.

#### 4) Autorise la machine à émettre des requêtes DNS, mais uniquement vers les serveurs récursifs présents sur ta configuration réseau et pense à autoriser les réponses correspondantes à entrer.Il est maintenant possible d'effectuer des requêtes DNS depuis le serveur.

#### 5) Autorise maintenant les connexions ssh entrantes (et les sorties correspondantes) uniquement depuis ton réseau interne. La connexion ssh sur la machine redevient accessible depuis la machine hôte.

#### 6) Autorise enfin les connexions http entrantes (et les réponses) depuis n'importe quelle adresse.

#### ✏️ Remarque : Assure toi que les règles sont bien correctement rechargées à chaque redémarrage de la machine.

### 3️⃣`NFtables`

![image](https://github.com/user-attachments/assets/6311130e-aeed-40f6-961c-2aef8cfda0a1)































