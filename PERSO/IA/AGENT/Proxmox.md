# Installation de l'agent Claude Code — trouver-sites
---

Labs Proxmox :

- Debian 13

- 192.168.0.23

- RAM : 8Go

- CPU : 4 cores


---
## 1. Prérequis VM


## 2. Claude Code CLI
- Installé en binaire autonome (pas de Node/npm sur la VM — le CLI ne dépend pas de npm)
- Authentification OAuth déjà faite pour `sednal` (`~/.claude/.credentials.json`)
- Version en place : `claude --version` → `2.1.278 (Claude Code)`

## 3. Boucle de l'agent (`agent-boucle.sh`)
- Script placé en `/usr/local/bin/agent-boucle.sh` (root:root, `755`)
- Gère : plage horaire autorisée, quota hebdomadaire, relance automatique de sessions `claude -p`
- Logs dans `data/agent-logs/` (créé par le script lui-même au premier lancement)

## 4. Service systemd `agent-claude`
- Unit : `/etc/systemd/system/agent-claude.service`
- Lance `agent-boucle.sh` en tant que `sednal`, `WorkingDirectory=/opt/trouver-sites`
- Activation :

````bash
systemctl daemon-reload
systemctl enable --now agent-claude
````

## 5. Pilotage par issues GitHub (`agent-github-sync`)
- Dépôt privé de pilotage : `NALSED/agent-momo`
- Installation via `installer.sh` (à lancer en root, dans le dossier du module) :
  - demande le login GitHub et un jeton fine-grained (droits Issues lecture/écriture), vérifié par un appel API
  - crée `/etc/agent-github/` (jeton + config, `700`/`600`)
  - installe `/usr/local/bin/agent-github-sync` (script Python de synchro) et `/usr/local/bin/agent-boucle.sh`
  - crée `/opt/trouver-sites/github/{entree,sortie}`
  - crée `/var/lib/agent-github/envoyes`
  - installe les units `agent-github-sync.service` et `agent-github-sync.timer` (`/etc/systemd/system/`)
  - ajoute la section §14 à `CLAUDE.md` et `github/` au `.gitignore`, commit
  - active le timer et lance une première synchro :

````bash
systemctl daemon-reload
systemctl enable --now agent-github-sync.timer
systemctl start agent-github-sync.service
systemctl restart agent-claude
````
- Résultat attendu : une issue « État de l'agent » créée sur `NALSED/agent-momo`
