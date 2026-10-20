## Script Utiliser pour monitorer `CCR`


---

**=== Explication Script ===**

- `appeler_gratuit.sh` => Journalise chaque appel au compte gratuit (avant **et** après : note aussi le code de sortie)
- `comparer_tokens.sh` => Compare les jetons `Pro` / `Gratuit` du jour (appelle `economies.py`)
- `economies.py` => Détail en deux lignes `ccr` / `rtk`, pour un jour ou tout l'historique ; peut tenir un historique CSV
- `continuer.sh` => Lu via un [hook](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/-5-%20Config_Claude-Code-Router.md#21-fichier-pro--free) de `Claude Pro` pour le forcer à continuer tant qu'une phase est en cours
- `verif_ccr.sh` => Vérifie que : CCR, bascule gratuite, RTK, journal, ccusage, script de mesure, est Ok avant de démarrer l'agent Claude Code

**=== Mise à jour du 20/10/2026 ===**

- La mesure du côté gratuit dépendait d'une clé `OPENROUTER_MANAGEMENT_KEY` (API `/activity` d'OpenRouter) **jamais définie dans l'environnement** : `comparer_tokens.sh` écrivait donc toujours `0` jeton gratuit, silencieusement (le script continuait, `set -euo pipefail` ne l'arrêtait pas puisque la variable avait une valeur par défaut dans `verif_ccr.sh`). La donnée existe pourtant en local : CCR tient sa propre base d'usage, `~/.claude-code-router/app-data/usage.sqlite`, sur le compte `sednal-free`. Les deux scripts la lisent maintenant directement, en lecture seule, sans clé ni appel réseau.
- `rtk gain` (compte Pro) surestimait aussi fortement l'économie réelle : quelques `ls`/`find` sur un dossier de plusieurs milliers de fichiers comptaient à eux seuls pour l'essentiel du total affiché, alors que Claude Code aurait de toute façon tronqué ces sorties. `economies.py` corrige ce chiffre (il plafonne chaque commande à ce qui serait réellement entré dans le contexte) plutôt que de reprendre `rtk gain` tel quel.
- `continuer.sh` relançait l'agent jusqu'à deux fois à **chaque** arrêt, sur **toute** session de la machine (le réglage est global), même sans rien à faire — alors que chaque relance fait relire tout le contexte de la session. Il ne relance plus que si une phase est explicitement en cours.

---

`appeler_gratuit.sh`
````
#!/bin/bash
# Journalise chaque appel au compte gratuit (sednal-free / CCR) puis l'exécute, et note son issue.
# Usage : outils/appeler_gratuit.sh "<description courte>" -- <commande complète>
# Le gateway CCR doit tourner (port 3456) : sudo -iu sednal-free bash -lc 'ccr start --daemon --no-open'
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DESCRIPTION="$1"
shift
shift  # retire le séparateur --
mkdir -p "$ROOT/donnees"
echo "$(date -Iseconds) | $DESCRIPTION" >> "$ROOT/donnees/.journal_ccr.log"
"$@"
rc=$?
echo "$(date -Iseconds) |   -> code de sortie $rc" >> "$ROOT/donnees/.journal_ccr.log"
exit $rc
````

`comparer_tokens.sh`
- ⚠️ Ne demande plus de clé OpenRouter : lit `usage.sqlite` directement sur `sednal-free` (via `sudo -n -iu`). ⚠️
````
#!/bin/bash
# Compare les jetons Pro (local, sednal) et Gratuit (ccr, sednal-free) pour une date. Lecture seule, aucune clé.
# Le côté gratuit est MESURÉ dans la base d'usage de ccr (outils/economies.py) : l'ancienne version interrogeait
# OpenRouter avec OPENROUTER_MANAGEMENT_KEY, absente, et écrivait donc toujours 0 (corrigé le 2026-10-20).
# Usage : comparer_tokens.sh [AAAA-MM-JJ]
set -euo pipefail

DATE="${1:-$(date +%F)}"
ICI="$(cd "$(dirname "$0")" && pwd)"

# --- Côté Pro (sednal, transcriptions locales de Claude Code) ---
PRO_TOKENS=$(npx -y ccusage@latest daily --json --since "${DATE//-/}" --until "${DATE//-/}" 2>/dev/null \
  | jq '[.daily[]? | (.inputTokens + .outputTokens + .cacheCreationTokens + .cacheReadTokens)] | add // 0')

# --- Côté gratuit (ccr, base d'usage locale) ---
FREE_TOKENS=$(sudo -n -iu sednal-free python3 - "$DATE" <<'PY'
import os, sqlite3, sys
f = os.path.expanduser("~/.claude-code-router/app-data/usage.sqlite")
c = sqlite3.connect(f"file:{f}?mode=ro", uri=True)
print(c.execute("select coalesce(sum(total_tokens),0) from usage_events where substr(created_at,1,10) = ?", [sys.argv[1]]).fetchone()[0])
PY
)

