# Présentation de la solution de gestion de secret `Vault`.

---

### 1️⃣ Présentation
### 2️⃣ Fonctionnement
### 3️⃣ Bonnes pratiques

---
---

## 1️⃣ **Présentation**

![logo vault](https://blog.stephane-robert.info/_astro/logo-hashicorp-vault.CsOnZ3lS_GIVL6.svg)

### `Vault – Gestion sécurisée des secrets`

Vault est un outil conçu pour stocker et gérer **en toute sécurité des secrets**.  
Un *secret* désigne toute donnée sensible dont l’accès doit être strictement contrôlé, comme :

- clés d’API  
- mots de passe  
- certificats  
- autres informations confidentielles  

Vault permet de centraliser ces données tout en garantissant leur protection et leur traçabilité.

---

### `Fonctionnalités principales`

Vault ne se limite pas à un simple stockage. Il prend en charge **l’ensemble du cycle de vie des secrets**, de leur création à leur révocation.

#### Stockage sécurisé
- Les secrets de type clé/valeur sont stockés dans Vault.
- Ils sont **chiffrés avant d’être écrits** dans le stockage persistant.
- Un accès direct au stockage brut ne permet pas de lire les secrets.

#### Secrets dynamiques
- Génération de secrets **à la demande** pour certains systèmes (ex. bases de données).
- Révocation automatique des secrets générés.
- Réduction des risques liés aux accès prolongés ou compromis.

#### Chiffrement des données
- Chiffrement et déchiffrement des données **sans stockage**.
- Utilisation de Vault comme service de chiffrement.

#### Baux et renouvellement
- Chaque secret est associé à un **bail (lease)**.
- À l’expiration du bail, le secret est **révoqué automatiquement**.
- Possibilité de renouveler les baux si nécessaire.

---

### `Concepts et architecture`

HashiCorp représente Vault sous la forme d’un **triangle** :

- **Sommet** : les clients accédant aux secrets
- **Base** : les composants fondamentaux de Vault :
  - moteurs de secrets  
  - méthodes d’authentification  
  - policies (politiques de sécurité)

Cette architecture garantit une séparation claire entre l’accès, la gestion des secrets et les règles de sécurité.


![Architecture Vault](https://blog.stephane-robert.info/_astro/vault-triangle.BS4k8qEm_Z1bWz81.webp)

---
---

## 2️⃣ **Fonctionnement**

### === SOMMAIRE ===

- I) `Architecture Générale`

- II) `Flux d'une Requête` 

- III) `Principaux Chemins (Endpoints)`  

---

### 📋 `Vue d'ensemble`

HashiCorp Vault est un **gestionnaire de secrets centralisé** qui fonctionne comme un serveur web exposant une **API REST HTTP/HTTPS**. Toutes les interactions avec Vault se font via des requêtes HTTP standard vers différents endpoints, bien que l’utilisation de HTTPS en production soit vivement conseillée.

### I) 🏗️ `Architecture Générale` 🏗️
```
┌──────────────────────────────────────────────────────────┐
│                      CLIENTS                             │
│  (Applications, CLI, Scripts, Humains via UI)            │
└───────────────────────┬──────────────────────────────────┘
                        │ Requêtes HTTP/HTTPS
                        v
┌──────────────────────────────────────────────────────────┐
│                   VAULT SERVER                           │
│                   (Port 8200)                            │
│                                                          │
│  ┌────────────────────────────────────────────────────┐  │
│  │              API REST (/v1/*)                      │  │
│  │  - Authentification (Tokens, AppRole, LDAP...)     │  │ 
│  │  - Autorisation (Policies)                         │  │
│  │  - Routage vers les moteurs                        │  │
│  └────────────────────────────────────────────────────┘  │
│                         |                                │
|                         v                                |  
│  ┌────────────────────────────────────────────────────┐  │
│  │            MOTEURS DE SECRETS                      │  │
│  │                                                    │  │
│  │  sys/       → Administration système               │  │
│  │  secret/    → Secrets statiques (KV)               │  │
│  │  cubbyhole/ → Stockage personnel par token         │  │
│  │  transit/   → Chiffrement as-a-Service             │  │
│  │  pki/       → Certificats SSL/TLS                  │  │
│  │  database/  → Credentials dynamiques DB            │  │
│  │  aws/       → Credentials AWS temporaires          │  │
│  └────────────────────────────────────────────────────┘  │
│                          |                               │
|                          v                               │
│  ┌────────────────────────────────────────────────────┐  │
│  │          CLÉ DE CHIFFREMENT                        │  │
│  │  Toutes les données sont chiffrées (AES-256-GCM)   │  │
│  └────────────────────────────────────────────────────┘  │
│                          |                               │
|                          v                               │
│  ┌────────────────────────────────────────────────────┐  │
│  │         BACKEND DE STOCKAGE                        │  │
│  │  - Raft (Integrated Storage) - Recommandé          │  │
│  │  - Consul                                          │  │
│  │  - Fichier local (dev seulement)                   │  │
│  │  - PostgreSQL / MySQL                              │  │
│  │  - AWS S3 / Azure / GCS                            │  │
│  └────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────┘
                          | 
                          v
                  ┌───────────────┐
                  │  Disque/Cloud │
                  │  (chiffré)    │
                  └───────────────┘
```

