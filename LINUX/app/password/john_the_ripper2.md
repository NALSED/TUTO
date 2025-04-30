# `John The Ripper`
https://www.openwall.com/john/doc/
---

## 1️⃣ `Intro`
## 2️⃣ `Modes`
## 3️⃣ `Rules`
## 4️⃣ `mask`
## 5️⃣ `Exemple`
## 6️⃣ ``
## 7️⃣ ``
## 8️⃣ ``
## 9️⃣ ``



---
---
## 1️⃣ `Intro`
### contient les attributs utilisateur de base
    /etc/passwd
![image](https://github.com/user-attachments/assets/916946a8-98d7-4029-afc9-d82ad787eec7)

---

### fichier /etc/shadow

## ⚠️ Les fichiers de mots de passe traditionnels sont conservés dans /etc/passwd, mais les mots de passe hachés sont stockés dans /etc/shadow

<details>
<summary>
<h2>
:arrow_forward: contenu de /etc/shadow.  
</h2>
</summary>

### Identifiant de l'utilisateur
Il s'agit de l'identifiant du compte utilisateur, indiqué lors de la création. Autrement dit, c'est l'identifiant que vous utilisez pour vous connecter avec ce compte.

### Mot de passe chiffré
Le mot de passe de ce compte utilisateur, chiffré avec un algorithme (plusieurs possibilités), en respectant le format `$type$salt$hash`, c'est-à-dire un numéro correspondant à l'algorithme utilisé, les informations de salage et le hash du mot de passe.  
Ce champ peut aussi avoir un astérisque ou un point d'exclamation comme valeur. Dans ce cas, l'authentification par mot de passe est refusée par ce compte (il doit utiliser une autre méthode).

### Nombre de jours depuis le dernier changement de mot de passe
Il s'agit du nombre de jours écoulés depuis la dernière modification de mots de passe, en prenant comme date de référence le 1er janvier 1970.  
- Si la valeur est à `0`, cela veut dire que l'utilisateur devra changer son mot de passe lors de la prochaine connexion.  
- Une valeur vide signifie que les fonctions de gestion de l'ancienneté du mot de passe sont désactivées.

### Âge minimum du mot de passe
Combien de jours l'utilisateur doit-il garder son mot de passe avant de pouvoir le changer ?  
- Si vous avez un `0`, alors l'utilisateur peut le changer dès qu'il le souhaite.

### Âge maximum du mot de passe
Combien de jours le mot de passe est-il valide ? Ensuite, l'utilisateur doit changer le mot de passe à la prochaine connexion.  
- Par défaut, cette valeur est fixée à `99999`, comme vous pourrez sûrement le constater.

### Avertissement
Combien de jours avant que le mot de passe expire faut-il prévenir l'utilisateur qu'il va devoir le changer ?

### Période d'inactivité
Une fois le mot de passe expiré, combien de jours faut-il compter avant que le compte soit désactivé si le mot de passe n'est pas changé dans les temps ?  
- Cette option est vide la plupart du temps.

### Date d'expiration
Quand le compte a-t-il été désactivé ?  
- Cette valeur est exprimée en nombre de jours à partir du 1er janvier 1970.

### Pas encore utilisé
Il n'y a pas de valeur après le dernier `:` car ce dernier champ n'a pas d'utilité à ce jour, mais cela viendra peut-être...

</details>




## 2️⃣ `Modes`

###  1) Single Mode 
###  2) Word List Mode
###  3) Incremental Mode
###  3) External Mode
---




## 3️⃣ `Rules`
### Les régles sont à éditer dans le fichier de conf de john et appeler ensuite pour le craquage.
    sudo gedit /tec/john/john.conf
    EXEMPLE=[List.Rules:monTest]

### Editer les régles en leurs donnant un nom qui sera appelé via la commande
    john --rules=<EXEMPLE>

### Utiliser les régles ci dessous

<details>
<summary>
<h2>
:arrow_forward:RULES
</h2>
</summary>
 

# Syntaxe générale + Explications et exemples des commandes

## ⚠️L'ordre dans lequel apparaisse les explication est une sugestion de syntaxe global pour une création de régle dans JtR
## 1️⃣ 🏴 `Reject Flag` => pour filtrer la commande qui suit
## 2️⃣  🧮 Opérations de Bases
## 3️⃣ 🔢 Constantes Numérique et Variables => utilisées en complément des Opérations de bases ou en variable
## 4️⃣ ⛓️ Commande de chaines(strings) => Encomplément




### sous [List.Rules:monTest] écrire la régle ⬇️ 


## 🏴 `Reject Flag`

### Ces régles permet de trier des commandes en foctions des drapeaux

### `-:` Ne rien faire avec le mot d'entrée.

### `-c` : Rejeter cette règle sauf si le type de hachage actuel est sensible à la casse.
### Cela permet d'éviter d'appliquer certaines transformations (comme la conversion en minuscules ou en majuscules) à des hachages qui ne distinguent pas entre les lettres majuscules et minuscules.

### 📝 `EXEMPLE`  

    -c l # Utilise la commande "l" (convertir en minuscules), mais elle sera rejetée si le type de hachage n'est pas sensible à la casse.


### `-8` : Rejeter cette règle sauf si le type de hachage actuel utilise des caractères sur 8 bits (1octets, comme MD5 DES.)

### 📝 `EXEMPLE`  

      -8 u # "u" (mettre le mot de passe en majuscules) sera appliquée uniquement si le type de hachage utilise des caractères à 8 bits. 


### `-s` : Rejeter cette règle sauf si certains mots de passe ont été divisés lors du chargement.

>Lorsque John the Ripper charge un ensemble de mots de passe pour effectuer un craquage, certains mots de passe peuvent être divisés en morceaux ou traités par segments. Cela est souvent utilisé dans des configurations où les mots de passe sont plus complexes ou lorsqu'il y a besoin de manipuler des parties du mot de passe séparément (par exemple, des mots de passe longs ou des formats de hachage spécifiques).

### 📝 `EXEMPLE`  
    -s d # Cette règle applique la commande d (dupliquer le mot de passe), mais elle ne sera exécutée que si les mots de passe ont été divisés lors du processus de chargement.

### `-p` : Rejeter cette règle sauf si les commandes de paires de mots sont actuellement autorisées.

### 📝 `EXEMPLE`  
    -p d  # duplique le mot de passe  si l'option de paire de mots est activée. 

>Les "word pair commands" (commandes de paire de mots) dans John the Ripper sont utilisées dans un mode avancé appelé "Single crack mode", où deux mots peuvent être combinés ou manipulés simultanément pour générer des mots de passe candidats plus complexes.

### -p peux être utilisé avec les extra commandes :

### `1` : Utilise le premier mot de la ligne d'entrée (souvent le nom d'utilisateur ou une partie associée).

### `2` : Utilise le second mot de l'entrée (par exemple, un nom complet ou un commentaire).

### `+` Combine les deux mots (1 et 2) pour créer un seul mot, puis applique les transformations.
### ⚠️ À utiliser seulement après 1 ou 2.

### 📝 `EXEMPLE` `1` // `2` // `+` : 
     john:...:John Smith # Si l'entrée est comme ça ⬅️

### Alors 
`1` → prend "John"

`2` → prend "Smith"

`1+` → crée "JohnSmith"

`2+` → crée "SmithJohn"

### 📝 `EXEMPLE` ``-p // `1` // `2` // `+` : 

### Avec l'entrée :
    
    first = "Admin"
    second = "PASSword"
    -p 1u2l+c # Ici uniquement sur paire de mots => 1u → "ADMIN" 2l → "password" +r → concatène → "ADMINpassword" → puis renverse → "drowssapNIMDA"

---
---

## 🧮 Opérations de Bases

### `:` (no-op) : Ne rien faire avec le mot d'entrée.

### `l` : Convertir le mot en minuscules.

### `u` : Convertir le mot en majuscules.

### `c` : Mettre la première lettre en majuscule.

### `C` : Mettre la première lettre en minuscule et les autres en majuscules.

### `t` : Inverser la casse de tous les caractères du mot.

### `TN` : Inverser la casse du caractère à la position N.

### `r` : Inverser l'ordre des caractères du mot.

### `d` : Dupliquer le mot.

### `f` : Réfléchir le mot (ajouter un reflet du mot).

### `{` : Faire tourner le mot vers la gauche.

### `}` : Faire tourner le mot vers la droite.

### `$X` : Ajouter le caractère X à la fin du mot. Ajoute uniquement un caractère contrairement à Az "!/*-" qui peux ajouter une chaine de caractère

### `^X` : Ajouter le caractère X au début du mot. Ajoute uniquement un caractère contrairement à A0 "!/*-" qui peux ajouter une chaine de caractère

 ---
 ---

 ## 🔢 Constantes Numérique et Variables

### Principalement utilisé dans le variable avec la lettre v pour déclarer la variable
    v<VARIABLE> <VALEUR>  
### 📝 `EXEMPLE`     
    va*l   # Définit la variable A avec la longueur du mot actuel

### `0...9` : chiffres de 0 à 9 → représentent les valeurs numériques 0 à 9.

### `A...Z` : lettres de A à Z → représentent les valeurs numériques 10 à 35.

### `*` : : pour max_length (longueur maximale).

### `-`  pour (max_length - 1).

### `+`  pour (max_length + 1).

### `a...k` : pour des variables numériques définies par l'utilisateur (avec la commande "v").

### `l` : longueur du mot initial ou mis à jour (mise à jour chaque fois que "v" est utilisé).

### `m` : position du dernier caractère du mot initial ou mémorisé.

### `p` : position du caractère trouvé en dernier avec les commandes "/" ou "%".

### `z` : position ou longueur "infinie" (au-delà de la fin du mot).


---
---

## ⛓️ Commande de chaines(strings)

### `AN"STR"`: Insérer la chaîne "STR" dans le mot à la position N.
### N = 0 => début de mot
### N = z => fin de mot

### 📝 `EXEMPLE`
    Az"!"      # Ajoute "!" à la fin du mot

### `N` : Rejeter le mot à moins qu'il ne fasse plus de N caractères.

### 📝 `EXEMPLE`
    N=8        # Test les MDP d'une longueur mini de 8 caractéres, en dessous ils seront ignorés 

### `'N` : Test exactement le nombre N de caractères

### 📝 `EXEMPLE`
    'N=8 Testera des mot de passe de exactement 8 caractères








































































---

## 🔢  `Constantes Numériques et Variables`



































</details>


---
## 4️⃣ `Exemple`

 `Fichier Zip`
### 1) Extraire le Hash et le mettre dans un fichier
    zip2john <FICHIER> > <NOM.txt>




## 5️⃣ ``
## 6️⃣ ``
## 7️⃣ ``
## 8️⃣ ``
## 9️⃣ ``







----

## 4️⃣ ``
## 5️⃣ ``
## 6️⃣ ``
## 7️⃣ ``
## 8️⃣ ``
## 9️⃣ ``
