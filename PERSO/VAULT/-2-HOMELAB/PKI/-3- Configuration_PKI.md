# Configuration Du Rôle PKI, sur le Serveur Vault.

---

### 1️⃣ `Création Policy` [Accès rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/-2-HOMELAB/PKI/-3-%20Configuration_PKI.md#1%EF%B8%8F%E2%83%A3-cr%C3%A9ation-policy-acc%C3%A8s-rapide-1)
### 2️⃣ `Configuration PKI` [Accès rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/-2-HOMELAB/PKI/-3-%20Configuration_PKI.md#2%EF%B8%8F%E2%83%A3-configuration-pki)
### 3️⃣ `Role PKI` [Accès rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/-2-HOMELAB/PKI/-3-%20Configuration_PKI.md#3%EF%B8%8F%E2%83%A3-role-pki)
### 4️⃣ `Demande de Certificats` [Accès rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/-2-HOMELAB/PKI/-3-%20Configuration_PKI.md#4%EF%B8%8F%E2%83%A3-demande-de-certificats)
### 5️⃣ `Renouvelement` [Accès rapide](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/-2-HOMELAB/PKI/-3-%20Configuration_PKI.md#5%EF%B8%8F%E2%83%A3-renouvelement)

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



### `-1.` Activer les moteur de certifications et Création CA_Root

**=== RSA ===**

`-1.1` . Activer le moteur PKI
```
vault secrets enable -path=PKI_Sednal_Root_RSA -max-lease-ttl=9132d pki
```

- nom moteur : `PKI_Sednal_Root_RSA`
- TTL : `25 ans`

`-1.2.` Générer l'autorité de certifiaction racine
```
vault write -field=certificate PKI_Sednal_Root_RSA/root/generate/internal \
    common_name="sednal.com" \
      issuer_name="Sednal_Root_R-1" \
      ttl=9132d \
      key_type=rsa key_bits=4096 \
      exclude_cn_from_sans=true > /etc/Vault/PKI/Cert_CA/Root/Sednal_Root_R-1.crt
```

- nom : `Sednal_Root_R-1`
- (-field=certificate obtiens juste le PEM du certificat, pour redirection dans un fichier, Ici `Sednal_Root_R-1.crt`)

`-1.3.` Génération et distibution de la CRL 
```
vault write PKI_Sednal_Root_RSA/config/urls \
    issuing_certificates="https://vault.sednal.lan/v1/PKI_Sednal_Root_RSA/ca" \
    crl_distribution_points="http://pihole.sednal.lan/crl/root_r"
```    

- issuing_certificates : URL encodée dans le certificat qui permettre aux clients de télécharger le certificat de la CA et reconstituer la chaîne de confiance.

- crl_distribution_points : indique le endpoint du CRL dans le certificat.

```
vault write PKI_Sednal_Root_RSA/config/crl \
    auto_rebuild=true \
    enable_delta=true
```

- auto_rebuild : Active la reconstruction automatique de la CRL avant expiration

- enable_delta : Active les CRL delta (incrementales) pour optimiser les performances




**=== ECDSA ===**


`-1.4` . Activer le moteur PKI
```
vault secrets enable -path=PKI_Sednal_Root_ECDSA -max-lease-ttl=9132d pki
```

- nom moteur : `PKI_Sednal_Root_ECDSA`
- TTL : `25 ans`

`-1.5.` Générer l'autorité de certifiaction racine
```
vault write -field=certificate PKI_Sednal_Root_ECDSA/root/generate/internal \
   common_name="sednal.com" \
     issuer_name="Sednal_Root_E-1" \
     ttl=9132d \
     key_type=ec key_bits=384 \
     exclude_cn_from_sans=true > /etc/Vault/PKI/Cert_CA/Root/Sednal_Root_E-1.crt

```

- nom : `Sednal_Root_E-1`
- (-field=certificate obtiens juste le PEM du certificat, pour redirection dans un fichier, Ici `Sednal_Root_E-1.crt`)

`-1.6.` Génération et distibution de la CRL 
```
 vault write PKI_Sednal_Root_ECDSA/config/urls \
     issuing_certificates="https://vault.sednal.lan/v1/PKI_Sednal_Root_ECDSA/ca" \
     crl_distribution_points="http://pihole.sednal.lan/crl/root_e"
```    

