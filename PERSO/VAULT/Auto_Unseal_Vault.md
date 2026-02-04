# Mise en place de l'Auto-unseal pour Vault.

---

## Installation compléte et configuration démarrage de Vault via Auto-unseal

---

---


# Vault Auto-Unseal — Architecture

### 🥼 LAB 🥼

| IP               | Machine        | Détails RAM / CPU                | OS        |
|-----------------|----------------|---------------------------------|-----------|
| 192.168.0.241   | Raspberry Pi 4 | RAM: 1 GB<br>Processeur: ARM Cortex-A72 | Debian 13 |
| 192.168.0.242   | VM (VirtualBox)| RAM: 4 GB<br>Processeur: 2 cœurs     | Debian 13 |

---

## === SCHEMA ===
```
     === 192.168.0.241 ===                              === 192.168.0.242 ===
┌─────────────────────────────┐                    ┌─────────────────────────────┐
│          VAULT A            │                    │          VAULT B            │
│         Vault_Auto          │                    │         Vault_root          │
│                             │                    │                             │
│       Key Provider          │                    |        Auto-Unseal          │ 
│                             │                    │                             │
│  Port   : 8100              │   1 encrypt ───>   │  Port   : 8200              │
│  Storage: raft              │   2 decrypt <───   │  Storage: raft              │
│  Transit: activé            │                    │  Seal   : transit → Vault A │
│  Unseal : manuel            │                    │  Token  : env var           │
│  Dispo : 24/24              │                    │  Unseal : automatique       │
└─────────────────────────────┘                    └─────────────────────────────┘
        ↑                                                      ↑
        │                                                      │
  Unsealed en premier                              Se unseal automatiquement
  (vault operator init/unseal)                     via Vault A à chaque redémarrage
```

## Ordre de déploiement

```
1) Démarrer Vault A         
2) Init + Unseal Vault A     → vault operator init / unseal
3) Activer Transit sur A     → vault secrets enable transit
4) Créer la clé              → vault write transit/keys/autounseal
5) Créer policy + token      → pour autoriser Vault B
6) Démarrer Vault B          
```


---
---

## 1️⃣ Prérequis
#### 1.1) openssl ici => raspbery-pi 192.168.0.241
#### 1.2) Pouvoir faire tourner Vault A 24h/24h ici => raspbery-pi 192.168.0.241
#### 1.3) kleopatra (chiffrement GPG)
#### 1.4) DNS Resolver, Ici Pfsense.
#### 1.5) optionelle : VSC comme éditeur de texte.



=== PATH 192.168.0.241:8100===




=== PATH 192.168.0.242:8200===
































