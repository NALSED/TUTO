# Présentation Token dans Vault.

---

### 1️⃣ `Durée de vie des token`
### 2️⃣ ``

---

### 1️⃣ **Durée de vie des token**

Deux maniére d'implémenter une durée de vie aux token le TTL (time to live) et la révocation

Sur le shéma ci dessous on voit que le token `A` à créé le token `B` et `C` avec des TTL différent, on peux aussi noter que `B` et `C` sont parent.

`A` parent => `B`
`B` enfant => `A`

 Le token `G` est quand à lui orphelin

 <img width="877" height="860" alt="image" src="https://github.com/user-attachments/assets/16ce2f76-7b33-40a8-bfaa-e72ea72e075e" />
