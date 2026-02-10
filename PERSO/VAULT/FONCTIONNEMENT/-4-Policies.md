### Politique des doits sur Vault (Policies)

---

1️⃣ `Présentation`
2️⃣ `Utilisation`
`COMMANDES`

---


1️⃣ **Présentation**

`-1. Intoduction`

- Les `Policies` définissent qui peut faire quoi dans Vault (contrôle d'accès), le format est du hcl (HarchiCorp language)

- Syntaxe de base

<img width="1020" height="239" alt="image" src="https://github.com/user-attachments/assets/3be72ddf-eeed-476d-9c23-e8ae12bb5088" />

**[CAPABILITIES]**

-  Possibilitées Standard / HTTP verbs : 

<img width="1636" height="338" alt="image" src="https://github.com/user-attachments/assets/a3c22a2a-eeb6-451f-8ca8-069eb00f1a7b" />


- Possibilitées spécial / HTTP verbs :

<img width="1083" height="320" alt="image" src="https://github.com/user-attachments/assets/43094bcb-1246-4784-bb42-ed5074fd0474" />

**Arborecence fichier dans Vault**

          Vault Server (127.0.0.1:8200)
          │
          ├── sys/                           [Configuration système]
          │   ├── auth/token/tune            (config tokens)
          │   ├── mounts/                    (secrets engines installés)
          │   └── policies/                  (liste des policies)
          │
          ├── auth/                          [Authentification]
          │   ├── token/
          │   │   ├── create                 (créer token)
          │   │   ├── lookup                 (info token)
          │   │   └── accessors/             (liste accessors)
          │   │
          │   └── approle/
          │       └── role/jenkins/
          │           ├── role-id            (ID fixe du rôle)
          │           └── secret-id          (secret temporaire)
          │
          ├── secret/                        [Secrets statiques KV v2]
          │   └── data/
          │       ├── prod/
          │       │   ├── mysql/root-password
          │       │   └── stripe/api-key
          │       │
          │       └── dev/
          │           └── mysql/test-password
          │
          ├── database/                      [Credentials DB dynamiques]
          │   ├── config/mysql-prod          (connexion DB)
          │   ├── roles/app-role             (définition rôle)
          │   └── creds/app-role             (générer user/pass temporaires)
          │
          └── transit/                       [Chiffrement as a Service]
              ├── keys/payment-data          (clé de chiffrement)
              ├── encrypt/payment-data       (chiffrer)
              └── decrypt/payment-data       (déchiffrer)

----

`-2. Synthaxe`

- Path vs Segment => Schéma :

      secret/data/prod/mysql/root-password
      │      │    │    │     └─ segment 5
      │      │    │    └─────── segment 4
      │      │    └──────────── segment 3
      │      └───────────────── segment 2
      └──────────────────────── segment 1
      
      └────────── PATH ─────────────────┘



**[EXEMPLE Policy]**

<img width="1257" height="701" alt="image" src="https://github.com/user-attachments/assets/003abdd5-f319-4a20-9945-a10634215a6c" />


- Ici :

    - secret/ : uniquement lister les secret commencant par `secret/`

    - secret/database : quasiment tous les droit
    
    - secret/cloud/bastion :Le secret doit exister pour pouvoir Update dessus. 


**[Path Glob Pattern]**

Permet d'appliquer une policy à **plusieurs paths** en utilisant des wildcards au lieu de spécifier chaque path individuellement.
(tous les paths qui matchent le pattern avec wildcard)

#### - `*` ou Wildcard

Le `*` est un **préfixe** : il se place toujours à la fin d’un segment et indique que la policy s’applique à tout ce qui commence exactement par ce segment avant la wildcard.

- exemple 1 :

        path "secret/*" {
            capabilities = ["list"]
        }

La politique s'appliquera à tous les secret qui commence par `secret/`

-exemple 2 (mixer `*` et `deny`):

      path "secret/*" {
            capabilities = ["create", "read", "update", "delete", "list"]
        }

      path "secret/confidential"
            capabilities = ["deny"]

Les politique avec `*` ne s'appliqueront pas à `secret/confidential`


#### - `+`

Spécifie que n'importe quelle valeur entre les deux parties du path est acceptée.

- exemple :

     path "secret/+/admin" {
        capabilities = ["deny"]
     }



Ici, toutes les valeurs entre `secret` et `admin` sont acceptées.













-. ``



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


 **Arborecence Compléte**

           Vault Server (http://127.0.0.1:8200)
          │
          ├── sys/ (System Backend - configuration Vault)
          │   ├── auth/
          │   │   ├── token/tune (config auth token)
          │   │   ├── approle/ (config AppRole)
          │   │   └── kubernetes/ (config K8s auth)
          │   ├── mounts/ (secrets engines montés)
          │   ├── policies/ (gestion policies)
          │   ├── audit/ (config audit logs)
          │   └── health (santé du serveur)
          │
          ├── auth/ (Méthodes d'authentification)
          │   ├── token/
          │   │   ├── create (créer token)
          │   │   ├── lookup (info token)
          │   │   ├── renew-self (renouveler)
          │   │   └── accessors/ (liste accessors)
          │   │
          │   ├── approle/
          │   │   └── role/
          │   │       ├── jenkins/
          │   │       │   ├── role-id (ID du rôle)
          │   │       │   └── secret-id (secret temporaire)
          │   │       └── gitlab/
          │   │           ├── role-id
          │   │           └── secret-id
          │   │
          │   ├── userpass/
          │   │   ├── login/john (login utilisateur)
          │   │   └── users/john (config utilisateur)
          │   │
          │   └── kubernetes/
          │       └── login (auth depuis K8s pod)
          │
          ├── secret/ (KV v2 Secrets Engine - mount par défaut)
          │   ├── data/ (données actuelles)
          │   │   ├── prod/
          │   │   │   ├── mysql/
          │   │   │   │   ├── root-password
          │   │   │   │   └── app-user
          │   │   │   ├── postgres/
          │   │   │   │   └── connection-string
          │   │   │   ├── api-keys/
          │   │   │   │   ├── stripe
          │   │   │   │   ├── sendgrid
          │   │   │   │   └── aws
          │   │   │   └── ecommerce/
          │   │   │       ├── db-password
          │   │   │       └── jwt-secret
          │   │   │
          │   │   ├── staging/
          │   │   │   ├── mysql/
          │   │   │   └── api-keys/
          │   │   │
          │   │   └── dev/
          │   │       ├── mysql/
          │   │       └── test-credentials
          │   │
          │   └── metadata/ (métadonnées et versions)
          │       └── prod/mysql/root-password
          │
          ├── database/ (Database Secrets Engine - credentials dynamiques)
          │   ├── config/
          │   │   ├── mysql-prod (connexion MySQL)
          │   │   └── postgres-prod (connexion PostgreSQL)
          │   │
          │   ├── roles/
          │   │   ├── readonly-role (role lecture seule)
          │   │   ├── admin-role (role admin)
          │   │   └── ecommerce-app (role applicatif)
          │   │
          │   └── creds/
          │       ├── readonly-role (générer credentials temporaires)
          │       ├── admin-role
          │       └── ecommerce-app
          │
          ├── aws/ (AWS Secrets Engine - credentials IAM dynamiques)
          │   ├── config/root (config AWS root)
          │   ├── roles/
          │   │   ├── deploy-role (role déploiement)
          │   │   ├── s3-readonly (accès S3 lecture)
          │   │   └── ec2-admin
          │   │
          │   └── creds/
          │       ├── deploy-role (générer access/secret key)
          │       └── s3-readonly
          │
          ├── pki/ (PKI Secrets Engine - certificats SSL/TLS)
          │   ├── root/
          │   │   ├── generate/internal (générer CA root)
          │   │   └── sign-intermediate (signer CA intermédiaire)
          │   │
          │   ├── roles/
          │   │   ├── web-server (role certificats web)
          │   │   ├── internal-api (role API internes)
          │   │   └── client-cert
          │   │
          │   ├── issue/
          │   │   ├── web-server (émettre certificat web)
          │   │   └── internal-api (émettre certificat API)
          │   │
          │   └── cert/
          │       └── ca (récupérer CA publique)
          │
          ├── transit/ (Transit Engine - Encryption as a Service)
          │   ├── keys/
          │   │   ├── customer-data (clé chiffrement clients)
          │   │   ├── payment-data (clé données paiement)
          │   │   └── pii-data (clé données personnelles)
          │   │
          │   ├── encrypt/
          │   │   ├── customer-data (chiffrer données)
          │   │   └── payment-data
          │   │
          │   ├── decrypt/
          │   │   ├── customer-data (déchiffrer données)
          │   │   └── payment-data
          │   │
          │   └── rewrap/
          │       └── customer-data (re-chiffrer avec nouvelle version)
          │
          ├── ssh/ (SSH Secrets Engine - certificats SSH)
          │   ├── roles/
          │   │   └── admin-role
          │   └── sign/
          │       └── admin-role (signer clé SSH)
          │
          └── identity/ (Identity Secrets Engine - entités et groupes)
              ├── entity/
              │   └── id/{entity-id}
              ├── group/
              │   └── id/{group-id}
              └── alias/
                  └── id/{alias-id}
