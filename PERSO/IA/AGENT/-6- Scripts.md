## Script Utiliser pour monitorer `CCR`


---

**=== Explication Script ===**

- `log-ai.sh` => Journalsation des appels
- `comparer_tokens.sh` => Compare les token `Pro` / `Free` pour calculer les économies
- `continuer.sh` => Lu via un [hook](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/-5-%20Config_Claude-Code-Router.md#21-fichier-pro--free) de `Claude Pro` pour le forcer à continuer à la fin d'un tache.
- `verif_ccr.sh` => Vérifie que : CCR, bascule gratuite, RTK, journal, ccusage, OpenRouter, script tokens, est Ok avant de démarrer l'agent Claude Code
---

`log-ai.sh`
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

`comparer_tokens.sh`
- ⚠️ Créer une `Key Management` dans open router : ⚠️

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

`continuer.sh`
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

`verif_ccr.sh`
````
#!/bin/bash
# Vérifie tous les points : CCR, bascule gratuite, RTK, journal, ccusage, OpenRouter, script tokens.
# Usage : OPENROUTER_MANAGEMENT_KEY="<clé provisioning>" ./verif_ccr.sh

set -uo pipefail
KEY="${OPENROUTER_MANAGEMENT_KEY:-}"
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

# 8. API OpenRouter (clé management)
if [ -z "$KEY" ]; then
  fail "OPENROUTER_MANAGEMENT_KEY non fournie, test API sauté"
else
  REP2=$(timeout 15 curl -s "https://openrouter.ai/api/v1/activity?date=$HIER" -H "Authorization: Bearer $KEY")
  if echo "$REP2" | grep -q '"data"'; then ok "API OpenRouter /activity répond"; else fail "API OpenRouter : $REP2"; fi
fi

# 9. Script comparer_tokens.sh exécutable et sans erreur
if [ -x /opt/grappes/outils/comparer_tokens.sh ]; then
  if [ -n "$KEY" ] && OPENROUTER_MANAGEMENT_KEY="$KEY" /opt/grappes/outils/comparer_tokens.sh "$HIER" >/dev/null 2>&1; then
    ok "comparer_tokens.sh exécuté sans erreur"
  else
    fail "comparer_tokens.sh : échec ou clé manquante"
  fi
else
  fail "comparer_tokens.sh non exécutable"
fi

echo "=== Terminé ==="
````
