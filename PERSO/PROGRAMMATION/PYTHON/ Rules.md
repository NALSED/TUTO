# 📜  Régles et Astuces Python. 📜
[PEP 8 – Style Guide for Python Code](https://peps.python.org/pep-0008/)
[PYTHON TUTO](https://www.w3schools.com/python/default.asp)
[CHEAT SHEET](https://www.pythoncheatsheet.org/cheatsheet/built-in-functions)

---
---

<details>
<summary>
<h2>
✏️ `Commentaires`  ✏️
</h2>
</summary>


#### Option 1️⃣ 
      
      # Commentaires 


#### Option 2️⃣

     """
      
      Commentaires
    
     """
      
</details>

---

<details>
<summary>
<h2>
🔔  `RAPPEL () [] {}` : 🔔
</h2>
</summary>


| Symbole | Nom                | Utilisation principale                         | Exemple Python                    |
|---------|--------------------|--------------------------------------------------|-----------------------------------|
| ()      | Parenthèses        | - Appel de fonction                              | `print("Hello")`                 |
|         |                    | - Définir un **tuple**                           | `mon_tuple = (1, 2, 3)`          |
|         |                    | - Priorité dans les opérations                   | `result = (2 + 3) * 4`           |
| []      | Crochets           | - Définir une **liste**                          | `ma_liste = [1, 2, 3]`           |
|         |                    | - Indexation / slicing                           | `ma_liste[0]`, `texte[1:4]`      |
| {}      | Accolades          | - Définir un **dictionnaire**                    | `mon_dict = {"a": 1, "b": 2}`    |
|         |                    | - Définir un **set (ensemble)**                 | `mon_set = {1, 2, 3}`            |
|         |                    | - Utilisé avec des **comprehensions**           | `{x: x**2 for x in range(3)}`    |
| () + [] | Tuple de listes     | - Contenir plusieurs listes dans un tuple       | `(([1, 2], [3, 4]))`             |
| [] + () | Liste de tuples     | - Liste contenant des tuples                    | `[(1, 'a'), (2, 'b')]`           |
| {} + [] | Dictionnaire de listes | - Associer des clés à des listes          | `{"clé1": [1, 2], "clé2": [3]}`  |
| {} + () | Dictionnaire de tuples | - Clés associées à des tuples              | `{"clé": (1, 2)}`                |

</details>

---
<details>
<summary>
<h2>
📊  `Variables` 📊
</h2>
</summary>

#### 1️⃣ Snake case : my_variable_name
#### 2️⃣ Ne pas utiliser le mots clés de python (else, if, for, while, return, True, False) 
#### 3️⃣ [NOM VARIABLE] [OPERATEUR D'AFFECTATION] [VALEUR]
#### Portée Global🔴
#### Portée Local🟢


            device_name = "router 1" #🔴

            def  test():
                test_value = "test OK" #🟢
                print(test_value)
                print(device_name)

            test()

---

#  ⚙️ `Opérateur` ⚙️

#### STR ⬇️
[STRING](https://www.w3schools.com/python/python_strings.asp)
#### `Concaténation`
      salutation = "Bonjour"
      nom = "Jen Patate"
      print(salutation+" "+nom)
#### Sortie
      (.venv) PS A:\save\Python> py .\chaine_caractere.py
      Bonjour Jen Patate

--- 

#### `Multiplication`
      print(nom*6)

#### Sortie
      Jen PatateJen PatateJen PatateJen PatateJen PatateJen Patate

---
#### `Slicing`

      >>> nom = "Jean"
      >>> nom [0]
      'J'
      >>> nom [0:3]
      'Jea'
      >>> nom [0:1]
      'J'
      >>> nom [0:2]
      'Je'
      >>> nom [0:4]
      'Jean'

---

#### `Split` ===> .split()
   
#### Séparation IP  Port    
      >>> ip_address = "192.168.1.1:80"
      >>> ip_address.split(":")
      ['192.168.1.1', '80']


#### Récupération IP
      >>> ip_address.split(":")[0]
      '192.168.1.1'
      >>> ip_address.split(":")[1]
      '80'

---

#### `Remplacer` ===> .replace()

      >>> ip_address
      '192.168.1.1:80'
      >>> ip_address.replace("192","196")
      '196.168.1.1:80'

#### ET

      >>> ip_address = "192.192.1.1:80"
      >>> ip_address.replace("192","196",1)
      '196.192.1.1:80'

---

#### `Supprimme string au début et à la fin` .strip()  
       >>> ip_address = "azeeeeee192.192.1.1:80ezzaezezezezezezeza"
      >>> ip_address.strip("aze")
      '192.192.1.1:80'

---

####  `Test` ===>startswith() endswith()

      >>> ip_address
      '192.168.0.241'
      >>> ip_address.startswith("192")
      True
      >>> ip_address.startswith("193")
      False

      >>> ip_address
      '192.168.0.241'
      >>> ip_address.endswith("193")
      False
      >>> ip_address.endswith("241")
      True
      
#### `Présence` ===> in OR not
      txt = "The best things in life are free !"
            if "free" in txt:
                print("Yes, 'free' is present.")
            else :
                print ("no, 'free' is not present")    

---
---

# 💾 `Données intégrés` 💾

---
---

# 1️⃣  📑 `List` 📑

### Une liste est modifiable et dynamique.

#### Déclarer une liste
       ip_list = ["192.168.0.122", "192.168.23.152"]

---

#### `Ajoute` un élément à la fin de la liste ===> append()

      >>> ip_list = ["192.168.0.122", "192.168.23.152"]
      >>> ip_list.append("192.168.0.1")
      >>> print(ip_list)
      ['192.168.0.122', '192.168.23.152', '192.168.0.1']

---

#### `Supprime` tous les éléments de la liste ===> clear()
      >>> ip_list.clear()
      >>> print(ip_list)
      []
---

#### Renvoie une copie de la liste ===> copy()

#### NON LIE
      ip_list_2 = ip_list.copy()

#### LIE (si modif dans ip_list ip_list_2 change aussi)
      ip_list_2 = ip_list
---

#### `Renvoie le nombre d'éléments` avec la valeur spécifiée ===> count()
      >>> print(ip_list)
      ['192.168.0.1', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.3.12']
      >>> ip_list.count('192.168.0.145')
      5

---

#### `Ajoute` les éléments d'une liste (ou de tout itérable), `à la fin de la liste actuelle`  ===> extend()

      >>> print(ip_list)
      ['192.168.0.122', '192.168.23.152', '192.168.0.1']
      >>> ip_list.extend(["192.168.0.145", "192.168.3.12"]) 
      >>> print(ip_list)
      ['192.168.0.122', '192.168.23.152', '192.168.0.1', '192.168.0.145', '192.168.3.12']

---

#### Renvoie l'index du premier élément avec la valeur spécifiée ===> index()

      >>> print(ip_list)
      ['192.168.0.1', '192.168.0.145', '192.168.3.12']
      >>> ip_list.index('192.168.0.145')
      1

---

### `Ajoute un élément à la position spécifiée` ===> insert()
      >>> print(ip_list)
      ['192.168.0.122', '192.168.23.152', '192.168.0.1', '192.168.0.145', '192.168.3.12']
      >>> ip_list.insert(2,"192.168.0.0")
      >>> print(ip_list)
      ['192.168.0.122', '192.168.23.152', '192.168.0.0', '192.168.0.1', '192.168.0.145',         '192.168.3.12']

---

#### Retire l'élément à la position spécifiée ===> pop()

      >>> print(ip_list)
      ['192.168.3.12', '192.168.0.192', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.123', '192.168.0.1']
      >>> ip_list.pop(1)
      '192.168.0.192'
      >>> print(ip_list)
      ['192.168.3.12', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.123', '192.168.0.1']


---

#### `Retire` l'élément avec la valeur spécifiée ===> remove()

      >>> print(ip_list)
      ['192.168.0.122', '192.168.0.1', '192.168.0.145', '192.168.3.12']
      >>> ip_list.remove('192.168.0.122')
      >>> print(ip_list)
      ['192.168.0.1', '192.168.0.145', '192.168.3.12']

---

#### Inverse l'ordre de la liste (ordre décroissant) ===> reverse()

      >>> print(ip_list)
      ['192.168.0.1', '192.168.0.123', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.192', '192.168.3.12']
      >>> ip_list.reverse()
      >>> print(ip_list)
      ['192.168.3.12', '192.168.0.192', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.123', '192.168.0.1']

---

####  Trie la liste (seul ordre croissant) ===> sort()

      >>> print(ip_list)
      ['192.168.0.1', '192.168.0.145', '192.168.0.145', '192.168.0.123', '192.168.0.145', '192.168.0.192', '192.168.0.145', '192.168.0.145', '192.168.3.12']
      >>> ip_list.sort()
      >>> print(ip_list)
      ['192.168.0.1', '192.168.0.123', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.145', '192.168.0.192', '192.168.3.12']


---
---


# 2️⃣ 🔒  `Tuples` 🔒

##### `Les tuples sont utilisés pour stocker plusieurs éléments dans une seule variable.`  Un tuple est une collection ordonnée et immuable, `de façon permanante`

      >>> ip_info = ("192.168.0.152", "255.255.255.0")
      >>> print ip_info
      ('192.168.0.152', '255.255.255.0')
      
#### Récupérer les données
      >>> print(ip_info)
      ('192.168.0.152', '255.255.255.0')
      >>> ip, mask = ip_info
      >>> print(ip)
      '192.168.0.152
      >>> print(mask)
      '255.255.255.0'

#### Combiner
      ip_test= (("192.168.0.1","255.255.255.0"), ("192.168.0.2","255.255.255.0"))
      print(ip_test)
      (('192.168.0.1', '255.255.255.0'), ('192.168.0.2', '255.255.255.0'))

#### lier
     
      >>> print(ip_test)
      (('192.168.0.1', '255.255.255.0'), ('192.168.0.2', '255.255.255.0'))
      >>> ip_test1 = ("192.168.0.1","255.255.255.0")
      >>> ip_test2 = ("192.168.0.2","255.255.255.0")
      >>> ip_test = ip_test1 + ip_test2
      >>> print(ip_test)
      ('192.168.0.1', '255.255.255.0', '192.168.0.2', '255.255.255.0')



---
---

## 3️⃣  📈  `Range` 📈

#### Utile pourgénérer des suite de nombre.En générale avec boucle for
#### range(stop) : Génère une séquence d'entiers de 0 à stop - 1.range
#### (start, stop): Génère une séquence d'entiers de start à stop - 1.range
#### (start, stop, step): Génère une séquence d'entiers de start à stop - 1, en avançant de step à chaque itération.
      
      ip_range  = range(1,255)
      for ip in ip_range:
          print(ip)
      # edite  les  chiffres  de 1 à 254
      
      print(f"192.168.1.{ip}") ip_range  = range(1,255)
     #Génére des adressess ip de 192.168.1.1  =>  192.168.1.254


</details>

---

<details>
<summary>
<h2>
📖 `Dictionnaire`📖
</h2>
</summary>

#### `Structure Dictionaire` 

      """
      d = {
              clé: valeur,
              clé: valeur,
              clé: valeur,
              ...
              clé: valeur
            }
      """

#### Ici 

            # Dictionnaire  clé: valeur,
            config_net = {"ip" : "192.168.0.165",
                    "mask" : "255.255.255.0",
                    "gateway" : "195.168.0.1",
                    "dns" : ["8.8.8.8","192.168.0.241"]
            }
            print(config_net)

#### Sortie Dico
            (.venv) PS A:\save\Python> python .\dico.py
            {'ip': '192.168.0.165', 'mask': '255.255.255.0', 'gateway': '195.168.0.1', 'dns': ['8.8.8.8', '192.168.0.241']}

#### On peux `rechercher` des éléments avec leurs clés

             # Dictionnaire
            config_net = {"ip" : "192.168.0.165",
                    "mask" : "255.255.255.0",
                    "gateway" : "195.168.0.1",
                    "dns" : ["8.8.8.8","192.168.0.241"]
            }
            # Extraction de l'adressse ip
            address_ip = config_net["ip"]
            # Extraction du mask
            netmask = config_net["mask"]
            # Affichage IP + Mask
            print(address_ip+" "+netmask)

---

#### Ajouter/modifier une clé + valeur

      # network => clé et Reseau_entreprise_=> valeur 
      config_net["network"] = "Reseau_entreprise_"

---

#### Supprimer élément
     
      del config_net["dns"]
      >>> print(config_net) 
      {'ip': '192.168.0.165', 'mask': '255.255.255.0', 'gateway': '195.168.0.1'}
      

####  Liste clé ===> .key()
      
      config_net.key()
      >>> config_net.keys()  
      dict_keys(['ip', 'mask', 'gateway', 'dns'])


#### Liste valeur ===> .values()
      >>> config_net.values() 
      dict_values(['192.168.0.165', '255.255.255.0', '195.168.0.1', ['8.8.8.8', '192.168.0.241']])
      

#### Afficher clés et valeurs ===> .items()
      config_net = {"ip" : "192.168.0.165",
              "mask" : "255.255.255.0",
              "gateway" : "195.168.0.1",
              "dns" : ["8.8.8.8","192.168.0.241"]
      }

            for a, b in config_net.items():
                      print(f"{a}: {b}")

            #Sortie
            
            ip: 192.168.0.165
            mask: 255.255.255.0
            gateway: 195.168.0.1
            dns: ['8.8.8.8', '192.168.0.241']

#### Test présence/absence  ===> .keys()
      
      >>> "ib" in config_net.keys()
      False
      >>> "ip" in config_net.keys() 
      True


#### Range dans un dico ===> range()
      ip_gen = range(1, 255,15)
      dico = {"ip": [f"192.168.0.{i}" for i in ip_gen]}

      print(dico)

</details>



---
   
 

<details>
<summary>
<h2>
🔢 `Bit/Bytes/Opérations` 🔢
</h2>
</summary>

#### Opérateur bit
      
#### AND      (&) ===> 1 SI a = 1 ET b = 1 
           
#### OR       (|) ===> 1  SI a OU b = 1
      
#### XOR      (^) ===>  1 SI a = 1 ET b = 0
     
#### NOT      (~) ===> ~n = -n - 1
      
#### << décalage à gauche
      
#### >> décalage à droite

---

## `EXEMPLE`
#### convertion ip en binaire

      # IP à convertir
      ip ="192.168.0.1"

      # Découpage de  l'IP en 4 Octets
      octets = ip.split(".")

      #Création d'une Liste pour "acceuillir" les octets
      binary=[]

      #Les Octets sont placés le un à le suite des autres sous le format 4 paquet  de 8 bits 
      binary.append(format(int(octets[0]), '08b'))
      binary.append(format(int(octets[1]), '08b'))
      binary.append(format(int(octets[2]), '08b'))
      binary.append(format(int(octets[3]), '08b'))

      Résultat avec comme séparateur rien
      print("".join(binary))

     (.venv) PS A:\save\Python> python .\bytes2.py
      11000000101010000000000000000001


#### Et  binaire en IP

      Adresse binaire à  convertir
      octet = "11000000101010000000000000000001"  
      
      # Liste
      octet_list = []

      #Les 4 Octets sont converties en base 2
      octet_list.append(str(int(octet[0:8], 2)))
      octet_list.append(str(int(octet[8:16], 2)))
      octet_list.append(str(int(octet[16:24], 2)))
      octet_list.append(str(int(octet[24:32], 2)))

      #Résultat avec "." en séparateur
      print(".".join(octet_list))
      192.168.0.1

      
## `EXERCICES`

### `EXO 1`
#### masque sous réseau => masque  inversé

      #Defini le  maque daans une variable
      sub_net = 0b11111111111111111111111100000000

      #Inversion des bit
      wc = ~sub_net
      
      #convertie en binaire et limite à 32 bit,et ajoute des  0 àgauche  pour avoir un format  32  bits
      wc = (bin(wc & 0xFFFFFFFF))[2:].zfill(32)
      
      print(wc)
      00000000000000000000000011111111
---

### `EXO 2`
#### Déterminer le réseau

      ip =  0b11000000101010000000000100001101
      sub = 0b11111111111111111111111100000000

      # ET (&) logique en excluant  le "0b"
      network_bin = bin(ip & sub)[2:]

      #Liste
      network = []

      #Converti les octets binaires en base 2
      network.append(str(int(network_bin[0:8], 2)))
      network.append(str(int(network_bin[8:16], 2)))
      network.append(str(int(network_bin[16:24], 2)))
      network.append(str(int(network_bin[24:32], 2)))

      #Résultat binaire
      print(network_bin)

      #Résultat décimal pointée
      print(".".join(network))
      11000000101010000000000100000000
      192.168.1.0


### `EXO 3`

#### Adresse de broadcast

      ip =  0b11000000101010000000000100001101
      sub = 0b11111111111111111111111100000000

      # inversion 0=>1
      broadcast_mask = ~sub
      
      #Conversion binaire en32 bit
      broadcast_add = (ip | broadcast_mask) & 0xFFFFFFFF
      broadcast_add = bin(broadcast_add)[2:].zfill(32)

      #Liste
      broadcast_mask_int  =  []
      
      #Converti les octets binaires en base 2
      broadcast_mask_int.append(str(int(broadcast_add[0:8], 2)))
      broadcast_mask_int.append(str(int(broadcast_add[8:16], 2)))
      broadcast_mask_int.append(str(int(broadcast_add[16:24], 2)))
      broadcast_mask_int.append(str(int(broadcast_add[24:32], 2)))

      #résultat
      print(".".join(broadcast_mask_int))
      192.168.1.255

</details>


---

<details>
<summary>
<h2>
🔀 `Structures Conditionelles :` 🔀
</h2>
</summary>

### Opérateur de comparaion:
* #### `==` égale
* #### `!=` différent
* #### `>` sup
* #### `<` inf
* #### `>=` sup/égale
* #### `<=` inf/égale

### Opérateur logique:
* #### `and` TRUE si toutes les conditions TRUE
* #### `or` TRUE si une des conditions TRUE
* #### `not` inverser valeur condition
--
--

# `IF/ELIF/ELSE :`

            if condition_1
                  #code executé si condition_1 TRUE
            
            elif condition_2
                  #code executé si condition_2 TRUE et condition_1 FALSE
            
            else:
                  #code exécuté si condition_1 et condition_2 FALSE


            #Type accépté  
            * Bolean TRUE FALSE
            * Nombre (0 FALSE, reste TRUE )
            * Strings ("" FALSE,  reste TRUE)

#### `EXEMPLE :`

            user= input("entré un username,svp : ")
            pwd= input("entré un mpd,,svp : ")

            #Boucle les deux ont TRUE
            if user  == "admin" and pwd  == "admin123":
                print("accés OK")
            
            #Boucle condition_1 TRUE condition_2 FALSE
            elif user == "admin":
                print("MDP faux")
            
            #Boucle condition_1 et condition_2 FALSE
            else:
                print("accés refusé")

---

### `Ternaires :`

#### Permet des assignations rapide de conditions dans des variables.

#### `EXEMPLE :`

            username = "admin"
            access_status = "Accéss Ok. " if username == "admin"  else "Accés  NOK"
            print(access_status)



---

# `in`

#### Tester la présence ou non d'un élément dans une  liste une ensemble.

#### `EXEMPLE :`

            # Utilisation de ternaire pour la premiere boucle
            username = "admin"
            access_status = "Accéss Ok. " if username == "admin"  else "Accés  NOK"
            print(access_status)

            # Utilisation de in pour tester  la présence
            allowed_users = ["admin", "guest", "user"]
            if username in allowed_users:
                print("User OK")
            else: 
                print("User NOK")


---  

# `Lambda`

#### Créer un fonction, qui  sera utilisée temporairement. 


#### `EXEMPLE :`
            
            #lambda renvoi TRUE si username et password correspond dan lambda et les variable  qui suivent
            user_access =  lambda username, password  : username == "admin" and password == "admin123"
           #variable
            username = "admin"
            password = "admin123"
            # Si lambda TRUE => ok
            if user_access(username, password):
                print("ok")
            #Sinon NOK
            else: 
                print("NOK")

---

# `all` et `any`

* #### `all` TRUE si tout les element  de l'iterable sont vrai.
* #### `any` TRUE si un des element de l'iterable est vrai.



#### `EXEMPLE :`

            # Variable utilisateur 
            user = "admin"
            password = "admin123"
            # condition pour TRUE TRUE don all renvoie ok car TRUE TRUE
            condition = [user == "admin", password ==  "admin123" ]
            
            if all(condition):
                print("ok")
            
            # Variable accés
            failed_attemps  = 2
            suspicious_activity_detected = False

             # condition pour FALSE FALSE donc any renvoie rien car FALSE FALSE
             # Si FALSE TRUE lorss  sortie !!! access denied !!!
            alert_condition = [failed_attemps > 3, suspicious_activity_detected]
            if any(alert_condition):
                print("!!! access denied !!!")

---

# `is et isintance()`

####  `is`
     
     # vérifie simplement si la variable user est exactement None
      user = None 
      if user is None:
          print("no")

#### `isintance()`

      # Vérifie si l'objet obj est une instance de la classe class
      user = "None" #None (obj) est de la classe str
      if isinstance(user, str)
          print("OUI")

---

# `match`

#### Correspondance motif ou paterne

      #entrer un des rôle demander match va comparer avec les case
      user_role = input("veuillez entrer  votre rôle : (guest, admin, user)")

      #en fontion de  l'input une sortie  prévu à chaque  fois
      match user_role:
          case "admin":
              print("MDP admin")
          case "guest":
              print("hello")
          case "user":
              print("nice")
      
       #Le reste   
          case _:
              print("role non reconnue ")

---

# `FOR` et `WHILE`

### `FOR`

#### Exemple:

      ips = ["192.168.0.1", "192.168.0.2","192.168.0.3"]
      for ip in ips:
            print("Analyse ip adresse : ", ip )
      #SORTIE
      Analyse ip adresse :  192.168.0.1
      Analyse ip adresse :  192.168.0.2
      Analyse ip adresse :  192.168.0.3

#### Exemple avec index et enumerate
#### Permet la création d'un index à chque tour
      ips = ["192.168.0.1", "192.168.0.2","192.168.0.3"]
      for index, ip in enumerate(ips):
          print(index+1, "=>Analyse ip adresse : ", ip )
      #SORTIE      
      1 =>Analyse ip adresse :  192.168.0.1
      2 =>Analyse ip adresse :  192.168.0.2
      3 =>Analyse ip adresse :  192.168.0.3

---

### `FOR` + if pour recherche  dans liste
      
      # Création d'une liste
      ips = ["192.168.0.1", "192.168.0.2","192.168.0.3"]
      # Création d'un index pour chaque élément de la liste
      for index, ip in enumerate(ips):
          print(index+1, "=>Analyse ip adresse : ", ip )
      
      # Recherche d'une ip suspect
      suspicious_ip = []
      
      for ip in ips:
          if "192.168.0.2" in ip:
              suspicious_ip.append(ip)
      
      # Sortie
      print("IP suspectes détectées :", suspicious_ip)

      ## code plus court ## 
      ips = ["192.168.0.1", "192.168.0.102", "192.168.0.3", "192.168.0.104"]
      #pour chaque ip dans la liste ips filtrer : ne garder que les IPs qui contiennent "192.168.0.102"
      suspicious_ips = [ip for ip in ips if "192.168.0.102" in ip]

      print(suspicious_ips)

### Recherche d'IP suspecte commençant par...
      
      
      ips = ["192.168.0.1", "192.168.0.102", "192.168.0.3", "192.168.0.104", "192.168.1.1", "192.168.2.33","192.168.5.56"]
            #pour chaque ip dans la liste ips filtrer : ne garder que les IPs qui contiennent "192.168.0.102"
      suspicious_ips = [ip for ip in ips if ip.startswith("192.168.0.") ]
      
      print(suspicious_ips)
      #['192.168.0.1', '192.168.0.102', '192.168.0.3', '192.168.0.104']

---

      # Liste des noms d'utilisateur
      usernames = ["admin", "guest", "user"]
      
      # Liste des mots de passe correspondants
      passwords = ["admin123", "guest123", "user123"]
      
      # Associe chaque nom d'utilisateur avec son mot de passe respectif
      for username, password in zip(usernames, passwords):
            print(f"vérif {username} avec mdp {password}")

---
#### Crétion d'Alerte echec ou  réussite de connection

            security_logs =[ 
                            {"ip": "192.168.1.10", "status": "failed"},
                            {"ip": "192.168.1.15", "status": "success"},
                            {"ip": "192.168.1.20", "status": "failed"},
                            {"ip": "192.168.1.10", "status": "failed"}
            
            ]
            
            failed_attempts = {}
            
            for log  in security_logs:
                if log["status"] == "failed":
                    #Récupération de l'ip via la clé ip
                    ip= log["ip"]
                    
                    #Incrémente de 1 le nombre d’échecs pour l’IP, en mettant 0 par défaut si l’IP n’existe pas encore dans le dictionnaire
                    failed_attempts[ip] = failed_attempts.get(ip,0) +1
                    #Si erreur de connection sup 2 print
                    if failed_attempts[ip] > 2 :
                        print(f"Alerte : IP {ip} à  échoué")
                        break
                else:
                    print(f"connexion reussi  de  l'IP {log['ip']}")    



---
#### Association de tuple dans une liste
      coordinates = [(1,2),(3,4),(5,6)]
      for x,y in coordinates:
          print(f"coordonées : x = {x} et y = {y}")
      #coordonées : x = 1 et y = 2
      coordonées : x = 3 et y = 4
      coordonées : x = 5 et y = 6
---

# `WHILE`

### La boucle while est idéale pour les variables dynamiques ou les situations où on ne connaît pas à l'avance combien de fois répéter le code, car elle s'exécute tant qu'une condition reste vraie.
      
      while condition:
          # instructions
#### Exemples :
      count = 0

      while count < 3:
          print("Valeur de count :", count)
          # idem count = count + 1
          count += 1

---

#### "Détection" d'un nombre de tentative de connection
      attempts  = 0
      max_attemps = 3
      while attempts < max_attemps:
          print(f"Tentative {attempts  + 1} Analyse  en cours...")
          attempts += 1
---

#### "Détection" d'un nombre de tentative de connection avec entrée dynamique
      attempts = 0
      max_attempts = 3
      
      while attempts < max_attempts:
          print(f"Tentative {attempts + 1} : Analyse en cours...")
          password = input("Entrez un MDP : ")
      
          if password == "admin123":
              print("Accès autorisé.")
              break
          else:
              print("Mot de passe incorrect.\n")
          
          attempts += 1
      
      if attempts == max_attempts:
          print("Accès refusé. Trop de tentatives.")

---

#### while + continue

      while  True:
          
          ip = input("Veuillez entrer une IP :\nPour sortir tapez 'exit'\n> ")
      
          if ip == exit:
              print("Sortie")
              break
          elif ip == "192.168.0.1":
              print("Accés refusé")
              continue
      
          print("Welcome")
          break

#### while parcours dico
      
      # Liste avec dictionnaire avec IP et liste d'adresse IP
      logs = [
              {"ip": "192.168.0.1", "status":"success"},
              {"ip": ["192.168.0.2", "192.168.0.3", "192.168.0.4"], "status":"failed"},
      ]
      
      # index = 0 sert à  parcourir logs avvec while
      index = 0
      
      # La boucle continue tant que index est inférieur à la longueur de la liste logs
      # Dans ce cas, len(logs) vaut 2, donc la boucle tournera deux fois (index = 0 puis index = 1)
      while index < len(logs):
          
      #extrais le log courant depuis la liste logs, en fonction de l'index.
      
      # log devient un dictionnaire, par exemple :
      # À index = 0, log = {"ip": "192.168.0.1", "status": "success"}
      # À index = 1, log = {"ip": ["192.168.0.2", "192.168.0.3", "192.168.0.4"], "status": "failed"}    
          log = logs[index]
      
      # Si la ligne  contient "failed"    
          if log["status"] == "failed":
              
      # Ecrire dans le dico log la ligne définie par la clé ip         
              print(f"Echec de la connection : {log['ip']}")
      
          else:
              print(f"connection OK : {log['ip']}")
      # Permet  de passer au tour suivant 
          index +=1



      connection OK : 192.168.0.1
      Echec de la connection : ['192.168.0.2', '192.168.0.3', '192.168.0.4']

####  ⚠️  A titre de comparaison même résultat aavvec  for
      for log in logs:
          if log["status"] == "failed":
              
              print(f"Echec de la connection : {log['ip']}")
      
          else:
              print(f"connection OK : {log['ip']}")

</details>
