        |              | Propriétaire |            |            | Groupe |            |            | Autres utilisateurs |            |            |
        |--------------|--------------|------------|------------|--------|------------|------------|---------------------|------------|------------|
        |              | Lecture      | Écriture   | Exécution  | Lecture| Écriture   | Exécution  | Lecture             | Écriture   | Exécution  |
        | Droits       | r            | w          | x / s, S   | r      | w          | x / s, S   | r                   | w          | x / t, T   |
        
---

        | Valeur octale | Lecture (r) | Écriture (w) | Exécution (x) | Description |
        |---------------|-------------|--------------|----------------|-------------|
        | 0             | –           | –            | –              | Aucun droit |
        | 1             | –           | –            | x              | Exécution seule |
        | 2             | –           | w            | –              | Écriture seule |
        | 3             | –           | w            | x              | Écriture + exécution |
        | 4             | r           | –            | –              | Lecture seule |
        | 5             | r           | –            | x              | Lecture + exécution |
        | 6             | r           | w            | –              | Lecture + écriture |
        | 7             | r           | w            | x              | Lecture + écriture + exécution |
