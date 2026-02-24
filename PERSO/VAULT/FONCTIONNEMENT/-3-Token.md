# Présentation Token dans Vault.

---

### 1️⃣ `Présentation`
### 2️⃣ `Utilisation`
### `COMMANDES`
---

### 1️⃣ **Présentation**

-1. `Presentation token :`

Deux manières d'implémenter une durée de vie aux tokens : le `TTL` (time to live) et la `Révocation`.

-Hiérarchie TTL Vault 

````
System max_lease_ttl (limite absolue Vault)
         ↓ (peut réduire mais pas dépasser)
Backend max_lease_ttl (auth/token tune)
         ↓ (peut réduire mais pas dépasser)
Token -explicit-max-ttl (individuel)
````

`[EXEMPLE]`

 <img width="877" height="860" alt="image" src="https://github.com/user-attachments/assets/16ce2f76-7b33-40a8-bfaa-e72ea72e075e" />

Sur le shéma (montre un service token) ci-dessus on voit que le token `A` à créé le token `B` et `C` avec des TTL différent, on peux aussi noter que `B` et `C` sont parent.
Par défaut c'est le Token utilisé pour la connection à Vault qui détermine le parent, mais il est possible de choisir le token parent (voir commandes ⬇️ )

`A` parent => `B`
`B` enfant => `A` et Le token `G` est quand à lui orphelin.

---

Le TTL peut être prolongé, arrêté et avoir un temps maximum.
Ici, le TTL a été prolongé de 5 h ; la durée actuelle est de 4 h avec une durée maximale de 9 h.

<img width="346" height="363" alt="image" src="https://github.com/user-attachments/assets/ae8903b1-f7d2-4db3-b5eb-d04573375207" />

---

-2. `Actions possible`

-2.1 Renew

Le TTL arrive à expiration on peux le renouveler, soit d'une valeur par defaut, soit une valeur déterminée.

-2.2 Revoked

Un token peut être révoqué manuellement ou à expiration du TTL

---

-3. `Les deux Familles de Token`

=== Token standard ===

Limité dans le temps (TTL), expiration automatique.

<img width="343" height="364" alt="image" src="https://github.com/user-attachments/assets/c548c2af-dde7-4315-b3fa-9d37971fa753" />

===Token avec privilège ===

- Periodic token :
Renouvelable indéfiniment, utile pour les jobs long terme.

<img width="345" height="403" alt="image" src="https://github.com/user-attachments/assets/3a374e1f-827d-4c17-87dc-76a6cb4d3ca0" />

- Root token :
Token avec les privilèges absolus sur Vault.

`[NOTE]` 
Bonne pratique : l’utiliser une seule fois pour configurer Vault, puis le révoquer ou générer des tokens avec moins de privilèges pour l’usage quotidien.

<img width="337" height="307" alt="image" src="https://github.com/user-attachments/assets/d2bc4fde-86c8-44cc-86c7-4fa28ed7f68f" />



`[RESUME]`

<img width="1271" height="568" alt="image" src="https://github.com/user-attachments/assets/cecc1dcd-24bd-4875-a72b-edde21d75aa0" />

---
---

### 2️⃣ **Utilisation**
`[NOTE]`

| Type de jeton        | Vault 1.9.x ou versions antérieures | Vault 1.10 et versions ultérieures |
|---------------------|--------------------------------------|------------------------------------|
| Service Token    | `s.<random>`                         | `hvs.<random>`                     |
| Batch Token        | `b.<random>`                         | `hvb.<random>`                     |
| Recovery Token | `r.<random>`                       | `hvr.<random>`                     |


-2.1. `Token accessor`

- Clé d’authentification permettant de récupérer des information  
- Associé à des **policies** qui définissent les permissions (read, write, list, etc.)  
- Possède une **durée de vie (TTL)**  
- Peut être **renouvelable** ou **révoqué**


-2.3. `Token Type`

<img width="1452" height="500" alt="image" src="https://github.com/user-attachments/assets/122907e7-6f18-4228-a64f-ca4d3827c9d6" />

- Service Token vs Batch Token (Vault)

**Service Token**

- Token `persistant`
- Stocké par Vault (état conservé)
- Peut être `renouvelé`
- Peut créer d’autres tokens
- Idéal pour les `services / applications long-running`
- Peut être explicitement `révoqué`

