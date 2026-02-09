# Présentation Token dans Vault.

---

### 1️⃣ `Durée de vie des token`
### 2️⃣ ``
### `COMMANDES`
---

### 1️⃣ **Durée de vie des token**

-1. `Presentation token :`

Deux manières d'implémenter une durée de vie aux tokens : le `TTL` (time to live) et la `Révocation`.

-Hiérarchie TTL Vault 

      1 System (config globale Vault)
                   |
                   v
      2 Mount (moteur auth/secrets)
                   |
                   v
      3 Role (rôle spécifique)
                   |
                   v
      4 Request (token/lease individuel)


[EXEMPLE]

 <img width="877" height="860" alt="image" src="https://github.com/user-attachments/assets/16ce2f76-7b33-40a8-bfaa-e72ea72e075e" />

Sur le shéma (montre un service token) ci-dessus on voit que le token `A` à créé le token `B` et `C` avec des TTL différent, on peux aussi noter que `B` et `C` sont parent.

`A` parent => `B`
`B` enfant => `A` et Le token `G` est quand à lui orphelin.

Le TTL peut être prolongé, arrêté et avoir un temps maximum.
Ici, le TTL a été prolongé de 5 h ; la durée actuelle est de 4 h avec une durée maximale de 9 h.

<img width="346" height="363" alt="image" src="https://github.com/user-attachments/assets/ae8903b1-f7d2-4db3-b5eb-d04573375207" />

-2. `Actions possible`

-2.1 Renew

Le TTL arrive à expiration on peux le renouveler, soit d'une valeur par defaut, soit une valeur déterminée.

-2.2 Revoked

Un token peut être révoqué manuellement ou à expiration du TTL

-3. `Type token`

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

### **COMMANDES**