### 🔗 `Anatomie d'une URL Vault` 🔗

Vault expose son API via des URLs structurées :
```
https://vault.example.com:8200/v1/secret/data/myapp/db
  |        |              |    |  |      |    |
  |        |              |    |  |      |    └─ Chemin du secret => Connexion sécurisée (TLS/SSL). HTTP possible en dev uniquement
  |        |              |    |  |      └────── Type de moteur (KV v2) => Pour KV v2 : /data (lecture/écriture) ou /metadata (métadonnées)
  |        |              |    |  └───────────── Moteur monté => Point de montage du moteur de secrets 
  |        |              |    └──────────────── Version de l'API => Version de l'API (actuellement v1 pour toutes les opérations)
  |        |              └───────────────────── Port (8200 par défaut) => Port par défaut de Vault (configurable)
  |        └──────────────────────────────────── Domaine/Hostname => Adresse du serveur Vault
  └───────────────────────────────────────────── Protocole (HTTPS obligatoire en prod) =>  Connexion sécurisée (TLS/SSL). HTTP possible en dev uniquement 
```

---

### II) 🔄 `Flux d'une Requête` 🔄

**-1. Le Client Envoie une Requête**

```http
POST /v1/secret/data/myapp/db HTTP/1.1
Host: vault.example.com:8200
X-Vault-Token: hvs.CAESIE8fG7q...
Content-Type: application/json

{
  "data": {
    "username": "db_admin",
    "password": "P@ssw0rd123"
  }
}
```

**-2. Vault Traite la Requête**
```
┌─────────────────────────────────────────────┐
│ 1. RÉCEPTION                                │
│    → Serveur HTTP écoute sur port 8200      │
└─────────────────┬───────────────────────────┘
                  ↓
┌─────────────────────────────────────────────┐
│ 2. AUTHENTIFICATION                         │
│    → Validation du token X-Vault-Token      │
│    → Identification de l'entité             │
└─────────────────┬───────────────────────────┘
                  ↓
┌─────────────────────────────────────────────┐
│ 3. AUTORISATION                             │
│    → Vérification des policies ACL          │
│    → Peut-il écrire dans secret/myapp/db ?  │
└─────────────────┬───────────────────────────┘
                  ↓
┌─────────────────────────────────────────────┐
│ 4. ROUTAGE                                  │
│    → Identification du moteur (secret/)     │
│    → Délégation au Secret Engine KV v2      │
└─────────────────┬───────────────────────────┘
                  ↓
┌─────────────────────────────────────────────┐
│ 5. TRAITEMENT                               │
│    → Validation des données JSON            │
│    → Versioning (KV v2)                     │
│    → Métadonnées (created_time, version)    │
└─────────────────┬───────────────────────────┘
                  ↓
┌─────────────────────────────────────────────┐
│ 6. CHIFFREMENT                              │
│    → Sérialisation des données              │
│    → Chiffrement AES-256-GCM                │
│    → Clé de chiffrement (Encryption Key)    │
└─────────────────┬───────────────────────────┘
                  ↓
┌─────────────────────────────────────────────┐
│ 7. STOCKAGE                                 │
│    → Écriture dans le backend (Raft/Consul) │
│    → Données persistées sur disque          │
└─────────────────┬───────────────────────────┘
                  ↓
┌─────────────────────────────────────────────┐
│ 8. RÉPONSE                                  │
│    → Construction de la réponse HTTP        │
│    → Retour au client                       │
└─────────────────────────────────────────────┘
```

