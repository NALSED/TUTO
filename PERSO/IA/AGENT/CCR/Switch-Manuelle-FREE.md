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
2. **Pick models** → chercher et ajouter les modèles gratuits voulus (liste -5-). Vérifier qu'aucun modèle `anthropic/...` (payant) ne traîne dans "Added models" — le supprimer si présent.
3. **Verify connection** → cocher le(s) modèle(s), lancer "Start check". Doit afficher **Available / Connection verified**. Ne rien documenter comme fonctionnel sans ce test.
4. **Connect agent** → Agent = Claude Code, Profile name = `Claude Code`, **Default model** = le modèle gratuit vérifié (ex. `OpenRouter/nvidia/nemotron-3-ultra-550b-a55b:free`). Laisser Opus/Sonnet/Fable/Haiku sur "Keep Claude Code default".
5. **Finish**.

À la fin du wizard, CCR réécrit **globalement** `~/.claude/settings.json` de cet utilisateur (`apiKeyHelper`, `ANTHROPIC_BASE_URL=http://127.0.0.1:3456`, etc.). À partir de là, `claude` tout seul route aussi vers la gateway — c'est voulu, puisque cet utilisateur est dédié au gratuit.

---

### -5- Modèles gratuits (OpenRouter, `$0/M`)

Connexion réellement vérifiée en live :

- `nvidia/nemotron-3-ultra-550b-a55b:free` (1M contexte) — rôle `default`

Présents dans le catalogue gratuit, **pas encore testés en connexion live** — à vérifier avant usage réel :

- `cohere/north-mini-code` (256K) — candidat `background`
- `thinkingmachines/inkling` (1.05M) — candidat `longContext`
- `google/gemma-4-31b` (262K) — candidat `think`
- `nvidia/nemotron-3-super` (262K)
- `google/gemma-4-26b-a4b` (262K)
- `nvidia/nemotron-3-nano-omni` (256K)
- `thinkingmachines/inkling-small` (1.05M)

Retirés le 31/10/2026 : `poolside/laguna-s-2.1`, `poolside/laguna-xs-2.1` — ne pas les utiliser.

**`qwen/qwen3.8-27b` n'existe pas / n'est pas gratuit — ne jamais l'utiliser.**

`webSearch` (`google/gemini-2.5-flash:online` ou autre) : non vérifié, à tester avant d'être documenté comme acquis.

---

### -6- Usage

```
ccr "Claude Code"
```

Bannière attendue : `OpenRouter/<modèle>[...] · API Usage Billing`. **Ce libellé "API Usage Billing" est générique** (affiché même sur modèle `:free`) — il ne veut pas dire qu'une vraie facturation Anthropic a eu lieu.

Pour repasser côté Pro sur la même VM : se déconnecter de `sednal-free`, utiliser l'utilisateur natif (-2-). Pas de bascule de fichier, pas d'hybride dans une même session — chaque utilisateur garde sa config isolée dans son `$HOME`.

---

### -7- Points de vigilance (retours d'expérience)

- Jamais de `sudo npm install -g` → mélange root/utilisateur et conflits de ports.
- `ccr "<profil>"` ≠ sous-commande : `<profil>` doit être le nom exact donné dans le wizard ("Claude Code"), pas `code`.
- Erreur `spawn claude ENOENT` → `@anthropic-ai/claude-code` pas installé dans cet utilisateur.
- Erreur `libnode.so.XXX` → version Node changée après l'install de CCR : `npm uninstall -g @musistudio/claude-code-router && npm cache clean --force && npm install -g @musistudio/claude-code-router`.
- Toujours vérifier `ps aux | grep claude-code-router` si comportement incohérent : un vieux process d'un autre utilisateur peut squatter le port.