- issuing_certificates : URL encodée dans le certificat qui permettre aux clients de télécharger le certificat de la CA et reconstituer la chaîne de confiance.

- crl_distribution_points : indique le endpoint du CRL dans le certificat.

```
vault write PKI_Sednal_Root_ECDSA/config/crl \
       auto_rebuild=true \
       enable_delta=true
```

- auto_rebuild : Active la reconstruction automatique de la CRL avant expiration

- enable_delta : Active les CRL delta (incrementales) pour optimiser les performances

---

### `-2.` Cross siging

`-2.1.` Récupérer la clé de Root_ECDSA
```
_e1_default_issuer=$(vault read -field=default PKI_Sednal_Root_ECDSA/config/issuers)
_key_id=$(vault read PKI_Sednal_Root_ECDSA/issuer/$_e1_default_issuer | grep -i key_id | awk '{print $2}')
```

`-2.2.`Générer le CSR de cross-sign
```
vault write -format=json PKI_Sednal_Root_ECDSA/intermediate/cross-sign \
    common_name="Sednal_Root_XS_1" \
    key_ref=$_key_id | jq -r '.data.csr' > /etc/Vault/PKI/Cert_CA/CSR/cross_e1.csr
```

`-2.3.` Root_RSA signe le CSR
```
vault write -format=json PKI_Sednal_Root_RSA/root/sign-intermediate \
    use_csr_values=true \
    csr=@/etc/Vault/PKI/Cert_CA/CSR/cross_e1.csr \
    ttl=1826d \
    exclude_cn_from_sans=true | jq -r '.data.certificate' > /etc/Vault/PKI/Cert_CA/Root/Sednal_Root_XS-1.crt
```

`-2.4.` Importer le cert croisé dans Root
```
vault write PKI_Sednal_Root_ECDSA/intermediate/set-signed \
    certificate=@/etc/Vault/PKI/Cert_CA/Root/Sednal_Root_XS-1.crt
```

`-2.5.` Concaténation (Pour permettre au client de reconstituer le chaine de confiance)
```
path=/etc/Vault/PKI/Cert_CA/Root
```

```
cat "$path"/Sednal_Root_XS-1.crt "$path"/Sednal_Root_R-1.crt "$path"/Sednal_Root_E-1.crt > "$path/Sednal_Root_All.crt"
```

----

### `-3.` Certificats Intermédiaire

`[NOTE]` 

L'utilisation de certificats intermédiaires est une bonne pratique 
fondamentale en PKI.

La **Root CA** est l'ancre de confiance absolue — si sa clé privée 
est compromise, toute la PKI est à reconstruire. En la protégeant 
derrière une CA intermédiaire, on limite drastiquement son exposition.

L'intermédiaire agit comme un **bouclier** : c'est lui qui émet les 
certificats finaux au quotidien. En cas de compromission, on peut 
révoquer et régénérer l'intermédiaire sans toucher à la Root CA.

**=== RSA ===**

`-3.1.` - Générer le certificat intermédiare 
```
vault secrets enable -path=PKI_Sednal_Inter_RSA -max-lease-ttl=1825d pki
```

`-3.1.` Génération du CSR  
```
vault write -format=json PKI_Sednal_Inter_RSA/intermediate/generate/internal \
     common_name="sednal.lan Intermediate Authority" \
     issuer_name="Sednal_Inter_R-1" \
     | jq -r '.data.csr' > /etc/Vault/PKI/Cert_CA/CSR/Sednal_Inter_R-1.csr
```

`-3.3.` Signature du certifiact inter via CA Root RSA
```
vault write -format=json PKI_Sednal_Root_RSA/root/sign-intermediate \
     issuer_ref="Sednal_Root_R-1" \
     csr=@/etc/Vault/PKI/Cert_CA/CSR/Sednal_Inter_R-1.csr \
     format=pem_bundle ttl="1825d" \
     | jq -r '.data.certificate' > /etc/Vault/PKI/Cert_CA/Inter/Sednal_Inter_R-1.cert.pem
```


**=== ECDSA ===**

`-3.4.` Générer le certificat intermédiare 
```
vault secrets enable -path=PKI_Sednal_Inter_ECDSA -max-lease-ttl=1825d pki
```

