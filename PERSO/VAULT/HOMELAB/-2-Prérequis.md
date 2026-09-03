# Prérequis

---

## `-1-` Arborécences / Droits / Variables

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

## `-2-` Dépendances

### `Installer jq`

utilisé pour extraire les champs des réponses JSON de Vault.
````
sudo dnf install -y jq
````
