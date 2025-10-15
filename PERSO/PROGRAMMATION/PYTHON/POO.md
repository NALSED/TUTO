# 👨‍💻 Programmation Orientée Objet 👨‍💻

## Introduction à la Programmation Orientée Objet (POO)

La **Programmation Orientée Objet (POO)** est un paradigme qui organise le code en **objets**. Chaque objet est une instance d'une **classe**(Plan ou modèle), qui définit ses **attributs** (propriétés) et ses **méthodes** (actions).

## Concepts de Base de la Programmation Orientée Objet (POO)

| **Concept**             | **Définition**                                                                | **Incidence / Effet sur le code**                                            |
|-------------------------|--------------------------------------------------------------------------------|----------------------------------------------------------------------------|
| **Classe**              | Plan ou modèle qui définit des objets, avec leurs attributs et méthodes.       | Permet de structurer le code et de créer plusieurs objets basés sur ce modèle. |
| **Objet**               | Instance d'une classe. Un objet possède des attributs et des méthodes.         | L'objet est une entité concrète créée à partir d'une classe, avec des valeurs spécifiques pour ses attributs. |
| **Attribut**            | Propriétés ou variables qui stockent des données dans un objet.                | Les objets peuvent avoir des attributs spécifiques qui décrivent leurs caractéristiques (ex. `nom`, `âge`). |
| **Méthode**             | Actions ou fonctions associées à un objet, définissant son comportement.       | Les objets peuvent effectuer des actions ou manipuler leurs attributs via des méthodes. |

## Explication

- **Classe** : C'est un modèle pour créer des objets. Une classe définit les propriétés (attributs) et les comportements (méthodes) que ses objets auront.
- **Objet** : Un objet est une instance spécifique d'une classe, avec des valeurs concrètes pour ses attributs.
- **Attribut** : Ce sont les variables ou les données associées à un objet, qui lui donnent des caractéristiques spécifiques.
- **Méthode** : Ce sont les fonctions ou actions que l'objet peut exécuter.

---
<details>
<summary>
<h2>
 👉 `Pour plus de détails`
</h2>
</summary>

# 🔑 `Attributs` 🔑

## Résumé sur les Attributs de Classe et Attributs d'Instance en Python

### 1. Attributs d'instance
- **Définition** : Ce sont des variables associées à une **instance spécifique** d'une classe.
- **Propriétés** :
  - Chaque objet (instance) a sa propre copie de ces attributs.
  - Ils sont généralement définis dans la méthode `__init__` (le constructeur) en utilisant le mot-clé `self`.
  - Ils peuvent avoir des valeurs différentes pour chaque instance.

### 2. Attributs de classe
- **Définition** : Ce sont des variables partagées par **toutes les instances** de la classe.
- **Propriétés** :
  - Il n'y a qu'une seule copie de ces attributs, peu importe le nombre d'objets créés.
  - Ils sont définis directement dans le corps de la classe, en dehors de toute méthode.
  - Toutes les instances de la classe partagent la même valeur pour ces attributs.

### 3. Différences clés
- **Attributs d'instance** :
  - Uniques à chaque objet.
  - Définis dans `__init__(self, ...)`.
  - Peuvent être modifiés individuellement pour chaque instance.

- **Attributs de classe** :
  - Partagés par tous les objets de la classe.
  - Définis directement dans la classe, en dehors de `__init__`.
  - Toute modification de cet attribut affecte toutes les instances.

---

# 🔧 `Les méthodes` 🔧


## Résumé sur les Types de Méthodes en Python

### 1. Méthodes d'instance
- **Définition** : Ce sont des méthodes associées à une **instance spécifique** de la classe.
- **Propriétés** :
  - Elles prennent **`self`** comme premier argument, ce qui permet d'accéder aux attributs et aux autres méthodes de l'instance.
  - Elles sont appelées sur une **instance** (objet) de la classe.
  - Elles peuvent accéder et modifier les **attributs d'instance**.

### 2. Méthodes de classe
- **Définition** : Ce sont des méthodes qui sont liées à la **classe elle-même**, et non à une instance spécifique.
- **Propriétés** :
  - Elles prennent **`cls`** comme premier argument, ce qui permet d'accéder aux **attributs de classe**.
  - Elles sont définies avec le décorateur **`@classmethod`**.
  - Elles sont généralement appelées sur la **classe** elle-même, mais peuvent également être appelées sur des instances.

