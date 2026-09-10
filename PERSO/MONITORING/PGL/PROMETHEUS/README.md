## === Prometheus ===



### Présentation

- Basé sur du language `GO`

- `DB time series` (Base de donnée basée sur le temps) + serveur web + moteur

- Prometheus fait du `scrapping`, sur une route donnée => `IP + PORT`

- Très bonne répartition `mémoire / Disque`

- Le stockage se fait en 3 colones : `clé / valeur /timestam`p

- Calcule par `double delta` pour limiter la place des éléments collectés : écart par rapport à la valeur précédente

- Possibilité `d'auto discovery` 

---
