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

Ici, nous développerons le cas d’un serveur unique.

`[Prérequis]`

- Role ADDS installé
- Ici ip via DHCP et entrer sur domaine local (192.168.0.252 / ad_ldap.sednal.lan) 

- Récapitultif `AD`

<img width="674" height="475" alt="image" src="https://github.com/user-attachments/assets/96b8e66c-41b6-4de9-b039-de41311ae4ee" />


`-1.` Installation Role ADCS

- Add Roles and Features => Suivre l'installation d’ADCS => On garde la première option par défaut `Certification Authority`

<img width="349" height="172" alt="image" src="https://github.com/user-attachments/assets/373fc084-27b9-440c-ab4f-a8ef814ae95b" />

### - Pour finir de l'installation du rôle => etre connecté en Administrateur :

<img width="754" height="557" alt="image" src="https://github.com/user-attachments/assets/c313b3b5-d24f-4c87-9dc3-f8bf32a08ee1" />

### - Cocher le/les service souhaités :

<img width="759" height="560" alt="image" src="https://github.com/user-attachments/assets/c1a0812a-48b0-4459-a32e-2b752372491e" />

### - Entreprise CA (1 serveur)

<img width="755" height="558" alt="image" src="https://github.com/user-attachments/assets/6f40c747-f7a0-4409-bcde-d7523c1bf593" />

### - Root CA

<img width="749" height="556" alt="image" src="https://github.com/user-attachments/assets/50e0c80d-2e36-4c64-b6a7-a6d2304cc897" />

### - Create new private key 

<img width="757" height="561" alt="image" src="https://github.com/user-attachments/assets/b5fb9f7b-8e88-4419-9bb4-d7ae0b6b70d0" />

### - SHA512 et 4096

<img width="758" height="558" alt="image" src="https://github.com/user-attachments/assets/3d0c0b5b-c40d-427d-8707-e9c03fd2ab2e" />

### - Renseigner CA Name

<img width="757" height="549" alt="image" src="https://github.com/user-attachments/assets/991cf95a-5387-4264-903b-7f6b349ef5cb" />

### - Validitée

<img width="748" height="554" alt="image" src="https://github.com/user-attachments/assets/3a35d109-8c11-4d4c-95a7-015aadfa80aa" />

### - Localisation du Certificat

<img width="760" height="558" alt="image" src="https://github.com/user-attachments/assets/acd813d8-0d60-45a2-9ed0-dfac81290a48" />

- trouver la concole de gestion de certification :

<img width="639" height="785" alt="image" src="https://github.com/user-attachments/assets/2188d14f-bd57-4337-8fde-b39e62b6726e" />

<img width="634" height="719" alt="image" src="https://github.com/user-attachments/assets/d91d1882-ebe9-439c-a2d1-b85f0156126c" />

<img width="1120" height="589" alt="image" src="https://github.com/user-attachments/assets/10d9b656-a8e7-4bb1-9857-7ef7888d98fb" />

**[Bonne Pratique]**

- Se rendre dans Active Directory User and Computers

<img width="727" height="312" alt="image" src="https://github.com/user-attachments/assets/76f330a3-ccc4-4f5d-80e1-7035d53227e0" />

- Chercher `Cert Publishers` => Clic droit => Properties => Members => Remove  
Ce privilège est là uniquement pour l'installation du rôle CA. Pour des raisons de sécurité, il est conseillé de le supprimer.

<img width="883" height="494" alt="image" src="https://github.com/user-attachments/assets/674a1350-0da6-480f-8884-67fd0528fd30" />

**Retrouver le certificat**

1. tapper win + R => mmc

2. File => Add/Remove Snap-in...

<img width="364" height="330" alt="image" src="https://github.com/user-attachments/assets/466885b8-c34c-4e50-89db-ca4f4170f026" />

3. Cetificates => Add

<img width="784" height="541" alt="image" src="https://github.com/user-attachments/assets/130b2270-98c9-4413-b8bb-0488a6b42833" />

4. Computer account

5. Local computer => Finish

6. OK

<img width="1083" height="563" alt="image" src="https://github.com/user-attachments/assets/70c769a9-9c0f-4a5a-abfd-5f7b162010d3" />

















---

### 2️⃣ **LDAPS**
