# 🧩 `FONCTION` 🧩

---



#### 📝 Une fonction en Python est un bloc de code réutilisable qui réalise une tâche précise. Elle peut prendre des paramètres en entrée, effectuer des opérations, et retourner un résultat.

#### Syntaxe de base pour définir une fonction:
      def nom_de_la_fonction(parametre1, parametre2, ...):
          # bloc de code
             return valeur_de_retour  # optionnel

#### Avantage fonction avec `def`
#### Dans les deux exemples suivant le résultat est le même,,  c'est l'utilisation  qui va changer.

### 🎯 Pourquoi privilégier l’une ou l’autre ?

| ✅ Solution 1 : à privilégier si...                        | ✅ Solution 2 : à privilégier si...                                         |
|-----------------------------------------------------------|----------------------------------------------------------------------------|
| on fais un petit script rapide.                          | on veux réutiliser cette vérification plusieurs fois.                      |
| on n’as pas besoin de réutiliser le code.                | on veux écrire un code propre, clair et modulaire.                        |
| C’est un test simple ou temporaire.                      | on veux tester ou modifier facilement la logique d’accès.                |
|                                                           | on veux séparer la logique et l'affichage (bonne pratique en programmation). |

### 📝 `EXEMPLE`

            #solution 1  
            username = "admin"
            pwd =  "admin123"
            if username  == "admin" and pwd  == "admin123":
                print("accés ok")
            else:
                print("accées refusé")
            
            #solution 2    

            # Définition de  la fontion
            def verif(username, pwd):
                if username == "admin" and pwd == "admin123":
                    return  "accés  ok"
                return "accés refusé"
            # Appeler la fonction
            print(verif("admin", "admin123"))

---

<details>
<summary>
<h2>
⚙️ Paramétres Fonction ⚙️ 
</h2>
</summary>

# 🎯 Types de paramètres des fonctions en Python

| Type                        | Description                                             | Exemple                                  |
|-----------------------------|---------------------------------------------------------|------------------------------------------|
| Paramètres positionnels      | Arguments passés dans l’ordre, obligatoires             | `def f(a, b):` → `f(1, 2)`               |
| Paramètres par défaut        | Paramètres avec une valeur par défaut                    | `def f(a=10):` → `f()` ou `f(5)`         |
| Paramètres nommés           | Arguments passés en précisant le nom du paramètre       | `f(a=1, b=2)`                            |
| Paramètres variables (`*args`)   | Reçoit un nombre variable d’arguments positionnels       | `def f(*args):` → `f(1, 2, 3)`           |
| Paramètres variables nommés (`**kwargs`) | Reçoit un nombre variable d’arguments nommés               | `def f(**kwargs):` → `f(a=1, b=2)`       |
| Paramètres positionnels uniquement (`/`) | Indique que les paramètres avant `/` sont uniquement positionnels | `def f(a, b, /):`              |
| Paramètres nommés uniquement (`*`)      | Indique que les paramètres après `*` sont uniquement nommés    | `def f(*, a, b):`              |



### `EXEMPLE`

#### *args   
      def addition(*args):
          total = 0
          for nombre in args:
              total += nombre
          return total
      
      print(addition(1, 2, 3))  # Sortie : 6
      print(addition(5, 10))    # Sortie : 15


####  **kwargs

      def afficher_infos(**kwargs):
          for cle, valeur in kwargs.items():
              print(f"{cle} : {valeur}")
      
      afficher_infos(nom="Alice", age=30)
      # Sortie :
      # nom : Alice
      # age : 30







</details>














---

<details>
<summary>
<h2>
 ⚡Fontion par Type  d'objet⚡
</h2>
</summary>

## Ce classement regroupe les fonctions Python selon le type d’objet (liste, chaîne, dictionnaire, etc.) sur lequel elles agissent principalement.              
---
---
* #  📑 `LISTE` 📑
#### `enumerate()` : prend une collection et la renvoie sous forme d'objet énuméré.
      x = ('apple', 'banana', 'cherry')
      y = enumerate(x)

      print(list(y))
      #[(0, 'apple'), (1, 'banana'), (2, 'cherry')]

---




#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``
#### ``



---
---

* ## 🪢 `TUPLE` 🪢



#### `zip()` : est une fonction Python qui associe les éléments de plusieurs itérables entre eux par position, en créant un itérable de tuples.
      a = ("John", "Charles", "Mike")
      b = ("Jenny", "Christy", "Monica")
            x = zip(a, b)
      print(tuple(x))
      # (('John', 'Jenny'), ('Charles', 'Christy'), ('Mike', 'Monica'))


</details>





