# 🧩 `FONCTION` 🧩

---



#### 📝 Une fonction en Python est un bloc de code réutilisable qui réalise une tâche précise. Elle peut prendre des paramètres en entrée, effectuer des opérations, et retourner un résultat.

#### Syntaxe de base pour définir une fonction:
      def nom_de_la_fonction(parametre1, parametre2, ...):
          # bloc de code
             return valeur_de_retour  # optionnel

---

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
