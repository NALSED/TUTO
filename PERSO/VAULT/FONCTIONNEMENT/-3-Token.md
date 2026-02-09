# Présentation Token dans Vault.

---

### 1️⃣ `Durée de vie des token`
### 2️⃣ ``
### `COMMANDES`
---

### 1️⃣ **Durée de vie des token**

Deux manières d'implémenter une durée de vie aux tokens : le `TTL` (time to live) et la `Révocation`.

[EXEMPLE]

 <img width="877" height="860" alt="image" src="https://github.com/user-attachments/assets/16ce2f76-7b33-40a8-bfaa-e72ea72e075e" />

Sur le shéma (montre un service token) ci-dessus on voit que le token `A` à créé le token `B` et `C` avec des TTL différent, on peux aussi noter que `B` et `C` sont parent.

`A` parent => `B`
`B` enfant => `A` et Le token `G` est quand à lui orphelin.

---

### **COMMANDES**