`-3.5.` Génération du CSR  
```
vault write -format=json PKI_Sednal_Inter_ECDSA/intermediate/generate/internal \
     common_name="sednal.lan Intermediate Authority" \
     issuer_name="Sednal_Inter_E-1" \
     | jq -r '.data.csr' > /etc/Vault/PKI/Cert_CA/CSR/Sednal_Inter_E-1.csr
```

`-3.6.` Signature du certifiact inter via CA Root ECDSA
```
vault write -format=json PKI_Sednal_Root_ECDSA/root/sign-intermediate \
     issuer_ref="Sednal_Root_E-1" \
     csr=@/etc/Vault/PKI/Cert_CA/CSR/Sednal_Inter_E-1.csr \
     format=pem_bundle ttl="1825d" \
     | jq -r '.data.certificate' > /etc/Vault/PKI/Cert_CA/Inter/Sednal_Inter_E-1.cert.pem
```

`-3.7.` Importation certificats  inter RSA et ECDSA dans Vault.
```
vault write  PKI_Sednal_Inter_RSA/intermediate/set-signed certificate=@/etc/Vault/PKI/Cert_CA/Inter/Sednal_Inter_R-1.cert.pem
vault write  PKI_Sednal_Inter_ECDSA/intermediate/set-signed certificate=@/etc/Vault/PKI/Cert_CA/Inter/Sednal_Inter_E-1.cert.pem
```

---

## 3️⃣ **Role PKI**

- 17 - Créer un role pour les certificats inter RSA

vault write PKI_Sednal_Inter_RSA/roles/Cert_Inter_RSA \
    issuer_ref="$(vault read -field=default PKI_Sednal_Inter_RSA/config/issuers)" \
    allowed_domains="sednal.lan" \
    allow_subdomains=true \
    allow_localhost=true \
    key_type=rsa \
    key_bits=4096 \
    max_ttl="365d" \
    ttl="90d" \
    no_store=false

- issuer_ref : utilise la sortie par defaut
- TTL : `90 jours`
- no_store=false : Conserve les certificats émis dans Vault pour audit


- 18 - Créer un role pour les certificats inter ECDSA

vault write PKI_Sednal_Inter_ECDSA/roles/Cert_Inter_ECDSA \
    issuer_ref="$(vault read -field=default PKI_Sednal_Inter_ECDSA/config/issuers)" \
    allowed_domains="sednal.lan" \
    allow_subdomains=true \
    allow_localhost=true \
    key_type=ec \
    key_bits=384 \
    max_ttl="365d" \
    ttl="90d" \
    no_store=false

- issuer_ref : utilise la sortie par defaut
- TTL : `90 jours`
- no_store=false : Conserve les certificats émis dans Vault pour audit

---

## 4️⃣ **Demande de Certificats** 

- Ici utilisation du Script : [demande_cert.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/PKI/renew_cert.sh)

---

## 5️⃣ **Renouvelement** 

- Inscription à systemd avec timer pour execution tous les 80 jours, les certificats finaux on une TTL de 90 jours

`1.1` Editer le Script
```
sudo nano /etc/Vault_Script/Script_Renouvelement/renew_cert.sh
```

- Ici utilisation du Script : [renouvelement_cert.sh](https://github.com/NALSED/TUTO/blob/main/PERSO/VAULT/SCRIPT/PKI/renouvelement_cert.sh)

-Le rendre exécutable
```
sudo chmod +x  /etc/Vault_Script/Script_Renouvelement/renew_cert.sh
```

-Appliquer les permission
```
 sudo chown sednal:vault  /etc/Vault_Script/Script_Renouvelement/renew_cert.sh
```

`-1.2.` Inscription exécution du Script => Systemd :
```
  sudo nano /etc/systemd/system/renew_cert_ssl.service 
```

**=== SERVICE ===**
```
[Unit]
Description=Renouvellement cerficats SSL Infra
After=network.target
RefuseManualStart=yes

[Service]
Type=oneshot
ExecStart=/etc/Vault_Script/Script_Renouvelement/renew_cert.sh
User=sednal
Group=vault

[Install]
WantedBy=multi-user.target
```

`-1.3.` Edition timer
```
 sudo nano /etc/systemd/system/renew_cert_ssl.timer 
```

**=== TIMER ===**

```
[Unit]
Description=Renouvellement du certificat tous les 80 jours
Requires=renew_cert_ssl.service
  
[Timer]
OnCalendar=*-*-1/80
Persistent=true
  
[Install]
WantedBy=timers.target
```
















