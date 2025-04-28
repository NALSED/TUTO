# `John The Ripper`
https://www.openwall.com/john/doc/
---

## 1️⃣ `Intro`
## 2️⃣ `Modes`
## 3️⃣ `Rules`
## 4️⃣ `Exemple`
## 5️⃣ ``
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

### Editer les régles en leurs donnant un nom qui sera appelé via la commande
    john --rules=<RULESNAME>

### Utiliser les régles ci dessous

<details>
<summary>
<h2>
:arrow_forward:RULES
</h2>
</summary>

## 🏴 `Flags de Rejet`

-:  Pas d’effet (no-op) — ne rejette jamais

-c  Rejette si le hash n’est pas sensible à la casse

-8  Rejette si le hash n’utilise pas de caractères 8 bits

-s  Rejette si aucun hash n’a été splitté au chargement

-p  Rejette si les commandes sur les paires de mots sont désactivées

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
