
# Présentation des méthodes d'authentification de Vault

---

### 1️⃣ `Présentation`
### 2️⃣ `Utilisation`
### `COMMANDES`

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

=== USER ===

- `Vault Token` 🔴 Déconseillé : impossibilité de vérifier l'identité de l'utilisateur.  
- `Userpass` 🟢 Authentification via nom d'utilisateur et mot de passe.  
- `LDAP` 🟢 Permet à Vault d'authentifier les employés avec leurs identifiants corporate au lieu de créer des comptes séparés.  
  (LDAP = annuaire centralisé d'entreprise qui stocke utilisateurs, groupes et mots de passe)

---

=== APP ===




-. ``



-. ``



-. ``

---
---

### 2️⃣ **Utilisation**


---
---

### **COMMANDES**


``


-Sortie


---


``


-Sortie


---

``


-Sortie


---

``


-Sortie


---

``


-Sortie


---

``


-Sortie


---


 [CHOSES A RETENIR]
