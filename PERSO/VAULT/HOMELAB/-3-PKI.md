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

### `- 1.1` Création du fichier Policies

`[NOTE]`

Les policies sont en quelque sorte les droits propre à l'infra de Vault.

Plus d'info [ICI](https://developer.hashicorp.com/vault/docs/concepts/policies)

- Création
````
sudo vim /etc/vault/pki/config/policy/Policy_PKI.hcl
````


### `- 1.2` Edition du fichier Policies
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

### `- 1.3` Droits
````
chown vault:vault /etc/vault/pki/config/policy/Policy_PKI.hcl
````

### `- 1.4` Editer dans Vault
````
vault policy write sednal-pki /etc/vault/pki/config/policy/Policy_PKI.hcl
````

---
---

### `-2-` **Génération Certificats RSA**

`[RAPPEL]`

Durée lease Certificats

- `Root` CA	RSA 4096	`25 ans`

- `Intermediate` CA	RSA 4096	`5 ans`

- `Finaux`	RSA 2048	`90 jours`

---

### `- 2.1` Activation du moteur PKI `CA ROOT`
````
vault secrets enable -path=PKI-Sednal-Root-RSA -max-lease-ttl=9132d pki
````


### `- 2.2` Génération de l'autorité du certification racine `CA ROOT`
````
vault write -field=certificate PKI-Sednal-Root-RSA/root/generate/internal \
  common_name="sednal.com" \
  issuer_name="Sednal-Root-R-1" \
  ttl=9132d \
  key_type=rsa key_bits=4096 \
  exclude_cn_from_sans=true \
| sudo tee /etc/vault/pki/cert_ca/root/Sednal_Root_R-1.crt > /dev/null
````
### `- 2.3` Droit `CA ROOT`
````
sudo chown vault:vault /etc/vault/pki/cert_ca/root/Sednal-Root-R-1.crt
````

### `- 2.4` Génération et distibution de la CRL `CA ROOT`
````
vault write PKI-Sednal-Root-RSA/config/urls \
    issuing_certificates="https://vault.sednal.lan/v1/PKI-Sednal-Root-RSA/ca" \
    crl_distribution_points="http://infra.sednal.lan/crl/root-r"
````

---

### `- 2.5` Activation du moteur PKI `CA INTER`
````
````


### `- 2.6` Génération de l'autorité du certification racine `CA INTER`
````

````
### `- 2.7` Droit `CA INTER`
````
````

### `- 2.8` Génération et distibution de la CRL `CA INTER`
````

````


















### `- `

### `- `



























