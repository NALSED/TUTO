# Présentation de la solution de gestion de secret `Vault`.

---

### 1️⃣ Présentation
### 2️⃣ Fonctionnement
### 3️⃣ Bonnes pratiques

---

## 1️⃣ **Présentation**

![logo vault](https://blog.stephane-robert.info/_astro/logo-hashicorp-vault.CsOnZ3lS_GIVL6.svg)

### Vault – Gestion sécurisée des secrets

Vault est un outil conçu pour stocker et gérer **en toute sécurité des secrets**.  
Un *secret* désigne toute donnée sensible dont l’accès doit être strictement contrôlé, comme :

- clés d’API  
- mots de passe  
- certificats  
- autres informations confidentielles  

Vault permet de centraliser ces données tout en garantissant leur protection et leur traçabilité.

---

### Fonctionnalités principales

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

### Concepts et architecture

HashiCorp représente Vault sous la forme d’un **triangle** :

- **Sommet** : les clients accédant aux secrets
- **Base** : les composants fondamentaux de Vault :
  - moteurs de secrets  
  - méthodes d’authentification  
  - policies (politiques de sécurité)

Cette architecture garantit une séparation claire entre l’accès, la gestion des secrets et les règles de sécurité.




---

## 2️⃣ **Fonctionnement**

Vault






























---

## 3️⃣ **Bonnes pratiques**
