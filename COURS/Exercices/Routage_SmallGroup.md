![image](https://github.com/user-attachments/assets/adcaaa02-24aa-4954-a8ae-8a0203a9b8b4)

### 1. `Donne la table de routage statique de R2 et R4. Si possible réduit la table de routage en la simplifiant.`

#### `R2`

|Réseau|Préfixe|Passerelle|Interfaces|
|:-:|:-:|:-:|:-:|
|192.168.10.0 |24|direct|192.168.10.1|DHCP?
|192.168.20.0|24|direct|192.168.20.1|DHCP?
|172.16.70.0|24|10.40.0.2|10.40.0.1|
|10.30.0.0|16|direct|10.30.0.2|
|10.40.0.0|16|direct|10.40.0.1|
|10.50.0.0|16|10.40.0.2|10.40.0.1|
|10.60.0.0|16|10.40.0.2|10.40.0.1|
|10.80.0.0|16|10.40.0.2|10.40.0.1|
|0.0.0.0|10.30.0.1|10.30.0.2|




#### `R4`


|Réseau|Préfixe|Passerelle|Interfaces|
|:-:|:-:|:-:|:-:|
|192.168.10.0|24|10.60.0.1|10.60.0.2|
|192.168.20.0|24|10.60.0.1|10.60.0.2|
|10.30.0.0|16|10.60.0.1|10.60.0.2|
|10.40.0.0|16|10.60.0.1|10.60.0.2|
|10.50.0.0|16|10.60.0.1|10.60.0.2|
|10.60.0.0|16|DIRECT|10.60.0.2|
|172.16.70.0|24|DIRECT|172.16.70.254|
|10.80.0.0|16|DIRECT|10.80.0.1|
|0.0.0.0|0.0.0.0|10.60.0.1|10.60.0.2|

### 2. `Quel matériel peux-tu placer à côté de R1 ?`

Un par-feu, qui filtrera les requêtes entre mon réseau local et internet.


### 3. `Indique la spécificité des vlan 10 et 20.

Ce sont 2 vlans reliés au switch "switch2", lui-même relié au routeur R2
sur l'interface g3/0.
Normalement, chaque vlan devraient être relié (via un switch) sur une
interface du routeur, or là il y a 2 vlans sur une seule interface.



### 4. `Quels autres vlans du schéma sont sur la même construction réseau ?`
Les Vlans 70 et 80 relié au routeur R4 via le switch 6, sur la même interface g3/0



### 5. `Comment appelle-t'on ce type de construction ?`
La technique utilisé est un trunk et le nom réseau est routeur on a stick



### 6. `Quelle doit être la passerelle par défaut du vlan 60 ?`

ça passerelle par defaut devra être 10.60.0.1, afin de pouvoir comuniquer avec internet et les autres réseaux après le routeur R3





### 7. `De la même manière, donne les passerelles par défaut manquantes des vlans qui n'en en pas.`




### 8. `Quelle(s) modification(s) faire sur le schéma pour que le routeur DHCP délivre une configuration IP sur tout les vlans ?`




### 9. `Sur quel matériel effectuer une modification d'ACL pour interdire l'accès à internet au routeur DHCP ?`




### 10. `Donne une ou des ACL qui permettent de faire cela.`







