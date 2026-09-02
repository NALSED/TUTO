# Retour sur l'implémentation de Vault.

---

La première implémentation, archivée dans `TUTO/PERSO/VAULT/ARCHIVE_V1/`,
présente beaucoup de problèmes.

La découverte simultanée d'un nouvel outil et de nouveaux concepts a eu pour
effet de complexifier à la fois la mise en place et la documentation. En
l'état, son maintien est quasiment impossible, ou en tout cas beaucoup trop
chronophage.

Je produis donc une **V2** de l'implémentation de Vault : mêmes objectifs
— PKI interne et auto-unseal — mais une mise en œuvre plus simple et
réellement maintenable.

Je m'appuie pour cela sur la V1 et sur un audit du dépôt réalisé par Claude,
qui pointe un certain nombre de problèmes, d'incohérences et de fragilités.
Cet audit est reproduit ci-dessous.


<details>
<summary>
<h2>
AUDIT
</h2>
</summary>

| # | Fichier | Problème | Correctif |
|---|---------|----------|-----------|
| 1 | `PKI/-4-` §1.3 / §1.6 | `crl_distribution_points="http://pihole.sednal.lan/crl/root_r"` alors que le endpoint nginx est sur `infra.sednal.lan` (`PKI/-2-`) et que `push-crl.sh` pousse vers `sednal@infra.sednal.lan:/var/www/pki/`. **Tous les certificats émis pointent vers une CRL qui n'existe pas.** | `crl_distribution_points="http://infra.sednal.lan/crl/root_r"` (idem `root_e`, `intermediate_r`, `intermediate_e`) |
| 2 | `SCRIPT/PKI/push-crl.sh` | `curl -s http://vault.sednal.lan:8200/...` → le listener est en TLS. Le curl échoue, `-o` crée quand même 4 fichiers **vides**, poussés en prod par `scp`. Pas de `-f`, pas de contrôle. | `https://` + `--cacert` + `curl -sf` + validation `openssl crl` avant push |
| 3 | `SCRIPT/PKI/demande_cert.sh` | Bloc INFRA : espaces après le `\` de `"$base_ca/Sednal_Root_E-1.crt" \   ` → **la continuation de ligne est cassée**, le rsync part en vrac | Supprimer les espaces parasites |
| 4 | `PKI/-4-` §2 (concaténation) | Variable `$path` **jamais définie** (seuls `$path_root` et `$path_inter` existent) ; noms de fichiers faux (`Sednal_Inter_R.crt` au lieu de `Sednal_Inter_R-1.cert.pem`) ; le bloc ECDSA **écrase** le fichier RSA. → `Sednal_Root_All.crt` n'a jamais pu être correct | Voir Phase 3.4 du plan |
| 5 | `Auto_Unseal_Vault.md` §2-2 | Signature du cert `Vault_Root` lancée **sur 238** avec `-CAkey /etc/Vault/Vault_Root/Cert/private/CA.key` : la clé privée de la CA est sur **241** et n'y est jamais copiée (et ne doit pas l'être) | Signer sur 241, ne transférer que le `.crt` |
| 6 | `Auto_Unseal_Vault.md` §2-2 | `Vault_Root.cnf` → `[dn] CN = vault_2.sednal.lan` (copier/coller de Vault_Auto) | `CN = vault.sednal.lan` |
| 7 | Partout | `vault_2.sednal.lan` : **underscore interdit** dans un nom d'hôte (RFC 1123). Certains résolveurs et libs TLS le rejettent | Renommer en `vault-auto.sednal.lan` |
| 8 | `Auto_Unseal_Vault.md` §5 | `vault token create -policy=autounseal` → **TTL par défaut 768 h renouvelable**. Si 238 reste éteint > 32 jours, le token expire et l'auto-unseal ne repart **jamais**. C'est très probablement la cause de la VM « dead » | Token **périodique** : `vault token create -policy=autounseal -period=768h -orphan` |
| 9 | `PKI/-4-` §5 | `OnCalendar=*-*-1/80` = « le 1er de chaque mois », pas « tous les 80 jours ». `RefuseManualStart=yes` interdit tout test manuel du service | `OnUnitActiveSec=80d` + `Persistent=true`, retirer `RefuseManualStart` |
| 10 | `SCRIPT/PKI/renew_cert.sh` | Ne redéploie **pas** les CA, ne refait **aucune** concaténation (`bareos_webui.pem`, `cert_key_tls.pem`, `ws-certs.d/`, `pve-ssl.pem`) et **ne redémarre aucun service**. Après renouvellement, tous les services continuent de servir l'ancien certificat jusqu'à intervention manuelle | Voir Phase 5 |
| 11 | `renew_cert.sh` / `demande_cert.sh` | `ssh "$cible" "rm -f keys/* cert/*"` **avant** le rsync → si le rsync échoue, le service se retrouve sans certificat, sans rollback | Écrire en `.new`, valider, swap atomique |
| 12 | idem | Pas de `set -o pipefail` ; si `vault write` renvoie vide, `jq -r` écrit littéralement `null` dans le `.crt`. Pas de `VAULT_ADDR`/`VAULT_TOKEN` dans l'unité systemd (dépend de `~/.vault-token` de `sednal`), et `sudo tee` exige un NOPASSWD | Voir Phase 5 |
| 13 | `PKI/-3-` §4.4 | Vhost Apache WebUI → `/etc/bareos/ssl/certs/bareos.sednal.lan.crt` et `/ssl/private/...` : **ces chemins n'existent pas** dans l'arborescence `-8-` | `cert/web/bareos_rsa.crt` et `keys/web/bareos_rsa.key` |
| 14 | `PKI/-3-` §2.1 | `bareos_webui.pem` en `640 bareos:bareos`, mais il est lu par **php-fpm (`www-data`)** → *permission denied* | `usermod -aG bareos www-data` (ou `640 root:www-data`) |
| 15 | `PKI/-3-` §1.2 / §1.4 | `TLS Allowed CN = "bareos.sednal.lan"` sur le Director et sur `Storage_Local`, alors que les certificats portent `CN=bareos-dir.sednal.lan` et `CN=bareos-sd-local.sednal.lan` (cf. `-6-`) → **échec de vérification du pair** | Aligner : soit un CN unique, soit la bonne liste de CN par ressource |
| 16 | `PKI/-3-` §1.2 et §3.2 | `TLS Authenticate = yes` : TLS n'est utilisé que pour **l'authentification**, le flux repasse **en clair** ensuite. Contradictoire avec l'objectif « tout chiffré » | Retirer `TLS Authenticate` et laisser `TLS Enable = yes` |
| 17 | `-8-` vs scripts | `-8-` annonce « Bareos RSA uniquement », `-9-` annonce `Ecdsa (vide)`, mais `demande_cert.sh` et `renew_cert.sh` génèrent **et poussent** l'ECDSA pour tous les services Bareos | Trancher et aligner les 3 |
| 18 | `-9-` vs `-4-` | `-9-` : `Sednal_Root_All.crt ← cat XS-1 + R-1 + E-1` (cross-sign) et un `cross_e1.csr`, alors que `-4-` dit explicitement « sans cross-signing ». Aucun de ces objets n'est produit nulle part | Supprimer les références au cross-sign |
| 19 | `-9-` vs scripts | Arborescence documentée en CamelCase (`/etc/Vault/PKI/private/Bareos/Rsa`) vs scripts en minuscules (`/etc/vault/pki/private/bareos/rsa`). Sur Linux c'est **bloquant** | Tout en minuscules |
| 20 | `PKI/-2-` §1.3 | nginx : `alias` vers un fichier + pas de `default_type application/pkix-crl`. Fonctionne, mais fragile et mauvais MIME | `location = /crl/root_r { alias ...; default_type application/pkix-crl; }` |


</details>
