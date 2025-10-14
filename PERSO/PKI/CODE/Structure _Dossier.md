# Arborescence des deux programmes Shell et WebUi

## 1️⃣ Shell

               /CODE
              │
              ├── g_cert.sh => Lancement install
              ├── main.py => Gestion, via gcert dans le shell
              ├── requirements.txt
              ├── .gitignore
              ├── README.md.txt
              ├── venv/
              ├── libs/ => Dossier créer pour isoler les dépendences  python et éviter  un venv en  prod
              ├──__pycache__/
              ├── my_package/
              │   ├──__init__.py
              │   ├── certif.py
              │   ├── gestion.py
              │   ├── lan.py
              │   ├── logs.py
              │   ├── test.py
              │   ├── wan.py
              │   └──__pycache__/
              └── script/
                  ├── doc.md
                  └── load.sh
            
            ---

## 2️⃣ WebUi

            CODE/
            │
            ├── g_cert.sh                    # Script d'installation ou de lancement
            ├── main.py                      # Point d'entrée CLI principal
            ├── requirements.txt             # Dépendances Python
            ├── .gitignore                   # Fichiers ignorés par Git
            ├── README.md.txt                # Documentation principale
            │
            ├── venv/                        # Environnement virtuel Python
            │   └── ...                      # (bin/, lib/, etc.)
            │
            ├── __pycache__/                 # Cache Python global
            │
            ├── libs/                        # Librairies personnalisées
            │   └── ...                      # Modules spécifiques
            │
            ├── my_package/                  # Package principal de l'app
            │   ├── __init__.py
            │   ├── certif.py
            │   ├── gestion.py
            │   ├── lan.py
            │   ├── logs.py
            │   ├── test.py
            │   ├── wan.py
            │   └── __pycache__/
            │
            ├── script/                      # Scripts annexes
            │   ├── doc.md
            │   └── load.sh
            │
            ├── webapp/                      # 💻 Interface Flask
            │   ├── __init__.py              # Initialise l'app Flask (factory pattern possible)
            │   ├── routes.py                # Routes Flask (logique Web)
            │   ├── views/                   # Rendu HTML
            │   │   └── index.html           # Page d’accueil
            │   ├── static/                  # CSS, JS, images
            │   │   └── style.css            # Exemple de CSS
            │   └── templates/              # Alias de `views/` 
            │       └── index.html
            │
            └── run_web.py                   # Point d’entrée pour lancer Flask


### Exemple de fichiers associés

#### run_web.py (Point d’entrée Flask)

        from webapp import create_app

        app = create_app()
        
        if __name__ == "__main__":
            app.run(debug=True)

---

#### webapp/__init__.py (initialisation de Flask)

        from flask import Flask
        
        def create_app():
            app = Flask(__name__)
        
            from .routes import main
            app.register_blueprint(main)
        
            return app

---

#### webapp/routes.py

        from flask import Blueprint, render_template, request
        from my_package.gestion import une_fonction_utilitaire  # Exemple d'import depuis ton package existant
        
        main = Blueprint('main', __name__)
        
        @main.route("/", methods=["GET", "POST"])
        def index():
            message = ""
            if request.method == "POST":
                data = request.form.get("data")
                message = une_fonction_utilitaire(data)
            return render_template("index.html", message=message)


---
#### webapp/views/index.html

          <!DOCTYPE html>
          <html>
          <head>
              <meta charset="UTF-8">
              <title>UI Flask - Projet Certif</title>
              <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
          </head>
          <body>
              <h1>Interface Web - GCert</h1>
              <form method="post">
                  <input type="text" name="data" placeholder="Entrer une info">
                  <button type="submit">Envoyer</button>
              </form>
              {% if message %}
                  <p>Résultat : {{ message }}</p>
              {% endif %}
          </body>
          </html>


---

#### .gitignore (extrait utile)

        # Python
        __pycache__/
        *.pyc
        *.pyo
        
        # Environnement virtuel
        venv/
        
        # IDE
        .vscode/
        *.swp
        
        # Flask config
        instance/




          










