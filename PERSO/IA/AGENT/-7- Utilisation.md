## Utilisation `CCR` / `Claude Code`.

---

- Maintenant que tout est en place, le changement ce fait via un fichier dans le projet.

````
vim CLAUDE.md
````
````
# Exemple d'instruction.

Routage 4.5 : tâches **mécaniques** (fixtures synthétiques, reformatage, `ruff`, docstrings, renommages) via :
`outils/appeler_gratuit.sh "<description>" -- sudo -iu sednal-free bash -lc 'claude -p "<tâche>" --settings "{\"env\":{\"ANTHROPIC_MODEL\":\"OpenRouter/nvidia/nemotron-3-ultra-550b-a55b:free\"}}"'`

Une commande purement locale sans IA (ruff seul, mv, etc.) ne passe pas par le wrapper : elle s'exécute directement, elle ne consomme aucun compte.
Tâches de **jugement** (architecture, scoring, recoupement, revue, décisions) sur le compte Pro.
Sous pression de quota, déplacer plus de mécanique vers le gratuit et le noter dans `ETAT.md`
````
