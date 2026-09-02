# Compte rendu infra + plan de reconstruction

Périmètre relu : `PERSO/VAULT/**` (PKI, scripts, auto-unseal) et `PERSO/SAUVEGARDE/BAREOS/BAREOS2/**`.

---

# PARTIE 1 — COMPTE RENDU DES ERREURS

## 1. Bloquants PKI / Vault

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

## 2. Bloquants Bareos

| # | Fichier | Problème | Correctif |
|---|---------|----------|-----------|
| 21 | `-F-` / `-B-` 2.2 | `Storage_Remote { Address = 176.31.163.227 }` alors que toute l'archi repose sur le tunnel autossh `localhost:9103`. Le tunnel ne sert donc à rien — et dès que le SD du VPS sera bindé sur `127.0.0.1` derrière nftables en DROP, **la connexion échouera** | `Address = localhost` (via tunnel) |
| 22 | `-A-` §3.6 + `-K-` | Le tunnel `-L 9103:localhost:9103` bind `127.0.0.1:9103` pendant que le SD local écoutait `0.0.0.0:9103` → c'est **exactement** l'erreur `Cannot bind address ... Address already in use` du troubleshooting. Le contournement (`SD Address = bareos.sednal.lan`) marche mais reste fragile | Tunnel sur un port dédié : `-L 9104:localhost:9103`, et `Storage_Remote { Address = localhost; SDPort = 9104 }` |
| 23 | `-A-` §3.6 | `autossh ... debian@172.31.163.227` → **typo**, le VPS est en `176.` | Corriger l'IP |
| 24 | `-A-` §3.4 | Règles **iptables** sur le VPS, alors que le VPS tourne désormais en **nftables policy DROP** (serveur mail + fail2ban) → règle inopérante ou stack mixte | Réécrire en nftables dans la chaîne input existante |
| 25 | `-I-` | `pg_dump ... -f /home/sednal/BackUp_SQL_Bareos_$(date...).backup` → le dump atterrit **à côté** du dossier `/home/sednal/BackUp_SQL_Bareos`, seul chemin déclaré dans le FileSet. **Aucun dump n'est sauvegardé.** Slash manquant | `/home/sednal/BackUp_SQL_Bareos/bareos_$(date +\%F).dump` |
| 26 | `-I-` + `-J-` | Cron du dump à **11 h 55** le dimanche, WoL du serveur Bareos à **12 h 00** → la machine est éteinte, **le dump ne tourne jamais** | Déplacer à 12 h 15, ou basculer en `RunBeforeJob` |
| 27 | `-I-` + `SCRIPTS/Install_PostGreSQL_Bareos.sh` | `pg_dump -U bareos` depuis le cron de `sednal` avec `pg_hba : local all bareos md5` → demande un mot de passe → **échec silencieux** | `~/.pgpass` (600) ou exécution en `postgres` |
| 28 | `-I-` | Aucune rotation des dumps → saturation de `/home` à terme | `find ... -mtime +90 -delete` |
| 29 | Dépôt entier | **Aucun job `BackupCatalog`**, aucun `RunBeforeJob`, aucun `make_catalog_backup.pl`. La sauvegarde du catalogue repose uniquement sur le cron cassé ci-dessus | Voir Phase 6 |
| 30 | `-C-` | Full mensuel + `Volume Retention = 6 days` (Win/Lin LAN) et `29 days` en WAN pour un Full tous les 2 mois → **le volume contenant le Full est recyclé avant le Full suivant**. La chaîne de restauration est perdue | `Volume Retention` ≥ 2 cycles (≈ 70 jours) |
| 31 | `-C-` 1.1 | `Maximum Volume Bytes = 680G` × `Maximum Volumes = 2` = **1,36 To** sur un LV de 700 Go | 50G × 12 par ex. |
| 32 | `-C-` 2.3 | `Lin_BackUp_Pool_WAN { Storage = Storage_Local }` → **le pool « WAN » écrit en local** | `Storage = Storage_Remote` |
| 33 | `-C-` | `Purge Oldest Volume = yes` : déconseillé par Bareos, purge sans condition la plus ancienne bande même si elle est encore nécessaire | Retirer, laisser `Recycle`/`AutoPrune` faire le travail |
| 34 | `-H-` 2.1 | `Pool = WinBackup_Pool_WAN` alors que le pool s'appelle `Win_Backup_Pool_WAN` → **`bareos-dir -t` échoue** | Corriger |
| 35 | `-D-` 1.3 | **Accolade fermante manquante** sur le FileSet Linux ; le fichier s'appelle `Lin_Archive_FileSet_LAN.conf` mais la ressource s'appelle `Lin_BackUp_FileSet_LAN` | Corriger les deux |
| 36 | `-E-` 2.1 | `Run = Incremental 1st sun feb apr jun aug oct dec 14:00` → **mot-clé `at` manquant** | `... dec at 14:00` |
| 37 | `-F-` 1 | `Device = Locale_Device` vs `Local_Device` défini dans `-B-` 1.1 | Corriger |
| 38 | `-B-` / `-K-` / `-L-` | Nommage mélangé : `Local-Sd`, `Local_Sd.conf`, `Storage_Local`, `storage_local`. `-K-` montre un bloc Director dans le chemin d'un fichier SD | Uniformiser |
| 39 | `-D-` 1.1 / 2.1 | Exclusions Windows `C:/Programmes`, `C:/Programmes(x86)` : **ces dossiers n'existent pas** (`Program Files`). `signature = MD5` | `C:/Program Files`, `C:/Program Files (x86)`, `signature = SHA256` |
| 40 | Dépôt entier | **Aucun `bareos-fd` sur le VPS**, aucune ressource Client pour lui → `mail-data`, config DMS, volumes SOGo, `/etc/letsencrypt` : **rien n'est sauvegardé** | Voir Phase 6 |
| 41 | `-J-` | `apt install wakeonlane`, `sudo contab -e`, `/sbin/powerofff` : trois typos. Le `poweroff` de 16 h 05 coupe le serveur **sans vérifier qu'aucun job ne tourne** | Corriger + garde `bconsole` avant extinction |
| 42 | `-G-` | Aucun `Job Retention` / `File Retention` sur les Clients → défauts (180 j / 60 j) plus longs que la rétention volume → entrées catalogue orphelines | Aligner sur la rétention volume |

