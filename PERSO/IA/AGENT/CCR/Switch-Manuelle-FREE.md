## Installation et Configuration de `Claude Code Router`

---

- Projet [https://github.com/musistudio/claude-code-router](https://github.com/musistudio/claude-code-router)
- API sur [https://openrouter.ai/](https://openrouter.ai/)
- Implémentation sur une VM Proxmox, avec l'API `openrouter`

**=== Documentation ===**

- [https://www.datacamp.com](https://www.datacamp.com/fr/tutorial/claude-code-router)
- [https://www.morphllm.com](https://www.morphllm.com/claude-code-router)
- [OpenRouter — Rate limits](https://openrouter.zendesk.com/hc/en-us/articles/39501163636379-OpenRouter-Rate-Limits-What-You-Need-to-Know)

---

=== Labs ===

- IP : `192.168.0.250`
- CPU `8 cores`
- RAM Ddr5 `16Go`
- Hard Disk 1 `32Go`
- Hard Disk 2 `60 Go`

---

- Objectif : adapter le modèle utilisé en fonction du besoin (gratuit vs abonnement Pro).
- Version testée : CCR `3.1.1`, Claude Code `v2.1.289`. **Plus de `config.json` manuel fonctionnel** — toute la configuration passe par l'interface web (`ccr ui`).
- CCR **ne peut pas consommer l'abonnement Claude Pro**, quel que soit le réglage (confirmé par l'issue musistudio/claude-code-router#482 et par test). Tout modèle routé par CCR est facturé en API classique — gratuit seulement si le modèle porte le suffixe `:free`.
- Architecture retenue : **une seule VM, deux utilisateurs Linux**, parce que CCR réécrit `~/.claude/settings.json` globalement à chaque démarrage et détruirait sinon la config native.

---

### -1- Prérequis (les deux utilisateurs)

````
node -v
````

Doit afficher `v22` ou plus. Sinon :

````
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
````

---

### -2- Utilisateur natif Pro (`sednal`)

Rien à installer côté CCR. Juste s'assurer d'être connecté :

````
claude
/login
````

Vérifier la bannière : `Sonnet 5.5 · Claude Pro`.

Cet utilisateur garde son `~/.claude/settings.json` écrit à la main (hooks, `modelSettings`). CCR n'y touche jamais tant qu'il n'est pas installé sous ce compte.

---

### -3- Utilisateur CCR / gratuit (`sednal-free`)

````
sudo adduser sednal-free
sudo su - sednal-free
````

````
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.profile
echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.bashrc
source ~/.profile
````

- **Le `PATH` doit aller dans `~/.profile`, pas seulement dans `~/.bashrc`.** Le `.bashrc` de Debian commence par « si le shell n'est pas interactif, ne rien faire » : un appel non interactif (`bash -lc`) ne lit jamais la ligne ajoutée à la fin. Symptôme : `bash: line 1: claude: command not found` alors que la commande marche parfaitement en session interactive.

````
npm install -g @musistudio/claude-code-router
npm install -g @anthropic-ai/claude-code
````

- **Jamais de `sudo npm install -g`.** Cela crée une installation root parallèle, invisible du `ccr stop` de l'utilisateur, qui squatte le port et provoque des erreurs incompréhensibles.
- `@anthropic-ai/claude-code` est requis séparément : CCR lance le binaire `claude`, il ne l'embarque pas. Sans lui : `Failed to start claude: Error: spawn claude ENOENT`.

Lancer l'interface :

````
ccr ui
````

Deux ports distincts, à ne pas confondre :

| Port | Rôle |
| :-- | :-- |
| `3456` | gateway — c'est lui qui est dans `ANTHROPIC_BASE_URL` |
| `3458` | interface web de configuration |

Le port de l'UI **et** le `ccr_web_token` changent à chaque `ccr start` : toujours relire la sortie de la commande. Un token périmé donne `CCR web authentication token is missing or invalid` et fait échouer les tests de connexion sans que ce soit évident.

Accès distant :

````
ssh -L 3458:127.0.0.1:3458 sednal-free@192.168.0.250
````

---

### -4- Configuration du provider (dans l'UI)

1. **Choose provider** → preset **OpenRouter** → coller la clé API OpenRouter (régénérée, jamais celle d'un screenshot ou d'un chat).
2. **Pick models** → ajouter les modèles de `-5-`. Retirer tout modèle `anthropic/...` présent par défaut dans « Added models » : c'est du payant.
3. **Verify connection** → cocher tous les modèles → **Start check**. Chaque modèle doit afficher **Available / Connection verified**. Ne rien documenter comme fonctionnel sans ce test.
4. **Connect agent** → Agent = Claude Code, Profile name = `Claude Code`, **Default model** = un modèle vérifié. Laisser Opus/Sonnet/Fable/Haiku sur « Keep Claude Code default ».
5. **Finish**.

À la fin du wizard, CCR réécrit **globalement** `~/.claude/settings.json` de cet utilisateur (`apiKeyHelper`, `ANTHROPIC_BASE_URL=http://127.0.0.1:3456`, `ANTHROPIC_MODEL`). À partir de là, `claude` seul route aussi vers la gateway — c'est voulu, cet utilisateur est dédié au gratuit.

**Ne jamais éditer ce fichier à la main** : CCR l'écrase au démarrage suivant. Toute personnalisation passe par *Agent Profiles → Advanced settings → Edit Claude settings*.

**Ne pas créer plusieurs Agent Profiles pour simuler des rôles** — testé et non fonctionnel : un seul profil (System default) contrôle réellement `settings.json`, quel que soit le nom passé à `ccr "<profil>"`. Un seul profil suffit, le choix du modèle se fait autrement (`-6-`).

---

### -5- Modèles gratuits (OpenRouter, `$0/M`) — vérifiés en connexion live le 04/10/2026

| Modèle | Contexte | Usage |
| :-- | :-- | :-- |
| `nvidia/nemotron-3-ultra-550b-a55b:free` | 1 M | général, gros contexte |
| `cohere/north-mini-code:free` | 256 K | doc, logs, commits, scan de dossier |
| `google/gemma-4-31b-it:free` | 262 K | réflexion, plan gratuit |

- **Toujours écrire le suffixe `:free`.** Sans lui, l'id désigne la **variante payante** du même modèle chez OpenRouter.
- Noter les noms exacts : `gemma-4-31b-it` (et non `gemma-4-31b`), `nemotron-3-ultra-550b-a55b` (et non `nemotron-3-ultra`).
- Pas besoin de modèle dédié au gros contexte : Nemotron-3 Ultra a déjà 1 M de fenêtre.

Candidats écartés :

- `thinkingmachines/inkling` et `inkling-small` : **HTTP 403 — *only available on agentic harnesses*.** OpenRouter bloque ces modèles hors d'un vrai harnais agentique, y compris le test « Verify connection ». Inutilisables ici.
- `poolside/laguna-s-2.1` / `laguna-xs-2.1` : retirés le 31/10/2026.
- `qwen/qwen3.8-27b` : n'existe pas, n'a jamais été gratuit. Issu d'un « benchmark » jamais vérifié — cause du premier 402 rencontré.
- `google/gemini-2.5-flash:online` (recherche web) : non testé, à vérifier avant usage.

---

### -6- Usage et changement de modèle (méthode confirmée)

````
ccr "Claude Code"
````

Une fois dans la session, changer de modèle **à la volée, sans redémarrage** :

````
/model openrouter,cohere/north-mini-code:free
/model openrouter,google/gemma-4-31b-it:free
/model openrouter,nvidia/nemotron-3-ultra-550b-a55b:free
````

Format impératif : `/model <provider>,<modèle>` — nom du provider en **minuscule** exactement tel que configuré dans CCR (`openrouter`), séparé du modèle par une virgule, sans espace.

**Le menu interactif `/model` (flèches + Entrée) ne fonctionne pas** pour ce switch : il écrit dans la clé `model` de `settings.json` sous une forme encodée (`anthropic/claude-ccr-h4f70…`) qui entre en conflit avec `env.ANTHROPIC_MODEL` posé par CCR, et produit `API Error: 400 All target providers failed` alors que la bannière affiche pourtant le bon modèle.

Bannière attendue après switch : `openrouter,<modèle> · API Usage Billing`. **Ce libellé est générique**, affiché même sur un modèle `:free` — il ne prouve aucune facturation Anthropic.

Pour un usage non-interactif (orchestrateur, script), le flag `--model` **ne fonctionne pas** avec un modèle de la gateway, quelle que soit la forme essayée : Claude Code répond `unrecognized_model` et retombe silencieusement sur le modèle par défaut. Une variable d'environnement passée au shell est ignorée elle aussi, le bloc `env` du `settings.json` de CCR étant prioritaire.

La seule méthode qui pilote réellement le modèle en `-p` est la surcharge de settings en ligne :

````
claude -p "<tache>" --settings '{"env":{"ANTHROPIC_MODEL":"OpenRouter/<modele>:free"}}'
````

Noter les deux formes de nom, chacune dans son contexte :

| Contexte | Forme |
| :-- | :-- |
| commande `/model` en session | `openrouter,cohere/north-mini-code:free` |
| surcharge `--settings` en `-p` | `OpenRouter/cohere/north-mini-code:free` |

Le flag `-p` saute le prompt de confiance du dossier de travail (*workspace trust*), sinon reposé à chaque nouveau dossier en session interactive. `--permission-prompts none` fait refuser les demandes de permission au lieu de les laisser en attente quand personne n'est derrière le clavier.

**`[claude-code:unrecognized_model]` est un avertissement, pas une erreur.** Il s'affiche pour *tout* modèle de la gateway, y compris le modèle par défaut qui fonctionne. Ce n'est donc pas un indicateur fiable d'échec : le seul juge de ce qui a réellement tourné est la page *Activity* d'OpenRouter.

---

### -7- Bascule entre les deux utilisateurs

````
sudo -iu sednal-free bash -lc 'ccr "Claude Code"'
````

Appel non-interactif complet, tel que l'orchestrateur l'utilisera :

````
sudo -iu sednal-free bash -lc 'claude -p "<tache>" --settings "{\"env\":{\"ANTHROPIC_MODEL\":\"OpenRouter/cohere/north-mini-code:free\"}}"'
````

Vérification de la bascule :

````
sudo -iu sednal-free bash -lc 'echo $HOME; which claude; which ccr'
````

Attendu :

````
/home/sednal-free
/home/sednal-free/.npm-global/bin/claude
/home/sednal-free/.npm-global/bin/ccr
````

- **`sudo -iu` obligatoire, jamais `sudo -u` seul.** Sans `-i`, `HOME` reste celui de l'appelant et `~/.npm-global/bin` n'est pas dans le `PATH` : la session lirait la config **native** en croyant être sur le gratuit, et `ccr`/`claude` seraient introuvables.

- Bascule sans mot de passe pour un agent automatisé :

````
sudo visudo -f /etc/sudoers.d/agent-mapping
````

````
sednal ALL=(sednal-free) NOPASSWD: ALL
````

Pour repasser côté Pro : utiliser l'utilisateur natif (`-2-`). Pas de bascule de fichier, pas d'hybride dans une même session — chaque utilisateur garde sa config isolée dans son `$HOME`.

---

### -8- OpenRouter — palier de requêtes

- Sans achat : **50 requêtes/jour, 20/minute.**
- Un achat ponctuel unique de **10 $** débloque **1000 requêtes/jour définitivement**, palier conservé même une fois le solde revenu à zéro. Pas un abonnement, pas récurrent.
- Pour un agent qui travaille 8-10 h/jour, cet achat est un **prérequis bloquant**. À titre d'ordre de grandeur : les seuls tests de mise au point du 04/10/2026 ont consommé 38 requêtes dans la journée, sur les 50 autorisées.
- Suivi sur **openrouter.ai → Activity**. C'est aussi le seul endroit qui dit quel modèle a réellement servi une requête et à quel coût. Relevé du 04/10/2026 après mise au point complète : **$0.00 de dépense totale**, modèles `:free` confirmés gratuits.

---

### -9- Points de vigilance (retours d'expérience)

- Jamais de `sudo npm install -g` → mélange root/utilisateur et conflits de ports.
- `ccr "<profil>"` ≠ sous-commande : `<profil>` doit être le nom exact donné dans le wizard (`Claude Code`), pas `code`.
- Erreur `spawn claude ENOENT` → `@anthropic-ai/claude-code` pas installé dans cet utilisateur.
- Erreur `libnode.so.XXX` → version de Node changée après l'installation de CCR :

````
npm uninstall -g @musistudio/claude-code-router
npm cache clean --force
npm install -g @musistudio/claude-code-router
````

- Comportement incohérent → vérifier qu'aucun vieux process ne squatte le port :

````
ps aux | grep -i claude-code-router
sudo ss -tlnp | grep 3456
````

- Le token web CCR change à chaque `ccr start` — toujours relire la dernière URL avant d'ouvrir l'UI.
- Plusieurs Agent Profiles ne permettent pas de router par rôle — un seul profil, switch via `/model provider,modèle:free`.
- Certains modèles gratuits OpenRouter refusent les requêtes hors harnais agentique (403) — toujours passer par « Verify connection » avant de documenter un modèle comme utilisable.
- Un id de modèle sans `:free` est la variante **payante** : vérifier la page *Activity* d'OpenRouter après les premiers tests pour confirmer que le coût est bien à `$0`.
