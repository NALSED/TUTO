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

### -1- `default` : "openrouter,qwen/qwen3.8-27b"

- `Rôle` : Chef d'orchestre du mode gratuit, écriture du code, retouches et coordination.

- `Choix` : Meilleur score du benchmark réalisé le 04/10/2026 sur les modèles gratuits OpenRouter (code + général + multimodal, 262K contexte). Remplace `poolside/laguna-s-2.1`, moins bien noté sur ces critères. Accédé via la clé API OpenRouter, pas besoin de clé API Anthropic.

### -2- `background` : "openrouter,cohere/north-mini-code"

- `Rôle` : Scan de fichiers, indexation du dossier, petits scripts d'arrière-plan.

- `Choix` : Claude Code consomme énormément de tokens pour lire la structure du projet.
Déporter cette charge sur North Mini Code (conçu spécifiquement pour le terminal) vous évite de griller 40% de votre quota Claude Pro inutilement. Sert aussi de 2e secours derrière Qwen3.8 27B si celui-ci est saturé.

### -3- `think` : "openrouter,nvidia/nemotron-3-ultra"

- `Rôle` : Phase de réflexion, création des architectures et Plan Mode (/plan).   

- `Choix` : (55B actifs / 550B MoE). C'est le modèle de raisonnement le plus lourd de la liste. Il conçoit des plans d'architecture complexes gratuitement avant de laisser Claude Sonnet exécuter le code. Sert aussi de 1er secours derrière Qwen3.8 27B si celui-ci est saturé.

- `Alternative payante`: "deepseek,deepseek-reasoner" (DeepSeek R1).

### -4- `longContext` : "openrouter,thinkingmachines/inkling"

- `Rôle` : Analyse de très gros fichiers ou charge d'une documentation complète de framework (>60k tokens). 

- `Choix` : Gratuit (Fenêtre de 1,05 Million de tokens). Permet d'injecter des bases de code entières sans jamais risquer de dépasser la mémoire de Claude ou de saturer votre forfait.

- Alternative gratuite : `openrouter,dots-studio/dots3-note-preview` (512K context).

### -5- `webSearch` : "openrouter,google/gemini-2.5-flash:online"

- `Rôle` : Recherche de documentation à jour et d'API récentes sur Internet.

- `Choix` : OpenRouter nécessite le suffixe `:online` pour activer la recherche web native.

---

- Avant l'installation de `Claude Code Router`

`=== Prérequis ===`

- Node.js v18 ou supérieur comme environnement d'exécution

```
sudo apt update && sudo apt install nodejs
```

- npm comme gestionnaire de paquets

```
sudo apt install npm
```

- Claude Code installé globalement 
voir [Proxmox.md](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/Proxmox.md)

- Au moins un backend de modèle, soit une clé API d'un fournisseur externe pris en charge (DeepSeek, Gemini, OpenRouter, Groq, Volcengine, SiliconFlow, etc.)

ICI **Openrouter** [https://openrouter.ai/](https://openrouter.ai/) — accès à Claude via OpenRouter aussi (pas de clé API Anthropic nécessaire, facturé via les crédits OpenRouter)

---

### -1- Installation et Démarrage du router

`- 1.1` Pour éviter des conflits de fichiers et de droits.

```
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
```

`- 1.2` bashrc

```
sudo vim $HOME/.bashrc

# Editer
export PATH=~/.npm-global/bin:$PATH
source .bashrc
```

`- 1.3` Installer Claude Code Router

```
npm install -g @musistudio/claude-code-router
```

`- 1.3` Démarrer

```
ccr start
```

`- 1.4` Vérification du port d'écoute 

```
ss -tlnp | grep 3456
```

---

### -2- Configuration

- Deux configuration différente :

   - 1 Si Claude Code Pro à encore des crédits
   - 2 Si claude code Pro ne dispose plus de crédit

`- 2.1` Configuration avec crédit

```
vim ~/.claude-code-router/config-pro.json
```

```json
{
  "providers": [
    {
      "name": "openrouter",
      "api_base_url": "https://openrouter.ai/api/v1/chat/completions",
      "api_key": "VOTRE_CLE_API_OPENROUTER",
      "models": [
        "qwen/qwen3.8-27b",
        "cohere/north-mini-code",
        "nvidia/nemotron-3-ultra",
        "thinkingmachines/inkling",
        "poolside/laguna-s-2.1",
        "google/gemini-2.5-flash:online",
        "anthropic/claude-3.5-sonnet:online"
      ]
    }
  ],
  "router": {
    "default": "anthropic,claude-3-7-sonnet",
    "background": "openrouter,cohere/north-mini-code",
    "think": "openrouter,nvidia/nemotron-3-ultra",
    "longContext": "openrouter,thinkingmachines/inkling",
    "webSearch": "openrouter,anthropic/claude-3.5-sonnet:online"
  }
}
```

- La ligne `default` utilise le préfixe `anthropic,` (pas `openrouter,`) : CCR bascule alors sur le Claude Code CLI natif déjà connecté sur momo, qui consomme l'abonnement Pro via son propre jeton OAuth — aucune clé API Anthropic requise. Seule la clé OpenRouter (`VOTRE_CLE_API_OPENROUTER`) est à renseigner, pour les modèles préfixés `openrouter,`.

`- 2.2` Configuration sans crédit

```
vim ~/.claude-code-router/config-free.json
```

```json
{
  "providers": [
    {
      "name": "openrouter",
      "api_base_url": "https://openrouter.ai/api/v1/chat/completions",
      "api_key": "VOTRE_CLE_API_OPENROUTER",
      "models": [
        "qwen/qwen3.8-27b",
        "cohere/north-mini-code",
        "nvidia/nemotron-3-ultra",
        "thinkingmachines/inkling",
        "poolside/laguna-s-2.1",
        "google/gemini-2.5-flash:online"
      ]
    }
  ],
  "router": {
    "default": "openrouter,qwen/qwen3.8-27b",
    "background": "openrouter,cohere/north-mini-code",
    "think": "openrouter,nvidia/nemotron-3-ultra",
    "longContext": "openrouter,thinkingmachines/inkling",
    "webSearch": "openrouter,google/gemini-2.5-flash:online"
  }
}
```

`- 2.4` Inscription des commande pour basculer d'une offre à l'autre

```
sudo vim .bashrc
```

```bash
# Switch vers le mode Pro (Claude via OpenRouter, pas de clé API Anthropic)
cc-pro() {
  cp ~/.claude-code-router/config-pro.json ~/.claude-code-router/config.json
  ccr restart
  echo "Mode Claude (via OpenRouter) ACTIF"
}

# Switch vers le mode 100% Gratuit 
cc-free() {
  cp ~/.claude-code-router/config-free.json ~/.claude-code-router/config.json
  ccr restart
  echo "Mode 100% GRATUIT Actif (Quota Claude sauvé)"
}
```

```
source .bashrc
```
