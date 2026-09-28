## Installation et Configuration de `Claude Code Router`

---

- Mise en place du projet [https://github.com/musistudio/claude-code-router](https://github.com/musistudio/claude-code-router)

- API sur [https://openrouter.ai/](https://openrouter.ai/)

- Implémentation du `Claude Code Router` sur une VM sur proxmox, avec l'API `openrouter`

**=== Documentation ===**

- [https://www.datacamp.com](https://www.datacamp.com/fr/tutorial/claude-code-router)

- [https://www.morphllm.com](https://www.morphllm.com/claude-code-router)

---

=== Labs ===

- IP : `192.168.0.23`

- CPU `8 cores`

- RAM Ddr5 `16Go`

- Hard Disk 1 `32Go`

- Hard Disk 2 `60 Go`

---

- Ici l'objectif est d'utiliser le projet est de pouvoir adapter les IA en fonction de l'usage et surtout du besoin.

- le principe est le suivant `Claue Code Router`, agis comme un orchestrateur d'IA, un fichier `JSON` détermine qu'elle IA est utilisées pour quelle besoin.

- L'utilisant la clé API d'`openrouter`, nous donne accées à un multitude d'IA, jai pour ma par choisi des Ia gratuite pour démarrer, comme ci dessous : 
     1. default : "anthropic,claude-3-7-sonnet"Rôle : Chef d'orchestre principal, écriture du code, retouches et coordination.Pourquoi ce choix : Vous utilisez directement votre abonnement Claude Pro (20$/mois) via l'API/Auth Anthropic. C'est le meilleur modèle au monde pour orchestrer le projet.2.

      2. background : "openrouter,cohere/north-mini-code"Rôle : Scan de fichiers, indexation du dossier, petits scripts d'arrière-plan.   Pourquoi ce choix : Gratuit. Claude Code consomme énormément de tokens pour lire la structure de votre projet. Déporter cette charge sur North Mini Code (conçu spécifiquement pour le terminal) vous évite de griller 40% de votre quota Claude Pro inutilement.Alternative gratuite : openrouter,poolside/laguna-xs-2.13.

      3. think : "openrouter,nvidia/nemotron-3-ultra"Rôle : Phase de réflexion, création des architectures et Plan Mode (/plan).   Pourquoi ce choix : Gratuit (55B actifs / 550B MoE). C'est le modèle de raisonnement le plus lourd de votre liste. Il conçoit des plans d'architecture complexes gratuitement avant de laisser Claude Sonnet exécuter le code.Alternative payante très économique : "deepseek,deepseek-reasoner" (DeepSeek R1).
   
     4.  longContext : "openrouter,thinkingmachines/inkling"Rôle : Analyse de très gros fichiers ou charge d'une documentation complète de framework (>60k tokens).   Pourquoi ce choix : Gratuit (Fenêtre de 1,05 Million de tokens). Permet d'injecter des bases de code entières sans jamais risquer de dépasser la mémoire de Claude ou de saturer votre forfait.Alternative gratuite : openrouter,dots-studio/dots3-note-preview (512K context).5.

     5.  webSearch : "openrouter,anthropic/claude-3.5-sonnet:online"Rôle : Recherche de documentation à jour et d'API récentes sur Internet.Pourquoi ce choix : OpenRouter nécessite le suffixe :online pour activer la recherche web native.   Alternative gratuite : "openrouter,google/gemini-2.5-flash:online"
    














