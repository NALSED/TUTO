| 🔧 Ce que c'est           | 📘 À quoi ça sert ?                                      | 🧠 Exemple d'usage concret              |
|--------------------------|----------------------------------------------------------|-----------------------------------------|
| **Classe**               | Créer un modèle (comme un plan)                          | `Utilisateur`, `Voiture`, `Produit`     |
| **Objet**                | Créer un "vrai" élément à partir d’un modèle             | Un utilisateur nommé "Alice"            |
| **Méthode**              | Faire agir un objet (comme une fonction)                 | `afficher()`, `envoyer()`, `connecter()`|
| **Attribut**             | Stocker une info dans l’objet                            | `nom`, `âge`, `adresse IP`              |
| **__init__**             | Code qui s’exécute automatiquement à la création         | Donne un nom et une IP à l’objet        |
| **Encapsulation**        | Cacher les infos sensibles                               | Empêcher de voir ou modifier un mot de passe |
| **Getter / Setter**      | Lire ou changer un attribut caché de façon sécurisée     | Changer un mot de passe, le valider     |
| **Héritage**             | Reprendre les propriétés d’une autre classe              | `Voiture` hérite de `Véhicule`          |
| **Polymorphisme**        | Utiliser plusieurs objets différents de la même façon    | `jouer()` fonctionne sur `Chien` et `Chat` |
| **Classe abstraite**     | Créer un modèle sans donner les détails (incomplet)      | Oblige les enfants à définir des actions |
| **Méthodes magiques**    | Personnaliser les comportements automatiques de Python   | `__str__`, `__eq__`, `__len__`...       |
| **Surcharge d’opérateur**| Redéfinir comment réagit un objet avec `+`, `==`, etc.   | Additionner deux objets `IP`, comparer  |
| **@property**            | Rendre un getter facile à appeler (comme un attribut)    | Accès propre à une info cachée          |
| **@classmethod**         | Méthode liée à la classe (pas à l’objet)                 | Compter le nombre d’utilisateurs créés  |
| **@staticmethod**        | Méthode utilitaire qui ne touche ni classe ni objet     | Afficher un message de bienvenue        |
