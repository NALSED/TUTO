# Configuration Du Rôle PKI, sur le Serveur Vault.

---

### 1️⃣ `Création Policy` [Accès rapide]()
### 2️⃣ `Configuration PKI` [Accès rapide]()
### 3️⃣ `Demande de Certificats` [Accès rapide]()
### 4️⃣ `Renouvelement` [Accès rapide]()

---

## 1️⃣ **Création Policy** [Accès rapide]()

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

## 2️⃣ **Configuration PKI** [Accès rapide]()

---

## 3️⃣ **Demande de Certificats** [Accès rapide]()

---

## 4️⃣ **Renouvelement** [Accès rapide]()
