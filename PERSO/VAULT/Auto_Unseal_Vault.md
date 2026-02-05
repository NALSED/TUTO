# `Installation standard et Mise en place de l'Auto-unseal.`

---

Ce tutotriel à pour objectif : 

-1. La mise en place de certificat ssl pour que les serveur Vault soit en https,
-2. Le renouvelement automatique de ces certificats via systemd
-3. L'installation standard de vault en version ARM64 et AMD64.
-4. La configuration et la mise en place de l'aut-unseal via transit secret a

---
## 1️⃣ `Infra` [Accés rapide]()
## 2️⃣ `Certificats` [Accés rapide]() 
## 3️⃣ `Renouvelement` [Accés rapide]()
## 4️⃣ `Installation` [Accés rapide]()
## 5️⃣ `Configuration` [Accés rapide]()
## 6️⃣ `` [Accés rapide]()



---

## 1️⃣ `Infra`


#### 🥼 LAB 🥼

| IP               | Machine        | Détails RAM / CPU                | OS        |
|-----------------|----------------|---------------------------------|-----------|
| 192.168.0.241   | Raspberry Pi 4 | RAM: 1 GB<br>Processeur: ARM Cortex-A72 | Debian 13 |
| 192.168.0.242   | VM (VirtualBox)| RAM: 4 GB<br>Processeur: 2 cœurs     | Debian 13 |

---

### === SCHEMA ===
```
     === 192.168.0.241 ===                              === 192.168.0.242 ===
┌─────────────────────────────┐                    ┌─────────────────────────────┐
│          VAULT A            │                    │          VAULT B            │
│         Vault_Auto          │                    │         Vault_root          │
│                             │                    │                             │
│       Key Provider          │                    |        Auto-Unseal          │ 
│                             │                    │                             │
│  Port   : 8100              │   1 encrypt ───>   │  Port   : 8200              │
│  Storage: raft              │   2 decrypt <───   │  Storage: raft              │
│  Transit: activé            │                    │  Seal   : transit → Vault A │
│  Unseal : manuel            │                    │  Token  : env var           │
│  Dispo : 24/24              │                    │  Unseal : automatique       │
└─────────────────────────────┘                    └─────────────────────────────┘
        ↑                                                      ↑
        │                                                      │
  Unsealed en premier                              Se unseal automatiquement
  (vault operator init/unseal)                     via Vault A à chaque redémarrage
```

### Ordre de déploiement

```
1) Démarrer Vault A         
2) Init + Unseal Vault A     → vault operator init / unseal
3) Activer Transit sur A     → vault secrets enable transit
4) Créer la clé              → vault write transit/keys/autounseal
5) Créer policy + token      → pour autoriser Vault B
6) Démarrer Vault B          
```

- Prérequis
   -Pouvoir faire tourner Vault A 24h/24h ici => raspbery-pi 192.168.0.241
   - openssl
   - kleopatra (chiffrement GPG des clé vault)
   - DNS Resolver, Ici Pfsense.
   - Optionelle : VSC comme éditeur de texte.


---

=== PATH 192.168.0.241:8100===

     /etc/Vault
        |
        ├── CA_Vault/
        |   |
        |   ├── Cert/
        |   |   ├── public/
        |   |   |       └── CA.crt
        |   |   |
        |   |   └── private/
        │   |       └── CA.key   
        |   | 
        |   └── Config/
        |       └── CA_Vault.cnf
        |
        └── Vault_Auto/   
            |
            ├── Cert/
            |   ├── public/
            |   |   ├── CA.crt                
            |   |   └── Vault_Auto.crt
            |   |
            |   └── private/
            │       └── Vault_Auto.key
            |
            └── Config/
                    ├── Vault_Auto.hcl   
                    └── Vault_Auto.cnf


#### [Script déploiement dossier](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/Vault_auto_CA.sh)


=== PATH 192.168.0.242:8200===

      /etc/Vault
        | 
        └── Vault_Root/       
           |              
           ├── Cert/
           |   ├── public/
           |   |   ├── CA.crt
           |   |   └── Vault_Root.crt
           |   |
           |   └── private/
           |       └── Vault_Root.key    
           | 
           └── Config/
               ├── Vault_Root.hcl 
               └── Vault_Root.cnf  

#### [Script déploiement dossier](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/Vault_Root.sh)

-1. Créer le dossier via les scripts.
-2. Déclarer FQDN dans Pfsense

<img width="1144" height="81" alt="image" src="https://github.com/user-attachments/assets/3124aa98-3ae9-4bec-b408-064408dff0d3" />

`[NOTE]` ici `vault.sednal.lan` = Vault_Root, et `vault.sednal.lan` = Vault_Auto.


---

## 2️⃣ `Certificats`

-1. Création CA et certificat sur `192.168.0.241` 

-2. Création CA et certificat sur `192.168.0.238` 

-3. Déploiment Certificat + renouvelement auto via systemd


Ici `Vault_Auto` (192.168.0.241) sera toujours traiter en premier et `Vault_Root` (192.168.0.238) en second pour respecter l'odre de mise en place de `l'Auto-Unseal`.





-1. Création CA et certificat sur `192.168.0.241` 





-2. Création CA et certificat sur `192.168.0.238` 





-3. Déploiment Certificat + renouvelement auto via systemd











<details>
<summary>
<h2>

</h2>
</summary>
blabla
</details>


---



<details>
<summary>
<h2>

</h2>
</summary>
blabla
</details>


---




<details>
<summary>
<h2>

</h2>
</summary>
blabla
</details>


---




<details>
<summary>
<h2>
 
</h2>
</summary>
blabla
</details>


---



<details>
<summary>
<h2>
  
</h2>
</summary>
blabla
</details>


---




<details>
<summary>
<h2>

</h2>
</summary>
blabla
</details>


---



<details>
<summary>
<h2>

</h2>
</summary>
blabla
</details>


---



<details>
<summary>
<h2>
  
</h2>
</summary>
blabla
</details>
