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

- `Sortie Attendu`
````
PKI-Sednal-Inter-RSA/    pki               pki_09716ad0               n/a
PKI-Sednal-Root-RSA/     pki               pki_e8ac580a               n/a
````

- Certificat de l'intermédiaire
````
vault read -field=certificate PKI-Sednal-Inter-RSA/cert/ca | openssl x509 -noout -subject -issuer -dates
````

- `Sortie Attendu`
````
subject=CN=sednal.lan Intermediate Authority
issuer=CN=sednal.lan
notBefore=Sep  3 13:16:07 2026 GMT
notAfter=Sep  2 13:16:37 2031 GMT
````

- Chaîne complète
````
vault read -field=certificate PKI-Sednal-Inter-RSA/cert/ca_chain
````

- `Sortie Attendu` => Les 2 certificats à la suite


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

<details>
<summary>
<h2>
Sortie Attendu
</h2>
</summary>

````
     common_name="test.sednal.lan" \
     ttl="24h"
Key                 Value
---                 -----
authority_key_id    40:b3:80:41:24:1d:f7:61:02:a7:db:a5:06:79:96:4e:b4:46:6b:fc
ca_chain            [-----BEGIN CERTIFICATE-----
MIIFxzCCA6+gAwIBAgIUZXNLVAblOppqJdu0nuCfno15bcowDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKc2VkbmFsLmxhbjAeFw0yNjA5MDMxMzE2MDdaFw0zMTA5
MDIxMzE2MzdaMCwxKjAoBgNVBAMTIXNlZG5hbC5sYW4gSW50ZXJtZWRpYXRlIEF1
dGhvcml0eTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAL5ezmLfi70b
tR/STJOWZcdEUQHCG2ZPT4pNnJ3RKrPscSI5/GP16Xl/mV4C7BxiOljmABQ9q9XG
BchqMt7sQwubZHdG5q5BHYmmdN7MnuYyh0FLP0R+dLu4p+8Wqu4JJcMzzb9CID8k
P1ZB7Jdw60AdLCw3YdcBX/6d4GC+EGdF7RTvzt3eStZzTDP2M+DdGvHFL/clK3p1
2lCl11SCC+wsBEhf71iImrT5PFRrfIeM53POgd3VDuEVr0e0DY1ohV8IW0L5XL4x
DwA0IhQshPOQW6YnnpNQt8YRFbDMdoxQ47UPCamKoG4u4v0g63gXUmDjnKDZp3xD
ybKyiGzsNg5Fw58pAkVsxnFFtiwqyMH6mpXMNvm3y01E1k7K5oARFW2VU+/0Yitm
Isfxte2yW/x5ZbFsbJfBNM3gemqELkEc/CGO5bq38T3VaPVRQgl42wV2U42Xf91f
09tHeAKoLY6Fe8G+RQy6cf9zJLIbhKeOyckgbuYDPe5diL4h0uG7MU25dhInxc3K
0nMjzoRB7HA+PPyn1A/QMNLZbFVzy4giaw2sZ4k65ZbtuOklPnpOQgvgBbEvW2II
DQQ76wTlyORCAW3pgUq0/Uu94cBsbu1Rcm+m9MwTNNd5h9jJX+yTvQYflCNGoTXY
BiNTZDPOD5D669T7qUTJQCBSKekenzzzAgMBAAGjgfcwgfQwDgYDVR0PAQH/BAQD
AgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFECzgEEkHfdhAqfbpQZ5lk60
Rmv8MB8GA1UdIwQYMBaAFOYRblki2k5T6mgACvTFcrDf2Su4ME0GCCsGAQUFBwEB
BEEwPzA9BggrBgEFBQcwAoYxaHR0cDovL2luZnJhLnNlZG5hbC5sYW4vY3JsL1Nl
ZG5hbC1Sb290LVJTQS0xLmNydDBCBgNVHR8EOzA5MDegNaAzhjFodHRwOi8vaW5m
cmEuc2VkbmFsLmxhbi9jcmwvU2VkbmFsLVJvb3QtUlNBLTEuY3JsMA0GCSqGSIb3
DQEBCwUAA4ICAQAYGoxlo3bcCtknfgwebkjL35inL/jlVNIRAVGFgqOP1Yz4sScK
vq9Jlo7mjAdz9cKhiewqVED6jKleH82qxitBW9TxID0LojRZEtMSiceR4A6xme5u
RuthQCwFy1Ycgmwf1TztCiCIzEXIprMFrUU6Qp688kaIZR7qvFHZnaeTj7vKEb8e
TKYIU7v26UxOU2KomVysICRTsJqizyCguGWoaEwZ7/QBISn6RaAygCIcQvAQlTgO
g+MMLgSgS+DQ3+fXzVZodUEtz6dDg8T8IHbO+U8wQeFUFAyeVxz9v8NvxWck7gfJ
8pHp5JK1t75kl+hs1h4Jcbv325W23g4cKrxjdv/hmURnIaqtb9+yfdmt5Lh/4trZ
PbM3eQ9/te7//rxDcpK67Hwr8FmCc1d6uoiNwrQh+w+Se64tZqmi5IwWQ9yQxT3d
4E3p2FFJcQ+Jlt/0sEzVLFXcspsZ80vPjbe9CH3buXYL5bt8K7dBnQabYwUbrTZq
f4leLJoB2SYAP/Mn+0t3/JUkI5pvvSVjaws/bo2A1H/crl0uQKuXvHjMuoSY35N1
KKFobcz03vmd9cOvKj0pOYltRYwUMLmhFJKoGoYmNK3DXPV9ULjltW7NeZGN6Zkg
Bx6EOfLi+LBsPAraf2MuGkU/VOiCZV5cpsz1A7i9LI2jBBxlJRQs6XcTtA==
-----END CERTIFICATE----- -----BEGIN CERTIFICATE-----
MIIFHTCCAwWgAwIBAgIULS5aUkGYJTFXhqqFV19J8v/Z1u4wDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKc2VkbmFsLmxhbjAgFw0yNjA5MDMxMzE1MTRaGA8yMDUx
MDkwNDEzMTUzOVowFTETMBEGA1UEAxMKc2VkbmFsLmxhbjCCAiIwDQYJKoZIhvcN
AQEBBQADggIPADCCAgoCggIBAMJsR2WfJlwHJbFD6SUg7p90NMNr2BM6sU4eCr3d
k4FmWgmF0aPL/vcQAs8pkEEJeo3fZlFDQ0HkAM6dryP8teX7EI1eW19VSEhb6yXJ
3bgrNzAc0p25pthbItt7DhJWk7RJ1DrX1rOfOGmPPDE+ol85IzUk9a7Vi8ahefIJ
eqBqL1J47Kj3yspWIeOyOqVVNi1leS7lj3f91TWpnnwYBWA9gUVFrZnijsVyWUc9
UjxP+N2BnomfxQQW3mpuxirqVlIZW54y1a1pKd3/YNd3ikcAFdPV1tU7wVqXec/3
h6L08UAMCGLIF6jjfFO/DaBRpcf7yr9J4zoLxrM/wX5uUbSM+4dw95FbgYkAFned
Gt2TUX5VwGY9oKdlFKDoeVSNKB0+L43ZNiCAxlGoYyyFrXWbqkB8m8QVNSmRmuGk
J3mQBKswtJJeQCR2mNqwHIt8Hh6R9Dj1ceCxtpZ+aEk2kSB/aKDR1AyBu2D1wnXI
fyW1AqzUX5HH1buPSgfzqHqNwAy+MPJH5bmst2xcivKPn5oEmiG/zDMIsBGCn3JB
IBHn5J1AtwPDHYxCCPTNl2Fy/E1SR8Nm0YbN2zkPAax5ZGVpsUOsd1Wp6ndEeP53
1txX0W+WyFfET9CXNIaWGKJBTQ2sBboRlbpjbwvMPun6utqAageLcsdzKEd9fNDk
eQwRAgMBAAGjYzBhMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0G
A1UdDgQWBBTmEW5ZItpOU+poAAr0xXKw39kruDAfBgNVHSMEGDAWgBTmEW5ZItpO
U+poAAr0xXKw39kruDANBgkqhkiG9w0BAQsFAAOCAgEAU/lQQ1BviD/gZYAIIKkx
LxzjM+WkVMDlb1Y+lDY+j2FjpqjQHOswz9BLAPKVmnnOeMQFG5EmYDY1lF+L4Xl1
GpRloutzvXzmz4Pw7PwKGafhJRmna+slUlMuMDYSHTp4e8wHiX9ecuSJuI505hck
r8X72D5bIZAIR+e3B2zoEnTOuqJU6Vj+5NveDHvpjxEiYOELyT5ZW7D62aJNrZcj
YIfYb/H/2kd1irOc40znpA7Uzf/dj88N2SOIVLQ58Uh8WB7X+CRPju+xkGM9Yhlf
gcVvbP2vplT7xUpvq12Jfk/dwBA4cOH8EQpCAP/ThN1IfIeQt/gCl62Se3S/AlUL
gyXNArvn4xcUzNhcwRj6be2ClLABkqQHBXbFADtPbgzFwf+fygEKuim1SbBQqlSt
VBZkqwwZQvs/IGywYkolZiq4xvIOvi6bK/WFvkIWrb0tAvbSBEW+dgfVTg21RmGR
X2eoBmY7hwrTpBBQAYjK/Nbx8Hjx7kKDWeAIhlET+pavJMWrV+xeLCA86ub4GfOz
pJFs/i2mlN0S3YFNdm8l/QWqcB+J3bRzhNCdUp9ETCd3QZR8w5PbL12+S1Hajaba
LoVp7ToQ+5VC2GfY4dh94qp7AaJGAJMNquA9bctwrKWQGRVFbA0Lh7oUR8EQv5Vn
jxgSQY0mk3OKlI3WATC1XT8=
-----END CERTIFICATE-----]
certificate         -----BEGIN CERTIFICATE-----
MIIE+jCCAuKgAwIBAgIUWvvJvk0oBO8QCy7v9TprwVeUlBwwDQYJKoZIhvcNAQEL
BQAwLDEqMCgGA1UEAxMhc2VkbmFsLmxhbiBJbnRlcm1lZGlhdGUgQXV0aG9yaXR5
MB4XDTI2MDkwMzEzMTk0OVoXDTI2MDkwNDEzMjAxOVowGjEYMBYGA1UEAxMPdGVz
dC5zZWRuYWwubGFuMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxKOF
f6/vHqPkZTFgbYd6ojtQNeaVWusjkDF6Gbw4s2YxuVsnAf8TIgFufM+wN8eWCWTm
XL+yDLUNCRiSnQYK2hpBtN6ijJEIqH4U01T26qYvpym9RFFPy0ytixlH/sDlvY2m
oGKjxZukGj8vBK7zqMFwpunmRSLk7YUV2oSDx/rqB+YImKr8Ni5y5hbx3QmoZWgl
IJsSeyUdEg2lE8AN8YX9cJhK9HZNpLnZS28tE4uYzmSKC/cOGi2X+DZcJb10JX91
xa36o7uyjTzJAHJRWJ7H66pRajql4Ni4PxOubnEPh6Ki1jd5r9+LapsvFHZE0mzK
qiktdTktTCYhf2IgJwIDAQABo4IBJDCCASAwDgYDVR0PAQH/BAQDAgOoMB0GA1Ud
JQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAdBgNVHQ4EFgQUVBlktqdN7ugDyKLQ
Yq02mE8X3r0wHwYDVR0jBBgwFoAUQLOAQSQd92ECp9ulBnmWTrRGa/wwTgYIKwYB
BQUHAQEEQjBAMD4GCCsGAQUFBzAChjJodHRwOi8vaW5mcmEuc2VkbmFsLmxhbi9j
cmwvU2VkbmFsLUludGVyLVJTQS0xLmNydDAaBgNVHREEEzARgg90ZXN0LnNlZG5h
bC5sYW4wQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2luZnJhLnNlZG5hbC5sYW4v
Y3JsL1NlZG5hbC1JbnRlci1SU0EtMS5jcmwwDQYJKoZIhvcNAQELBQADggIBAAcV
fin1goyXOJ+/XjBD+3rNFMFpAkgjTH6TD8Q5aOsAW6smEEtZPw8Z2twdNeh6Ob93
v3cyXCeBardzXBXjbRrPvCykUjvhuXnhHpTkbjHQHHljtW0arRYAsjuoT4RjGt76
7p+gXznhdoOSWnpLoy+kuSHZzLo43XPEumm9VDUFAaiVUtZ+nfoz+sq9S1tk9g8Q
icSuFYw74SyrZJmfOg0MK4NUQEtuCXebdtUogpruhXE0BSEUmitZa911ytu+KeGW
OvrGqgiIbLv5ess0YUdjCUoARegBTILIaWUn61ahl08/UZyWvXqOzKPpeGoAIu7A
KnL9h5rfprcTaOFM2dVS/V2zfaWfuc3QHtla+0y5i/UcVlS5TcUVpc+GBLqOvjz6
+8zdEcd5l+pzhJ3Q8u6BIauLGcjP4OtveHc8QGsLgcfZSUZZ49ICIM4iUbnAWV7X
zgPTFcdsKSXLn4u1ua5UYVs+HWv9WWpWM1c+AA3mwG5eq0XvioBUMKVaCss3CQO/
0Yi5LAZCZa590HnvecGGjtRJxEGltSqNxL0sEJUCgRYQvEI/iOxAKruwa1RZjMF8
+zHEQgujihHV+VneojGtBtnRB2AUNcmFPIrBJeY6pOyUA7ySdnnA/YwI2Kk1wOtT
+T2LEVriWYiSyvopFAbYqD/l8JaxNjXs2B+tDVNw
-----END CERTIFICATE-----
expiration          1788528019
issuing_ca          -----BEGIN CERTIFICATE-----
MIIFxzCCA6+gAwIBAgIUZXNLVAblOppqJdu0nuCfno15bcowDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKc2VkbmFsLmxhbjAeFw0yNjA5MDMxMzE2MDdaFw0zMTA5
MDIxMzE2MzdaMCwxKjAoBgNVBAMTIXNlZG5hbC5sYW4gSW50ZXJtZWRpYXRlIEF1
dGhvcml0eTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAL5ezmLfi70b
tR/STJOWZcdEUQHCG2ZPT4pNnJ3RKrPscSI5/GP16Xl/mV4C7BxiOljmABQ9q9XG
BchqMt7sQwubZHdG5q5BHYmmdN7MnuYyh0FLP0R+dLu4p+8Wqu4JJcMzzb9CID8k
P1ZB7Jdw60AdLCw3YdcBX/6d4GC+EGdF7RTvzt3eStZzTDP2M+DdGvHFL/clK3p1
2lCl11SCC+wsBEhf71iImrT5PFRrfIeM53POgd3VDuEVr0e0DY1ohV8IW0L5XL4x
DwA0IhQshPOQW6YnnpNQt8YRFbDMdoxQ47UPCamKoG4u4v0g63gXUmDjnKDZp3xD
ybKyiGzsNg5Fw58pAkVsxnFFtiwqyMH6mpXMNvm3y01E1k7K5oARFW2VU+/0Yitm
Isfxte2yW/x5ZbFsbJfBNM3gemqELkEc/CGO5bq38T3VaPVRQgl42wV2U42Xf91f
09tHeAKoLY6Fe8G+RQy6cf9zJLIbhKeOyckgbuYDPe5diL4h0uG7MU25dhInxc3K
0nMjzoRB7HA+PPyn1A/QMNLZbFVzy4giaw2sZ4k65ZbtuOklPnpOQgvgBbEvW2II
DQQ76wTlyORCAW3pgUq0/Uu94cBsbu1Rcm+m9MwTNNd5h9jJX+yTvQYflCNGoTXY
BiNTZDPOD5D669T7qUTJQCBSKekenzzzAgMBAAGjgfcwgfQwDgYDVR0PAQH/BAQD
AgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFECzgEEkHfdhAqfbpQZ5lk60
Rmv8MB8GA1UdIwQYMBaAFOYRblki2k5T6mgACvTFcrDf2Su4ME0GCCsGAQUFBwEB
BEEwPzA9BggrBgEFBQcwAoYxaHR0cDovL2luZnJhLnNlZG5hbC5sYW4vY3JsL1Nl
ZG5hbC1Sb290LVJTQS0xLmNydDBCBgNVHR8EOzA5MDegNaAzhjFodHRwOi8vaW5m
cmEuc2VkbmFsLmxhbi9jcmwvU2VkbmFsLVJvb3QtUlNBLTEuY3JsMA0GCSqGSIb3
DQEBCwUAA4ICAQAYGoxlo3bcCtknfgwebkjL35inL/jlVNIRAVGFgqOP1Yz4sScK
vq9Jlo7mjAdz9cKhiewqVED6jKleH82qxitBW9TxID0LojRZEtMSiceR4A6xme5u
RuthQCwFy1Ycgmwf1TztCiCIzEXIprMFrUU6Qp688kaIZR7qvFHZnaeTj7vKEb8e
TKYIU7v26UxOU2KomVysICRTsJqizyCguGWoaEwZ7/QBISn6RaAygCIcQvAQlTgO
g+MMLgSgS+DQ3+fXzVZodUEtz6dDg8T8IHbO+U8wQeFUFAyeVxz9v8NvxWck7gfJ
8pHp5JK1t75kl+hs1h4Jcbv325W23g4cKrxjdv/hmURnIaqtb9+yfdmt5Lh/4trZ
PbM3eQ9/te7//rxDcpK67Hwr8FmCc1d6uoiNwrQh+w+Se64tZqmi5IwWQ9yQxT3d
4E3p2FFJcQ+Jlt/0sEzVLFXcspsZ80vPjbe9CH3buXYL5bt8K7dBnQabYwUbrTZq
f4leLJoB2SYAP/Mn+0t3/JUkI5pvvSVjaws/bo2A1H/crl0uQKuXvHjMuoSY35N1
KKFobcz03vmd9cOvKj0pOYltRYwUMLmhFJKoGoYmNK3DXPV9ULjltW7NeZGN6Zkg
Bx6EOfLi+LBsPAraf2MuGkU/VOiCZV5cpsz1A7i9LI2jBBxlJRQs6XcTtA==
-----END CERTIFICATE-----
private_key         -----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAxKOFf6/vHqPkZTFgbYd6ojtQNeaVWusjkDF6Gbw4s2YxuVsn
Af8TIgFufM+wN8eWCWTmXL+yDLUNCRiSnQYK2hpBtN6ijJEIqH4U01T26qYvpym9
RFFPy0ytixlH/sDlvY2moGKjxZukGj8vBK7zqMFwpunmRSLk7YUV2oSDx/rqB+YI
mKr8Ni5y5hbx3QmoZWglIJsSeyUdEg2lE8AN8YX9cJhK9HZNpLnZS28tE4uYzmSK
C/cOGi2X+DZcJb10JX91xa36o7uyjTzJAHJRWJ7H66pRajql4Ni4PxOubnEPh6Ki
1jd5r9+LapsvFHZE0mzKqiktdTktTCYhf2IgJwIDAQABAoIBAF0gjJMigX7jY8HB
FsgIx72Zla1RXR7ICfm6VPdnOvtLxPTiBKFfanJKd0dJHU3tilM8pBT8/JgkDt5l
8tnHCNCuarv8TMOB1LXnsHk93grXVe43SFnYoI/J6s7b1EsElEmnkmiXDrUBt0Bu
+Behu+gKZQ3H7LSFiCItS2JILBlDF/LVwwih7TV1r+i/4QbAiAqti346lAPQVz/6
ELrAWuGbKSLm/RaWVZOh6dKcUDOlrrlIuejSipl/NUZxxqs/QLTAvUv+s9bkJSH7
GILqVCBBMpExdDeUdeLHlL105rlFOiii1Q7J12UQOT30adK/6hA1DZWhXLRS7Ici
XztHdyECgYEAxg+CzdqOtzlT95BaW7fmJRU3VfwEUrMUbqJA0ozR9xV5Lx/Zwrw6
hgqfVF8fHc5lqmSIh/7NrtwHSKYogj39WE34QcMbKf+XuZfPoy1cfw8ypia9STHS
Ea8HG28T17STp6w0yWwXbjUKTRQAMSFp6Rn20mT6QkoZBXMVO+QJp4kCgYEA/imI
BDQyW9spUihTPtfxB2cKeKPnWJzkdq2Mx4i4Gelg3OnsmvIuHqaxtW7o4zW5tw/Q
ElYrNTX8WrjZElRPhko6kBFSIstNS2d6KLHbBXw8QQaYj7nHw8IyBMLa5yeQJMC/
PhvUA4E8jguJEBGeCx7bs6h7GA5xOdxoQZdD7i8CgYB+NbAiwV0kQLHTFfeebqeH
heeHMVsH3/nrLhWklfvOOa7JasB3KT8Z33b8askHU1jRpdKi5qnm/WrezpMNu7bP
KJBER7Htp2Pl7mlwEB3bEbIy0ojYNZkpj6E1yCia0gUtWb0hhXHA1qfDyjT9Gc/F
rLfuBk67I0Ciil1DluLYEQKBgQCYFeH+If3AWXRwZRDrGexwsYfiiLF2pOtQ2KjU
/Uqstqnvh0q9rQ1L6hOMrcFNtGhc0ml/j3BrdtJ6twGtpiWwBdrlOngbueuWo2TF
1SdqMN0dTAUee9y9lwa3MqIqj9IBLBVD5QMI1dyWYvCxXNllbiGpb7e4vWujY/A+
z3UmoQKBgHUb6SE9MzRg8VD4DAfwPQpD1/8Kfrl6ongGeXKkkG+5Qk7mQSXZ6Ge7
+bUqoG8gsYWc2vCkfkZ4O6uCMhCIZFfUnArkWHpXeB9VeS0MZ1nTMDZl8blmWfcP
m8PYdiReRQZO5i4JyJi4HdgoPMNZtWrtJJVCFqhmzrCQH/vDEAUm
-----END RSA PRIVATE KEY-----
private_key_type    rsa
serial_number       5a:fb:c9:be:4d:28:04:ef:10:0b:2e:ef:f5:3a:6b:c1:57:94:94:1c
````


</details>

- Nettoyage du test
````
vault list PKI-Sednal-Inter-RSA/certs
vault write PKI-Sednal-Inter-RSA/revoke serial_number="[SERIAL]"
````

