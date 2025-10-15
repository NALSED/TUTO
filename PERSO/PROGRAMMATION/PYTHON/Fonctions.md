# 🧩 `FONCTION` 🧩

---



#### 📝 Une fonction en Python est un bloc de code réutilisable qui réalise une tâche précise. Elle peut prendre des paramètres en entrée, effectuer des opérations, et retourner un résultat.

* ### 1️⃣ `Syntaxe` de base pour définir une fonction:
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

* ### 2️⃣  `Bonne pratique`
    
    * #####  `Anotation de type`
      #### Elle permettent d’indiquer quels types de données une fonction attend en entrée (paramètres) et ce qu’elle retourne en sortie.
      #### Bien qu'elles n'empêchent pas les erreurs à l'exécution, les annotations facilitent leur détection en amont via des outils adaptés.
                  def  fonction (param1: int,  param2: str)-> bool
                      return param1 > 0  and len(param2) > 0
                  print(fonction(5, "test"))     #  True
                  print(fonction(0, "test"))     #  False
                  print(fonction(5, ""))         #  False
                  print(fonction(-3, "abc"))     #  False

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


### `*`  => Tuple
### `**` => Dico
---
### `EXEMPLE`

#### `*args`  
      def addition(*args):
          total = 0
          for nombre in args:
              total += nombre
          return total
      
      print(addition(1, 2, 3))  # Sortie : 6
      print(addition(5, 10))    # Sortie : 15


####  `**kwargs`

      def afficher_infos(**kwargs):
          for cle, valeur in kwargs.items():
              print(f"{cle} : {valeur}")
      
      afficher_infos(nom="Alice", age=30)
      # Sortie :
      # nom : Alice
      # age : 30

#### Combinée : 

      def config_app(*arg, **kwargs):
          print("Argument positionelss : ", arg)
          print("Argument nommés", kwargs)
      
      config_app("192.168.0.160", "192.168.0.123", status="ok", firewall="nok" )
      
      # Argument positionelss :  ('192.168.0.160', '192.168.0.123')
      # Argument nommés {'status': 'ok', 'firewall': 'nok'}

#### Autre
      def alerte(*, ip, niveau):
          print(f"Envoi à  l'adresse {ip}  avec niveau {niveau}")
      alerte(ip="192.168.0.1", niveau="critical")

      # Envoi à  l'adresse 192.168.0.1  avec niveau critical
      
---


#### `/`

      def f(a, b, /, c, d):
          print(a, b, c, d)
      
      f(1, 2, 3, 4)      # OK, tous en position
      f(1, 2, c=3, d=4)  # OK, c et d nommés
      f(a=1, b=2, c=3, d=4)  # ERREUR, a et b sont positionnels uniquement

#### `*`

      def f(a, b, *, c, d):
          print(a, b, c, d)
      
      f(1, 2, c=3, d=4)  # OK
      f(1, 2, 3, 4)      # ERREUR, c et d doivent être nommés


---

####  Surveillance Logs
      
      #Fonction génératrice qui lit un fichier log ligne par ligne
      def surveiller_log(fichier_log):
         
      # Ouvre le fichier en mode lecture ('r') et garantit sa fermeture automatique
      with open(fichier_log, "r") as fichier:
            # Boucle tant qu'il y a des lignes à lire
            while ligne := fichier.readline():
                  # Renvoie la ligne lue, en enlevant les espaces et retours à la ligne
                  yield ligne.strip()
      
      # Utilisation de la fonction génératrice pour parcourir le fichier log
      for log in surveiller_log("log_securite.txt"):
            # Affiche chaque ligne lue avec un message clair
            print(f"Log détecté : {log}")


###  `Fonction décorée`

####  Ce type de fonction — un décorateur — permet de modifier dynamiquement le comportement d’une fonction sans toucher à son code source.

### `EXEMPLE`

      # Décorateur verrif_acces()
      # fonction prend  display_logs
      # def verrif_acces(fonction): == def verrif_acces(display_logs):
      def verrif_acces(fonction):
              # Wrapper(!convention!) permet de modifier display_logs via verif_acces, en acceptant des arguments nommés ou positionnels.    
          def  wrapper(*args,  **kwargs):
              # Vérifie si l'argument nommé 'user' vaut 'admin'
              if kwargs.get("user") == "admin":
                  # Si oui, appelle la fonction originale avec tous ses arguments
                  return fonction(*args, **kwargs)
              else:
                  print("accés nok")
          #appel la fonction wrapper
          return wrapper
      #@verrif_acces appel verrif_acces donc wrapper donc display_logs modifié
      @verrif_acces
      #Fonction  qui  attend  un argument nommé obligatoirement user
      def  display_logs(*,user):
          #Affiche la valeur de user
          print(user)
      # Appel de la fonction décorée avec user="admin"
      display_logs(user="admin")























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





