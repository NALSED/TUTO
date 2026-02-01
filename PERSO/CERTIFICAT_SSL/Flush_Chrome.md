# Forcer Chrome à recharger les certificats

## 1. Fermer complètement Chrome
      taskkill /F /IM chrome.exe

## 2. Vider le cache SSL de Chrome
Dans Chrome
      chrome://net-internals/#sockets

Cliquer sur `Flush socket pools`

## 3. Entrer le domaine

      chrome://net-internals/#hsts

En bas, cliquer sur "Delete domain security policies".
Entrez le domaine.

Redémarrez Chrome.
