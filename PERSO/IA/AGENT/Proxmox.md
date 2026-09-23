## Installation de l'agent Claude Code sur VM
---


---
### -1- Prérequis VM

VM Debian 13 existante sur Proxmox :

- IP : 192.168.0.23/24
- Passerelle : 192.168.0.1
- DNS : 192.168.0.241
- Options => Start at boot : Yes
- Options => QEMU Guest Agent : Enabled

`- 1.1` Installation des prérequis
````
sudo  -i
apt update && apt full-upgrade -y
apt install -y qemu-guest-agent ca-certificates curl jq
systemctl enable --now qemu-guest-agent
timedatectl set-timezone Asie/Erevan
````

### -2- Installation docker

- Voir [-1- docker_install.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/DOCKERS/SCRIPTS/-1-docker_install.sh)

- Ajout user => groupe docker + verrif
````
usermod -aG docker sednal
docker --version
docker compose version
````






## Installation de l'agent Claude Code sur VM
---


---
### -1- Prérequis VM

VM Debian 13 existante sur Proxmox :

- IP : 192.168.0.23/24
- Passerelle : 192.168.0.1
- DNS : 192.168.0.241
- Options => Start at boot : Yes
- Options => QEMU Guest Agent : Enabled

`- 1.1` Installation des prérequis
````
sudo  -i
apt update && apt full-upgrade -y
apt install -y qemu-guest-agent ca-certificates curl jq git
systemctl enable --now qemu-guest-agent
timedatectl set-timezone Asia/Yerevan
````

- `jq` est requis par la boucle de l'agent (lecture du quota).
- `git` est requis : le projet est un dépôt git, l'agent commite à chaque changement.

### -2- Installation docker

- Voir [-1- docker_install.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/DOCKERS/SCRIPTS/-1-docker_install.sh)

- Ajout user => groupe docker + verrif
````
usermod -aG docker sednal
docker --version
docker compose version
````

### -3- Installation de Claude Code

`- 3.1` Installation du CLI

Claude Code s'installe en binaire autonome : **ni Node ni npm ne sont nécessaires** sur la VM.

````
su - sednal
curl -fsSL https://claude.ai/install.sh | bash
claude --version
````