TOTAL=$((PRO_TOKENS + FREE_TOKENS))
PCT_FREE="0.0"
[ "$TOTAL" -gt 0 ] && PCT_FREE=$(awk "BEGIN{printf \"%.2f\", ($FREE_TOKENS/$TOTAL)*100}")

echo "=== Répartition des jetons — $DATE ==="
echo "Pro (sednal, cache compris) : $PRO_TOKENS"
echo "Gratuit (sednal-free/ccr)   : $FREE_TOKENS"
echo "Part gratuite               : ${PCT_FREE} %"
"$ICI/economies.py" --jour "$DATE"
````

- Nécessite `sudo -n -iu sednal-free` sans mot de passe depuis `sednal` (déjà requis par `-7-` pour la bascule) et l'accès en lecture au fichier `usage.sqlite` de CCR (droits par défaut : seul le propriétaire `sednal-free`, d'où le `sudo`).

`economies.py`
- Sort toujours **deux lignes**, `ccr` puis `rtk`, pour un jour (`--jour AAAA-MM-JJ`) ou tout l'historique (sans argument). `--csv` ajoute la ligne du jour à `donnees/.economies_jetons.csv`.
````
#!/usr/bin/env python3
"""Économie de jetons en deux lignes : ccr (compte gratuit) et rtk. Lecture seule, aucune clé, aucun appel réseau.

* ccr : MESURÉ, lu dans la base d'usage du routeur du compte `sednal-free` (~sednal-free/.claude-code-router/app-data/usage.sqlite),
  via `sudo -n -iu sednal-free` (le code est passé sur l'entrée standard : aucun fichier temporaire à partager).
* rtk : ESTIMÉ par rtk (octets / 4), lu commande par commande dans ~/.local/share/rtk/history.db, puis CORRIGÉ : l'entrée de chaque
  commande est plafonnée à ce que Claude Code aurait réellement montré (au-delà d'environ 30 000 caractères la sortie est rangée dans un
  fichier). Sans ce plafond, quelques `ls` sur un dossier de milliers de fichiers comptaient pour 71 % du total « économisé ».

Usage : outils/economies.py [--jour AAAA-MM-JJ] [--csv]   (sans --jour : tout l'historique ; --csv ajoute une ligne à donnees/.economies_jetons.csv)
"""

from __future__ import annotations

import argparse
import json
import os
import sqlite3
import subprocess
from datetime import datetime
from pathlib import Path

PLAFOND_VISIBLE = 7_500  # jetons : ~30 000 caractères, ce que Claude Code laisse entrer dans le contexte avant de ranger la sortie dans un fichier
CSV = Path(__file__).resolve().parent.parent / "donnees" / ".economies_jetons.csv"

CODE_CCR = r"""
import json, os, sqlite3, sys
jour = sys.argv[1] if len(sys.argv) > 1 else ""
f = os.path.expanduser("~/.claude-code-router/app-data/usage.sqlite")
c = sqlite3.connect(f"file:{f}?mode=ro", uri=True)
where, args = ("where substr(created_at,1,10) = ?", [jour]) if jour else ("", [])
r = c.execute(f"select count(*), coalesce(sum(status_code = 200),0), coalesce(sum(input_tokens),0), coalesce(sum(output_tokens),0), "
              f"coalesce(sum(cache_read_tokens),0), coalesce(sum(total_tokens),0) from usage_events {where}", args).fetchone()
print(json.dumps(dict(zip(["requetes", "reussies", "entree", "sortie", "cache", "total"], r))))
"""


def ccr(jour: str) -> dict | None:
    try:
        p = subprocess.run(["sudo", "-n", "-iu", "sednal-free", "python3", "-", jour], input=CODE_CCR, capture_output=True, text=True, timeout=30, check=False)
        return json.loads(p.stdout) if p.returncode == 0 else None
    except (OSError, ValueError, subprocess.TimeoutExpired):
        return None


def rtk(jour: str) -> dict | None:
    f = Path(os.path.expanduser("~/.local/share/rtk/history.db"))
    if not f.exists():
        return None
    c = sqlite3.connect(f"file:{f}?mode=ro", uri=True)
    where, args = ("where substr(timestamp,1,10) = ?", [jour]) if jour else ("", [])
    lignes = c.execute(f"select input_tokens, output_tokens, saved_tokens from commands {where}", args).fetchall()
    corrige = sum(max(0, min(i, PLAFOND_VISIBLE) - o) for i, o, _ in lignes)
    vu = sum(min(i, PLAFOND_VISIBLE) for i, _, _ in lignes)
    return {"commandes": len(lignes), "affiche": sum(s for _, _, s in lignes), "corrige": corrige, "vu": vu}