## 3. Sécurité

| # | Problème |
|---|----------|
| 43 | **Secrets en clair dans un dépôt public** : mot de passe console (`q0NK...`), Storage (`fCQq...`), clients `win` (`f5YT...`) et `lin` (`g+zM...`), profil WebUI `Password = "131213"`, ancien `File.conf` (`2IL4...`). → **rotation complète + purge de l'historique git** (`git filter-repo` / BFG) + `.gitignore` |
| 44 | Root token Vault utilisé pour tout, y compris dans les scripts automatisés. Token auto-unseal en clair dans `vault.hcl` (identifié dans la doc mais jamais traité) |
| 45 | **Aucun `vault operator raft snapshot save` nulle part.** C'est le point qui transforme une VM morte en reconstruction complète de la PKI |

---

# PARTIE 2 — PLAN DE RECONSTRUCTION

## Phase 0 — Avant de casser quoi que ce soit

1. **Tenter de récupérer le raft de 238.** Si le disque de la VM est encore montable, copier `/opt/vault/data` intégralement. Avec ce répertoire + la clé `transit/autounseal` intacte sur 241, on redémarre un Vault neuf dessus et **on garde les CA existantes** → on saute toute la Phase 3.
2. Sortir les *unseal keys* + root token de 241 **et** de 238 (GPG Kleopatra, copies VPS + disque externe). → **c'est le moment de traiter le dossier `cle` et l'archive `cle.tar.gz`** : vérifier le contenu, ce qui est encore valide, ce qui est à re-chiffrer, et consolider en un seul emplacement documenté.
3. Sur **241** : `vault status`, unseal si nécessaire, puis `vault read transit/keys/autounseal` → si la clé a disparu, aucun raft de 238 n'est déchiffrable.
4. **Point de décision :**
   - **A —** raft récupéré + clé transit OK → Phases 1, 2, puis 4 → 7 (les CA sont conservées, rien à redistribuer).
   - **B —** raft perdu → **les clés privées des Root CA sont perdues**. PKI entièrement neuve : Phases 1 → 7 complètes, avec redistribution du magasin de confiance sur les 6 machines + le PC Windows.
5. Sauvegarder les configs actuelles avant modification : `tar czf ~/pre-rebuild-$(date +%F).tgz /etc/bareos /etc/nginx/sites-available` sur 239 et 240.

## Phase 1 — Nouvelle VM 238