### 3. Méthodes statiques
- **Définition** : Ce sont des méthodes qui **ne dépendent ni de l'instance ni de la classe**.
- **Propriétés** :
  - Elles ne prennent ni **`self`** ni **`cls`** comme premier argument.
  - Elles sont définies avec le décorateur **`@staticmethod`**.
  - Elles ne peuvent accéder à ni aux **attributs d'instance** ni aux **attributs de classe**.
  - Elles sont appelées sur la **classe** ou sur une **instance**, mais ne modifient ni l'une ni l'autre.


### Différences clés
- **Méthodes d'instance** :
  - Sont liées à **une instance spécifique**.
  - Prennent **`self`** comme premier argument.
  - Accèdent et modifient les **attributs d'instance**.

- **Méthodes de classe** :
  - Sont liées à la **classe** elle-même.
  - Prennent **`cls`** comme premier argument.
  - Accèdent et modifient les **attributs de classe**.

- **Méthodes statiques** :
  - Ne dépendent ni de l'instance ni de la classe.
  - Ne prennent ni **`self`** ni **`cls`** comme premier argument.
  - Ne peuvent pas accéder aux **attributs d'instance** ou **de classe**.

</details>

---

## 1️⃣ `Intro`

* ####  Exemple => gestion de donnes Utilisateur

            #  créer la class
            class Utilisateur:
            
                # Attribut de classe
                nombre_utilisateur = 0
            
                # Fonction 1 format nom, ip status 
                def __init__(self, nom: str, ip: str, statut_connexion: bool):
                    # Attributs  d'instance
                    self.nom = nom
                    self.ip = ip
                    self.statut_connexion =statut_connexion
                    # Incrémentation
                    Utilisateur.nombre_utilisateur +=1
            
                # fonction 2 action
                #  Methode d'instance
                def afficher_details(self):
                    print(f"Utilisateur : {self.nom}, IP : {self.ip}, Status : {self.statut_connexion}")
            
                #  Methode  de class
                @classmethod
                def afficher_nombre_user(cls):
            
                    print(f"Nombre Utilisateur : {cls.nombre_utilisateur}")
            
                @staticmethod
                def afficher_bienvenue():
                    print("\nBienvenue dans le systeme de gestion des utilisateurs.\n")
            
            # variables données utilisateurs (instance)
            alice =  Utilisateur("Alice", "192.168.0.102", True)        
            bob = Utilisateur ("bob", "19.168.0.103", False)
            
            # Afficher les résulats
            
            Utilisateur.afficher_bienvenue()
            alice.afficher_details()
            bob.afficher_details()
            Utilisateur.afficher_nombre_user()

            ##SORTIE##
            Bienvenue dans le systeme de gestion des utilisateurs.

            Utilisateur : Alice, IP : 192.168.0.102, Status : True
            Utilisateur : bob, IP : 19.168.0.103, Status : False
            Nombre Utilisateur : 2


---
### `Grands Principes`

* #### `Le constructeur` => __init__
#### Automatiquement appelée lors de la création d’une instance de la classe
     class MaClasse:
         def __init__(self, param1, param2):
             self.param1 = param1
             self.param2 = param2    

--- 

## 2️⃣ `Encapsulation`
 
#### **L'encapsulation** est un principe fondamental en  POO. Elle **protège** les classes des modifications/suppressions accidentelles et favorise la réutilisation et la maintenabilité du code

| Syntaxe de l'attribut | Visibilité       | Accès depuis l'extérieur | Comportement / Usage                                      |
|------------------------|------------------|---------------------------|-----------------------------------------------------------|
| `nom`                  | Publique         | ✅ Oui                    | Attribut standard, accessible et modifiable librement.   |
| `_nom`                | Protégée         | ⚠️ Oui (convention)       | Convention : usage interne, mais reste accessible.        |
| `__nom`               | Privée (pseudo)  | 🚫 Non direct (via _Classe__nom) | Name mangling : empêche l'accès direct par erreur.     |



---
                
## 3️⃣ `La composition` 

