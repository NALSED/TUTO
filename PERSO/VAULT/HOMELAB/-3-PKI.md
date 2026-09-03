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

### `- 1.1` Prérequis

`[NOTE]`

`jq` est utilisé pour extraire les champs des réponses JSON de Vault.

- Paquets
````
sudo dnf install -y jq
````

- Arborescence de travail
````
sudo mkdir -p /etc/vault/pki/config/policy
sudo mkdir -p /etc/vault/pki/cert_ca/root
sudo mkdir -p /etc/vault/pki/cert_ca/csr
sudo mkdir -p /etc/vault/pki/cert_ca/inter
````

- Droits
````
sudo chown -R vault:vault /etc/vault/pki
sudo chmod -R 755 /etc/vault/pki
````

- Variables d'environnement
````
export VAULT_ADDR=https://vault.sednal.lan:8100
export VAULT_CACERT=/opt/vault/tls/vault.crt
````

---

### `- 1.2` Création du fichier Policies

`[NOTE]`

Les policies sont en quelque sorte les droits propre à l'infra de Vault.

Plus d'info [ICI](https://developer.hashicorp.com/vault/docs/concepts/policies)

- Création
````
sudo vim /etc/vault/pki/config/policy/Policy_PKI.hcl
````

---

### `- 1.3` Edition du fichier Policies
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

### `- 1.4` Droits
````
sudo chown vault:vault /etc/vault/pki/config/policy/Policy_PKI.hcl
sudo chmod 640 /etc/vault/pki/config/policy/Policy_PKI.hcl
````

---

### `- 1.5` Editer dans Vault
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

Le rattachement (AppRole pour le Vault Agent) est traité dans `2-agent.md`.

---
---

## `-2-` **Génération Certificats RSA**

`[RAPPEL]`

Durée lease Certificats

- `Root` CA	RSA 4096	`25 ans`

- `Intermediate` CA	RSA 4096	`5 ans`

- `Finaux`	RSA 2048	`30 jours` (infra) / `90 jours` (Bareos)

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

`[NOTE]`

Les URLs sont **gravées dans les certificats au moment de l'émission**.
Elles doivent donc être configurées **avant** toute émission, sinon il faut tout réémettre.

Le HTTP est volontaire : valider en HTTPS le serveur qui héberge la CRL créerait une dépendance circulaire.
Le contenu est signé, il n'a pas besoin d'être chiffré.

Le point de distribution est le reverse proxy `192.168.0.239` (décision n°5, cf. `README.md`).

````
vault write PKI-Sednal-Root-RSA/config/urls \
    issuing_certificates="http://infra.sednal.lan/crl/Sednal-Root-RSA-1.crt" \
    crl_distribution_points="http://infra.sednal.lan/crl/Sednal-Root-RSA-1.crl"
````

---

### `- 2.5` Reconstruction automatique de la CRL `CA ROOT`

`[NOTE]`

Sans `auto_rebuild`, la CRL n'est régénérée qu'à chaque révocation : elle expire et les clients stricts rejettent tout.

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

`[NOTE]`

Étape indispensable : tant que le certificat signé n'est pas réimporté, le moteur intermédiaire
possède sa clé privée mais **aucun certificat**, et ne peut donc rien émettre.

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

`[NOTE]`

Chaque autorité publie **ses propres** URLs : celles de l'intermédiaire pointent sur l'intermédiaire,
jamais sur la racine.

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

Deux rôles, deux durées (décision n°4, cf. `README.md`) :

- `infra` → `30 jours`, pour les machines allumées en permanence

- `bareos` → `90 jours`, le serveur n'étant allumé que 4 h par semaine

---

### `- 3.1` Rôle `infra`
````
vault write PKI-Sednal-Inter-RSA/roles/infra \
     allowed_domains="sednal.lan" \
     allow_subdomains=true \
     allow_localhost=true \
     allow_ip_sans=true \
     key_type=rsa key_bits=2048 \
     ttl="720h" \
     max_ttl="2160h" \
     no_store=false
````

---

### `- 3.2` Rôle `bareos`
````
vault write PKI-Sednal-Inter-RSA/roles/bareos \
     allowed_domains="sednal.lan" \
     allow_subdomains=true \
     allow_ip_sans=true \
     key_type=rsa key_bits=2048 \
     ttl="2160h" \
     max_ttl="2160h" \
     no_store=false
````

`[NOTE]`

`no_store=false` conserve les certificats émis dans Vault : c'est ce qui permet de les lister
et de les révoquer par numéro de série, donc de faire vivre la CRL.

---

### `- 3.3` Vérification des rôles
````
vault list PKI-Sednal-Inter-RSA/roles
vault read PKI-Sednal-Inter-RSA/roles/infra
````

---

### `- 3.4` Test d'émission
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

---
---
