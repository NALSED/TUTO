# Création PKI

---

Dans cette section, sera abordé le montage et configuration de la PKI, créations des certificats et gestion des rôles.

---

## **SOMMAIRE**

### `-1-` **Création de la PKI**

### `-2-` Génération Certificats RSA

### `-3-` Rôles PKI

---

`[NOTE]`

Les bonnes pratiques voudraient que le `Root Token` ne soit utilisé que pour la configuration initiale de Vault.
Il doit ensuite être `révoqué`, et remplacé par des accès configurés selon le principe du `moindre privilège`.

Dans le cadre de cette présentation, et pour des raisons `pédagogiques`, nous utiliserons toutefois ce Root Token.

---
---

## `-1-`  Création de la PKI

### `- 1.1` Création du fichier Policies

`[NOTE]`

Les policies sont en quelque sorte les droits propre à l'infra de Vault.

Plus d'info [ICI](https://developer.hashicorp.com/vault/docs/concepts/policies)

- Création
````
sudo vim /etc/vault/pki/config/policy/Policy_PKI.hcl
````

---

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

---

### `- 1.3` Droits
````
sudo chown vault:vault /etc/vault/pki/config/policy/Policy_PKI.hcl
sudo chmod 644 /etc/vault/pki/config/policy/Policy_PKI.hcl
````

---

### `- 1.4` Editer dans Vault
````
vault policy write sednal-pki /etc/vault/pki/config/policy/Policy_PKI.hcl
````

- Vérification
````
vault policy read sednal-pki
````

`[NOTE]`

À ce stade la policy `sednal-pki` existe mais n'est rattachée à **aucune méthode d'authentification** :
elle ne s'applique donc à personne. Les commandes qui suivent utilisent le `Root Token`.

Le rattachement (AppRole pour le Vault Agent) est traité dans `-4-Agent.md`.

---
---

## `-2-` **Génération Certificats RSA**

`[RAPPEL]`

Durée lease Certificats

- `Root` CA	RSA 4096	`25 ans`

- `Intermediate` CA	RSA 4096	`5 ans`

- `Finaux`	RSA 2048	`1 ans`

`[RAPPEL]`

Convention de nommage : `{émetteur}-{role}-{algo}-{génération}`

---

### `- 2.1` Activation du moteur PKI `CA ROOT`
````
vault secrets enable -path=PKI-Sednal-Root-RSA -max-lease-ttl=9132d pki
````

---

### `- 2.2` Génération de l'autorité de certification racine `CA ROOT`
````
vault write -field=certificate PKI-Sednal-Root-RSA/root/generate/internal \
  common_name="sednal.lan" \
  issuer_name="Sednal-Root-RSA-1" \
  ttl=9132d \
  key_type=rsa key_bits=4096 \
  exclude_cn_from_sans=true \
| sudo tee /etc/vault/pki/cert_ca/root/Sednal-Root-RSA-1.crt > /dev/null
````

---

### `- 2.3` Droits `CA ROOT`

- Propriétaire et Groupes
````
sudo chown vault:vault /etc/vault/pki/cert_ca/root/Sednal-Root-RSA-1.crt
````

- Autorisations
````
sudo chmod 644 /etc/vault/pki/cert_ca/root/Sednal-Root-RSA-1.crt
````

---

### `- 2.4` URLs de distribution `CA ROOT`

````
vault write PKI-Sednal-Root-RSA/config/urls \
    issuing_certificates="http://infra.sednal.lan/crl/Sednal-Root-RSA-1.crt" \
    crl_distribution_points="http://infra.sednal.lan/crl/Sednal-Root-RSA-1.crl"
````

---

### `- 2.5` Reconstruction automatique de la CRL `CA ROOT`

````
vault write PKI-Sednal-Root-RSA/config/crl \
    expiry=8760h \
    auto_rebuild=true \
    auto_rebuild_grace_period=720h
````

---
---

### `- 2.6` Activation du moteur PKI `CA INTER`
````
vault secrets enable -path=PKI-Sednal-Inter-RSA -max-lease-ttl=1825d pki
````

---

