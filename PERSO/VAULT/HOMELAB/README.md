# Choix d'implémentation — Vault V2

---

## Contexte

La V1 a été écrite pendant la découverte de Vault : chaque nouveau concept
s'est ajouté au précédent sans remise à plat. Résultat, une implémentation
que je ne pouvais plus ni auditer ni faire évoluer sans y passer des heures.

La V2 vise un périmètre plus restreint, que je maîtrise, que je peux relire
en entier et modifier sans crainte de casser autre chose. Les objectifs sont
inchangés — une PKI interne pour mes services — seule la mise en œuvre change.

---

## Décisions

| | Choix | Pourquoi | Détail |
|:-:|:--|:--|:-:|
| 1 | V1 archivée, réécriture complète | Doc et scripts non maintenables ; audit du dépôt à l'appui | [ARCHIVE_V1](.) |
| 2 | Suppression de l'auto-unseal | Complexité et point de panne non justifiés  | `-6- Administration.md` |
| 3 | RSA uniquement | La double chaîne RSA + ECDSA doublait chaque étape pour un usage nul — aucun service ne l'exigeait. Un moteur ECDSA reste ajoutable sous la même racine | `-3-PKI.md` |
| 4 | TTL 1 an pour tous les certificats finaux | Périmètre réduit au seul rôle `infra` : le TLS sur les démons Bareos est abandonné. L'infra étant éteinte environ un mois tous les quatre mois, un TTL court expirerait pendant les arrêts et Vault ne pourrait plus renouveler son propre certificat | `-3-PKI.md` |
| 5 | Reverse proxy TLS sur 192.168.0.239 | Un certificat multi-SAN au lieu d'un certificat par service : plus de `.pem` concaténés, de droits par démon ni de redémarrages distants | `-5-Proxy.md` |
| 6 | Vault Agent au lieu des scripts de push | L'agent tourne sur la machine cible, écrit le certificat et recharge le service. Supprime les scripts de déploiement, les clés SSH de Vault vers toutes les machines et le timer systemd | `-4-Agent.md` |
| 7 | Pas de distribution CRL | Sans mTLS, aucun client ne consulte la CRL. Les URLs restent gravées dans les certificats, le point de distribution sera monté le jour où il servira | `-6- Administration.md` |
