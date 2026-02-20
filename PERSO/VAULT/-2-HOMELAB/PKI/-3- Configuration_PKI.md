# Configuration Du Rôle PKI, sur le Serveur Vault.

---

### 1️⃣ `Création Policy` [Accès rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/-2-HOMELAB/PKI/-3-%20Configuration_PKI.md#1%EF%B8%8F%E2%83%A3-cr%C3%A9ation-policy-acc%C3%A8s-rapide-1)
### 2️⃣ `Configuration PKI` [Accès rapide]()
### 3️⃣ `Demande de Certificats` [Accès rapide]()
### 4️⃣ `Renouvelement` [Accès rapide]()

---

## 1️⃣ **Création Policy** 

`[NOTE]`
 Dans les bonnes pratiques, le **Root Token** ne doit être utilisé que pour la configuration initiale de Vault.  
 Il doit ensuite être **révoqué**, et remplacé par des accès configurés selon le principe du **moindre privilège**.  
  
 Dans le cadre de cette présentation, et pour des raisons pédagogiques, nous utiliserons toutefois ce Root Token.


`-1.1` Créer les policy Relative à la PKI
```
nano /etc/Vault/PKI/Config/Policy/Policy_PKI.hcl
```

`=>` - Editer
```
# Autoriser la gestion des moteurs de secrets (activation, suppression...)
# Nécessaire pour faire vault secrets enable/disable
path "sys/mounts/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# Autoriser la liste des moteurs de secrets actifs
# Nécessaire pour voir les PKI déjà montées
path "sys/mounts" {
  capabilities = [ "read", "list" ]
}

# Accès complet au moteur PKI Root RSA
# Couvre toutes les opérations : génération, signature, révocation, config...
# sudo requis pour certaines opérations sensibles comme config/urls
path "PKI_Sednal_Root_RSA*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo", "patch" ]
}

# Accès complet au moteur PKI Root ECDSA
path "PKI_Sednal_Root_ECDSA*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo", "patch" ]
}

# Accès complet au moteur PKI Intermediate RSA
# Couvre : émission certs leaf, gestion rôles, import CSR signé...
path "PKI_Sednal_Inter_RSA*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo", "patch" ]
}

# Accès complet au moteur PKI Intermediate ECDSA
path "PKI_Sednal_Inter_ECDSA*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo", "patch" ]
}
```



`-1.2` Editer dans Vault
```
vault policy write sednal-pki /etc/Vault/PKI/Config/Policy/Policy_PKI.hcl
```

---

## 2️⃣ **Configuration PKI** 

-Les certificats Root seront **cross-signés** entre RSA et ECDSA, 
offrant une compatibilité maximale avec tous les services.

-RSA est généré en premier — un service ne supportant pas ECDSA 
peut se rabattre sur RSA, mais l'inverse est impossible. 
-Le cross-signing crée un pont entre les deux chaînes de confiance.

-Pour plus de clarté, toute la génération suivra systématiquement 
cet ordre :

   -1. `=== RSA ===`
   -2. `=== ECDSA ===`



`-1.`





`-2.`

`-3.`

`-4.`

`-5.`

`-6.`

`-7.`

`-8.`

`-9.`

`-10.`

`-11.`

`-12.`

`-13.`

`-14.`

`-15.`

`-16.`

`-17.`

`-18.`

`-19.`

---

## 3️⃣ **Demande de Certificats** 

---

## 4️⃣ **Renouvelement** 
