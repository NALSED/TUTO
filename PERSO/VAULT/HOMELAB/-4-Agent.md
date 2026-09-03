# Vault Agent

---

Dans cette section, sera abordé le remplacement du certificat auto-signé de Vault par un
certificat issu de la PKI, puis la livraison automatique des certificats par le `Vault Agent`
sur `192.168.0.238` et `192.168.0.239`.

---

## **SOMMAIRE**

### `-1-` **Bascule du certificat de Vault**

### `-2-` `AppRole`

### `-3-` Agent sur `192.168.0.238`

### `-4-` Agent sur `192.168.0.239`

---

`[NOTE]`

L'agent ne peut pas produire le **premier** certificat de Vault : pour joindre Vault il doit
déjà faire confiance au certificat que Vault présente. La première émission se fait à la main.

---
---

## `-1-` Bascule du certificat de Vault

### `- 1.1` Export de la `CA ROOT`

- Créer le dossier
````
sudo mkdir -p /etc/ssl/nalsed
````

- Exporter le certificat
````
vault read -field=certificate PKI-Sednal-Root-RSA/cert/ca \
| sudo tee /etc/ssl/nalsed/ca.crt > /dev/null
````

- Copie du certificat dans stockage de certificats système Rhel
````
sudo cp /etc/ssl/nalsed/ca.crt /etc/pki/ca-trust/source/anchors/Sednal-Root-RSA-1.crt
````

- MAJ
````
sudo update-ca-trust
````

---

### `- 1.2` Sauvegarde de l'auto-signé

`[NOTE]`

Filet de sécurité : si Vault ne répond plus, on restaure ces deux fichiers et un `reload` suffit.
Le sceau n'est pas concerné.

- Création des "BackUp" clés et certificats.
````
sudo cp /opt/vault/tls/vault.crt /opt/vault/tls/vault.crt.selfsigned
sudo cp /opt/vault/tls/vault.key /opt/vault/tls/vault.key.selfsigned
````

---

### `- 1.3` Émission et bascule

- Edition du certificat final pour `192.168.0.238`
````
vault write -format=json PKI-Sednal-Inter-RSA/issue/infra \
     common_name="vault.sednal.lan" \
     ip_sans="192.168.0.238,127.0.0.1" \
     "ttl=8760h" > /tmp/cert.json
````

- Extraction certificats
````
jq -r '.data.certificate, .data.issuing_ca' /tmp/cert.json | sudo tee /opt/vault/tls/vault.crt > /dev/null
jq -r '.data.private_key'                   /tmp/cert.json | sudo tee /opt/vault/tls/vault.key > /dev/null
````


- Droits et propriétaire
````
sudo chown vault:vault /opt/vault/tls/vault.crt /opt/vault/tls/vault.key
sudo chmod 644 /opt/vault/tls/vault.crt
sudo chmod 640 /opt/vault/tls/vault.key
````

- Suppression fichier
````
rm /tmp/cert.json
````

- Redémarrage Vault
````
sudo systemctl reload vault
````

- Connection
````
export VAULT_ADDR=https://vault.sednal.lan:8100
export VAULT_CACERT=/etc/ssl/nalsed/ca.crt
vault login
vault status
````

Pour rendre permanant inscription dans : `~/.bashrc`.

---
---

## `-2-` `AppRole`

### `- 2.1` Activation et policy

- Autorisation et création fichier policy
````
vault auth enable approle

sudo vim /etc/vault/pki/config/policy/Policy_Issue.hcl
````

- Edition policy
````
path "PKI-Sednal-Inter-RSA/issue/infra" {
  capabilities = [ "create", "update" ]
}
````

- Editer dans Vault
````
vault policy write pki-issue /etc/vault/pki/config/policy/Policy_Issue.hcl
````

---

### `- 2.2` Rôles

`[NOTE]`

`secret_id_ttl=0` : le secret n'expire jamais. Simplification assumée en homelab.

- Création de rôle pour .238 et .239
````
for M in 238 239; do
  vault write auth/approle/role/vault-$M \
       token_policies="pki-issue" \
       token_ttl=1h token_max_ttl=4h \
       secret_id_ttl=0 secret_id_num_uses=0
done
````

