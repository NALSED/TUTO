# Régles et Astuces Python.
[PEP 8 – Style Guide for Python Code](https://peps.python.org/pep-0008/)
[PYTHON TUTO](https://www.w3schools.com/python/default.asp)
[CHEAT SHEET](https://www.pythoncheatsheet.org/cheatsheet/built-in-functions)

---
---

### `Commentaires`

#### Option 1️⃣ 
      
      # Commentaires 


#### Option 2️⃣

     """
      
      Commentaires
    
     """

---


### `Variables`

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
---
### `Opérateur`

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

# `Données intégrés`

---

## :one `List`


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


## 2️⃣ `Tuples`

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

## 3️⃣ `Range`




---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---

### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---

### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---

### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---

### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---

### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---

### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---

### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
### ``
 
---


### ``
 
---
