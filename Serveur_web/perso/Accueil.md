<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion - Accueil</title>
    <style>
        /* Animation du fond */
        @keyframes bg-scrolling-reverse {
            from {
                background-position: 0 0;
            }

            to {
                background-position: 50px 50px;
            }
        }

        body {
            margin: 0;
            font-family: Exo, Arial, sans-serif;
            background: url("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAIAAACRXR/mAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAAABnSURBVHja7M5RDYAwDEXRDgmvEocnlrQS2SwUFST9uEfBGWs9c97nbGtDcquqiKhOImLs/UpuzVzWEi1atGjRokWLFi1atGjRokWLFi1atGjRokWLFi1af7Ukz8xWp8z8AAAA//8DAJ4LoEAAlL1nAAAAAElFTkSuQmCC") repeat;
            background-size: 50px 50px;
            animation: bg-scrolling-reverse 5s linear infinite;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            /* Contenu centré en haut */
            align-items: center;
            height: 100vh;
            color: white;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.7);
        }

        header {
            width: 100%;
            /* L'entête prend toute la largeur */
            background: rgba(10, 10, 10, 0.9);
            padding: 20px 0;
            text-align: center;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
        }

        header h1 {
            font-size: 36px;
            margin: 0;
            font-weight: bold;
            text-transform: uppercase;
        }

        nav {
            margin-top: 15px;
        }

        nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            justify-content: center;
        }

        nav ul li {
            margin: 0 20px;
        }

        nav ul li a {
            color: white;
            text-decoration: none;
            font-size: 1.2rem;
            letter-spacing: 1px;
        }

        nav ul li a:hover {
            color: #00aaff;
        }

        .container {
            display: flex;
            flex-direction: column;
            justify-content: center;
            /* Centre le contenu verticalement */
            align-items: center;
            /* Centre le contenu horizontalement */
            text-align: center;
            background: rgba(30, 30, 30, 0.8);
            padding: 20px 40px;
            border-radius: 15px;
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.5);
            max-width: 400px;
	    height: auto;
	    min-height: 200px;
            margin-top: 200px;
            /* Ajoute plus d'espace entre l'entête et le bloc */
        }

	.content {
		flex: 1;
	}

        h2 {
            font-size: 2.5rem;
            margin-bottom: 20px;
            /* Plus d'espace sous le titre */
        }

        p {
            font-size: 1.2rem;
            margin-top: 10px;
        }

        .google-search {
            background-color: rgba(20, 20, 20, 0.8);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
            margin-bottom: 40px;
            margin-top: 30px;
            display: flex;
            justify-content: center;
            /* Centre la recherche horizontalement */
            width: fit-content;
            /* La barre de recherche prend la largeur de son contenu */
        }

        .google-search input[type="text"] {
            padding: 10px;
            font-size: 1rem;
            border-radius: 5px;
            border: none;
            width: 280px;
            background: black;
            color: white;
        }

        .google-search input[type="submit"] {
            padding: 10px 20px;
            font-size: 1rem;
            background-color: #00aaff;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            color: white;
            transition: 0.3s;
        }

        .google-search input[type="submit"]:hover {
            background-color: #00aaff;
        }

        footer {
            width: 100%;
            background: rgba(10, 10, 10, 0.9);
            padding: 10px 0;
            text-align: center;
            margin-top: auto;
        }
    </style>
</head>

<body>
    <!-- Header -->
    <header>
        <h1>INFRA</h1>
        <nav>
            <ul>
                <li><a href="next.html">Services</a></li>
            </ul>
        </nav>
    </header>

    <!-- Contenu principal -->
    <div class="container">
        <h2>gestion</h2>
        <p>Infra</p>
    </div>

    <!-- Google Search  -->
    <div class="google-search">
        <form method="GET" action="http://www.google.be/search">
            <div align="center">
                <a href="http://www.google.fr/">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/b/b9/First-google-logo.gif" border="0" alt="Logo Google" align="absmiddle" width="80">
                </a>
                <input type="text" name="q" size="31" maxlength="255" placeholder="Rechercher sur Google">
                <input type="hidden" name="hl" value="fr">
                <input type="submit" name="btnG" value="Rechercher">
            </div>
        </form>
    </div>

    <!-- Footer -->
    <footer>&copy; version 3 </footer>
</body>

</html>
