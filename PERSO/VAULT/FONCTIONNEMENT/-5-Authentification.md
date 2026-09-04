
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

---

Précisions sur quelques authentifications spécifiques :

🟢 = Recommandé pour la production / Bonne pratique

🟡 = Acceptable dans certains cas spécifiques / Attention requise

🔴  = Déconseillé / Risque de sécurité

#### **=== USER ===**

* `Vault Token` 🔴 Déconseillé : impossibilité de vérifier l'identité de l'utilisateur.

* `Userpass` 🟢 Authentification via nom d'utilisateur et mot de passe.

* `LDAP` 🟢 Permet à Vault d'authentifier les employés avec leurs identifiants corporate au lieu de créer des comptes séparés. (LDAP = annuaire centralisé d'entreprise qui stocke utilisateurs, groupes et mots de passe)

* `OIDC` 🟢 Authentification via fournisseur externe (Google, Okta, Azure AD) avec redirection navigateur pour SSO. (OIDC = protocole d'authentification qui utilise des JWT)

* `GitHub` 🟡 Authentification via personal access token GitHub. Utile pour développeurs mais limité (pas pour production).

---

#### **=== APP ===**

* `AppRole` 🟢 Authentification pour applications/machines via role-id (public) + secret-id (temporaire). Idéal pour automatisation sans credentials humains.

* `Kubernetes` 🟢 Les pods Kubernetes s'authentifient automatiquement via leur service account token. Pas de credentials à gérer manuellement.

* `AWS IAM` 🟢 Les instances EC2/Lambda s'authentifient via leur rôle IAM. Vault vérifie auprès d'AWS. Pas de secrets à stocker.

* `JWT` 🟡 L'application a déjà un token JWT signé, Vault vérifie sa signature et délivre un token Vault. (Cas d'usage : CI/CD, service-to-service)

* `TLS Certificate` 🟡 Authentification via certificat client TLS. Sécurisé mais gestion des certificats complexe.

---
---

### 2️⃣ **Utilisation**

Pour la présentation, Vault vient d'être initialisé (prod) et, par conséquent, seule l'authentification par token est disponible.

<img width="771" height="562" alt="image" src="https://github.com/user-attachments/assets/729e2852-ebb0-4d97-873c-c09d4dcd12ad" />

Pour des raisons d'infrastructure, toutes les authentifications ne pourront pas être développées.

#### **=== BONNE PRATIQUE ===**

Afin de ranger correctement les policies (sur la machine qui accueille le serveur Vault, avant édition), voici une suggestion :
```
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
```

## `- Présentation de moyens d'authentification` 

### **-1. UserPass**

