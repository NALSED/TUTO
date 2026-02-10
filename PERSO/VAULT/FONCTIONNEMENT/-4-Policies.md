### Politique des doits sur Vault (Policies)

---

1️⃣ `Présentation`

`COMMANDES`

---


1️⃣ **Présentation**

`-1. Intoduction`

- Les `Policies` définissent qui peut faire quoi dans Vault (contrôle d'accès), le format est du hcl (HarchiCorp language)

- Syntaxe de base

<img width="1020" height="239" alt="image" src="https://github.com/user-attachments/assets/3be72ddf-eeed-476d-9c23-e8ae12bb5088" />

### **[CAPABILITIES]**

#### -  Possibilitées Standard / HTTP verbs : 

<img width="1636" height="338" alt="image" src="https://github.com/user-attachments/assets/a3c22a2a-eeb6-451f-8ca8-069eb00f1a7b" />


#### - Possibilitées spécial / HTTP verbs :

<img width="1083" height="320" alt="image" src="https://github.com/user-attachments/assets/43094bcb-1246-4784-bb42-ed5074fd0474" />

**Arborecence fichier dans Vault** (non exaustif)

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



### **[EXEMPLE Policy]**

<img width="1257" height="701" alt="image" src="https://github.com/user-attachments/assets/003abdd5-f319-4a20-9945-a10634215a6c" />


- Ici le politique appliquées aux path :

    - secret/ : uniquement lister les secret commencant par `secret/`

    - secret/database : quasiment tous les droit
    
    - secret/cloud/bastion :Le secret doit exister pour pouvoir Update dessus. 


### **[Path Glob Pattern]**

Permet d'appliquer une policy à **plusieurs paths** en utilisant des symboles au lieu de spécifier chaque path individuellement.

(tous les paths qui matchent le pattern avec `*` ou `+`)

#### - `*` ou Wildcard

Le `*` est un **préfixe** (de a suite du path) : il se place toujours à la fin d’un segment et indique que la policy s’applique à tout ce qui commence exactement par ce segment avant la wildcard.

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

Les politiques avec `*` ne s'appliqueront pas à `secret/confidential`

---

#### - `+`

Spécifie que n'importe quelle valeur entre les deux parties du path est acceptée.

- exemple :

     path "secret/+/admin" {
        capabilities = ["deny"]
     }

Ici, toutes les valeurs entre `secret` et `admin` sont acceptées.


---

### **COMMANDES**

Voir la documentation officiel de Vault [ICI](https://developer.hashicorp.com/vault/docs/concepts/policies)

---


 [CHOSES A RETENIR]

<img width="1675" height="889" alt="image" src="https://github.com/user-attachments/assets/4448d1a4-aa91-4f64-a34f-f08f418b55a3" />




 
