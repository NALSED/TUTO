# Installation et configuration du role LDAPS sur Windows Server 2025 via ADCS

---

Pour les besoins d'un test de connection via `Ldap` sur le logiciel [Vault](https://github.com/NALSED/TUTO/tree/main/PERSO/VAULT), mise en place d'un LDAPS, avec création de certifcats Ssl avec le Role `ADCS`.


---

1️⃣ `Role ADCS et Certificat`

2️⃣ `LDAPS`

---


### 1️⃣ **Role ADCS et Certificat**

#### -Présentation role `AD CS` (Active Directory Certificate Services)

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

Ici, nous développerons le cas d’un serveur unique. ⬆️

---

`[Prérequis]`

- Role ADDS installé
- Ici ip via DHCP et entrer sur domaine local (192.168.0.252 / ad_ldap.sednal.lan) 

- Récapitultif `AD`

<img width="674" height="475" alt="image" src="https://github.com/user-attachments/assets/96b8e66c-41b6-4de9-b039-de41311ae4ee" />

---

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

### `[NOTE]` trouver la concole de gestion de certification :

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

### `[NOTE]` ⚠️ Ici, c'est une phase de test, donc on gère l'enregistrement DNS via pfSense. Mais en environnement de production, un flux comme ci-dessous est conseillé.
### La déclaration DNS resolver et le FQND du certificat doit être identique.

- Ici

<img width="1135" height="33" alt="image" src="https://github.com/user-attachments/assets/54a622e7-6bfc-4e13-b2dc-3f0711d26b75" />

#### **Architecture DNS Production - pfSense + Active Directory**

 📊 `Schéma d'architecture`


         ┌─────────────────────────┐
         │       Clients           │
         │   (DHCP DNS = pfSense)  │
         └───────────┬─────────────┘
                     │
                     v
         ┌───────────────────────────┐
         │         pfSense           │
         │   DNS Resolver (Unbound)  │
         │   • Cache DNS             │
         │   • Forwarding Mode       │
         │   • Host Overrides        │
         └───────────┬───────────────┘
                     │
                     v Forward sednal.lan
         ┌─────────────────────────────┐
         │      DC1 <────────> DC2     │
         │  • Zone: sednal.lan         │
         │  • Réplication AD           │
         │  • Enregistrements DNS      │
         └─────────────────────────────┘

`- Configuration`

### pfSense
- **DNS Resolver**: Enabled + Forwarding Mode
- **DNS Servers**: `IP_DC1`, `IP_DC2`
- **DHCP**: DNS = `IP_pfSense`
- **Host Overrides**: Services hors domaine uniquement

### Domain Controllers
- **Zone**: `sednal.lan` (réplication AD automatique)
- **Enregistrements**: Gérés sur les DC
- **Redondance**: DC1 ↔ DC2

---

### `I` **Création du template de certificat**

`-1.` Créer un Certificat

Win + R

        certsrv.msc


`-2.` Dans certsrv => ouvrir le menue certificat => clic droit : Certificate Templates => Manage

<img width="1308" height="819" alt="image" src="https://github.com/user-attachments/assets/6df2e3d3-cdfd-46b3-bfed-a477c4332544" />


`-3.` Kerberos Authentification => clic droit : Duplicate Template

<img width="455" height="642" alt="image" src="https://github.com/user-attachments/assets/1dfd26bf-7887-493a-9408-bdc8b4ddecd5" />

`-4.` Onglet : General => Renseigner un Nom => ici `LDAPS`

`-5.` Onglet : Request Handling => cocher Allow private key to be exported

<img width="399" height="556" alt="image" src="https://github.com/user-attachments/assets/a80a173f-98d3-4f89-80de-564a16e54f64" />

`-6.` Onglet : Subject Name => Supply in the request , message alerte normal

<img width="541" height="613" alt="image" src="https://github.com/user-attachments/assets/01203365-5ab7-41e1-9ba5-9b6e87b296e6" />

`-7.` Onglet : Security pour respecter la politique de sédcurité du message précédent :

- garder uniquement :
   - Authenticated Users => read only 
   - Domain Admin => read , write , enroll
   - Domain Controllers => enroll, autoenroll
   - ENTREPRISE DOMAIN CONTROLLERS => enroll, autoenroll

