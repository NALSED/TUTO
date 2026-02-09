# Les clées et tokens dans Vault.

---

Ici seront traité les Unseal Keys, Master Keys, Root Token et L'Encryption Key Ring.

### 1️⃣ `Unseal Keys`
### 2️⃣ `Root Token`
### 3️⃣ `Master Keys`
### 4️⃣ `L'Encryption Key Ring`

---

### 1️⃣ **Unseal Keys**

⚠️ Point trés important sur Vault : Les `unseal keys` servent à `reconstituer la master key en mémoire` pour passer de l'état SEALED à UNSEALED.

Par exemple après  un redémarrage, crash, maintenance etc ...  la master key disparaît de la mémoire. Les données sur disque restent chiffrées et inaccessibles sans cette clé.
Protection contre le vol physique : Même si quelqu'un vole le serveur ou le disque dur, les données restent chiffrées car la master key n'est pas stockée avec elles.

Les `Unseal Keys` sont attribuées lors de la première initialisation de Vault. Leur nombre est configurable, mais par défaut, 5 clés sont créées.
Après l’installation de Vault, suite à l’exécution de la commande vault operator init, le message suivant apparaît :


     / # vault operator init
            Unseal Key 1: [...] 
            Unseal Key 2: [...]
            Unseal Key 3: [...]
            Unseal Key 4: [...]
            Unseal Key 5: [...]
            
            Initial Root Token:  [...]
            
            Vault initialized with 5 key shares and a key threshold of 3. Please securely
            distribute the key shares printed above. When the Vault is re-sealed,
            restarted, or stopped, you must supply at least 3 of these keys to unseal it
            before it can start servicing requests.
            
            Vault does not store the generated root key. Without at least 3 keys to
            reconstruct the root key, Vault will remain permanently sealed!
            
            It is possible to generate new unseal keys, provided you have a quorum of
            existing unseal keys shares. See "vault operator rekey" for more information.

Ces clés sont des fragments de la master key, divisée selon l’algorithme de partage de secret de Shamir. Un seuil minimum de clés est nécessaire (et configurable) pour reconstituer la master key en mémoire.

📝 **Criticité** : Très élevée. Elles doivent être :

- Stockées séparément et en sécurité

- Distribuées à différentes personnes de confiance

- Jamais stockées ensemble

- Sauvegardées de manière sécurisée (coffre-fort physique, HSM, etc.)

---

### 2️⃣ **Root Token**

Le `Root Token` est lui aussi fourni par Vault lors de la première initialisation, il est léquivelent de root sur linux => c'est Token avec les `privilèges absolus` sur Vault.

Il peut : 
- Tout lire, écrire, supprimer

- Créer des politiques

- Gérer l'authentification

- Configurer tous les aspects de Vault


📝 **Criticité** : Maximale. Bonnes pratiques :

- Le révoquer après la configuration : `vault token revoke <root-token>`

- Ne jamais le stocker en clair

- Utiliser des jetons avec moins de privilèges pour les opérations quotidiennes

- Le régénérer avec `vault operator generate-root` si nécessaire (nécessite les unseal keys)


---


### 3️⃣ **Master Keys**

Créée automatiquement lors de l'initialisation, mais jamais visible directement.

C'est la clé qui chiffre toutes les données dans le backend de stockage de Vault. Elle protège l'encryption key ring qui contient les clés utilisées pour chiffrer vos secrets.

📝 **Criticité** : Extrême. 

Si elle est compromise, toutes vos données sont exposées. Heureusement, Vault ne stocke jamais cette clé en clair - elle est elle-même protégée par l'algorithme de Shamir.


---

### 4️⃣ `L'Encryption Key Ring`

L'encryption key ring (ou keyring) est un concept crucial dans Vault. 

Le key ring est une collection de clés de chiffrement utilisées par Vault pour chiffrer et déchiffrer les données des secrets. C'est essentiellement un trousseau de clés cryptographiques.
Vault supporte la rotation automatique des clés de chiffrement sans rechiffrer toutes les données existantes.

- Avec la commande `vault operator rotate`, voilà ce que fait Vault :

- Une nouvelle clé (version 3) est ajoutée au key ring

- Les nouveaux secrets sont chiffrés avec la clé v3

- Les anciens secrets restent chiffrés avec leurs clés d'origine (v1, v2)

Vault sait quelle version de clé utiliser (Grace aux métadonnées) pour déchiffrer chaque secret.

- Fonctionnement SEAL / UNSEAL

**Tant que Vault est sealed :**

- Le key ring existe sur disque mais est chiffré

- La master key n'est pas en mémoire

- Le key ring est inaccessible

**Quand Vault est unsealed :**

- La master key est reconstituée en mémoire

- Le key ring est déchiffré en mémoire

- Vault peut chiffrer/déchiffrer les secrets


```
┌─────────────────────────────────────┐
│     Unseal Keys (3 sur 5)           │
│  (Fragments de la Master Key)       │
└──────────────┬──────────────────────┘
               ↓
    ┌──────────────────────┐
    │    Master Key        │  ← Reconstituée en mémoire
    │  (jamais stockée)    │     lors du unseal
    └──────────┬───────────┘
               ↓ Chiffre/Déchiffre
    ┌──────────────────────┐
    │  Encryption Key Ring │  ← Stocké chiffré sur disque
    │  ┌────────────────┐  │
    │  │ Key Version 1  │  │
    │  │ Key Version 2  │  │
    │  │ Key Version 3  │  │
    │  │     ...        │  │
    │  └────────────────┘  │
    └──────────┬───────────┘
               ↓ Chiffre/Déchiffre
    ┌──────────────────────┐
    │   Vos secrets        │  ← Stockés chiffrés
    │  (dans le backend)   │
    └──────────────────────┘
```


