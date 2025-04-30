# 🏴‍☠️`CTF WCS`🏴‍☠️ 

## 1️⃣ Intro

### Bienvenu dans ce challenge cybersécurité de fin de session TSSR.
### Tu peux utiliser tous les outils, techniques, sites web, logiciels, que tu souhaites pour arriver
### à tes fins.
### Les fichiers ou documents fournis peuvent t'aider, ou pas...
### Si tu es bloqué, ton formateur pourra - peut-être - t'aider à avancer !
### Soit inventif et perspicace !
### BONNE CHANCE !


<details>
<summary>
<h2>
:arrow_forward: 2. INIT  
</h2>
</summary>


# ➡️ Ouvrir le Zip

### 1️⃣ Prise en main de [JtR](https://github.com/NALSED/Future-R-vision/blob/main/LINUX/app/password/john_the_ripper2.md)

### 2️⃣ Création de la régle pour casser le MDP
#### En utilisant commande vu précédement voici la régle:

  'N=8 # chaine de 8 caractére
  A0"Az" # Ajoute Az au début
  $7 ou Az"7" # Fini par 7
  @M # Supprime le carractére M
  @5 # Supprime le carractére 5

### 3️⃣ extraire le Hash du Zip et liste de mot
#### Pour extraire utiliser zip2john
    zip2john challengeTSSR.zip > tssr.hashes

#### Le fichier tssr.hashes contient maintenant le hash du mdp sur lequel nous utilisons notre régle john
#### Je vais utiliser la liste de base sur Kali rockyou.txt
  cd /usr/share/wordlists
  sudo gzip -d rockyou.txt.gz

### 4️⃣ Faire la recherche via rockyou et notre régle  
#### Lancer la commande
    john 















</details>



<details>
<summary>
<h2>
:arrow_forward: 3. FILES ?  
</h2>
</summary>
blabla
</details>




<details>
<summary>
<h2>
:arrow_forward: 4. MAIN  
</h2>
</summary>
blabla
</details>