---


### `II` **Edition du certificat**

`-1.` Retrouver le template

win + R

      certsrv.msc

`-2.` Clic droit : Certificate Templates => New => rechercher le certificat LDAPS

<img width="801" height="469" alt="image" src="https://github.com/user-attachments/assets/a459fd57-b0c4-4104-bc19-e5738d4ab0a0" />

Le certificat est maintenant disponible pour les machines ayant les permissions.

---


### `III` **Demande de certificat**

`-1.` Ouvrir une console `mmc` (Console Root)

win + R

      mmc

`-2.` Add/Remove Snap-in...

<img width="348" height="331" alt="image" src="https://github.com/user-attachments/assets/f168f8de-a385-4cf3-bce9-0bcf38b2de3c" />

`-3.` Certificates => Add => Computer account => local computer => OK

<img width="378" height="338" alt="image" src="https://github.com/user-attachments/assets/f863ea45-7108-4da6-99d0-e8b5ca7335f1" />


`-4.` Dérouler Certificates (Local computer) => Personal => Certificates => All Tasks => Request New Certificate

<img width="592" height="267" alt="image" src="https://github.com/user-attachments/assets/9fe64665-c6d8-42b5-a800-302978dff980" />

`-5.` Next => Next, Ici dans Active Directory Enrollment Policy, `LDAPS` devrait apparaître => cocher LDAPS et cliquer sur le texte en bleu


`-6.` Renseigner le CN et DNS (ils doivent être les même que les enregistrement DNS de pfsense); ainsi que celui de l'adds.

<img width="499" height="507" alt="image" src="https://github.com/user-attachments/assets/bb62feb8-71f0-44cc-bc16-78d6450c9bdd" />

- OK => Enroll

-Dans la partie Personal => Certificates : on peux retrouver les certificats

<img width="1129" height="631" alt="image" src="https://github.com/user-attachments/assets/e751eb02-5fc7-4c78-b1dd-8efbb251e14a" />



`-7.` `[SECURITE]` Un fois les certificats édités, supprimer le template LDAPS.

<img width="754" height="524" alt="image" src="https://github.com/user-attachments/assets/71a01ee0-9bf1-4c4c-a500-3d2adfdae8a8" />


### `IV` **Exporter le certificat LDAPS**


`-1.` Sur le certificat => Clic droit : All Tasks => Export

<img width="875" height="325" alt="image" src="https://github.com/user-attachments/assets/5e1c9b40-d8ee-49c4-9204-0071d9f30287" />


`-2.` Exporter avec la clé privée 

<img width="533" height="522" alt="image" src="https://github.com/user-attachments/assets/e766f363-9e28-4da6-9d65-466141b66626" />


`-3.` Next

<img width="532" height="519" alt="image" src="https://github.com/user-attachments/assets/83c90122-8784-4829-ae8f-37f76071cac4" />


`-4.` Group or user names

<img width="532" height="518" alt="image" src="https://github.com/user-attachments/assets/a1001f6b-44a5-4758-ab9f-f719b35c1bd0" />


`-5.` Browse et renseigner un nom de fichier
 
<img width="1193" height="701" alt="image" src="https://github.com/user-attachments/assets/ae403f89-8e08-4aae-9885-ae274c310c1a" />

- Message réussite

<img width="177" height="130" alt="image" src="https://github.com/user-attachments/assets/29ef82d5-0e41-4dd7-b701-42d043c4eed2" />


`-6.` Exporter le CA 

- win + R : mmc
- File => Add/Remove Snap-in...
- Certificates => Add => Computer account => Local computer => Ok

<img width="496" height="634" alt="image" src="https://github.com/user-attachments/assets/912b84ae-b34b-4266-9399-8d2481cbdd10" />

clic droit sur le certificat, All Task => Export => Suivre l'assistant


### `V` **TEST**


`-1.` Test sur Windows Serveur 2025

⚠️ Les outils d'aministration ADDS doivent être installés ⚠️

`[VERIFICATION]`

