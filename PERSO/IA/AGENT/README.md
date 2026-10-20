## Création d'un agent de programmation "autonome"

---

### `=== Présentation ===`
- Cette section va porter sur la mise en place dans une VM sur proxmox, d'un agent `Claude CLI`, `Claude-Code-Router` (CCR), `OpenRouter`,  `RTK AI`

   - `Claude CLI` sera l'agent de programmation, il pourra switcher entre deux configuration de LLM.
   - `Claude-Code-Router` Permet à claude code d'avoir plusieurs configuration IA et switcher avec celle proposé par Openrouter.
   - `OpenRouter` Provider IA.
   - `RTK AI` Compresse les sortie de commandes du LLM, afin de préserver aussi des tokens. 

---

### `=== Fonctionnement ===`

Sur la VM 192.168.0.250, dans proxmox 192.168.0.242.

- `OpenRouter` fourni à `CCR` des model AI, dans ce cas de figure des model gratuit, car en parralléle un compte `Claude Pro` est utilisé.

- `Deux profils` d'AI sont créé via CCR et implémenté sur la VM (192.168.0.250). Après plusieurs test, `CCR` entre en confit avec le compte `Claude Pro` au niveau du fichier **~/.claude/settings.json**.

- En effet ce fichier est réécris par `Claude` ET par `CCR` ce qui créé des conflits et des crash.

- La solution retenu est la suivante, deux utilisateur créé sur la VM, `sednal` et `sednal-free` :
   - Sur `sednal` le fichier **~/.claude/settings.json** de `Claude-Pro` est déployé.
   - Sur `sednal-free` le fichier **~/.claude/settings.json** de `CCR` est déployé.  

- Et c'est `Claude CLI` sui choisi en fonction des tâches et des instructions qui lui sont données qui switch entre les utilisateurs et les models.

- Journalisation des changement d'user et model + calcule des token économisés via scripts

````
┌─────────────────────────────────────────┐
│  PC ADMIN                               │
│  192.168.0.235                          │
│                                         │
│   - Navigateur (UI CCR via tunnel SSH)  │
│   - Terminal SSH vers momo              │
└───────────────┬─────────────────────────┘
                │ ssh sednal-free@192.168.0.250   
                │ -L 3458:127.0.0.1:3458          
                v                                 
┌─────────────────────────────────────────────────────────────────────────────────┐
│                       PROXMOX                                                   │
│                     192.168.0.242                                               │
│                                                                                 │
│   ┌─────────────────────────────────────────────────────────────────────────┐   │
│   │  VM — Debian 13 CLI                                                     │   │
│   │  192.168.0.250                                                          │   │
│   │  - CCR                                                                  │   │
│   │  ┌──────────────────────────────┐   ┌────────────────────────────────┐  │   │
│   │  │ utilisateur sednal           │   │ utilisateur sednal-free        │  │   │
│   │  │         === PRO ===          │   │        === FREE ===            │  │   │
│   │  │                              │   │                                │  │   │
│   │  │ - claude-opus-5              │   │ - nvidia/nemotron-3-ultra:free │  │   │ 
│   │  │ - claude-opus-5-5            │   │ - cohere/north-mini-code:free  │  │   │
│   │  │ - claude-sonnet-5            │   │ - google/gemma-4-31b-it:free   │  │   │
│   │  │ - RTK                        │   │                                │  │   │
│   │  └─────────────┬────────────────┘   └────────────────┬───────────────┘  │   │
│   │                │ sudo -iu sednal-free                │                  │   │        
│   │                └─────────────────────────────────────┘                  │   │
│   │                                                                         │   │
│   │ === JOURNALISATION ===                                                  │   │
│   │  appeler_gratuit.sh => journal des appels au gratuit (avant/après)      │   │
│   │  comparer_tokens.sh + economies.py => jetons Pro vs gratuit, mesurés    │   │
│   └─────────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────────┘

````

- **Mesuré le 20/10/2026** (`economies.py`, base d'usage locale de CCR) : `nemotron` et `cohere` sont les deux modèles réellement utilisés (823 K jetons au total sur 97 requêtes, 27 % en échec — tous datés de la mise en place et d'essais de modèles, 0 échec depuis le 17/10). `gemma-4-31b-it` reste configuré mais n'a encore rendu aucun résultat exploitable (limite de débit OpenRouter, HTTP 429) : à vérifier avant de s'y fier.

---

### **MISE EN PLACE**

**=== INSTALLATION ===**

-1- [Claude CLI](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/-1-%20Claude-Cli_Install.md)

-2- [Claude Code Router](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/-2-%20Install_Claude-Caude-Router.md)

-3- [RTK AI](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/-3-%20Install_RTK-AI.md)


**=== CONFIGURATION ===**

-4- [OpenRouter](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/-4-%20Config_OpenRouter.md)

-5- [Claude Code Router](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/-5-%20Config_Claude-Code-Router.md)

-6- [Script](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/-6-%20Scripts.md)


**=== Utilisation ===**

-7- [Utilisation](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/-7-%20Utilisation.md)

---


**=== Documentation ===**

- [https://www.datacamp.com](https://www.datacamp.com/fr/tutorial/claude-code-router)
- [https://www.morphllm.com](https://www.morphllm.com/claude-code-router)
- [OpenRouter — Rate limits](https://openrouter.zendesk.com/hc/en-us/articles/39501163636379-OpenRouter-Rate-Limits-What-You-Need-to-Know)