Résultat attendu (version au moment de l'installation) :

````
2.1.278 (Claude Code)
````

Le binaire est déposé dans `/home/sednal/.local/bin/claude` — ce chemin devra figurer dans le `PATH` du service systemd (§5.2).

`- 3.2` Authentification

À faire **une seule fois**, en interactif, sous l'utilisateur `sednal` :

````
claude
````

Suivre la connexion OAuth proposée. Le jeton est ensuite stocké dans :

````
/home/sednal/.claude/.credentials.json
````

Ce fichier est lu par la boucle de l'agent pour interroger la consommation de quota (§5.1). Sans lui, la boucle tourne mais ne sait plus mesurer le quota.

### -4- Arborescence et dépôt du projet

`- 4.1` Création

````
install -d -o sednal -g sednal -m 755 /opt/trouver-sites
cd /opt/trouver-sites
sudo -u sednal git init -b main
sudo -u sednal git config user.name "agent-momo"
sudo -u sednal git config user.email "agent@momo.local"
````

`- 4.2` Fichiers de pilotage (propriétaire `sednal`)

| Fichier | Rôle |
|---|---|
| `CLAUDE.md` | Instructions permanentes de l'agent : mission, principes figés, feuille de route, règles de travail, fin de mission. C'est le seul document qui fait autorité pour lui. |
| `docs/JOURNAL.md` | Compte rendu que l'agent tient au fil de l'eau : c'est par là qu'on suit son travail. |
| `docs/PROPOSITIONS.md` | Ce que l'agent voudrait changer mais n'a pas le droit de décider seul. |
| `docs/MODIF.md` | Historique des modifications de fichiers. |
| `docs/TROUBLESHOOTING.md` | Pannes rencontrées et résolutions. |
| `.claude/settings.json` | Réglages Claude Code propres au projet. |
| `.gitignore` | Exclut `data/`, `sortie/`, `github/`. |

### -5- Boucle de l'agent

`- 5.1` Script `agent-boucle.sh`

````
install -o root -g root -m 755 agent-boucle.sh /usr/local/bin/agent-boucle.sh
````

Rôle : relancer `claude -p` en boucle tant que la mission n'est pas terminée, avec **trois garde-fous** :

1. **Plage horaire** — l'agent ne travaille que de **17 h 00 à 8 h 30**. La tranche 9 h – 17 h est réservée (quota gardé pour un usage personnel).
2. **Fenêtre de quota de 5 h** — l'agent n'ouvre jamais une fenêtre de session qui se terminerait après 9 h, pour garantir une session neuve à 9 h. 
3. **Quota hebdomadaire** — arrêt dès `SEUIL_HEBDO` (85 %). Au-delà, la boucle dort 30 min et re-teste.

Autres réglages, en tête de script :

| Variable | Valeur | Rôle |
|---|---|---|
| `DEBUT_MIN` | `17*60` | Début de la plage autorisée (17 h 00) |
| `FIN_MIN` | `8*60+30` | Fin de la plage autorisée (8 h 30) |
| `H_LIBRE` | `9` | Heure à laquelle la session doit être neuve |
| `DUREE_FENETRE` | `5*3600` | Durée d'une fenêtre de quota de session |
| `SEUIL_HEBDO` | `85` | % de quota hebdomadaire au-delà duquel on s'arrête |
| `ATTENTE` | `900` | Pause entre deux sessions (15 min) |
| `MARGE` | `90` | Arrêt anticipé avant un renouvellement interdit |

Fichiers produits, dans `/opt/trouver-sites/data/agent-logs/` :

| Fichier | Contenu |
|---|---|
| `agent.log` | Sortie des sessions + lignes de journal `=== session N — … ===` |
| `usage.json` | Dernière réponse du point d'accès de consommation |
| `quota_hebdo` | Dernière mesure hebdo : `pourcentage epoch_renouvellement` |

Deux prompts selon le cas : **initial** (journal quasi vide) ou **reprise** (relire `CLAUDE.md`, `JOURNAL.md`, `git log`, `git status`, puis continuer). Les instructions GitHub en attente sont ajoutées au prompt et passent en priorité (§6).

`- 5.2` Service systemd

````
cat > /etc/systemd/system/agent-claude.service <<'FIN'
[Unit]
Description=Agent Claude Code — trouver-sites
After=network-online.target docker.service
Wants=network-online.target

[Service]
Type=simple
User=sednal
Group=sednal
WorkingDirectory=/opt/trouver-sites
Environment=HOME=/home/sednal
Environment=PATH=/home/sednal/.local/bin:/usr/local/bin:/usr/bin:/bin
ExecStart=/usr/local/bin/agent-boucle.sh
Restart=on-failure
RestartSec=300

[Install]
WantedBy=multi-user.target
FIN

systemctl daemon-reload
systemctl enable --now agent-claude
systemctl is-active agent-claude
````

Résultat attendu :

````
active
````

### -6- Pilotage par issues GitHub

`- 6.1` Prérequis

- Dépôt **privé** dédié : `NALSED/agent-momo` (il ne contient aucun code, seulement les issues de pilotage).
- Jeton GitHub **fine-grained**, limité à ce dépôt, droits **Issues : lecture et écriture**.

`- 6.2` Installation

À lancer **en root**, depuis le dossier du module :

````
./installer.sh
````

Le script demande le login GitHub puis le jeton (saisie masquée), vérifie le jeton par un appel API, puis :

| Action | Détail |
|---|---|
| Secrets | `/etc/agent-github/token` et `/etc/agent-github/config` (`700` / `600`) |
| Scripts | `/usr/local/bin/agent-github-sync`, `/usr/local/bin/agent-boucle.sh` |
| Dossiers projet | `github/entree` (root, lecture seule pour l'agent), `github/sortie` (sednal) |
| État interne | `/var/lib/agent-github/envoyes` |
| Units | `agent-github-sync.service` + `agent-github-sync.timer` |
| Documentation agent | Ajoute la section §14 à `CLAUDE.md`, ajoute `github/` au `.gitignore`, commite |
| Démarrage | Active le timer, lance une première synchro, redémarre `agent-claude` |

Résultat attendu : une issue **« État de l'agent »** créée sur le dépôt (à épingler).

`- 6.3` Fonctionnement

- Synchro **toutes les 5 minutes** (`OnUnitActiveSec=5min`, `OnBootSec=2min`).
- Chaque issue ouverte écrite dans `github/entree/<numéro>.md` ; la liste de celles qui attendent une réponse dans `github/a_traiter`.
- Réponse de l'agent : `github/sortie/<numéro>-<court-titre>.md`, première ligne `statut: en_cours|fait|bloque|question`. La synchro la publie en commentaire, pose l'étiquette, ferme l'issue si `fait`.
- Étiquettes gérées : `a-faire`, `en-cours`, `question`, `bloque`, `fait`, `etat`.
- L'issue « État de l'agent » est réécrite à chaque passage : service actif, session en cours, quota, instructions en attente, dernières sessions, derniers commits, fin du journal.
- **L'agent n'a jamais accès au jeton** : la synchro tourne en root, l'agent ne voit que des fichiers.

### -7- Suivi et exploitation

`- 7.1` Commande `avancement`

````
cat > /usr/local/bin/avancement <<'FIN'
#!/usr/bin/env bash
cd /opt/trouver-sites || exit 1
echo "===== SERVICE ====="; systemctl is-active agent-claude
echo "===== QUOTA ====="; cat data/agent-logs/quota_hebdo 2>/dev/null
echo "===== SESSIONS ====="; grep "===" data/agent-logs/agent.log | tail -8
echo "===== COMMITS ====="; git -c safe.directory=/opt/trouver-sites log --oneline -10
echo "===== JOURNAL ====="; tail -30 docs/JOURNAL.md
FIN
chmod 755 /usr/local/bin/avancement
````

Lecture de `quota_hebdo` : `85 1790434800` = 85 % consommés, renouvellement à l'epoch indiqué (`date -d @1790434800`).

`- 7.2` Lancement manuel hors plage (dépannage)

La boucle refuse de démarrer pendant la tranche réservée ou au-delà du seuil de quota. Pour forcer une session ponctuelle sans modifier le script :

````
sudo systemctl stop agent-claude
cat > /home/sednal/prompt-manuel.txt <<'FIN'
Tu reprends une mission interrompue. Lis CLAUDE.md, docs/JOURNAL.md, git log --oneline -20 et git status
pour savoir où tu en étais ; termine ou annule proprement tout travail non commité, puis continue la
mission en autonomie complète. Tiens docs/JOURNAL.md à jour. Commite souvent.
FIN
chown sednal:sednal /home/sednal/prompt-manuel.txt
````

Puis, **en tant que `sednal`** :

````
cd /opt/trouver-sites && nohup timeout 5h claude -p "$(cat ~/prompt-manuel.txt)" --dangerously-skip-permissions --model opus >> data/agent-logs/manuel.log 2>&1 &
````

Points de vigilance :

- `timeout 5h` borne la session : sans lui, rien ne la limite (les garde-fous sont dans la boucle, pas dans `claude`).
- `manuel.log` reste **vide jusqu'à la fin** : `claude -p` n'écrit sa réponse qu'au terme de la session. Suivre l'avancement par les commits et `docs/JOURNAL.md`.
- Ne **jamais** relancer `agent-claude` tant que la session manuelle tourne : deux agents sur le même dépôt et la même base.
- Ne pas coller un bloc de plusieurs lignes derrière un `sudo -i` ou un `sudo -u` : le shell interactif ou l'invite de mot de passe avale les lignes suivantes. Coller la ligne `sudo` seule.
- Rendre la main à la boucle à la fin :

````
pkill -f 'claude -p'
sudo systemctl start agent-claude
````

### -8- Vérifications après installation

````
systemctl is-active agent-claude
systemctl is-active agent-github-sync.timer
sudo -u sednal claude --version
ls -l /usr/local/bin/agent-boucle.sh /usr/local/bin/agent-github-sync
ls -ld /etc/agent-github
tail -5 /opt/trouver-sites/data/agent-logs/agent.log
````

Attendu : `active` deux fois, la version du CLI, les deux scripts en `755`, `/etc/agent-github` en `700`, et au moins une ligne `=== session 1 — début … ===` dans le journal dès que la plage horaire s'ouvre.