**-3. Le Client Reçoit la Réponse**

```http
HTTP/1.1 200 OK
Content-Type: application/json
Cache-Control: no-store

{
  "request_id": "abc-123-def-456",
  "lease_id": "",
  "renewable": false,
  "lease_duration": 0,
  "data": {
    "created_time": "2026-02-08T12:30:00.123456Z",
    "custom_metadata": null,
    "deletion_time": "",
    "destroyed": false,
    "version": 1
  }
}
```

---

### III) 🛣️ `Principaux Chemins (Endpoints)` 🛣️ 

[RAPPEL] === Méthodes HTTP et Actions ===

| Méthode HTTP | Action Vault | Exemple |
|--------------|--------------|---------|
| **GET** | Lire des données | Récupérer un secret |
| **POST** | Créer ou effectuer une action | Créer un secret, login |
| **PUT** | Créer ou mettre à jour | Définir une policy |
| **DELETE** | Supprimer | Supprimer un secret |
| **LIST** | Lister (spécifique Vault) | Lister les secrets d'un chemin |


- **Chemins Système (`sys/`)**

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/v1/sys/health` | GET | État de santé du serveur |
| `/v1/sys/seal` | PUT | Sceller Vault |
| `/v1/sys/unseal` | PUT | Desceller Vault |
| `/v1/sys/mounts` | GET | Lister les moteurs montés |
| `/v1/sys/auth` | GET | Lister les méthodes d'auth |
| `/v1/sys/policies/acl` | GET/PUT | Gérer les policies |
| `/v1/sys/audit` | GET/PUT | Gérer l'audit |

- **Secrets Statiques (`secret/` - KV v1)**

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/v1/secret/data/myapp` | POST | Créer/Mettre à jour un secret |
| `/v1/secret/data/myapp` | GET | Lire le secret (dernière version) |
| `/v1/secret/data/myapp?version=2` | GET | Lire une version spécifique |
| `/v1/secret/metadata/myapp` | GET | Lire les métadonnées |
| `/v1/secret/delete/myapp` | POST | Soft delete (récupérable) |
| `/v1/secret/destroy/myapp` | POST | Hard delete (irrécupérable) |

- **Stockage Personnel (`cubbyhole/`)**

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/v1/cubbyhole/temp` | POST | Stocker (lié au token) |
| `/v1/cubbyhole/temp` | GET | Lire (seulement avec le même token) |

- **Chiffrement (`transit/`)**

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/v1/transit/keys/mykey` | POST | Créer une clé de chiffrement |
| `/v1/transit/encrypt/mykey` | POST | Chiffrer des données |
| `/v1/transit/decrypt/mykey` | POST | Déchiffrer des données |
| `/v1/transit/sign/mykey` | POST | Signer des données |

- **Authentification**

| Endpoint | Méthode | Description |
|----------|---------|-------------|
| `/v1/auth/token/create` | POST | Créer un token |
| `/v1/auth/approle/login` | POST | Login via AppRole |
| `/v1/auth/ldap/login/:username` | POST | Login via LDAP |
| `/v1/auth/userpass/login/:username` | POST | Login user/pass |
```

## 🎯 Résumé

| Composant | Description |
|-----------|-------------|
| **Interface** | API REST HTTP/HTTPS sur port 8200 |
| **Communication** | Requêtes/Réponses JSON |
| **Authentification** | Token dans header `X-Vault-Token` |
| **Autorisation** | Policies ACL (capabilities sur des paths) |
| **Moteurs** | Modules montés sur des chemins (`secret/`, `transit/`, etc.) |
| **Chiffrement** | AES-256-GCM pour toutes les données |
| **Stockage** | Backend configurable (Raft, Consul, etc.) |
| **Sécurité** | Seal/Unseal avec Shamir Secret Sharing |



## 3️⃣ **Bonnes pratiques**

### 💾 `Stockage Physique`

| Backend | Usage | Haute Dispo | Performance |
|---------|-------|-------------|-------------|
| **Integrated Storage (Raft)** | Production | ✅ Oui | ⚡ Excellente |
| **Consul** | Production | ✅ Oui | ⚡ Bonne |
| **PostgreSQL/MySQL** | Production | ⚠️ Avec setup | 🐢 Moyenne |
| **Fichier local** | Dev/Test | ❌ Non | ⚡ Bonne |
| **AWS S3** | Production | ⚠️ Avec DynamoDB | 🐢 Moyenne |