[DOC HASHICORP](https://developer.hashicorp.com/vault/docs/auth/userpass)

#### `Shéma`
<img width="1280" height="488" alt="image" src="https://github.com/user-attachments/assets/64fbb20e-2970-4210-a5f5-a00345c8063b" />

#### `Résumé Commandes`

<img width="1529" height="658" alt="image" src="https://github.com/user-attachments/assets/e104dfaa-2d77-4d9b-9d42-36af3906fff9" />

### **[DÉMONSTRATION]**

⚠️ Le serveur utilisé pour la démo, n'est pas en dev mode, donc vault secrets non actif

- Activation : 
```
vault secrets enable -path=secret kv-v2
```

- Sortie:
```
Success! Enabled the kv-v2 secrets engine at: secret/
```

---
        
#### `-1.` Création de l'arborescence ci dessus ⬆️ (=== BONNE PRATIQUE ===)
```
mkdir -p vault-config/{policies/{user,apps},scripts}
```

<img width="381" height="156" alt="image" src="https://github.com/user-attachments/assets/a82f309a-1e48-419f-9ca9-964a56e69383" />


#### `-2.` Création de la policy qui administrera l'authentification User
```
nano vault-config/policies/user/policy_user_auth.hcl
```

-Éditer 
```
path "secret/data/users" {
  capabilities = ["read", "create", "update", "delete"]
}
```

**=== BONNE PRATIQUE ===**

- [EXEMPLE] d'arborescence endpoint dans Vault
```
secret/data/{env}/{app}/{type}/{name}
secret/data/prod/ecommerce/database/mysql
```

=> Clair, prévisible, scalable

#### `-3.` Uploader la policy  dans Vault
`[NOTE]` La policy est stocker sous le nom que l'on donne au fichier en local, et sous le nom que l'on donne lors de l'upload dans Vault.

=> En Local : vault-config/policies/user/policy_user_auth.hcl

=> Dans Vault user (Dans le endpoint policies) 

---

`[SYNTAXE]`vault policy write user [CHEMIN ABSOLU DU FICHIER POLICY] ou se trouver dans le fichier

- Ici
```
vault policy write user /home/sednal/vault-config/policies/user/policy_user_auth.hcl
```

-Sortie 
```
Success! Uploaded policy: user
```

-Vérification dans Vault
```
vault policy list
```

<img width="382" height="74" alt="image" src="https://github.com/user-attachments/assets/7ae5b300-be2b-4c66-86aa-5a6ab9b16323" />

Tout est OK.


#### `-4.` autoriser l'authentification via Userpass 
- par défaut le chemin sera auth/userpass quand activation userpass
Si besoin de chemin différent : `vault auth enable -path="test" userpass`
Ici le chemin sera auth/test

- Mais pour cette démonstrations nous utiliserons
```
vault auth enable userpass
```

-Sortie 
```
Success! Enabled userpass auth method at: userpass/
```

-Vérification 
```
vault auth list
```

<img width="769" height="98" alt="image" src="https://github.com/user-attachments/assets/529c9ad4-971c-4519-babc-de32c488aaaf" />

#### `-5.` Créer un utilisateur
```
vault write auth/userpass/users/sednal password=131213 policies=user
```

ici 
-`Syntaxe classique` : vault write
- `path` : auth/userpass/users/ ⚠️ `users` n'est pass une convention
- `Nom Utilisateur` : sednal
- `Mot de passe` : password=131213
- `Politique créer plus haut` : policies=user
  
#### `-6.` Lister et lire les info de notre utilisateur `sednal`
```
vault list auth/userpass/users/
vault read auth/userpass/users/sednal
```

<img width="564" height="345" alt="image" src="https://github.com/user-attachments/assets/4d5d52d6-6a80-4965-a7ca-c7b0be058136" />

`[NOTE]` Ici que le `token_max_ttl` = 0, mais il y à le token_max_ttl sys qui prend le dessus avec environ 32 jours

#### `-7.` TEST Authentification en CLI et WEB UI

- `CLI`

<img width="926" height="349" alt="image" src="https://github.com/user-attachments/assets/fd6fd3ce-920d-4a76-b923-8d174f47cbd2" />

`[NOTE]` Le max ttl est bien celui du system
Maintenant l'utilisateur peux se connecter via userpass ou token.

- `WEB`

<img width="615" height="608" alt="image" src="https://github.com/user-attachments/assets/2d98582a-f2bd-4cd6-99a0-13dba75da5e7" />

-Tout est OK

<img width="515" height="420" alt="image" src="https://github.com/user-attachments/assets/9b3d4f23-88f7-42c1-bd72-372cd7c62369" />

---

### **-2. AppRoles**

[DOC HASHICORP](https://developer.hashicorp.com/vault/docs/auth/approle)

 `AppRole` permet `d'automatiser la connexion des applications` pour accéder à des secrets de manière sécurisée.

#### `Shéma`
<img width="1549" height="740" alt="image" src="https://github.com/user-attachments/assets/7800d11c-563b-460a-91af-1233277eb3d3" />

#### `Résumé Commandes`

<img width="1516" height="626" alt="image" src="https://github.com/user-attachments/assets/0a1fd581-b8b8-4142-aaa1-9b4f0c9968ab" />

<img width="1531" height="647" alt="image" src="https://github.com/user-attachments/assets/35657fb7-cb67-4153-88ec-225d7cc51faf" />

### **[DÉMONSTRATION]**

`[RAPPEL]`
```
vault write  [engine]/[type]/[nom-libre]
                │        │        │
                │        │        └── Libre
                │        └─────────── Imposé par Vault (config, roles, creds)
                └──────────────────── Imposé par Vault (database, aws, pki…)
```

#### `-1.` Autoriser l'Authentification via AppRole
```
vault auth enable approle
```

-Sortie :
```
Success! Enabled approle auth method at: approle/
```

-Liste 
```
vault auth list
```

<img width="794" height="112" alt="image" src="https://github.com/user-attachments/assets/2b38282e-b69b-4d9e-a789-4e0a07890669" />

#### `-2.` Création du role d'authentification AppRole
```
vault write auth/approle/role/app token_policies="default"
```

- Ici la politique de token est par défaut, dans la doc officiel il est décrit comment gérer ça [ICI](https://developer.hashicorp.com/vault/docs/auth/approle#via-the-cli-1)
Pour modifier les Information

-Sortie :
```
Success! Data written to: auth/approle/role/app
```

-Liste : 

<img width="487" height="76" alt="image" src="https://github.com/user-attachments/assets/93fa6194-359b-4c81-aee4-f4f03b75268c" />

#### `-3.` Récupérer le Role-ID et Secret-ID

📝 role-id => statique
📝 secret-id => dynamique, il est délivré à la demande
```
vault read auth/approle/role/app/role-id      
```

<img width="582" height="75" alt="image" src="https://github.com/user-attachments/assets/95f45d7b-26c1-4a66-9fcd-74602295545c" />

```
vault write -f auth/approle/role/app/secret-id
```

<img width="634" height="138" alt="image" src="https://github.com/user-attachments/assets/ba202a52-c0b1-493d-a500-bfb10252fc26" />

#### `-4.` Test via CLI

`[SYNTAXE]` => vault write auth/approle/login role_id=$ROLE_ID secret_id=$SECRET_ID

Ici 
```
vault write auth/approle/login role_id=493f9341-d783-4029-0c30-9c12f53e2157 secret_id=e4b3b425-5a53-f50f-b654-15e19d97bc3e
```

<img width="925" height="245" alt="image" src="https://github.com/user-attachments/assets/b9dd6e39-0b38-40b4-817a-546b4c7c4a20" />

---

### **-3. LDAPS**

[DOC LDAP](https://github.com/hashicorp/web-unified-docs/blob/main/content/vault/v1.21.x/content/docs/auth/ldap.mdx)

Configuration ADDS ADCS LDAPS => [ICI](https://github.com/NALSED/TUTO/edit/main/PERSO/LDAP/Windows_Server_2025.md)

Architecture réseau

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         Réseau 192.168.0.0/24                           │
└─────────────────────────────────────────────────────────────────────────┘

┌──────────────────────┐       ┌──────────────────────┐       ┌──────────────────────┐
│   Serveur Vault      │       │   Serveur AD         │       │   Client Windows     │
│   (Debian 13)        │◄─────►│   (Windows Server    │◄─────►│   (Windows 10 Pro)   │
│                      │       │    2025)             │       │                      │
│  IP: 192.168.0.250   │       │  IP: 192.168.0.252   │       │  IP: 192.168.0.19    │
│  Port: 8200 (HTTP)   │       │  Port: 636 (LDAPS)   │       │                      │
│                      │       │  Port: 389 (LDAP)    │       │  User: a.testos      │
│  Services:           │       │  Port: 88 (Kerberos) │       │                      │
│  - HashiCorp Vault   │       │  Port: 53 (DNS)      │       │  Domaine: sednal.lan │
│  - Auth: LDAP        │       │                      │       │                      │
│                      │       │  Services:           │       │                      │
│  Domaine: sednal.lan │       │  - AD DS             │       │                      │
│  Hostname: VaultTrain│       │  - AD CS (CA)        │       │                      │
│                      │       │  - DNS Server        │       │                      │
│                      │       │  - LDAPS (TLS)       │       │                      │
│                      │       │                      │       │                      │
│                      │       │  Domaine: sednal.lan │       │                      │
│                      │       │  Hostname: AD-LDAP   │       │                      │
│                      │       │  FQDN: ad_ldap.      │       │                      │
│                      │       │        sednal.lan    │       │                      │
└──────────────────────┘       └──────────────────────┘       └──────────────────────┘
```

`-1.` Exporter les certificats LDAPS sur le `serveur vault` depuis le `serveur AD`
```
scp C:\Users\Administrator\Desktop\CA-Certificat.cer sednal@192.168.0.250:/home/sednal/cert_CA
```

`-2.` Convertir CER en CRT
```
openssl x509 -inform der \
    -in /home/sednal/cert_AD/CA-Certificat.cer \
    -out /home/sednal/cert_AD/CA-Certificat.crt
```

`-3.` Intégrer le certificat

- Copiez le certificat dans le bon répertoire
```
sudo cp /home/sednal/cert_AD/CA-Certificat.crt /usr/local/share/ca-certificates/
```

- Mettez à jour les certificats de confiance
```
sudo update-ca-certificates
```

  -Sortie

<img width="886" height="117" alt="image" src="https://github.com/user-attachments/assets/ec702229-cf23-4787-b6c5-ee3dd4e40e45" />

`-4.` Autoriser Auth Ldap
```
vault auth enable ldap       
```

`-5.` Configuration Auth Vault
```
vault write auth/ldap/config \
    url="ldaps://ad_ldap.sednal.lan:636" \
    binddn="CN=antoine testos,CN=Users,DC=sednal,DC=lan" \
    bindpass="[MOT_DE_PASSE]" \
    userdn="CN=Users,DC=sednal,DC=lan" \
    userattr="sAMAccountName" \
    groupdn="CN=Users,DC=sednal,DC=lan" \
    groupfilter="(&(objectClass=group)(member:1.2.840.113556.1.4.1941:={{.UserDN}}))" \
    groupattr="cn" \
    insecure_tls=false \
    starttls=false
```

<img width="390" height="27" alt="image" src="https://github.com/user-attachments/assets/851c0f25-4496-40bd-9178-d7b90fa20c95" />

### **[EXPLICATION]**
       
        url="ldaps://ad_ldap.sednal.lan:636"
        # Adresse LDAPS du contrôleur de domaine (protocole sécurisé, port 636)
        
        binddn="CN=antoine testos,CN=Users,DC=sednal,DC=lan"
        # Compte que Vault utilise pour se connecter à l'AD (Distinguished Name complet)
        
        bindpass="[MOT_DE_PASSE]"
        # Mot de passe du compte binddn
        
        userdn="CN=Users,DC=sednal,DC=lan"
        # Où chercher les utilisateurs dans l'arborescence AD
        
        userattr="sAMAccountName"
        # Attribut AD utilisé pour identifier l'utilisateur (ex: a.testos)
        
        groupdn="CN=Users,DC=sednal,DC=lan"
        # Où chercher les groupes dans l'arborescence AD
        
        groupfilter="(&(objectClass=group)(member:1.2.840.113556.1.4.1941:={{.UserDN}}))"
        # Filtre LDAP pour trouver tous les groupes dont l'utilisateur est membre (inclut les groupes imbriqués)
        
        groupattr="cn"
        # Attribut du groupe à utiliser comme nom (cn = Common Name, ex: "Domain Admins")
        
        insecure_tls=false
        # Vérifier le certificat SSL (false = sécurisé, true = accepter tout certificat)
        
        starttls=false
        # Ne pas utiliser STARTTLS (car on utilise déjà LDAPS natif sur le port 636)


`-6.` policy
```
sudo nano vault-config/policies/use/user_ldap.hcl
```

- Éditer
```
path "secret/*" {
  capabilities = ["read", "list"]
}
```

- Mappage
```
vault policy write testos-policy user_ldap.hcl
vault write auth/ldap/users/a.testos policies=testos-policy
```

`-7.` Tester la configuration 

### **Depuis le serveur Vault**
```
vault login -method=ldap username=a.testos
```

Tout est OK :

<img width="1079" height="303" alt="image" src="https://github.com/user-attachments/assets/30d18701-6152-4888-95d6-7407f670921b" />

### **Depuis le Client a.testos**

` Test de Connection depuis la machine Win 10`

- pointer le serveur 192.168.0.250 (Linux debian 13)
```
$env:VAULT_ADDR = "http://192.168.0.250:8200"
```

- Authentification en LDAPS
```
vault login -method=ldap username=a.testos
```

-Résultat 

<img width="837" height="415" alt="image" src="https://github.com/user-attachments/assets/0d98ae52-a409-4aeb-85f7-d04214e62209" />


