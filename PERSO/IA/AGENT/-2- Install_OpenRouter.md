## Installation `Claude Code Router`


---


- `Projet` [https://github.com/musistudio/claude-code-router](https://github.com/musistudio/claude-code-router)
- `API` sur [https://openrouter.ai/](https://openrouter.ai/)

---

=== Labs ===

- IP : `192.168.0.250`
- CPU `8 cores`
- RAM Ddr5 `16Go`
- Hard Disk 1 `32Go`
- Hard Disk 2 `60 Go`

---

### -1- Prérequis

- Afin de pouvoir changer de configuration via `OpenRouter` la technique retenue est la suivante :

   - Création de 2 Utilisateurs Linux, avec 2 configuration du fichier `~/.claude/settings.json`, et c'est Claude CLI via des instruction qui change entre les deux utilisateurs.
   - Utilisation de 2 Utilisateurs, car CCR **ne peut pas consommer l'abonnement Claude Pro**, quel que soit le réglage (confirmé par l'issue musistudio/claude-code-router#482 et par test).

`- 1.1` User
````
sudo adduser sednal-free
sudo su - sednal-free
````

`- 1.2` Nodejs
````
node -v
````

Doit afficher `v22` ou plus. Sinon :

````
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
````

### -2- Configuration User

- Configuration des fichier `.bashrc` et `.profile` 
- Configuration npm install sans `sudo`

`[RAPPEL]`

- `~/.profile` : lu une seule fois à l'ouverture d'une session de connexion (SSH, bash -l, su -). Sert à définir l'environnement : PATH, variables d'export.
- `~/.bashrc` : lu à chaque nouveau shell bash interactif (ouverture d'un terminal). Sert au confort : alias, fonctions, prompt, complétion
- `npm` (Node Package Manager) : gestionnaire de paquets de Node.js (JavaScript).

**=== Explications ===**

- `claude` et `CCR` s’installe via `npm`.

- - **Le `PATH` doit aller dans `~/.profile`, pas seulement dans `~/.bashrc`.** Le `.bashrc` de Debian commence par « si le shell n'est pas interactif, ne rien faire » : un appel non interactif (`bash -lc`) ne lit jamais la ligne ajoutée à la fin.

- La suite à pour but de configurer les fichiers `.bashrc` et `.profile`, afin que `npm` fasse les installations dans $HOME et sans `sudo`. En effet l'utilisation de `sudo npm install -g`, installe une seconde copie, côté root. 

- Ce que ça apporte pour `CCR`
   - `Un seul propriétaire` : `CCR`, `claude` et leurs processus appartiennent à `sednal-free`. `ccr stop` et `ccr start` agissent sur ce qui tourne réellement.
   - `Port` : pas de seconde installation qui garde le port occupé.
   - `Moindre risque` : un compte « gratuit » ou isolé n'a pas besoin de privilèges, et les scripts d'installation des paquets ne tournent pas en root.
  
---

`- 2.1` Créer un dossier d'installation.
````
mkdir -p ~/.npm-global
````

`- 2.2` Changer le dossier de destination d'installation
````
npm config set prefix '~/.npm-global'
````

- Ajouter `~/.npm-global/bin` au **PATH** (dans ~/.profile et ~/.bashrc) : pour que le shell trouve `CCR` et `claude`

`- 2.3` Editer ~/.profile
````
sudo vim ~/.profile
````
````
export PATH="$HOME/.npm-global/bin:$PATH"
````

`- 2.4` Editer ~/.bashrc
````
sudo vim ~/.bashrc
````
````
export PATH="$HOME/.npm-global/bin:$PATH"
````

`- 2.5` Recharger ~/.bashrc
````
source ~/.bashrc
````

---

### -3- Installer `RCC`

`[NOTE]`

- `@anthropic-ai/claude-code` est requis séparément : CCR lance le binaire `claude`, il ne l'embarque pas.
- Sans lui : `Failed to start claude: Error: spawn claude ENOENT`.

````
npm install -g @musistudio/claude-code-router
npm install -g @anthropic-ai/claude-code
````



