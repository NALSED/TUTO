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
| Tu fais un petit script rapide.                          | Tu veux réutiliser cette vérification plusieurs fois.                      |
| Tu n’as pas besoin de réutiliser le code.                | Tu veux écrire un code propre, clair et modulaire.                        |
| C’est un test simple ou temporaire.                      | Tu veux tester ou modifier facilement la logique d’accès.                |
|                                                           | Tu veux séparer la logique et l'affichage (bonne pratique en programmation). |

### 📝 `EXEMPLE`

            #solution 1  
            username = "admin"
            pwd =  "admin123"
            if username  == "admin" and pwd  == "admin123":
                print("accés ok")
            else:
                print("accées refusé")
            
            #solution 2    
            
            def verif(username, pwd)
                if username == "admin" and pwd == "admin123"
                    return  "accés  ok"
                return "accés refusé"
            
            print(verif("admin", "admin123"))

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