#### La **composition** est un principe de conception en programmation orientée objet (POO) dans lequel **une classe est constituée d'autres classes**.

#### EXEMPLE :

     class AddressIP:
         def __init__(self,ip):
             self.ip = ip
         def to_binary(self):        
             pass
         def __str__(self):
             return self.ip <===== Pour  retourner l'IP est pas self.ip en tant qu'objet de la classe AddressIP
     
     #  créer la class
     class Utilisateur:
         # Attribut de classe
         nombre_utilisateur = 0
     
         # Fonction 1 format nom, ip status 
         def __init__(self, nom: str, ip: str, statut_connexion: bool,):
             # Attributs public d'instance
             self.nom = nom
             self.ip = AddressIP(ip) <======= ICI On appelle le constructeur de la classe AddressIP pour créer un nouvel objet.

---


## 4️⃣ Geters et Seters
#### Les **getters** et **setters** sont des **méthodes** utilisées pour **accéder** (get) ou **modifier** (set) les **attributs privés** d’un objet, tout en **contrôlant** leur usage (validation, transformation, etc.).


#### EXEMPLE geter
     
     class Utilisateur:
     
         def __init__(self, nom: str, ip: str,):
             self.nom =nom
             self.ip =ip
             self.__password = "test"
     
         def afficher_details(self):
             print(f"Utilisateur : {self.nom}, IP : {self.ip}, MDP : {self.password}")
     
         # Permet d'accéder au mot de passe comme un attribut, pas comme une méthode
         # @property transforme une méthode en attribut
         @property 
         def password(self):
             return "********"
         
         @password.setter
         def password(self, new_password: str):    
             if len(new_password) >= 8:
                 self.__password =  new_password
                 print("mot  de passe mis à jour.")
             else:
                 print("MDP trop court ! ")
     
     alice = Utilisateur("Alice","192.168.0.123")
     bob = Utilisateur("Bob", "192.168.0.124")
     alice.password= "12345678"  
     bob.password= "1234567"     
     alice.afficher_details()
     bob.afficher_details()    


---

#### EXEMPLE seters

     class Utilisateur:
         
         def __init__(self, nom: str, ip: str,):
             self.nom = nom 
             self.ip = ip 
             self.__password = "test"
     
         def afficher_details(self):
             print(f"Utilisateur : {self.nom}, IP : {self.ip}, MDP : {self.__password}")
     
     
         def get_password(self):
             return "********"

         # Permet de changer le MPD pourtant protégé
         def  set_password(self, new_password: str):
             if len(new_password) >= 8:
                 self.__password =  new_password
                 print("mot  de passe mis à jour.")
             else:
                 print("MDP trop court ! ")
     
     alice = Utilisateur("Alice", "192.168.0.102") 
     bob = Utilisateur ("bob", "19.168.0.103")
     
     
     alice.set_password("1234567")
     bob.set_password("12345678")
     alice.afficher_details()
     bob.afficher_details()

---

## 5️⃣ `Héritage et Polymorphisme`

* ### 1) `Héritage` 
L’**héritage** est un mécanisme de la programmation orientée objet qui permet à une **classe enfant (ou sous-classe)** de **hériter des attributs et des méthodes** d’une **classe parent (ou super-classe)**.

#### EXEMPLE:

     # Classe parent
     class Dispositif_reseaux:
         def __init__(self,nom : str, ip : str):
             self.nom = nom
             self.ip = ip
     
         def afficher_details(self):
             print(f"Nom : {self.nom}, Ip :{self.ip}")

     # Classse enfant
     class Routeur(Dispositif_reseaux):  
         def __init__(self, nom, ip, version_os):
             # Permet d'hériter des attributs de la classe parent(avec le constructeur parent _init_)
             super().__init__(nom,ip)
             self.version_os = version_os

         # Redéfinit la méthode pour ajouter l'affichage de l'OS    
         def afficher_details(self)
             super().afficher_details()
             print(f"Version OS : {self.version_os}")
     
     router = Routeur("Router 1","192.168.0.123","IOS 15.1")      
     router.afficher_details()

* ### 2) `Redéfinition de méthode`, pour héritage enfant

#### La classe enfant redéfinit la méthode de la classe parent

