## Configuration de CCR.

---

`[TUTO]`

[https://www.morphllm.com/claude-code-router](https://www.morphllm.com/claude-code-router)
[https://www.datacamp.com/fr/tutorial/claude-code-router](https://www.datacamp.com/fr/tutorial/claude-code-router)

## **=== SOMMAIRE ===**

**- Cette partie traite de la configuration de CCR via son UI, le choix de AI.**

- `-1-` === UI ===
  - `1.1` `CLI` => `UI`
  - `1.2` `Provider`
  - `1.3` `Agent Profiles`

**- Cette partie traite du changement de model AI, changement de profil utilisateur, l'usage non-interactif.**

- `-2-` === CLI ===
   - `2.1` Fichier `Pro` / `Free`
   - `2.2` Changement de `model`
   - `2.3` `Usage non-interactif`
   - `2.4` Changement de profil

- `-3-` Point de vigilance


---

<details>
<summary>
<h2>
=== UI ===
</h2>
</summary>

### `-1-` `CLI` => `UI`

`- 1.1` Demande `URL` 
````
ccr ui
````

- Cette commande donne en sortie une url avec le toekn de connection
````
CCR service started at http://127.0.0.1:3458/?ccr_web_token=znwn7lntCe8Awbfc7wM9W1t41nGPgP48EwTNEO8627Q (pid 3086).
Opened CCR management UI at http://127.0.0.1:3458/?ccr_web_token=znwn7lntCe8Awbfc7wM9W1t41nGPgP48EwTNEO8627Q
````

- Mais la VM est une `debian CLI` donc utilisatio de `tunnel SSH` 

[NOTE]

- PC admin 192.168.0.235
- Proxmox 192.168.0.242
- VM AI 192.168.0.250

- Le tunnel SSh ira de `192.168.0.250` => `192.168.0.235`


`- 1.2` Création tunel `SSH` (terminal sur .235)
````
ssh -L 3458:127.0.0.1:3458 sednal-free@192.168.0.250
````

**=== Explication ===**
- `-L` port forwarding
- Syntaxe : `<port_local>:<hôte_cible>:<port_cible>`

- A present l'UI est disponible sur `192.168.0.235` via l'url
````
http://127.0.0.1:3458/?ccr_web_token=znwn7lntCe8Awbfc7wM9W1t41nGPgP48EwTNEO8627Q
````

<img width="1728" height="575" alt="image" src="https://github.com/user-attachments/assets/3922e336-40d9-475f-aae0-117ba6cb8fc5" />

---

## `-2-` Provider

### `- 2.1` Ajouter un `provider`

- Providers => + Add

<img width="1714" height="201" alt="image" src="https://github.com/user-attachments/assets/5c07a53c-2378-4ae2-85f0-3c8ad98a223a" />

### `- 2.2`  Déclarer un `provider`

- Choisir `OpenRouter` + Name + Next

<img width="569" height="217" alt="image" src="https://github.com/user-attachments/assets/e0beaaf7-67ed-4052-83a9-f9c4ace4d734" />

### `- 2.3` Fournir la clé `API`

<img width="573" height="214" alt="image" src="https://github.com/user-attachments/assets/372a325b-6001-4fd5-b8c9-fc9d1f84ec7b" />

### `- 2.4` Choix des models `AI`

- Retirer `anthropic/claude-sonnet-5.5`

- Ajouter les model choisi sur `OpenRouter`, Ici:
````
MODEL                                   CONTEXT  USAGE
nvidia/nemotron-3-ultra-550b-a55b:free  1 M      général, gros contexte
cohere/north-mini-code:free             256 K    doc, logs, commits, scan de dossier
google/gemma-4-31b-it:free              256 K    réflexion, plan gratuit
````

<img width="995" height="365" alt="image" src="https://github.com/user-attachments/assets/a649bd47-1c09-49fd-bfc4-c500a8da23d4" />


### `- 2.5` Tester la connection

- `CCR` test la disponibilité des `AI` chez `OpenRouter`

- Check Connection + Start check

<img width="520" height="407" alt="image" src="https://github.com/user-attachments/assets/7f103324-0490-4538-9501-6b84c6c86129" />


- Résultat attendu => Tous les model en `Available`

<img width="505" height="675" alt="image" src="https://github.com/user-attachments/assets/8ed3529a-9fad-4dbd-8214-c337dac60c04" />


- **Done**

<img width="1722" height="231" alt="image" src="https://github.com/user-attachments/assets/4d8f526c-1040-499e-b34e-764effa53164" />

---


### `-3-` Agent Profiles

`- 3.1` Se rendre dans la section `Agent Profiles`

<img width="271" height="549" alt="image" src="https://github.com/user-attachments/assets/91f921b6-2e74-4468-98fa-ce5bfe8d2130" />

`- 3.2` `+ Add profile`

- remplir les case `Required` => `+ Add`

- **Résultat attendu** un profil agent par `AI` OpenRouter utilisé par CCR.

<img width="1735" height="557" alt="image" src="https://github.com/user-attachments/assets/12b53942-bd0e-45f9-8053-a57598ed50c2" />

</details>

---

<details>
<summary>
<h2>
=== CLI === 
</h2>
</summary>


`[RAPPEL]`

**Fichier Conf AI**

- Un fichier de configuration par utilisateur sur la VM `192.168.0.250` : `sednal` / `sednal-free`

````
cat /home/sednal/.claude/settings.json
````
````
{
  "model": "sonnet",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "rtk hook claude"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [ ....................................... Ce hook est rajouté pour forcer claude pro à continuer. Voir -7- Scripts.md
          {
            "type": "command",
            "command": "/opt/grappes/outils/continuer.sh"
          }
        ]
      }
    ]
  },
  "modelSettings": {
    "claude-opus-5": {
      "effortLevel": "high"
    },
    "claude-opus-5-5": {
      "effortLevel": "xhigh"
    },
    "claude-sonnet-5": {
      "effortLevel": "medium"
    }
  },
  "skipDangerousModePermissionPrompt": true,
  "theme": "dark",
  "agentPushNotifEnabled": true
}
````


````
cat /home/sednal-free/.claude/settings.json
````
````
{
  "apiKeyHelper": "/home/sednal-free/.claude-code-router/bin/ccr-claude-code-api-key-default-claude-code",
  "env": {
    "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY": "1",
    "ANTHROPIC_BASE_URL": "http://127.0.0.1:3456",
    "ANTHROPIC_API_BASE_URL": "http://127.0.0.1:3456",
    "CLAUDE_AGENT_API_BASE_URL": "http://127.0.0.1:3456",
    "NO_PROXY": "127.0.0.1,localhost,::1",
    "no_proxy": "127.0.0.1,localhost,::1",
    "CLAUDE_CODE_DISABLE_UNKNOWN_MODEL_WINDOW_ENFORCEMENT": "1",
    "ANTHROPIC_MODEL": "OpenRouter/nvidia/nemotron-3-ultra-550b-a55b:free[1m]",
    "CCR_CLAUDE_CODE_MODEL": "OpenRouter/nvidia/nemotron-3-ultra-550b-a55b:free[1m]",
    "CODEXL_CLAUDE_CODE_MODEL": "OpenRouter/nvidia/nemotron-3-ultra-550b-a55b:free[1m]"
  },
  "model": "openrouter,google/gemma-4-31b-it",
  "theme": "dark"
}
````
























</details>