Dans => Add Roles and Features Wizard :

         - Features
             └── Remote Server Administration Tools (5 of 43 installed)
                  └── Role Administration Tools (5 of 27 Tools)
                       └── AD DS and AD LDS Tools (3 of 4 Installed)
                           └── AD DS Tools (Installed) 
                                 🟢 ICI AD DS Snap-Ins and Command-Line Tools => Doit être installé


- Après cette Vérification : 

`-1.` rechercher `ldp`

<img width="773" height="332" alt="image" src="https://github.com/user-attachments/assets/c1178562-e58d-4922-9821-08690d21c6d8" />

`-2.` Connection => Connect...

<img width="189" height="229" alt="image" src="https://github.com/user-attachments/assets/193ddb60-0353-43b4-a1ad-e80325280cc8" />

`-3.` Renseigner le FQND du serveur AD + Port LDAPS + SSL => OK

-Résultat attendu :

<img width="1202" height="903" alt="image" src="https://github.com/user-attachments/assets/1ff0cbdb-510e-495b-99e4-2510e288137b" />


---

`-2.`Le serveur Adds avec la configuration `Ldaps` est sur un VM en 192.168.0.252, sur mon poste en 192.168.0.235 :

         Test-NetConnection -ComputerName ad_ldap.sednal.lan -Port 636

<img width="744" height="191" alt="image" src="https://github.com/user-attachments/assets/33d03eec-ae81-4f3b-8228-cedd8f90d97e" />

---

`-3.` Test sur le serveur Vault => 192.168.0.250 

-Ici c'est un machine Linux Debian 13, le certificat de l'AD (192.168.0.252), est déployé sur le serveur Vault, pour la marche à suivre voir [Ici](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/FONCTIONNEMENT/-5-Authentification.md#-3-ldaps)

`-1.` Installer le paquet `ldap-utils`

      sudo apt update && sudo apt -y install ldap-utils

`2.` Tester avec `ldapsearch`

      ldapsearch -x -H ldaps://ad_ldap.sednal.lan:636 \
     -D "a.testos@sednal.lan" \
     -W \
     -b "DC=sednal,DC=lan" \

-Sortie Attendu (extrait) 

### - 🧔 **USER**

<img width="655" height="698" alt="image" src="https://github.com/user-attachments/assets/596a78f0-84a8-41ac-afdc-af4d34a3de0e" />

### - 💻 **MACHINE**

<img width="658" height="825" alt="image" src="https://github.com/user-attachments/assets/e45e434c-4714-4b5b-a341-d395e410f9d2" />

  
---
---

**La suite concerne le Test LDAPS avec Vault**

<details>
<summary>
<h2>
Tuto complet 
</h2>
</summary>

**Labs** 

- Windows Serveur 2025 : 192.168.0.252 : ADDS / ADCS / LDAPS

- Serveur Vault : 192.168.0.250 : Vault configuré en ldap

- Client pour le test

---
 
`-1.` Clic droit sur ADDS => Active Drectory User and Computers => Users => Clic Droit => New User
- Suivre l'assistant de création

<img width="431" height="374" alt="image" src="https://github.com/user-attachments/assets/b31d3ae3-30d3-4083-b0bd-a1d218aee4d3" />

Password => Azerty*

`-2.` Pour le test Création d'une VM Win 11, faire entrer le poste sur le domaine, installer Vault.

**2.1** Configuration de Vault : Voir [ICI](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/FONCTIONNEMENT/-5-Authentification.md#-3-ldaps)

**ICI** Le test d'authentification sur le serveur Vault via ldaps, avec l'utilisateur `a.testos` est OK.

---

**2.2** Test Depuis le poste de a.testos => Win 10 

`2.2.1` Installation de Vault sur le Client 192.168.0.19
 
<img width="1009" height="403" alt="image" src="https://github.com/user-attachments/assets/c0584058-96a7-4800-9199-f8ee1e4793f4" />

`2.2.2` Test de Connection depuis la machine Win 10

- pointer le serveur 192.168.0.250 (Linux debian 13)

      $env:VAULT_ADDR = "http://192.168.0.250:8200"

- Authentification en LDAPS

      vault login -method=ldap username=a.testos


-Resultat 

<img width="837" height="415" alt="image" src="https://github.com/user-attachments/assets/0d98ae52-a409-4aeb-85f7-d04214e62209" />




</details>