#### EXEMPLE : 


     # Classe parent
     class AnalyserPaquet:
         # Méthode générique d'analyse
         def analyser(self, paquet: str):
             print(f"Analyse générale du paquet  : {paquet}")
     
     # Classe enfant
     class AnalysePaquetHTTP(AnalyserPaquet):
         
         # Redéfinit la méthode analyser pour les paquets HTTP
         def analyser(self, paquet: str):
            if "HTTP" in paquet:
                 print(f"Analyse spécifique paquet HTTP : {paquet}")
             else:
                 
                 # Appelle la méthode générique du parent
                 super().analyser(paquet)
     
     
     # Appel de la classe enfant
     analyseur = AnalysePaquetHTTP()    
     # entrée 1
     analyseur.analyser("HTTP GET /index.html")
     # entrée 2
     analyseur.analyser("ICMP Echo Request")

     # SORTIE
     Analyse spécifique paquet HTTP : HTTP GET /index.html
     Analyse générale du paquet  : ICMP Echo Request

---

## 3) `Polymorphisme`
#### Le **polymorphisme** est un principe de la programmation orientée objet qui permet d’utiliser **différents objets** de **types différents** de manière **interchangeable**, à travers une **même interface** (méthode ou fonction).


#### EXEMPLE

     # Classe parent : analyse générale
     class AnalyserPaquet:
         def analyser(self, paquet: str):
             print(f"Analyse générale du paquet : {paquet}")
     
     # Classe enfant : Analyse HTTP
     class AnalysePaquetHTTP(AnalyserPaquet):
     
         # Affiche un titre spécifique
         def whoami(self):
             print("\n=== HTTP Request ===")
     
         # Analyse spécifique
         def analyser(self, paquet: str):
             if "HTTP" in paquet:
                 print(f"Analyse spécifique paquet HTTP : {paquet}")
             else:
                 super().analyser(paquet)
     
     # Classe enfant : Analyse DNS
     class AnalysePaquetDNS(AnalyserPaquet):
     
         # Affiche un titre spécifique
         def whoami(self):
             print("\n=== DNS Request ===")
     
         # Analyse spécifique
         def analyser(self, paquet: str):
             if "DNS" in paquet:
                 print(f"Analyse spécifique paquet DNS : {paquet}")
             else:
                 super().analyser(paquet)
     
     # Liste d'objets analyzers (polymorphisme)
     analyseurs = [AnalysePaquetHTTP(), AnalysePaquetDNS()]
     
     # Paquets à analyser
     paquets = ["HTTP GET /index.html", "ICMP Echo Request", "DNS Query for exemple.com"]
     
     # Traitement des paquets avec polymorphisme
     for analyseur in analyseurs:
         analyseur.whoami()
         for paquet in paquets:
             analyseur.analyser(paquet)


     # SORTIE 

     === HTTP Request ===
     Analyse spécifique paquet HTTP : HTTP GET /index.html
     Analyse générale du paquet : ICMP Echo Request
     Analyse générale du paquet : DNS Query for exemple.com
     
     === DNS Request ===
     Analyse générale du paquet : HTTP GET /index.html
     Analyse générale du paquet : ICMP Echo Request
     Analyse spécifique paquet DNS : DNS Query for exemple.com



---

## 6️⃣ `Méthodes magique et surcharge d'opérateurs`

#### Les `Méthodes magique` **permettent aux objets** de se comporter comme des **types natifs** Python (int, str, list, etc.) pas besoin d’écrire des méthodes personnalisées pour tout faire.



* ### 1) `Méthodes magique`

#### EXEMPLE 1

     class AdresseIP:
         def __init__(self, ip):
             self.ip = ip
     
         def __str__(self):
             return f"Adresse IP : {self.ip}"
     
     # Création d'un objet
     ip1 = AdresseIP("192.168.0.1")
     
     # Affichage automatique via __str__
     print(ip1)  #Python appelle ip1.__str__()
     

