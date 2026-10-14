## Configuration de CCR.

---

`[TUTO]`

[https://www.morphllm.com/claude-code-router](https://www.morphllm.com/claude-code-router)
[https://www.datacamp.com/fr/tutorial/claude-code-router](https://www.datacamp.com/fr/tutorial/claude-code-router)

### **=== SOMMAIRE ===**

### `-1-` UI
### `-2-` Provider
### `-3-` Agent Profiles

---

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

### `-2-` Provider

`- 2.1` Ajouter un `provider`

- Providers => + Add

<img width="1714" height="201" alt="image" src="https://github.com/user-attachments/assets/5c07a53c-2378-4ae2-85f0-3c8ad98a223a" />

`- 2.2`  Déclarer un `provider`

- Choisir `OpenRouter` + Name

<img width="569" height="217" alt="image" src="https://github.com/user-attachments/assets/e0beaaf7-67ed-4052-83a9-f9c4ace4d734" />



---


### `-3-` Agent Profiles
