def k(n: float) -> str:
    return f"{n / 1e6:.2f} M".replace(".", ",") if n >= 1e6 else f"{n / 1e3:.1f} K".replace(".", ",") if n >= 1e3 else str(int(n))


def main() -> None:
    a = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    a.add_argument("--jour", default="", help="AAAA-MM-JJ (défaut : tout l'historique)")
    a.add_argument("--csv", action="store_true", help="ajoute la ligne du jour à donnees/.economies_jetons.csv")
    o = a.parse_args()
    periode = o.jour or "tout"
    c, r = ccr(o.jour), rtk(o.jour)
    if c is None:
        print(f"ccr ({periode}) : non disponible (base d'usage illisible ou sudo refusé)")
    elif not c["requetes"]:
        print(f"ccr ({periode}) : 0 appel au compte gratuit, 0 jeton déporté")
    else:
        echecs = c["requetes"] - c["reussies"]
        print(f"ccr ({periode}) : {c['requetes']} requêtes au compte gratuit ({echecs} en échec, {100 * echecs / c['requetes']:.0f} %), "
              f"{k(c['total'])} jetons déportés dont {k(c['sortie'])} de sortie utile — mesuré")
    if r is None:
        print(f"rtk ({periode}) : non disponible (historique absent)")
    else:
        pct = 100 * r["corrige"] / r["vu"] if r["vu"] else 0
        print(f"rtk ({periode}) : {k(r['corrige'])} jetons évités sur {r['commandes']} commandes ({pct:.0f} % de ce qui serait entré dans le contexte) — "
              f"estimé, corrigé ; rtk affiche {k(r['affiche'])}")
    if o.csv:
        jour = o.jour or datetime.now().astimezone().date().isoformat()
        nouveau = not CSV.exists()
        with CSV.open("a", encoding="utf-8") as f:
            if nouveau:
                f.write("date,ccr_requetes,ccr_echecs,ccr_jetons,ccr_sortie,rtk_commandes,rtk_evites_corriges,rtk_affiches\n")
            f.write(f"{jour},{(c or {}).get('requetes', '')},{(c['requetes'] - c['reussies']) if c else ''},{(c or {}).get('total', '')},"
                    f"{(c or {}).get('sortie', '')},{(r or {}).get('commandes', '')},{(r or {}).get('corrige', '')},{(r or {}).get('affiche', '')}\n")


if __name__ == "__main__":
    main()
````

`continuer.sh`
- Version du 20/10/2026 : ne relance plus que si une phase de travail est explicitement en cours (ligne `Phase en cours : <nom>` en tête d'`ETAT.md`, `aucune` sinon), seulement dans une session ouverte dans `grappes` ou `pilote`, et jamais une deuxième fois sur le même arrêt (`stop_hook_active`). Avant cette version, le hook relançait l'agent jusqu'à deux fois à **chaque** arrêt, **sur toute session de la machine**, même sans rien à faire.
````
#!/bin/bash
# Hook Stop (réglage global de Claude Code) : relance l'agent (exit 2) tant qu'une phase de grappes est en cours ; chemins relatifs au projet.
# Chaque relance fait relire TOUT le contexte de la session : on ne relance que lorsque c'est utile (2026-10-20).
#  1. une seule relance par arrêt : si l'agent continue déjà à cause de ce hook (stop_hook_active), on le laisse s'arrêter ;
#  2. seulement pour une session ouverte dans grappes ou pilote (le réglage est global : les autres projets ne sont pas concernés) ;
#  3. rien à relancer si ETAT.md dit « Phase en cours : aucune » (ligne tenue à jour en tête du fichier) ;
#  4. anti-boucle d'origine : au plus deux relances sans nouveau commit.
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENTREE="$(cat 2>/dev/null || true)"
if command -v jq >/dev/null 2>&1 && [ -n "$ENTREE" ]; then
  [ "$(printf '%s' "$ENTREE" | jq -r '.stop_hook_active // false' 2>/dev/null)" = "true" ] && exit 0
  CWD="$(printf '%s' "$ENTREE" | jq -r '.cwd // empty' 2>/dev/null)"
  case "$CWD" in "" | /opt/grappes* | /opt/pilote*) ;; *) exit 0 ;; esac
fi
cd "$ROOT" || exit 0
grep -q '^Phase en cours : aucune' "$ROOT/ETAT.md" 2>/dev/null && exit 0
mkdir -p "$ROOT/donnees"
ETAT_FILE="$ROOT/donnees/.stop_hook_state"
HEAD=$(git rev-parse HEAD 2>/dev/null || echo "none")
if [ -f "$ETAT_FILE" ]; then read -r LAST_HEAD COUNT < "$ETAT_FILE"; else LAST_HEAD=""; COUNT=0; fi
if [ "$HEAD" = "$LAST_HEAD" ]; then COUNT=$((COUNT+1)); else COUNT=0; fi
echo "$HEAD $COUNT" > "$ETAT_FILE"
[ "$COUNT" -ge 2 ] && exit 0
echo "Relis ETAT.md et ne traite que la phase en cours. Si un point est reellement bloquant (bug, decision irreversible), decris-le clairement et arrete-toi sur ce point precis." >&2
exit 2
````