#### EXEMPLE 2

     class AddressIp:
         
         def __init__(self, ip):
             self.ip = ip
     
         # Crée une sortie lisible pour l'utilisateur (ex : print)
         def __str__(self) -> str:
             return f"Adresse IP {self.ip}"
         
         # Aide au débogage : représentation technique de l'objet
         def __repr__(self) -> str:
             return f"AddressIp('{self.ip}')"
     
         # Compare deux objets pour vérifier s'ils ont la même adresse IP
         def __eq__(self, other_ip: object) -> bool:
             return self.ip == other_ip
     
     ip1 = AddressIp("192.168.0.1")
     ip2 = AddressIp("192.168.0.2")
     ip3 = AddressIp("192.168.0.2")
     
     print(ip1)
     print(repr(ip2))
     print(ip2 ==  ip3)
     
     # SORTIE
     Adresse IP 192.168.0.1
     AddressIP('192.168.0.2')
     True

---

* ### 2) `Surcharge d'opérateurs`
#### La **surcharge d’opérateurs** est un mécanisme qui permet à une **classe de définir** ou de redéfinir le **comportement des opérateurs standards** (+, -, *, /, ==, [], etc.) lorsqu’ils sont **appliqués à ses instances**.


<details>
<summary>
<h2>
 LISTE METHODES MAGIQUES
</h2>
</summary>

# 📘 Méthodes magiques (dunder methods) en Python

# Méthodes magiques courantes

| Méthode magique | Description courte                                        |
|-----------------|----------------------------------------------------------|
| `__init__`      | Constructeur appelé lors de la création d'une instance   |
| `__new__`       | Crée une nouvelle instance (avant `__init__`)            |
| `__del__`       | Destructeur appelé à la suppression de l'objet           |
| `__str__`       | Représentation lisible (utilisée par `print()`)           |
| `__repr__`      | Représentation officielle (pour debug, console)           |
| `__len__`       | Retourne la longueur (utilisé par `len()`)                 |
| `__getitem__`   | Accès par index ou clé (`obj[key]`)                       |
| `__setitem__`   | Affectation par index ou clé (`obj[key] = value`)          |
| `__delitem__`   | Suppression par index ou clé (`del obj[key]`)              |
| `__iter__`      | Retourne un itérateur (pour boucles `for`)                |
| `__next__`      | Retourne l’élément suivant dans un itérateur              |
| `__contains__`  | Vérifie la présence (`in`)                                |
| `__call__`      | Permet d'appeler l'objet comme une fonction                |
| `__eq__`        | Comparaison d’égalité (`==`)                               |
| `__ne__`        | Comparaison d’inégalité (`!=`)                             |
| `__lt__`        | Comparaison inférieure (`<`)                               |
| `__le__`        | Comparaison inférieure ou égale (`<=`)                     |
| `__gt__`        | Comparaison supérieure (`>`)                               |
| `__ge__`        | Comparaison supérieure ou égale (`>=`)                     |
| `__add__`       | Addition (`+`)                                            |
| `__sub__`       | Soustraction (`-`)                                        |
| `__mul__`       | Multiplication (`*`)                                      |
| `__truediv__`   | Division vraie (`/`)                                      |
| `__floordiv__`  | Division entière (`//`)                                   |
| `__mod__`       | Modulo (`%`)                                             |
| `__pow__`       | Puissance (`**`)                                         |
| `__bool__`      | Conversion en booléen (`bool(obj)`)                      |
| `__hash__`      | Valeur de hachage (pour dictionnaires et sets)           |
| `__enter__`     | Début d’un contexte (`with`)                             |
| `__exit__`      | Fin d’un contexte (`with`)                               |

---

# Méthodes magiques moins courantes

| Méthode magique     | Description courte                                     |
|---------------------|-------------------------------------------------------|
| `__and__`           | ET bit à bit (`&`)                                    |
| `__or__`            | OU bit à bit (`|`)                                    |
| `__xor__`           | OU exclusif bit à bit (`^`)                           |
| `__invert__`        | Complément bit à bit (`~`)                            |
| `__lshift__`        | Décalage binaire à gauche (`<<`)                      |
| `__rshift__`        | Décalage binaire à droite (`>>`)                      |
| `__neg__`           | Négation/unary minus (`-obj`)                         |
| `__pos__`           | Unary plus (`+obj`)                                   |
| `__abs__`           | Valeur absolue (`abs(obj)`)                           |
| `__format__`        | Formatage personnalisé (`format(obj, spec)`)          |
| `__copy__`          | Copie superficielle (`copy.copy()`)                   |
| `__deepcopy__`      | Copie profonde (`copy.deepcopy()`)                    |
| `__instancecheck__` | Support pour `isinstance()`                           |
| `__subclasscheck__` | Support pour `issubclass()`                           |




