#  Commande 

---

### `Créer environement virtuel`

[source](https://docs.python.org/fr/3.8/library/venv.html)
        
        python -m venv .venv

---

### `Activer environement`
#### Une fois activé les instalations et modifs se feront dans  l'environement  virtuel
         
         .\.venv\Scripts\activate


---

### `Executer fichier`
#### Sauver le  code et dans le terminal
        python .\[NOM DU FICHIER] # Autocomplétion avec TAb


---
---
# Bonnes Pratiques

---
        my_project/
        │
        ├── my_package/           # Répertoire principal du paquet
        │   ├── __init__.py       # Fichier spécial pour faire de ce répertoire un paquet Python
        │   ├── module1.py        # Module Python 1 : contient du code (fonctions, classes, etc.)
        │   ├── module2.py        # Module Python 2 : autre partie du code
        │   └── utils.py          # Module utilitaire : fonctions d’aide réutilisables
        │
        ├── tests/                # Répertoire dédié aux tests unitaires
        │   ├── __init__.py       # Permet de traiter ce dossier comme un package (facultatif)
        │   ├── test_module1.py   # Tests pour module1.py
        │   ├── test_module2.py   # Tests pour module2.py
        │   └── test_utils.py     # Tests pour utils.py
        │
        ├── venv/                 # Environnement virtuel isolé pour ce projet
        │                         # (à ne pas versionner dans Git)
        │
        ├── requirements.txt      # Fichier listant toutes les dépendances Python du projet
        │
        └── README.md             # Documentation du projet (description, installation, usage)


--- 

# Détail des éléments

## 1. my_package/

- C’est le cœur de l'application ou bibliothèque.
- Ce dossier contient le code Python organisé en modules.
- `__init__.py` : fichier qui indique à Python que ce dossier est un package.
  - Peut être vide, ou servir à initialiser le package (par exemple importer certaines fonctions directement).
- `module1.py`, `module2.py`, `utils.py` : fichiers Python où tu mets ton code réparti par fonctionnalité.

## 2. tests/

- Contient les tests automatisés pour le code.
- Permet de vérifier que chaque partie fonctionne comme prévu.
- Chaque fichier teste un module correspondant (ex : `test_module1.py` teste `module1.py`).
- Bonne pratique : toujours avoir des tests, cela facilite la maintenance et l’évolution du projet.

## 3. venv/

- C’est l’environnement virtuel  crées avec `python -m venv venv`.
- Il contient toutes les librairies et dépendances installées spécifiquement pour ce projet.
- Important : ce dossier ne doit pas être envoyé sur Git (ajouté dans `.gitignore`).
## 4. requirements.txt

- Fichier texte listant toutes les dépendances Python nécessaires au projet (exemple : Flask, requests, numpy, etc.).
- Permet à quelqu’un d’autre de reproduire l’environnement en tapant :

  ```bash
  pip install -r requirements.txt
*  créer le fichier  :
  * installer les  dépendances
                   pip freeze > requirements.txt
              
## 5. README.md

- Document texte en Markdown.
- Sert à décrire le projet :  
  - Ce que fait le projet  
  - Comment l’installer  
  - Comment l’utiliser  
  - Informations supplémentaires (contribuer, licence, etc.)
- C’est souvent la première chose que quelqu’un voit en arrivant sur ton projet (ex : GitHub).




 
### ``
 
