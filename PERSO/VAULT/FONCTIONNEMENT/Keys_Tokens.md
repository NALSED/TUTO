# Les clées et tokens dans Vault.

---

Ici seront traité les Unseal Keys, Master Keys et Root Token.

### 1️⃣ `Unseal Keys`
### 2️⃣ `Master Keys`
### 3️⃣ `Root Token`

---

### 1️⃣ **Unseal Keys**

Les Unseal Keys sont attribuées à la premiére initialisation de Vault, leurs nombres est configurable mais par default 5 clées sont créées.
Après l'installation de Vault, suite à la commande `vault operator init` ce message apparait :

```
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
```