- Identifiants (à noter, ils servent en `-3-` et `-4-`) pour .238 et .239
````
for M in 238 239; do
  echo "=== $M ==="
  vault read  -field=role_id      auth/approle/role/vault-$M/role-id
  vault write -f -field=secret_id auth/approle/role/vault-$M/secret-id
done
````

---
---

## `-3-` Agent sur `192.168.0.238`

### `- 3.1` Identifiants

- Création dossier template Agents
````
sudo mkdir -p /etc/vault-agent/templates
````

- Droit Dossier
````
sudo chmod 700 /etc/vault-agent
````

- Création / Edition fichier `role_id` et `secret_id`
````
sudo vim /etc/vault-agent/role_id
sudo vim /etc/vault-agent/secret_id
````

- Droits
````
sudo chmod 600 /etc/vault-agent/secret_id
sudo chmod 600 /etc/vault-agent/role_id
````

---

### `- 3.2` Templates

`[NOTE]`

⚠️ Les arguments doivent être `strictement identiques` dans les deux templates.
À la moindre différence, l'agent émet deux certificats et la clé ne correspond plus.

- Création fichier
````
  /etc/vault-agent/templates/cert.tpl
````

- Edition
````
{{- with secret "PKI-Sednal-Inter-RSA/issue/infra" "common_name=vault.sednal.lan" "ip_sans=192.168.0.238,127.0.0.1" "ttl=8760h" -}}
{{ .Data.certificate }}
{{ .Data.issuing_ca }}
{{- end -}}
````

- Création fichier
````
/etc/vault-agent/templates/key.tpl`
````

- Edition
````
{{- with secret "PKI-Sednal-Inter-RSA/issue/infra" "common_name=vault.sednal.lan" "ip_sans=192.168.0.238,127.0.0.1" "ttl=8760h" -}}
{{ .Data.private_key }}
{{- end -}}
````

---

### `- 3.3` Script de rechargement

`[NOTE]`

L'agent ne sait poser que les droits, pas le propriétaire : donc script.

- Création du script
````
vim /usr/local/bin/reload-vault.sh`
````

- Editer
````
#!/bin/bash
set -euo pipefail

chown vault:vault /opt/vault/tls/vault.crt /opt/vault/tls/vault.key
chmod 644 /opt/vault/tls/vault.crt
chmod 640 /opt/vault/tls/vault.key

systemctl reload vault
````

- Droit script
````
sudo chmod 700 /usr/local/bin/reload-vault.sh
````

---

### `- 3.4` Configuration

- Création fichier
````
/etc/vault-agent/agent.hcl
````

- Edition fichier de configuration agent
````
pid_file = "/run/vault-agent.pid"

# A quelle CA faire confiance
vault {
  address = "https://vault.sednal.lan:8100"
  ca_cert = "/etc/ssl/nalsed/ca.crt"
}

# Comment l'agent s'authentifie aupres de Vault
# Ici Approle via role_id et secret_id
auto_auth {
  method "approle" {
    config = {
      role_id_file_path                   = "/etc/vault-agent/role_id"
      secret_id_file_path                 = "/etc/vault-agent/secret_id"
      remove_secret_id_file_after_reading = false
    }
  }
}

# Certificat
template {
  source      = "/etc/vault-agent/templates/cert.tpl"
  destination = "/opt/vault/tls/vault.crt"
  perms       = "0644"
}

# Cle privee, puis rechargement de Vault
template {
  source      = "/etc/vault-agent/templates/key.tpl"
  destination = "/opt/vault/tls/vault.key"
  perms       = "0640"
  command     = "/usr/local/bin/reload-vault.sh"
}
````

---

### `- 3.5` Service

- Création du service
````
vim /etc/systemd/system/vault-agent.service
````

- Edition service

`[NOTE]`
Il lance le processus vault agent et le maintient démarré, s'authentifie avec le role_id/secret_id, demande un certificat, l'écrit sur disque, lance le script de reload.

````
[Unit]
Description=Vault Agent
After=network-online.target vault.service
Wants=network-online.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/vault agent -config=/etc/vault-agent/agent.hcl
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
````

- Rechargement et démarrage du service `vault-agent.service`
````
sudo systemctl daemon-reload
sudo systemctl enable --now vault-agent
````

---