- Hook `Stop` déclaré dans `~/.claude/settings.json` de `sednal` (réglage global : s'applique à toutes les sessions de ce compte, quel que soit le dossier ouvert — d'où le filtre sur `cwd`). Son entrée standard est le JSON envoyé par Claude Code à l'arrêt (`stop_hook_active`, `cwd`, …) ; `jq` doit être installé pour lire ces champs, sinon le hook se comporte comme l'ancienne version (relance toujours, par sécurité).

`verif_ccr.sh`

- Option Créer un `Alias`
````
vim /home/sednal/.bashrc
````
````
alias test='/home/sednal/Scripts/verif_ccr.sh'
source .bashrc
````

- ⚠️ **À faire sur le déploiement réel** : la copie sur `/home/sednal/Scripts/verif_ccr.sh` contient encore une clé OpenRouter en dur dans la variable `KEY=` (héritée de l'ancienne méthode de mesure). Cette clé n'est plus nécessaire depuis que `comparer_tokens.sh` lit `usage.sqlite` en local : la retirer du script et la régénérer sur OpenRouter (une clé qui a circulé en clair dans un fichier ne doit plus être considérée sûre). La version ci-dessous ne contient plus ce test ni cette variable.

````
#!/bin/bash
# Vérifie tous les points : CCR, bascule gratuite, RTK, journal, ccusage, script de mesure, est Ok avant de démarrer l'agent Claude Code.
# Usage : ./verif_ccr.sh  (aucune clé requise depuis le 20/10/2026 : la mesure du gratuit lit usage.sqlite en local)

set -uo pipefail
HIER=$(date -d "yesterday" +%F)

ok()  { echo "[OK]   $1"; }
fail(){ echo "[FAIL] $1"; }

# 1. Port CCR
if sudo ss -tlnp | grep -q 3456; then ok "Gateway CCR actif (port 3456)"; else fail "Gateway CCR injoignable"; fi

# 2. Service systemd
if systemctl is-active --quiet ccr-sednal-free.service; then ok "Service systemd actif"; else fail "Service systemd inactif"; fi

# 3. Bascule réelle
REP=$(sudo -iu sednal-free bash -lc 'claude -p "dis juste OK" --settings "{\"env\":{\"ANTHROPIC_MODEL\":\"OpenRouter/cohere/north-mini-code:free\"}}"' 2>/dev/null)
if [ -n "$(echo "$REP" | grep -v 'unrecognized_model' | tr -d '[:space:]')" ]; then
  ok "Bascule vers sednal-free fonctionnelle"
else
  fail "Bascule vers sednal-free : aucune réponse"
fi

# 4. RTK côté Pro
if sudo -iu sednal bash -lc 'which rtk' >/dev/null 2>&1; then ok "RTK installé (compte Pro)"; else fail "RTK absent"; fi

# 5. Hook PreToolUse
if sudo grep -q "rtk hook claude" /home/sednal/.claude/settings.json 2>/dev/null; then ok "Hook rtk présent"; else fail "Hook rtk absent"; fi

# 6. Journal
if sudo test -f /opt/grappes/donnees/.journal_ccr.log; then ok "Journal .journal_ccr.log présent"; else fail "Journal absent"; fi

# 7. ccusage
if timeout 30 npx ccusage@latest daily --json --since "$HIER" --until "$HIER" >/dev/null 2>&1; then ok "ccusage fonctionne"; else fail "ccusage en erreur"; fi

# 8. Base d'usage locale de CCR (lue par comparer_tokens.sh / economies.py, sans clé)
if sudo -n -iu sednal-free test -f ~/.claude-code-router/app-data/usage.sqlite 2>/dev/null; then
  ok "Base d'usage CCR lisible (sudo -n -iu sednal-free)"
else
  fail "Base d'usage CCR illisible : vérifier /etc/sudoers.d/agent-mapping (sednal ALL=(sednal-free) NOPASSWD: ALL)"
fi

# 9. Script de mesure exécutable et sans erreur
if [ -x /opt/grappes/outils/comparer_tokens.sh ]; then
  if /opt/grappes/outils/comparer_tokens.sh "$HIER" >/dev/null 2>&1; then
    ok "comparer_tokens.sh exécuté sans erreur"
  else
    fail "comparer_tokens.sh : échec"
  fi
else
  fail "comparer_tokens.sh non exécutable"
fi

echo "=== Terminé ==="
````
