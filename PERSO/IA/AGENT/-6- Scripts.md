## Script Utiliser pour monitorer `CCR`


---

**=== Explication Script ===**

- `log-ai.sh` => Journalsation des appels
- `comparer_tokens.sh` => Compare les token `Pro` / `Free` pour calculer les économies
- `continuer.sh` => Lu via un [hook](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/-5-%20Config_Claude-Code-Router.md#21-fichier-pro--free) de `Claude Pro` pour le forcer à continuer à la fin d'un tache.

---

log-ai.sh
````
#!/bin/bash
# Journalise chaque appel au compte gratuit (sednal-free / CCR) avant de l'executer.
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DESCRIPTION="$1"
shift; shift  # retire le séparateur --
mkdir -p "$ROOT/donnees"
echo "$(date -Iseconds) | $DESCRIPTION" >> "$ROOT/donnees/.journal_ccr.log"
exec "$@"
````

comparer_tokens.sh
- ⚠️ Créer une `Key Management dan open router`

[https://openrouter.ai/settings/provisioning-keys](https://openrouter.ai/settings/provisioning-keys)  
````
#!/bin/bash
# Compare les tokens Pro (local, sednal) vs Gratuit (OpenRouter/sednal-free) pour une date.
# Usage : comparer_tokens.sh [YYYY-MM-DD]
set -euo pipefail

DATE="${1:-$(date +%F)}"
OPENROUTER_KEY="${OPENROUTER_MANAGEMENT_KEY:?Variable OPENROUTER_MANAGEMENT_KEY non définie}"

# --- Côté Pro (sednal, transcripts locaux Claude Code) ---
PRO_JSON=$(npx ccusage@latest daily --json --since "$DATE" --until "$DATE" 2>/dev/null)
PRO_TOKENS=$(echo "$PRO_JSON" | jq '[.daily[]? | (.inputTokens + .outputTokens)] | add // 0')

# --- Côté gratuit (OpenRouter) ---
FREE_JSON=$(curl -s "https://openrouter.ai/api/v1/activity?date=$DATE" \
  -H "Authorization: Bearer $OPENROUTER_KEY")
FREE_TOKENS=$(echo "$FREE_JSON" | jq '[.data[]? | (.prompt_tokens + .completion_tokens)] | add // 0')

TOTAL=$((PRO_TOKENS + FREE_TOKENS))
PCT_FREE="0.0"
[ "$TOTAL" -gt 0 ] && PCT_FREE=$(awk "BEGIN{printf \"%.1f\", ($FREE_TOKENS/$TOTAL)*100}")

echo "=== Répartition tokens momo — $DATE ==="
echo "Pro (sednal)              : $PRO_TOKENS tokens"
echo "Gratuit (sednal-free/CCR) : $FREE_TOKENS tokens"
echo "Total                     : $TOTAL tokens"
echo "Part gratuite             : ${PCT_FREE}%"

# Historique
LOG="/opt/grappes/donnees/.economies_tokens.csv"
mkdir -p "$(dirname "$LOG")"
[ -f "$LOG" ] || echo "date,pro_tokens,free_tokens,total_tokens,pct_free" > "$LOG"
echo "$DATE,$PRO_TOKENS,$FREE_TOKENS,$TOTAL,$PCT_FREE" >> "$LOG"
````

continuer.sh
````
#!/bin/bash
# Hook Stop : force la continuation (exit 2) avec anti-boucle ; chemins relatifs au projet.
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT" || exit 0
mkdir -p "$ROOT/donnees"
ETAT_FILE="$ROOT/donnees/.stop_hook_state"
HEAD=$(git rev-parse HEAD 2>/dev/null || echo "none")
if [ -f "$ETAT_FILE" ]; then read -r LAST_HEAD COUNT < "$ETAT_FILE"; else LAST_HEAD=""; COUNT=0; fi
if [ "$HEAD" = "$LAST_HEAD" ]; then COUNT=$((COUNT+1)); else COUNT=0; fi
echo "$HEAD $COUNT" > "$ETAT_FILE"
[ "$COUNT" -ge 2 ] && exit 0
echo "Relis ETAT.md et ne traite que la phase en cours. Si un point est reellement bloquant (bug, decision irreversible), decris-le clairement et arrete-toi sur ce point precis." >&2
exit 
````
