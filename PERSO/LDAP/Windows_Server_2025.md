# Installation et configuration du role LDAPS sur Windows Server 2025 via ADCS

---

Pour les besoins d'un test de connection via `Ldap` sur le logiciel [Vault](https://github.com/NALSED/TUTO/tree/main/PERSO/VAULT), mise en place d'un LDAPS, avec création de certifcats Ssl avec le Role `ADCS`.


---

1️⃣ `Role ADCS et Certificat`
2️⃣ `LDAPS`
3️⃣


---


### 1️⃣ **Role ADCS et Certificat**

#### - `AD CS` (Active Directory Certificate Services)

    - Met en place une **PKI** dans Active Directory  
    - Émet et gère des **certificats numériques**  
    - Sert à l’authentification, au chiffrement et à la sécurisation des communications.
    - Passer de LDAP à LDAPS

#### - `Types de déploiement AD CS`

- `1 serveur`
  - **CA d’entreprise (Enterprise CA)**  
  => Solution simple, intégrée à Active Directory, adaptée aux petits environnements.

- `2 serveurs`
  - **CA racine autonome (Root CA)**  
    => Autorité principale, généralement hors ligne pour plus de sécurité.
  - **CA intermédiaire d’entreprise (Subordinate CA)**  
    => Émet les certificats aux utilisateurs et machines, intégrée à Active Directory.




---

### 2️⃣ **LDAPS**
