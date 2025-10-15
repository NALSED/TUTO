# 🛠️ Feuille de route : Aller plus loin en Python pour l’automatisation SysAdmin

> Objectif : Utiliser Python pour automatiser des tâches d’administration système de manière efficace et professionnelle.

---

## 1. Consolider les bases Python (si ce n’est pas encore fait)

- Maîtriser la syntaxe de base : variables, boucles, conditions, fonctions.
- Comprendre la gestion des erreurs avec `try/except`.
- Savoir lire et écrire dans des fichiers (`open`, `read`, `write`).
- Initiation à la programmation orientée objet (classes, méthodes).

---

## 2. Découvrir les modules Python essentiels pour l’automatisation système

| Module        | Utilité                                        | Ressources                      |
|---------------|-----------------------------------------------|--------------------------------|
| `os`          | Gestion des fichiers, dossiers, variables d’environnement | [docs os](https://docs.python.org/3/library/os.html)           |
| `subprocess`  | Exécution de commandes système externes       | [docs subprocess](https://docs.python.org/3/library/subprocess.html) |
| `shutil`      | Opérations avancées sur fichiers et dossiers  | [docs shutil](https://docs.python.org/3/library/shutil.html)   |
| `psutil`      | Surveillance des processus et ressources système | [psutil docs](https://psutil.readthedocs.io/en/latest/)        |
| `logging`     | Gestion des logs                               | [docs logging](https://docs.python.org/3/library/logging.html) |
| `json`, `yaml`, `configparser` | Manipulation des fichiers de configuration | [json](https://docs.python.org/3/library/json.html), [PyYAML](https://pyyaml.org/), [configparser](https://docs.python.org/3/library/configparser.html) |
| `paramiko`    | Connexion SSH et automatisation distante      | [paramiko docs](http://docs.paramiko.org/en/stable/)           |

---

## 3. Automatiser des tâches courantes

### a. Gestion des fichiers

- Copier, déplacer, supprimer des fichiers/dossiers.
- Modifier les permissions (`chmod`).
- Créer des sauvegardes avec rotation (ex : garder 7 derniers jours).

### b. Exécution de commandes système

- Lancer des commandes shell avec `subprocess.run()`.
- Capturer et analyser la sortie des commandes.
- Gérer les erreurs et les exceptions.

### c. Surveillance et collecte d’informations

- Lire et analyser les logs systèmes.
- Surveiller l’état des services/processus avec `psutil`.
- Envoyer des alertes en cas d’anomalies (email, Slack...).

### d. Manipulation de fichiers de configuration

- Lire et modifier des fichiers JSON, YAML, INI.
- Automatiser le déploiement de configurations.

### e. Automatisation réseau

- Tester la connectivité avec des pings.
- Automatiser les transferts de fichiers avec `paramiko` (SFTP/SSH).

---

## 4. Bonnes pratiques

- Écrire des scripts modulaires et réutilisables (fonctions, classes).
- Utiliser des environnements virtuels (`venv`).
- Documenter ton code et écrire des commentaires clairs.
- Mettre en place des tests unitaires avec `pytest`.
- Automatiser l’exécution avec des tâches cron (Linux/macOS) ou Task Scheduler (Windows).

---

## 5. Ressources recommandées

- **Livres :**  
  - *Automate the Boring Stuff with Python* — Al Sweigart (gratuit en ligne)  
  - *Python for Unix and Linux System Administration* — Noah Gift  
- **Tutoriels en ligne :**  
  - [Automate the Boring Stuff](https://automatetheboringstuff.com/)  
  - [Real Python — System Administration](https://realpython.com/python-sysadmin/)  
- **Outils et bibliothèques :**  
  - `psutil`, `paramiko`, `logging`  
- **Forums & Communautés :**  
  - Stack Overflow  
  - Reddit r/sysadmin  
  - CS50 Discord/Forum

---

## 6. Exemple de projet simple à réaliser

> **Sauvegarde automatique avec rotation**

- Script Python qui :  
  - Copie un dossier important vers un dossier de sauvegarde.  
  - Garde uniquement les 7 dernières sauvegardes (suppression des plus anciennes).  
  - Écrit un log détaillé de l’opération.  
  - Envoie une alerte email en cas d’erreur.

---

## 7. Prochaines étapes

- Pratiquer régulièrement avec des mini-projets personnels.
- Apprendre à automatiser avec des outils complémentaires : Ansible, Terraform.
- Approfondir les notions réseau et sécurité.
- Découvrir Docker et la conteneurisation.

---



---

