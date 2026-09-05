# Exploitation

---

Dans cette section, sera abordé le strict nécessaire au maintien en condition opérationnelle :
sauvegarde, descellement et dépannage.

---

## SOMMAIRE

### `-1-` Sauvegarde

### `-2-` Descellement

### `-3-` Dépannage

---
---

## `-1-` Sauvegarde

`[RAPPEL]`

La V1 a été perdue avec la VM `192.168.0.238` : clés Root et intermédiaires définitivement
détruites, PKI intégralement à reconstruire. Les clés privées des deux CA vivent à nouveau
dans ce Vault. **Cette section n'est pas optionnelle.**

---

### `- 1.1` Snapshot manuel

`[NOTE]`

À faire **avant** toute opération sensible : première émission, changement de configuration,
mise à jour du paquet.

````
vault operator raft snapshot save /tmp/vault-$(date +%F).snap
````

---

### `- 1.2` Token de sauvegarde

- Policy
````
sudo vim /etc/vault/pki/config/policy/Policy_Snapshot.hcl
````

- Édition
````
path "sys/storage/raft/snapshot" {
  capabilities = [ "read" ]
}
````

- Création du token
````
vault policy write pki-snapshot /etc/vault/pki/config/policy/Policy_Snapshot.hcl
sudo mkdir -p /etc/vault-snapshot && sudo chmod 700 /etc/vault-snapshot
vault token create -policy=pki-snapshot -period=768h -field=token \
| sudo tee /etc/vault-snapshot/token > /dev/null
sudo chmod 600 /etc/vault-snapshot/token
````

---

### `- 1.3` Snapshot automatique

- `/usr/local/bin/vault-snapshot.sh`
````
#!/usr/bin/env bash
set -euo pipefail

export VAULT_ADDR=https://vault.sednal.lan:8100
export VAULT_CACERT=/etc/ssl/nalsed/ca.crt
export VAULT_TOKEN=$(cat /etc/vault-snapshot/token)

DEST="/var/backups/vault"
mkdir -p "$DEST"

vault operator raft snapshot save "$DEST/vault-$(date +%F).snap"
find "$DEST" -name 'vault-*.snap' -mtime +56 -delete
````

````
sudo chmod 700 /usr/local/bin/vault-snapshot.sh
````

---

### `- 1.4` Timer hebdomadaire

- `/etc/systemd/system/vault-snapshot.service`
````
[Unit]
Description=Snapshot raft de Vault

[Service]
Type=oneshot
ExecStart=/usr/local/bin/vault-snapshot.sh
````

- `/etc/systemd/system/vault-snapshot.timer`
````
[Unit]
Description=Snapshot hebdomadaire de Vault

[Timer]
OnCalendar=Sun *-*-* 20:00:00
Persistent=true

[Install]
WantedBy=timers.target
````

````
sudo systemctl daemon-reload
sudo systemctl enable --now vault-snapshot.timer
````

`[NOTE]`

Dimanche 20 h : après la fenêtre de sauvegarde Bareos, la VM étant déjà allumée.

---

### `- 1.5` Sortie de la machine

`[RAPPEL]`

Un snapshot qui reste sur la VM ne protège de rien.

- À intégrer au FileSet Bareos
````
/var/backups/vault
````

- Les 5 clés de descellement et le Root Token issus de `vault operator init` ne sont **jamais**
stockés sur la VM. Support hors ligne. Sans elles, un snapshot restauré est inutilisable.

---

### `- 1.6` Restauration
````
vault operator raft snapshot restore -force /var/backups/vault/vault-[DATE].snap
````

`[NOTE]`

Après restauration, Vault repart **scellé** et attend les clés du Vault d'origine.

---
---

## `-2-` Descellement

`[RAPPEL]`

Décision n°2 : auto-unseal abandonné, descellement manuel à chaque démarrage.

````
export VAULT_ADDR=https://vault.sednal.lan:8100
export VAULT_CACERT=/etc/ssl/nalsed/ca.crt

vault status
vault operator unseal   # 3 fois, 3 cles differentes
vault login
vault status
````

`[NOTE]`

Tant que Vault est scellé, les agents échouent et redémarrent en boucle : c'est normal.
Ils repartent seuls en moins d'une minute après le descellement.

---
---

## `-3-` Dépannage

### `- 3.1` Reprise après un arrêt prolongé

`[NOTE]`

Si l'arrêt dépasse la durée de vie du certificat, Vault redémarre avec un certificat expiré.
L'agent refuse alors de s'y connecter (`certificate has expired`) et ne peut pas le renouveler :
Vault sert un certificat qu'il est incapable de remplacer seul.

- Diagnostic
````
openssl x509 -in /opt/vault/tls/vault.crt -noout -enddate
sudo journalctl -u vault-agent -n 20 --no-pager
````

- Retour sur l'auto-signé
````
sudo systemctl stop vault-agent

sudo cp /opt/vault/tls/vault.crt.selfsigned /opt/vault/tls/vault.crt
sudo cp /opt/vault/tls/vault.key.selfsigned /opt/vault/tls/vault.key
sudo chown vault:vault /opt/vault/tls/vault.crt /opt/vault/tls/vault.key
sudo systemctl reload vault
````

- Réémission
````
export VAULT_ADDR=https://vault.sednal.lan:8100
export VAULT_CACERT=/opt/vault/tls/vault.crt

sudo systemctl start vault-agent
````

`[NOTE]`

L'auto-signé étant lui aussi à durée limitée, le régénérer si nécessaire avec la commande
`openssl` de `-1-Installation-Lab.md`  -3.1- avant de relancer l'agent.

`[RAPPEL]`



---

### `- 3.2` L'agent ne rend pas les templates
````
sudo journalctl -u vault-agent -f
````

| Message | Cause |
|:--|:--|
| `permission denied` | policy incomplète ou mauvais rôle dans le template |
| `Vault is sealed` | Vault scellé, desceller |
| `connection refused` | Vault arrêté ou port filtré |
| `certificate signed by unknown authority` | `ca_cert` de l'agent obsolète |

---

### `- 3.3` Purge des certificats émis

`[NOTE]`

`no_store=false` conserve tous les certificats. Chaque redémarrage d'agent en produit un
nouveau : à lancer une fois si le stockage grossit.

````
vault write PKI-Sednal-Inter-RSA/config/auto-tidy \
     enabled=true \
     interval_duration=24h \
     tidy_cert_store=true \
     tidy_revoked_certs=true \
     safety_buffer=720h
````

---

### `- 3.4` Révocation
````
vault list  PKI-Sednal-Inter-RSA/certs
vault write PKI-Sednal-Inter-RSA/revoke serial_number="[SERIAL]"
````

`[NOTE]`

Sans point de distribution CRL monté, la révocation n'est **pas** propagée aux clients.
Le seul recours immédiat est de retirer le certificat de la machine concernée.

---
---