6. Debian 13, IP fixe `192.168.0.238`, FQDN `vault.sednal.lan` déclaré dans pfSense.
7. **NTP obligatoire** (`timedatectl set-ntp true`) : un décalage d'horloge casse toute la validation PKI.
8. `apt install vault jq cron rsync openssl` (dépôt HashiCorp).
9. Créer l'arborescence `/etc/vault/pki/{private,public}/{bareos,infra,pihole,upsnap,cockpit,proxmox,postgresql,vps}/{rsa,ecdsa}` + `cert_ca/{root,inter,csr}` + `config/policy` — **tout en minuscules** (correctif #19). Reprendre `deploiement_vault.sh` corrigé.
10. SSH : `ssh-keygen -t ed25519 -C vault-admin`, puis `ssh-copy-id` vers 239, 240, 241, 242 et `debian@176.31.163.227`.
11. **Purger l'ancienne clé publique** de la VM morte dans les `~/.ssh/authorized_keys` des 6 machines.
12. `usermod -aG vault sednal`.

## Phase 2 — TLS de Vault + auto-unseal

13. Sur **241**, générer clé + CSR du nouveau `Vault_Root` avec `CN = vault.sednal.lan` (correctif #6) et SAN `DNS:vault.sednal.lan, DNS:localhost, IP:192.168.0.238, IP:127.0.0.1`.
14. **Signer sur 241** (la clé de la CA y réside — correctif #5), puis transférer sur 238 uniquement : `CA.crt`, `Vault_Root.crt`, `Vault_Root.key`. Droits `vault:vault`, `644` / `640`.
15. Sur **241**, recréer un token auto-unseal **périodique** (correctif #8) :
    ```
    vault token create -policy=autounseal -period=768h -orphan -display-name=autounseal-238
    ```
16. `/etc/vault.d/vault.hcl` sur 238 : storage raft `node_id = "vault_root"`, listener 8200 TLS, bloc `seal "transit"` pointant vers 241 avec le nouveau token.
17. `systemctl enable --now vault` puis `vault operator init` → **sauvegarder immédiatement** les 5 clés + le root token (GPG, deux emplacements distincts).
18. Vérifier : `vault status` → `Sealed false`, et dans les logs `unsealed with stored key`.
19. **Test de résilience** : `reboot` de 238 → Vault doit revenir *unsealed* sans intervention.

## Phase 3 — PKI *(branche B uniquement)*

20. Policy : `vault policy write sednal-pki /etc/vault/pki/config/policy/Policy_PKI.hcl`.
21. Root RSA 4096 (25 ans) + Root ECDSA P-384 (25 ans), `issuer_name` `Sednal_Root_R-1` / `Sednal_Root_E-1`.
22. `config/urls` avec le **bon** point de distribution (correctif #1) :
    ```
    vault write PKI_Sednal_Root_RSA/config/urls \
      issuing_certificates="https://vault.sednal.lan:8200/v1/PKI_Sednal_Root_RSA/ca" \
      crl_distribution_points="http://infra.sednal.lan/crl/root_r"
    ```
    (idem `root_e`, `intermediate_r`, `intermediate_e`) puis `config/crl auto_rebuild=true enable_delta=true`.
23. Intermédiaires RSA + ECDSA (5 ans) : `intermediate/generate/internal` → `root/sign-intermediate` → `intermediate/set-signed`.
24. Concaténation **corrigée** (correctif #4) — un seul fichier, chaîne feuille → racine :
    ```
    cd /etc/vault/pki/cert_ca
    cat inter/Sednal_Inter_R-1.cert.pem root/Sednal_Root_R-1.crt \
        inter/Sednal_Inter_E-1.cert.pem root/Sednal_Root_E-1.crt \
        | sudo tee root/Sednal_Root_All.crt > /dev/null
    sudo chown vault:vault root/Sednal_Root_All.crt
    ```
25. Rôles `Cert_Inter_RSA` / `Cert_Inter_ECDSA` : `ttl=90d`, `max_ttl=365d`, `allowed_domains=sednal.lan`, `allow_subdomains=true`.
26. `demande_cert.sh` corrigé (#3, #12) → émission + déploiement sur les 6 machines.
27. Sur chaque machine : `cp Sednal_Root_*.crt Sednal_Inter_*.pem /usr/local/share/ca-certificates/` + `update-ca-certificates --fresh`. Sur le PC Windows, réimporter dans « Autorités de certification racines de confiance ».
28. Point CRL sur 239 : nginx corrigé (#20), puis test
    ```
    curl -s http://infra.sednal.lan/crl/root_r | openssl crl -inform DER -noout -text | head
    ```
    (⚠ `/crl` renvoie du **DER**, `/crl/pem` du PEM — à préciser dans le tuto).
29. `push-crl.sh` v2 (#2) : `https` + `--cacert` + `curl -sf` + validation `openssl crl` avant `scp`. Cron quotidien.

## Phase 4 — Reprise des clients

30. **Bareos 240** : chemins du vhost Apache (#13), droits `bareos_webui.pem` + `www-data` (#14), `TLS Allowed CN` alignés sur les vrais CN (#15), suppression de `TLS Authenticate` (#16).
31. **Infra 239** : `nginx -t` puis `systemctl reload nginx`.
32. **241** : concaténation `cert_key_tls.pem` (Pi-hole) + copie dans `/etc/cockpit/ws-certs.d/`, restart `pihole-FTL` et `cockpit`.
33. **Proxmox 242** : copie vers `/etc/pve/local/pve-ssl.{pem,key}`, `systemctl restart pveproxy`.
34. **VPS 176.31.163.227** :
    - `/etc/vps/ssl` repeuplé ;
    - `bareos-sd` bindé sur `127.0.0.1` (`SD Address = 127.0.0.1` dans `Remote_Sd.conf`) ;
    - **suppression de `bareos-dir` et du PostgreSQL locaux** — inutiles, le Director est sur le Gen8 ;
    - règle **nftables** (pas iptables, #24) : le SD n'est plus joignable que par le tunnel ;
    - tunnel autossh corrigé (#22, #23) : IP `176.`, `-L 9104:localhost:9103` ;
    - côté Director : `Storage_Remote { Address = localhost; SDPort = 9104 }` (#21).
35. Tests `openssl s_client` sur chaque service selon `PKI/-6-` : 8200, 443, 9101, 9102, 9103, 9090, 8006, 5432.

## Phase 5 — Renouvellement fiable

36. `renew_cert.sh` **v2** :
    - `set -euo pipefail` ;
    - `VAULT_ADDR` / `VAULT_CACERT` en `Environment=` dans l'unité systemd ;
    - authentification **AppRole** dédiée au lieu de `~/.vault-token` ;
    - contrôle du retour : rejet si `jq` renvoie `null` ou vide (#12) ;
    - écriture en `.new`, `openssl x509 -noout -checkend 0`, puis swap atomique (#11) ;
    - redéploiement des CA (fusion de `deploiement_ca.sh`) ;
    - **hooks post-déploiement** : concaténations (webui, pihole, cockpit, proxmox) + `ssh <cible> systemctl restart <service>` (#10).
37. Unité systemd : retirer `RefuseManualStart`, ajouter `OnFailure=` vers une unité de notification.
38. Timer : `OnUnitActiveSec=80d` + `Persistent=true` (#9). Vérifier avec `systemctl list-timers` et `systemd-analyze calendar`.
39. Test à blanc : `systemctl start renew_cert_ssl.service` → contrôler les dates avec `openssl x509 -noout -enddate` sur chaque cible.

## Phase 6 — Sauvegardes

### 6.a — Catalogue Bareos (DB `bareos`)

40. Supprimer le cron `pg_dump` cassé (#25, #26, #27) et le remplacer par le mécanisme natif Bareos :
    ```
    Job {
      Name = BackupCatalog
      Type = Backup
      Client = lin
      FileSet = "Catalog"
      Schedule = Lin_Schedule_LAN
      Storage = Storage_Local
      Pool = Lin_BackUp_Pool_LAN
      Messages = Standard
      Priority = 20                       # après tous les autres jobs
      RunBeforeJob = "/usr/lib/bareos/scripts/make_catalog_backup.pl MyCatalog"
      RunAfterJob  = "/usr/lib/bareos/scripts/delete_catalog_backup"
      Write Bootstrap = "|/usr/sbin/bsmtp -h localhost -f bareos -s 'Bootstrap' root"
    }
    ```
41. Vérifier la présence du FileSet `Catalog` (`/var/lib/bareos/bareos.sql`) et de `/etc/bareos/.pgpass` pour `make_catalog_backup.pl`.
42. **Conserver un dump hors Bareos** : sans lui, restaurer le catalogue à partir d'une sauvegarde Bareos est circulaire. Un `pg_dump -Fc` hebdomadaire copié sur le VPS + le disque externe, avec rotation 90 jours.
43. Corriger les rétentions (#30, #31, #32, #33, #42) : `Volume Retention = 70 days`, `Maximum Volume Bytes = 50G`, `Maximum Volumes = 12`, `Job/File Retention` alignés, `Purge Oldest Volume` retiré.

### 6.b — SOGo + mails (VPS)

44. **Installer `bareos-fd` sur le VPS** (#40) — c'est la brique manquante. Certificat dédié `bareos-fd-vps` via `ajout_service.sh`, `Client` déclarée côté Director, port 9102 ouvert **uniquement** depuis 192.168.0.240 en nftables.
45. Script pré-sauvegarde sur le VPS (`/usr/local/bin/pre_backup_mail.sh`), lancé en `RunBeforeJob` :
    ```
    set -euo pipefail
    d=/srv/backup ; mkdir -p $d
    # Base SOGo
    docker exec sogo-postgres pg_dump -U sogo -Fc sogo > $d/sogo_$(date +%F).dump
    # Volumes nommés SOGo (conf + data)
    docker run --rm -v sogo-conf:/src:ro -v $d:/out alpine \
        tar czf /out/sogo-conf_$(date +%F).tgz -C /src .
    docker run --rm -v sogo-data:/src:ro -v $d:/out alpine \
        tar czf /out/sogo-data_$(date +%F).tgz -C /src .
    find $d -mtime +30 -delete
    ```
46. FileSet du VPS :
    - `/srv/backup` (dumps ci-dessus) ;
    - `/home/debian/DMS/Mail_Server/docker-data/dms/mail-data` (les maildirs) ;
    - `/home/debian/DMS/Mail_Server/docker-data/dms/config` — **contient `postfix-accounts.cf`**, `rspamd`, les clés DKIM ;
    - `/home/debian/DMS/*/compose.yaml` et les `.env` ;
    - `/etc/letsencrypt`, la conf Caddy, `/etc/nftables.conf`, `/etc/fail2ban`.
    Exclure `mail-state` et `mail-logs`.
47. ⚠ **Le job du VPS doit écrire sur `Storage_Local` (Gen8)**, pas sur `Storage_Remote` : sauvegarder le VPS sur lui-même ne protège de rien.
48. Cohérence des maildirs : DMS n'a pas de mécanisme de *quiesce*. Soit `docker compose stop mailserver` pendant la fenêtre de sauvegarde (quelques minutes, la nuit), soit accepter le risque de messages en cours de livraison. À trancher.
49. Restaurer signifie remonter les volumes : documenter la procédure inverse (`docker volume create` + `tar x` + `pg_restore -U sogo -d sogo`) — **une sauvegarde non testée n'existe pas**.

### 6.c — Vault lui-même

50. **Le point qui manquait** (#45) : snapshot raft hebdomadaire.
    ```
    vault operator raft snapshot save /var/backups/vault/vault-$(date +%F).snap
    ```
    → timer systemd, chiffrement GPG, copie sur le VPS **et** sur le disque externe, rotation 8 semaines, et inclusion dans le FileSet Bareos.
51. Sauvegarder aussi `/etc/vault.d/vault.hcl`, `/etc/vault/pki/config/`, et **hors machine** les unseal keys + le root token.

## Phase 7 — Vérifications et clôture

52. `bareos-dir -t`, `bareos-sd -t`, `bareos-fd -t` sur chaque hôte → zéro erreur.
53. `bconsole` → `status director`, `status storage=Storage_Local`, `status storage=Storage_Remote`, `status client=...`.
54. Lancer un job de chaque type en manuel, vérifier le chiffrement dans les logs (`Encryption: TLS_...`).
55. **Test de restauration réel** : un fichier depuis le LAN, un fichier depuis le WAN, et le catalogue sur une VM jetable.
56. **Rotation de tous les secrets exposés** (#43) + purge de l'historique git + `.gitignore`.
57. Mettre `-K-Troubleshooting.md` et `-L-Modif.md` à jour, et corriger les tutos concernés (les correctifs #1 à #42 sont génériques, ils ont leur place dans le dépôt ; les incidents propres à l'infra n'y vont pas).

---

# Rappels encore ouverts

- Liste blanche fail2ban pour les réseaux Docker (`ignoreip 172.16.0.0/12`) + déban de `172.18.0.1`.
- Rate limiting sortant, MTA-STS, passage SPF en `-all` et DMARC en `p=reject` après lecture des rapports.
- Désactivation du MX Plan OVH (second SPF → permerror) — ticket en cours.
- **Adresse mail de secours externe** pour les réinitialisations de mot de passe, y compris le compte OVH.
- Durcissement de `userPasswordAlgorithm` (`md5` → `ssha512`) dans `sogo.conf` lors du passage sous Bitwarden, avec régénération du hash `c_password` dans `sogo_users`.
