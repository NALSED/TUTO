# Création PKI

---

Dans cette section, sera abordé le montage et configuration de la PKI, crations des certificats et gestion des rôles.

---

## **SOMMAIRE**

### `-1-`**Création de la PKI**

### `Génération Certifiacts RSA`

### ``

---

`[NOTE]`

Les bonnes pratiques voudraient que le `Root Token` ne soit utilisé que pour la configuration initiale de Vault.
Il doit ensuite être `révoqué`, et remplacé par des accès configurés selon le principe du `moindre privilège`.

Dans le cadre de cette présentation, et pour des raisons `pédagogiques`, nous utiliserons toutefois ce Root Token.


### `-1-`  Création de la PKI

### `1.1` Création du fichier Policies

`[NOTE]`

Les policies sont en quelque sorte les droits propre à l'infra de Vault.

Plus d'info [ICI](https://developer.hashicorp.com/vault/docs/concepts/policies)

- Création
````
sudo vim /etc/vault/pki/config/policy/Policy_PKI.hcl
````


### `1.2` Edition du fichier Policies
````
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
path "PKI-Sednal-Root-RSA*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo", "patch" ]
}

# Accès complet au moteur PKI Intermediate RSA
path "PKI-Sednal-Inter-RSA*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo", "patch" ]
}
````

### `1.3` Droits
````
chown vault:vault /etc/vault/pki/config/policy/Policy_PKI.hcl
````

### `1.4` Editer dans Vault
````
vault policy write sednal-pki /etc/vault/pki/config/policy/Policy_PKI.hcl
````

---
---

### `-2-` **Génération Certifiacts RSA**






