</details>

---

## 7️⃣ `Classes Abstraites`


### 1) `Classes Abstraites`  

#### Une **classe abstraite** est une classe qui **ne peut pas être instanciée directement**.  
#### Elle sert de **modèle** pour les autres classes en définissant une ou plusieurs **méthodes abstraites** (sans implémentation), que les **sous-classes doivent obligatoirement redéfinir**.

#### Elle est généralement utilisée pour :
* #### **Imposer un contrat** aux sous-classes
* #### **Organiser le code** selon une hiérarchie claire
*  #### Faciliter le **polymorphisme**

#### `Syntaxe de base `
#### Avec abc => module standard
#### Et ABS => class


     from abc import ABC, abstractmethod
     
     # Définition d'une classe abstraite
     class MaClasseAbstraite(ABC):
     
         @abstractmethod
         def ma_methode_abstraite(self):
             pass  


#### EXEMPLE 

    # Import du module abc pour utiliser les classes abstraites
    from abc import ABC, abstractmethod  
    
    # Classe abstraite de base représentant un dispositif de sécurité
    class Dispositif_secu(ABC):  # Hérite de ABC pour devenir une classe abstraite
        
        def __init__(self, nom):
            self.nom = nom  # Attribut commun : nom du dispositif

        # Méthode abstraite : doit être implémentée dans les classes filles
        @abstractmethod
        def activer(self):
            pass  

        # Méthode abstraite : doit être implémentée dans les classes filles
        @abstractmethod
        def desactiver(self):
            pass  
    
        def afficher_nom(self):
            # Méthode concrète partagée par toutes les sous-classes
            print(f"Disposotif de Sécurité : {self.nom}")
    
    # Classe concrète qui hérite de Dispositif_secu
    class Parefeu(Dispositif_secu):
    
        def activer(self):
            # Implémentation spécifique pour le pare-feu
            print(f"Le parfeu {self.nom} est activé")
    
        def desactiver(self):
            # Implémentation spécifique pour le pare-feu
            print(f"Le parfeu {self.nom} est désactivé")
    
    # Autre classe concrète qui hérite de Dispositif_secu
    class IDS(Dispositif_secu):
    
        def activer(self):
            # Implémentation spécifique pour l'IDS
            print(f"Le IDS {self.nom} est activé")
    
        def desactiver(self):
            # Implémentation spécifique pour l'IDS
            print(f"Le IDS {self.nom} est désactivé")
    
    # Instanciation d’un pare-feu et d’un IDS avec leur nom respectif
    parefeu = Parefeu("Fotinet  01")
    ids = IDS("IDS  01")
    
    # Activation des dispositifs
    parefeu.activer()
    ids.activer()


--- 

### 8️⃣ `Décorateurs et méthode de classe`


* ####  1) Décorateurs

#### Un **décorateur** est une **fonction spéciale** qui permet de **modifier ou enrichir le comportement d’une autre fonction**, **sans modifier son code**.


#### EXEMPLE :

     # Décorateur  qui rend imposible les arguments négatifs
     def valider_entrees(fonction):
     
         def nouvelle_fonction(self, *args):
             
             # Vérifie si au moins un argument est négatif
             if any(arg < 0 for arg in args):
                 print("Les argument  ne peuvent être négatifs") 
                 return
             
             # Si tout est OK, appelle la vraie fonction
             return fonction(self,*args,)
         return nouvelle_fonction    
     
     class Calcule:
     
         # Décorateur + méthode d'additioner
         @valider_entrees
         def additionner(self,a,b):
             return a+b    
         
         # Décorateur + méthode de soustraire
         @valider_entrees
         def soustraire(self,a,b):
             return a - b     
         
     # Test
     machine = Calcule()
     
     print(machine.additionner(10,56))
     print(machine.soustraire(96,56))    


*  #### 2) Méthode de classe

#### Méthode liée à la classe, pas à l’objet.

#### `Syntaxe`
     @classmethod
     def ma_methode(cls, args):
         # code

























