# Claude Desktop + MCP GitHub sur Ubuntu 24.04

## Prérequis

### 1. Installer Docker

```
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker
```

Vérification :
```
docker --version
```

---

## Installer Claude Desktop

Télécharger le `.deb` depuis https://claude.ai/download

```bash
# Depuis le dossier où se trouve le .deb
sudo dpkg -i claude-desktop_*.deb
sudo apt --fix-broken install -y
```

Lancer Claude Desktop une première fois pour initialiser la config :
```
claude-desktop &
```
Puis le fermer

---

## Créer un token GitHub

1. https://github.com/settings/tokens
2. **Tokens (classic)** → **Generate new token (classic)**
3. Nom : `claude-mcp`
4. Scopes à cocher :
   - `repo` (accès complet aux dépôts)
   - `read:org`
   - `read:user`
5. **Generate token** → copier le token `ghp_XXXXX` (affiché une seule fois)

---

## Configurer le MCP GitHub

### Option A — Docker géré par Claude Desktop (recommandé)

Claude Desktop lance lui-même le conteneur à chaque session.

Crée le fichier de config :
```bash
mkdir -p ~/.config/Claude
nano ~/.config/Claude/claude_desktop_config.json
```

Contenu :
```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "GITHUB_PERSONAL_ACCESS_TOKEN=ghp_XXXXX",
        "ghcr.io/github/github-mcp-server"
      ]
    }
  }
}
```

> Remplace `ghp_XXXXX` par ton vrai token.

### Option B — Conteneur Docker persistant

```bash
docker run -d \
  --name mcp-github \
  --restart unless-stopped \
  -e GITHUB_PERSONAL_ACCESS_TOKEN=ghp_XXXXX \
  ghcr.io/github/github-mcp-server
```

Config `claude_desktop_config.json` pour l'option B :
```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": [
        "exec", "-i", "mcp-github",
        "node", "/app/dist/index.js"
      ]
    }
  }
}
```

---

## Lancer et vérifier

```
# Relancer Claude Desktop
claude-desktop &
```

Dans un nouveau chat, l'icône 🔌 (ou un indicateur MCP) doit apparaître en bas de la fenêtre.


---

## Sécurité

```bash
# Restreindre les permissions du fichier de config (token dedans)
chmod 600 ~/.config/Claude/claude_desktop_config.json
```

Ne commit **jamais** ce fichier sur GitHub.

---

## Arborescence finale

```
~/.config/Claude/
└── claude_desktop_config.json   ← token GitHub ici
```

---

## Dépannage

| Problème | Solution |
|----------|----------|
| MCP non détecté | Vérifier que Docker tourne : `docker ps` |
| Permission denied Docker | `sudo usermod -aG docker $USER` puis relancer la session |
| Token invalide | Vérifier les scopes sur https://github.com/settings/tokens |
| Image introuvable | `docker pull ghcr.io/github/github-mcp-server` manuellement |
