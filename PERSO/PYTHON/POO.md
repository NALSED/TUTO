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

### 1️⃣ `Intro`

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

### 2️⃣ `Encapsulation`
 
#### L'encapsulation est un principe fondamental en  POO. Elle protège les classes des modifications/suppressions accidentelles et favorise la réutilisation et la maintenabilité du code

| Syntaxe de l'attribut | Visibilité       | Accès depuis l'extérieur | Comportement / Usage                                      |
|------------------------|------------------|---------------------------|-----------------------------------------------------------|
| `nom`                  | Publique         | ✅ Oui                    | Attribut standard, accessible et modifiable librement.   |
| `_nom`                | Protégée         | ⚠️ Oui (convention)       | Convention : usage interne, mais reste accessible.        |
| `__nom`               | Privée (pseudo)  | 🚫 Non direct (via _Classe__nom) | Name mangling : empêche l'accès direct par erreur.     |



---
                
### 3️⃣ `La composition` 

#### La composition est un principe de conception en programmation orientée objet (POO) dans lequel une classe est constituée d'autres classes.

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





























