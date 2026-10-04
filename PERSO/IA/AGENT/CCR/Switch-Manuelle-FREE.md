## Installation et Configuration de `Claude Code Router`

---

- Projet [https://github.com/musistudio/claude-code-router](https://github.com/musistudio/claude-code-router)
- API sur [https://openrouter.ai/](https://openrouter.ai/)
- Implémentation sur une VM Proxmox, avec l'API `openrouter`

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

- Objectif : adapter le modèle utilisé en fonction du besoin (gratuit vs abonnement Pro).
- Version testée : CCR `3.1.1`. **Plus de config.json manuel fonctionnel** — toute la configuration passe par l'interface web (`ccr ui`).
- CCR **ne peut pas consommer l'abonnement Claude Pro**, quel que soit le réglage (confirmé par l'issue musistudio/claude-code-router#482 et par test VM). Tout modèle routé par CCR est facturé en API classique (payant, ou gratuit si modèle `:free`).
- Architecture retenue : **une seule VM, deux utilisateurs Linux**, pour cloisonner sans bascule de fichier manuelle.

---

### -1- Prérequis (les deux utilisateurs)

```
node -v
```

Doit afficher `v22` ou plus. Sinon :

```
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
```

---

### -2- Utilisateur natif Pro (`sednal`)

Rien à installer côté CCR. Juste s'assurer d'être connecté :

```
claude
/login
```

Vérifier la bannière : `Sonnet 5.5 · Claude Pro`

---

### -3- Utilisateur CCR / gratuit (`sednal-free`)

```
sudo adduser sednal-free
sudo su - sednal-free
```

```
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

```
npm install -g @musistudio/claude-code-router
npm install -g @anthropic-ai/claude-code
```

```
ccr ui
```

Donne une URL `http://127.0.0.1:<port>/?ccr_web_token=...` (port variable : 3456/3458/3459 selon les redémarrages — toujours relire la sortie de la commande).

Accès distant si besoin :

```
ssh -L <port_local>:127.0.0.1:<port_distant> sednal-free@192.168.0.23
```

---

### -4- Configuration du provider (dans l'UI)

1. **Choose provider** → preset **OpenRouter** → coller la clé API OpenRouter (régénérée, jamais celle d'un screenshot/chat).
2. **Pick models** → ajouter les modèles de la liste -5-. Vérifier qu'aucun modèle `anthropic/...` (payant) ne traîne dans "Added models".
3. **Verify connection** → cocher tous les modèles → "Start check". Chaque modèle doit afficher **Available**. Ne rien documenter comme fonctionnel sans ce test — le token web expire à chaque `ccr start`, donc recharger l'URL avec le dernier token avant de tester, sinon erreur "CCR web authentication token is missing or invalid".
4. **Connect agent** → Agent = Claude Code, Profile name = `Claude Code`, **Default model** = n'importe lequel des modèles vérifiés (peu importe lequel, voir -6-). Laisser Opus/Sonnet/Fable/Haiku sur "Keep Claude Code default".
5. **Finish**.

CCR réécrit **globalement** `~/.claude/settings.json` de cet utilisateur (`apiKeyHelper`, `ANTHROPIC_BASE_URL=http://127.0.0.1:3456`). `claude` seul route aussi vers la gateway — voulu, cet utilisateur est dédié au gratuit.

**Ne pas créer plusieurs "Agent Profiles" pour simuler plusieurs rôles** — testé et non fonctionnel : un seul profil ("System default") contrôle réellement `settings.json`, peu importe le nom du profil invoqué avec `ccr "<profil>"`. Un seul profil suffit, le choix du modèle se fait autrement (-6-).

---

### -5- Modèles gratuits (OpenRouter, `$0/M`) — vérifiés en connexion live sur momo le 04/10/2026

- `nvidia/nemotron-3-ultra-550b-a55b:free` (1M contexte)
- `cohere/north-mini-code:free` (256K)
- `google/gemma-4-31b-it:free` (262K) — noter le suffixe `-it`, absent du nom "officiel" affiché ailleurs

Candidats non retenus :

- `thinkingmachines/inkling` et `inkling-small` : **HTTP 403 "only available on agentic harnesses"** — OpenRouter bloque ces modèles hors d'un vrai harnais agentique, y compris le test "Verify connection" de CCR. Ne pas utiliser.
- `poolside/laguna-s-2.1` / `laguna-xs-2.1` : retirés le 31/10/2026.
- `qwen/qwen3.8-27b` : n'existe pas / n'est pas gratuit.
- `google/gemini-2.5-flash:online` (webSearch) : non testé, à vérifier avant usage.

Pas besoin de modèle dédié pour `longContext` : `nemotron-3-ultra` a déjà 1M de contexte, il couvre ce rôle aussi.

---

### -6- Usage et switch de modèle (méthode confirmée)

```
ccr "Claude Code"
```

Une fois dans la session, changer de modèle **à la volée, sans redémarrage**, avec :

```
/model openrouter,cohere/north-mini-code
/model openrouter,google/gemma-4-31b-it
/model openrouter,nvidia/nemotron-3-ultra-550b-a55b
```

Format impératif : `/model <provider>,<modèle>` — nom du provider en minuscule exactement tel que configuré dans CCR (`openrouter`), séparé du modèle par une virgule, sans espace. **Le menu interactif `/model` (flèches + Enter/s) ne fonctionne pas pour ce switch** — il écrit dans une clé différente (`model`) qui entre en conflit avec le routage CCR (`env.ANTHROPIC_MODEL`) et produit `API Error 400`.

Bannière attendue après switch : `openrouter,<modèle> · API Usage Billing`. Ce libellé est générique, pas une preuve de facturation Anthropic réelle.

Pour un usage non-interactif (orchestrateur/script) :

```
claude -p "<tâche>" --model openrouter,<modèle>
```

Le flag `-p` saute aussi le prompt de confiance du dossier de travail (workspace trust), sinon redemandé à chaque nouveau dossier en session interactive.

Pour repasser côté Pro sur la même VM : utiliser l'utilisateur natif (-2-), pas de bascule de fichier, pas d'hybride dans une même session.

---

### -7- Points de vigilance (retours d'expérience)

- Jamais de `sudo npm install -g` → mélange root/utilisateur et conflits de ports.
- `ccr "<profil>"` ≠ sous-commande : `<profil>` doit être le nom exact donné dans le wizard ("Claude Code"), pas `code`.
- Erreur `spawn claude ENOENT` → `@anthropic-ai/claude-code` pas installé dans cet utilisateur.
- Erreur `libnode.so.XXX` → version Node changée après l'install de CCR : `npm uninstall -g @musistudio/claude-code-router && npm cache clean --force && npm install -g @musistudio/claude-code-router`.
- Toujours vérifier `ps aux | grep claude-code-router` si comportement incohérent : un vieux process d'un autre utilisateur peut squatter le port.
- **Plusieurs "Agent Profiles" ne permettent pas de router par rôle** — un seul profil, switch via `/model provider,model` en session (-6-).
- Le token web CCR (`ccr_web_token`) change à chaque `ccr start` — toujours relire la dernière URL avant d'ouvrir l'UI, sinon "token missing or invalid".
- Certains modèles gratuits OpenRouter refusent les requêtes hors harnais agentique (403) — toujours tester avec "Verify connection" avant de documenter un modèle comme utilisable.