### `- 2.7` Génération de la CSR `CA INTER`
````
vault write -format=json PKI-Sednal-Inter-RSA/intermediate/generate/internal \
     common_name="sednal.lan Intermediate Authority" \
     issuer_name="Sednal-Inter-RSA-1" \
     key_type=rsa key_bits=4096 \
| jq -r '.data.csr' \
| sudo tee /etc/vault/pki/cert_ca/csr/Sednal-Inter-RSA-1.csr > /dev/null
````

---

### `- 2.8` Droits CSR `CA INTER`

- Propriétaire et Groupes
````
sudo chown vault:vault /etc/vault/pki/cert_ca/csr/Sednal-Inter-RSA-1.csr
````

- Autorisations
````
sudo chmod 644 /etc/vault/pki/cert_ca/csr/Sednal-Inter-RSA-1.csr
````

---

### `- 2.9` Signature de `CA INTER` avec `CA ROOT`
````
vault write -format=json PKI-Sednal-Root-RSA/root/sign-intermediate \
     issuer_ref="Sednal-Root-RSA-1" \
     csr=@/etc/vault/pki/cert_ca/csr/Sednal-Inter-RSA-1.csr \
     format=pem_bundle \
     ttl="1825d" \
| jq -r '.data.certificate' \
| sudo tee /etc/vault/pki/cert_ca/inter/Sednal-Inter-RSA-1.cert.pem > /dev/null
````

---

### `- 2.10` Import du certificat signé dans `CA INTER`


````
vault write PKI-Sednal-Inter-RSA/intermediate/set-signed \
     certificate=@/etc/vault/pki/cert_ca/inter/Sednal-Inter-RSA-1.cert.pem
````

- Droits
````
sudo chown vault:vault /etc/vault/pki/cert_ca/inter/Sednal-Inter-RSA-1.cert.pem
sudo chmod 644 /etc/vault/pki/cert_ca/inter/Sednal-Inter-RSA-1.cert.pem
````

---

### `- 2.11` URLs de distribution `CA INTER`

````
vault write PKI-Sednal-Inter-RSA/config/urls \
    issuing_certificates="http://infra.sednal.lan/crl/Sednal-Inter-RSA-1.crt" \
    crl_distribution_points="http://infra.sednal.lan/crl/Sednal-Inter-RSA-1.crl"
````

---

### `- 2.12` Reconstruction automatique de la CRL `CA INTER`
````
vault write PKI-Sednal-Inter-RSA/config/crl \
    expiry=72h \
    auto_rebuild=true \
    auto_rebuild_grace_period=12h
````

---

### `- 2.13` Vérification de la chaîne

- Liste des moteurs montés
````
vault secrets list | grep PKI-Sednal
````

- Certificat de l'intermédiaire
````
vault read -field=certificate PKI-Sednal-Inter-RSA/cert/ca | openssl x509 -noout -subject -issuer -dates
````

- Chaîne complète
````
vault read -field=certificate PKI-Sednal-Inter-RSA/cert/ca_chain
````

---
---

## `-3-` **Rôles PKI**

`[RAPPEL]`

- `infra` → `1 ans`, pour les machines allumées en permanence

---

### `- 3.1` Rôle `infra`
````
vault write PKI-Sednal-Inter-RSA/roles/infra \
     allowed_domains="sednal.lan" \
     allow_subdomains=true \
     allow_localhost=true \
     allow_ip_sans=true \
     key_type=rsa key_bits=2048 \
     ttl="8760h" \
     max_ttl="8760h" \
     no_store=false
````

---

### `- 3.2` Vérification des rôles
````
vault list PKI-Sednal-Inter-RSA/roles
vault read PKI-Sednal-Inter-RSA/roles/infra
````

---

### `- 3.3` Test d'émission
````
vault write PKI-Sednal-Inter-RSA/issue/infra \
     common_name="test.sednal.lan" \
     ttl="24h"
````

- Nettoyage du test
````
vault list PKI-Sednal-Inter-RSA/certs
vault write PKI-Sednal-Inter-RSA/revoke serial_number="[SERIAL]"
````

