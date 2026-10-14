## Configuration `OpenRouter`

---

[https://openrouter.ai/](https://openrouter.ai/)

---

-1- Céation de compte / Clé API

- Créer un compte

- Créer une clé `API`, elle sera demandé lors de la création du routage avec `CCR` (Claude Code Router).

---

-2- Provisionement compte

⚠️ ce passage nécessite un paiement de 10$ ⚠️

- Les sous seront provisionner sur le compte et ne seront `pas toucher` dans notre cas utilisation de model `:free`

- Les `10$` permet de passer de `50 requêtes/jour OU 20/minute` **=>** `1000 requêtes/jour définitivement`.

 `[NOTE]`

- Après la mise en place total du workflow, un `test` à été réalisé ou `certifier` que les `10$ ne bouge pas.

- Suivi sur openrouter.ai => Activity. Relevé du 04/10/2026 après `mise au point complète` : $0.00 de dépense totale, lutilisation de modèles `:free` est **confirmés gratuits**.

- Si par la suite utilisation de model payant avec nouveau provisionement du compte, une option sur la clé API permet de bloqué le seuil de dépense.

---
 
-3- Choix IA.

- ce rendre dans l'onglet `Models`

<img width="1630" height="475" alt="image" src="https://github.com/user-attachments/assets/6a95c647-fd03-436f-8a19-f049829d56e2" />


- Plus de 500 model sont disponible, dans notre cas `Free`

<img width="1358" height="109" alt="image" src="https://github.com/user-attachments/assets/f77b1b17-2969-4881-841a-47c9a5fd69df" />

- Après benchmark ET mes besoins choix `AI`
````
MODEL                                   CONTEXT  USAGE
nvidia/nemotron-3-ultra-550b-a55b:free  1 M      général, gros contexte
cohere/north-mini-code:free             256 K    doc, logs, commits, scan de dossier
google/gemma-4-31b-it:free              256 K    réflexion, plan gratuit
````

- Toujours écrire le suffixe **:free**. Sans lui, l'id désigne la variante payante du même modèle chez `OpenRouter`.
