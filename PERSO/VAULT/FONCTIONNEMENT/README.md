## Accès rapide à la doc :


- [Variables environement](https://developer.hashicorp.com/vault/docs/commands#configure-environment-variables)
- [Création de Token](https://developer.hashicorp.com/vault/api-docs/auth/token#create-token)
- [Policies](https://developer.hashicorp.com/vault/docs/concepts/policies)
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()
- []()

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