**Batch Token**

- Token `éphémère` et `stateless`
- Non stocké par Vault (plus léger)
- `Non renouvelable`
- Ne peut pas créer d’autres tokens
- Expire automatiquement
- Idéal pour les `jobs courts / CI / scripts`

---



---
---

### **COMMANDES**

- `Voir les information d'un token`

       vault token lookup [token ou token accessor]



- Sortie

            sednal@VaultTraining:~$ vault token lookup [TOKEN]
            Key                 Value
            ---                 -----
            accessor            NeulGtbCoGPb0jsSx8khuI2G
            creation_time       1770706551
            creation_ttl        10m
            display_name        token
            entity_id           n/a
            expire_time         2026-02-10T08:05:51.97408552+01:00
            explicit_max_ttl    20m
            id                 
            issue_time          2026-02-10T07:55:51.974086504+01:00
            meta                <nil>
            num_uses            0
            orphan              false
            path                auth/token/create
            policies            [default]
            renewable           true
            ttl                 8m37s
            type                service
            
            sednal@VaultTraining:~$ vault token lookup -accessor NeulGtbCoGPb0jsSx8khuI2G
            Key                 Value
            ---                 -----
            accessor            NeulGtbCoGPb0jsSx8khuI2G
            creation_time       1770706551
            creation_ttl        10m
            display_name        token
            entity_id           n/a
            expire_time         2026-02-10T08:05:51.97408552+01:00
            explicit_max_ttl    20m
            id                  n/a
            issue_time          2026-02-10T07:55:51.974086504+01:00
            meta                <nil>
            num_uses            0
            orphan              false
            path                auth/token/create
            policies            [default]
            renewable           true
            ttl                 8m15s
            type                service



---


- `Augmenter la durée d'un token`

      vault token renew

- Sortie

      sednal@VaultTraining:/var/log$ vault token renew [TOKEN]
      Key                  Value
      ---                  -----
      token               
      token_accessor       DdI5TRGVtW9qtVLEWFd1kJDr
      token_duration       10m
      token_renewable      true
      token_policies       ["default"]
      identity_policies    []
      policies             ["default"]

---

- `MAX ttl system`

      ault read sys/auth/token/tune


---
 
- `Choisir le token Parent`
⚠️ Policies doivent être correct

      VAULT_TOKEN=[TOKEN] vault token create -ttl=600s -policy=default

[EXEMPLE SANS POLICIES]
     
      sednal@VaultTraining:~$ VAULT_TOKEN=[TOKEN] vault token create -ttl=600s -policy=default
      
      Error creating token: Error making API request.
      
      URL: POST http://127.0.0.1:8200/v1/auth/token/create
      Code: 403. Errors:
      
      * 1 error occurred:
              * permission denied
      
      
      sednal@VaultTraining:~$ TOKEN_ID=$(vault token create -ttl=60s -explicit-max-ttl=600s -policy=root -field=token)
      
      sednal@VaultTraining:~$ VAULT_TOKEN=$TOKEN_ID vault token create -ttl=600s -policy=default
      Key                  Value
      ---                  -----
      token                [TOKEN]
      token_accessor       yROjBXp6LNtjPmYN0r8c2iK7
      token_duration       10m
      token_renewable      true
      token_policies       ["default"]
      identity_policies    []
      policies             ["default"]

---

- `Révoquer un Token`

      vault token revoke - accessor yROjBXp6LNtjPmYN0r8c2iK7

- Sortie

         Success! Revoked token (if it existed)

---

- `Créer un token Batch`

      vault token create -type=batch -policy="default" -ttl=120s

- Sortie :

      Key                  Value
      ---                  -----
      token                [TOKEN]
      token_accessor       n/a <= PAS D'accessor
      token_duration       2m
      token_renewable      false <= NON renouvelable
      token_policies       ["default"]
      identity_policies    []
      policies             ["default"]

---
---

**[CHOSES A RETENIR]**

<img width="1740" height="817" alt="image" src="https://github.com/user-attachments/assets/d698d12e-299a-4333-9d07-ad9ea975f826" />

<img width="1260" height="773" alt="image" src="https://github.com/user-attachments/assets/7e10ac50-8050-4b31-bc96-c5316a681eb6" />
