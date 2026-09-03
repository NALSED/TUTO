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
````
sudo mkdir -p /etc/ssl/nalsed

vault read -field=certificate PKI-Sednal-Root-RSA/cert/ca \
| sudo tee /etc/ssl/nalsed/ca.crt > /dev/null

sudo cp /etc/ssl/nalsed/ca.crt /etc/pki/ca-trust/source/anchors/Sednal-Root-RSA-1.crt
sudo update-ca-trust
````

---

### `- 1.2` Sauvegarde de l'auto-signé

`[NOTE]`

Filet de sécurité : si Vault ne répond plus, on restaure ces deux fichiers et un `reload` suffit.
Le sceau n'est pas concerné.

````
sudo cp /opt/vault/tls/vault.crt /opt/vault/tls/vault.crt.selfsigned
sudo cp /opt/vault/tls/vault.key /opt/vault/tls/vault.key.selfsigned
````

---

### `- 1.3` Émission et bascule
````
vault write -format=json PKI-Sednal-Inter-RSA/issue/infra \
     common_name="vault.sednal.lan" \
     ip_sans="192.168.0.238,127.0.0.1" \
     ttl="720h" > /tmp/cert.json

jq -r '.data.certificate, .data.issuing_ca' /tmp/cert.json | sudo tee /opt/vault/tls/vault.crt > /dev/null
jq -r '.data.private_key'                   /tmp/cert.json | sudo tee /opt/vault/tls/vault.key > /dev/null

sudo chown vault:vault /opt/vault/tls/vault.crt /opt/vault/tls/vault.key
sudo chmod 644 /opt/vault/tls/vault.crt
sudo chmod 640 /opt/vault/tls/vault.key

shred -u /tmp/cert.json
sudo systemctl reload vault
````

`[NOTE]`

Le `.crt` contient le certificat **suivi de l'intermédiaire** : sans cette concaténation,
les clients ne peuvent pas reconstruire la chaîne.

- Bascule du client sur la Root
````
export VAULT_ADDR=https://vault.sednal.lan:8100
export VAULT_CACERT=/etc/ssl/nalsed/ca.crt
vault status
````

À rendre permanent dans `~/.bashrc`.

---
---

## `-2-` `AppRole`

### `- 2.1` Activation et policy
````
vault auth enable approle

sudo vim /etc/vault/pki/config/policy/Policy_Issue.hcl
````

- Edition
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

````
for M in 238 239; do
  vault write auth/approle/role/vault-$M \
       token_policies="pki-issue" \
       token_ttl=1h token_max_ttl=4h \
       secret_id_ttl=0 secret_id_num_uses=0
done
````

- Identifiants (à noter, ils servent en `-3-` et `-4-`)
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
````
sudo mkdir -p /etc/vault-agent/templates && sudo chmod 700 /etc/vault-agent

echo "[ROLE_ID]"   | sudo tee /etc/vault-agent/role_id   > /dev/null
echo "[SECRET_ID]" | sudo tee /etc/vault-agent/secret_id > /dev/null
sudo chmod 600 /etc/vault-agent/role_id /etc/vault-agent/secret_id
````

---

### `- 3.2` Templates

`[NOTE]`

**Piège** : les arguments doivent être **strictement identiques** dans les deux templates.
À la moindre différence, l'agent émet deux certificats et la clé ne correspond plus.

- `/etc/vault-agent/templates/cert.tpl`
````
{{- with secret "PKI-Sednal-Inter-RSA/issue/infra" "common_name=vault.sednal.lan" "ip_sans=192.168.0.238,127.0.0.1" "ttl=720h" -}}
{{ .Data.certificate }}
{{ .Data.issuing_ca }}
{{- end -}}
````

- `/etc/vault-agent/templates/key.tpl`
````
{{- with secret "PKI-Sednal-Inter-RSA/issue/infra" "common_name=vault.sednal.lan" "ip_sans=192.168.0.238,127.0.0.1" "ttl=720h" -}}
{{ .Data.private_key }}
{{- end -}}
````

---

### `- 3.3` Script de rechargement

`[NOTE]`

L'agent ne sait poser que le mode, pas le propriétaire : d'où ce script.

- `/usr/local/bin/reload-vault.sh`
````
#!/usr/bin/env bash
set -euo pipefail

chown vault:vault /opt/vault/tls/vault.crt /opt/vault/tls/vault.key
chmod 644 /opt/vault/tls/vault.crt
chmod 640 /opt/vault/tls/vault.key

systemctl reload vault
````

````
sudo chmod 700 /usr/local/bin/reload-vault.sh
````

---

### `- 3.4` Configuration

- `/etc/vault-agent/agent.hcl`
````
pid_file = "/run/vault-agent.pid"

vault {
  address = "https://vault.sednal.lan:8100"
  ca_cert = "/etc/ssl/nalsed/ca.crt"
}

auto_auth {
  method "approle" {
    config = {
      role_id_file_path                   = "/etc/vault-agent/role_id"
      secret_id_file_path                 = "/etc/vault-agent/secret_id"
      remove_secret_id_file_after_reading = false
    }
  }
}

template {
  source      = "/etc/vault-agent/templates/cert.tpl"
  destination = "/opt/vault/tls/vault.crt"
  perms       = "0644"
}

template {
  source      = "/etc/vault-agent/templates/key.tpl"
  destination = "/opt/vault/tls/vault.key"
  perms       = "0640"
  command     = "/usr/local/bin/reload-vault.sh"
}
````

`[NOTE]`

`command` uniquement sur le **second** template : on ne recharge qu'une fois les deux fichiers écrits.

---

### `- 3.5` Service

- `/etc/systemd/system/vault-agent.service`
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

````
sudo systemctl daemon-reload
sudo systemctl enable --now vault-agent
````

`[NOTE]`

Vault étant en descellement manuel, l'agent échoue après un redémarrage tant que Vault est scellé.
`Restart=on-failure` le fait repartir seul.

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

Le renouvellement automatique intervient aux deux tiers du bail, soit **~20 jours** pour 30 jours.

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
{{- with secret "PKI-Sednal-Inter-RSA/issue/infra" "common_name=infra.sednal.lan" "alt_names=pihole.sednal.lan,bareos.sednal.lan,cockpit.sednal.lan,proxmox.sednal.lan" "ip_sans=192.168.0.239" "ttl=720h" -}}
{{ .Data.certificate }}
{{ .Data.issuing_ca }}
{{- end -}}
````

- `/etc/vault-agent/templates/key.tpl`
````
{{- with secret "PKI-Sednal-Inter-RSA/issue/infra" "common_name=infra.sednal.lan" "alt_names=pihole.sednal.lan,bareos.sednal.lan,cockpit.sednal.lan,proxmox.sednal.lan" "ip_sans=192.168.0.239" "ttl=720h" -}}
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