### `- 3.6` Vérification
````
sudo systemctl restart vault-agent && sleep 5
vault status

openssl s_client -connect vault.sednal.lan:8100 -CAfile /etc/ssl/nalsed/ca.crt \
  </dev/null 2>/dev/null | grep "Verify return code"
````

- Attendu
````
Verify return code: 0 (ok)
````

`[RAPPEL]`

Le renouvellement automatique intervient aux deux tiers du bail, soit **~8 mois** pour 1 an.

---
---

## `-4-` Agent sur `192.168.0.239`

`[NOTE]`

Même mécanique qu'en `-3-`. Seuls changent : les identifiants, le contenu des templates,
le script de rechargement et les destinations.

### `- 4.1` Prérequis
````
sudo apt install -y jq curl

wget -O- https://apt.releases.hashicorp.com/gpg \
| sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
| sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install -y vault
````

- `CA ROOT` depuis 238
````
sudo mkdir -p /etc/ssl/nalsed
scp sednal@192.168.0.238:/etc/ssl/nalsed/ca.crt /tmp/ca.crt
sudo mv /tmp/ca.crt /etc/ssl/nalsed/ca.crt
sudo cp /etc/ssl/nalsed/ca.crt /usr/local/share/ca-certificates/Sednal-Root-RSA-1.crt
sudo update-ca-certificates
````

---

### `- 4.2` Identifiants
````
sudo mkdir -p /etc/vault-agent/templates && sudo chmod 700 /etc/vault-agent

echo "[ROLE_ID]"   | sudo tee /etc/vault-agent/role_id   > /dev/null
echo "[SECRET_ID]" | sudo tee /etc/vault-agent/secret_id > /dev/null
sudo chmod 600 /etc/vault-agent/role_id /etc/vault-agent/secret_id
````

---

### `- 4.3` Templates

`[NOTE]`

Un seul certificat multi-SAN pour tous les services du proxy.
Ajouter un service = ajouter son nom dans `alt_names` des **deux** templates,
puis `systemctl restart vault-agent`.

- `/etc/vault-agent/templates/cert.tpl`
````
{{- with secret "PKI-Sednal-Inter-RSA/issue/infra" "common_name=infra.sednal.lan" "alt_names=pihole.sednal.lan,bareos.sednal.lan,cockpit.sednal.lan,proxmox.sednal.lan" "ip_sans=192.168.0.239" "ttl=8760h" -}}
{{ .Data.certificate }}
{{ .Data.issuing_ca }}
{{- end -}}
````

- `/etc/vault-agent/templates/key.tpl`
````
{{- with secret "PKI-Sednal-Inter-RSA/issue/infra" "common_name=infra.sednal.lan" "alt_names=pihole.sednal.lan,bareos.sednal.lan,cockpit.sednal.lan,proxmox.sednal.lan" "ip_sans=192.168.0.239" "ttl=8760h" -}}
{{ .Data.private_key }}
{{- end -}}
````

---

### `- 4.4` Script de rechargement

- `/usr/local/bin/reload-nginx.sh`
````
#!/usr/bin/env bash
set -euo pipefail

chown root:www-data /etc/ssl/nalsed/infra.crt /etc/ssl/nalsed/infra.key
chmod 644 /etc/ssl/nalsed/infra.crt
chmod 640 /etc/ssl/nalsed/infra.key

nginx -t && systemctl reload nginx
````

````
sudo chmod 700 /usr/local/bin/reload-nginx.sh
````

`[NOTE]`

`nginx -t` avant le `reload` : un certificat mal écrit ne doit pas faire tomber le proxy.

---

### `- 4.5` Configuration et service

`[NOTE]`

Reprendre l'`agent.hcl` de `-3.4` en changeant uniquement les destinations
(`/etc/ssl/nalsed/infra.crt` et `.key`) et le `command` (`/usr/local/bin/reload-nginx.sh`).
L'unité systemd de `-3.5` est identique, sans `vault.service` dans `After`.

````
sudo systemctl daemon-reload
sudo systemctl enable --now vault-agent
sudo journalctl -u vault-agent -n 30 --no-pager
````

---

### `- 4.6` Vérification
````
openssl x509 -in /etc/ssl/nalsed/infra.crt -noout -subject -dates -ext subjectAltName
````

---
---
