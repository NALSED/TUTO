
# Présentation des méthodes d'authentification de Vault

---

### 1️⃣ `Présentation`
### 2️⃣ `Utilisation`
### [CHOSES A RETENIR]

---

### 1️⃣ **Présentation**


-1. `Comment s'authentifier?`

Deux choix `User` ou `App` 

<img width="1366" height="757" alt="image" src="https://github.com/user-attachments/assets/a627a1f4-a866-4555-b6bd-433d610a2983" />


### Pour les méthodes d'identification suivante voila le flux User => Vault => Auth => Data

# Schéma d'authentification Vault

        USER                    VAULT                    AUTH BACKEND
                                                        (LDAP/AD/GitHub/etc.)
          │                       │                              │
          │  1. Login request     │                              │
          │  (username/password)  │                              │
          │──────────────────────>│                              │
          │                       │                              │
          │                       │  2. Vérification identité    │
          │                       │─────────────────────────────>│
          │                       │                              │    
          │                       │  3. OK + groupes/infos       │
          │                       │<─────────────────────────────│
          │                       │                              │
          │                       │  4. Mapping groupes          │
          │                       │     → policies Vault         │
          │                       │                              │
          │  5. TOKEN + policies  │                              │
          │<──────────────────────│                              │
          │                       │                              │
          │  6. Requêtes avec     │                              │
          │     token             │                              │
          │──────────────────────>│                              │
          │                       │                              │
          │  7. Secrets (si       │                              │
          │     autorisé)         │                              │
          │<──────────────────────│                              │


- `Étapes`

1. **User** → Envoie credentials (username/password) à Vault
2. **Vault** → Vérifie auprès du backend d'auth (LDAP/AD/GitHub...)
3. **Backend** → Retourne OK + infos utilisateur (groupes, email...)
4. **Vault** → Mappe groupes backend → policies Vault
5. **Vault** → Retourne TOKEN avec policies attachées
6. **User** → Utilise le token pour accéder aux secrets
7. **Vault** → Retourne secrets si policies autorisent



Précisions sur quelques authentifications spécifiques :

🟢 **Vert** = Recommandé pour la production / Bonne pratique

🟡 **Jaune** = Acceptable dans certains cas spécifiques / Attention requise

🔴 **Rouge** = Déconseillé / Risque de sécurité

=== USER ===

* `Vault Token` 🔴 Déconseillé : impossibilité de vérifier l'identité de l'utilisateur.

* `Userpass` 🟢 Authentification via nom d'utilisateur et mot de passe.

* `LDAP` 🟢 Permet à Vault d'authentifier les employés avec leurs identifiants corporate au lieu de créer des comptes séparés. (LDAP = annuaire centralisé d'entreprise qui stocke utilisateurs, groupes et mots de passe)

* `OIDC` 🟢 Authentification via fournisseur externe (Google, Okta, Azure AD) avec redirection navigateur pour SSO. (OIDC = protocole d'authentification qui utilise des JWT)

* `GitHub` 🟡 Authentification via personal access token GitHub. Utile pour développeurs mais limité (pas pour production).

---

=== APP ===

* `AppRole` 🟢 Authentification pour applications/machines via role-id (public) + secret-id (temporaire). Idéal pour automatisation sans credentials humains.

* `Kubernetes` 🟢 Les pods Kubernetes s'authentifient automatiquement via leur service account token. Pas de credentials à gérer manuellement.

* `AWS IAM` 🟢 Les instances EC2/Lambda s'authentifient via leur rôle IAM. Vault vérifie auprès d'AWS. Pas de secrets à stocker.

* `JWT` 🟡 L'application a déjà un token JWT signé, Vault vérifie sa signature et délivre un token Vault. (Cas d'usage : CI/CD, service-to-service)

* `TLS Certificate` 🟡 Authentification via certificat client TLS. Sécurisé mais gestion des certificats complexe.

---
---

### 2️⃣ **Utilisation**

Pour la présentation, Vault vient d'être initialisé et, par conséquent, seule l'authentification par token est disponible.

<img width="771" height="562" alt="image" src="https://github.com/user-attachments/assets/729e2852-ebb0-4d97-873c-c09d4dcd12ad" />

Pour des raisons d'infrastructure, toutes les authentifications ne pourront pas être développées.

** === BONNE PRATIQUE ===**

Afin de ranger correctement les policies, voici une suggestion :

        vault-config/
        ├── policies/
        │   ├── humans/
        │   │   ├── admin.hcl
        │   │   └── developer.hcl
        │   └── apps/
        │       ├── jenkins.hcl
        │       └── gitlab.hcl
        ├── scripts/
        │   └── deploy-policies.sh
        └── README.md

### `- Présentation des Auth` 

**-1. UserPass**

#### `Shéma`
<img width="1280" height="488" alt="image" src="https://github.com/user-attachments/assets/64fbb20e-2970-4210-a5f5-a00345c8063b" />

#### `Résumé Commandes`

<img width="1529" height="658" alt="image" src="https://github.com/user-attachments/assets/e104dfaa-2d77-4d9b-9d42-36af3906fff9" />

### **[DEMONSTRATION]**

-1. Création de l'arborécence ci dessus ⬆️ (BONNE PRATIQUE)
       
        mkdir -p vault-config/{policies/{user,apps},scripts}

<img width="381" height="156" alt="image" src="https://github.com/user-attachments/assets/a82f309a-1e48-419f-9ca9-964a56e69383" />


-2.


** === BONNE PRATIQUE ===**

        - EXEMPLE
        secret/data/{env}/{app}/{type}/{name}
        secret/data/prod/ecommerce/database/mysql

→ Clair, prévisible, scalable

-3.



-4.



-5.



-6.




















---

**-2. AppRoles**

#### `Shéma`
<img width="1549" height="740" alt="image" src="https://github.com/user-attachments/assets/7800d11c-563b-460a-91af-1233277eb3d3" />

#### `Résumé Commandes`

<img width="1516" height="626" alt="image" src="https://github.com/user-attachments/assets/0a1fd581-b8b8-4142-aaa1-9b4f0c9968ab" />

<img width="1531" height="647" alt="image" src="https://github.com/user-attachments/assets/35657fb7-cb67-4153-88ec-225d7cc51faf" />

### **[DEMONSTRATION]**





















---

**=== AUTRE ===**

**-3. GitHub**

### **[DEMONSTRATION]**

**-4. LDAP**

### **[DEMONSTRATION]**

---
---

[CHOSES A RETENIR]
