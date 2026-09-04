# `-5-` Administration Conteneurs.


## - `SOMMAIRE`

### `- 5.1` Lancement des conteneurs

### `- 5.2` Création des comptes mail

### `- 5.3` Création de la table et de l'utilisateur SQL 

### `- 5.4` Configuration de `sogo.conf`

### `- 5.5` DKIM 

### `- 5.6` Test des deploy-hooks 
 
### `- 5.7` Test Open Relay 

### `- 5.8` Durcissement TLS 

### `- 5.9` Vérification fail2ban 

---

####  ⚠️ Prérequis propre à mon infra ⚠️
````
# Stopper nginx (occupe le port 80, empêche Caddy de démarrer)
sudo systemctl disable --now nginx

# Désactiver exim4 (écoute sur 127.0.0.1:25)
sudo systemctl disable --now exim4
````

⚠️ Ne **pas** purger exim4 : `bareos-director` dépend de `bsd-mailx`, qui dépend d'un MTA. Un `apt purge exim4` entraînerait la suppression de toute la chaîne Bareos.

---

###  `- 5.1` Lancement des conteneurs

- Ordre important
1 `DMS` => 2 `SOGo` => 3 `Caddy`
````
cd ~/DMS/Mail_Server/
sudo docker compose up -d

cd ~/DMS/SOGo/
sudo docker compose up -d

cd ~/DMS/Caddy/
sudo docker compose up -d
````


`[TEST]`

- LOGS
````
sudo docker ps
sudo docker logs mailserver --tail 50
sudo docker logs sogo --tail 50
sudo docker logs caddy --tail 50
````

- VARIABLES
````
sudo docker exec mailserver ps aux | grep -E 'opendkim|opendmarc|policyd'
# Ne doit rien retourner
````

- RÉSEAU
````
sudo docker network inspect sogo-net --format '{{range .Containers}}{{.Name}} {{end}}'
# Doit lister mailserver, sogo, sogo-postgres et caddy
````


### `- 5.2` Création des comptes mail

- Boîte principale
````
sudo docker exec -ti mailserver setup email add martin@nalsed.fr
````

⚠️ Le `-ti` est indispensable sur toute commande qui demande une saisie. Sans lui, la saisie du mot de passe n'est pas captée et l'échec est silencieux. 

- Alias
````
sudo docker exec -ti mailserver setup alias add contact@nalsed.fr martin@nalsed.fr
sudo docker exec -ti mailserver setup alias add postmaster@nalsed.fr martin@nalsed.fr
sudo docker exec -ti mailserver setup alias add abuse@nalsed.fr martin@nalsed.fr
````

`[NOTE]`

`postmaster` et `abuse` ne sont pas cosmétiques : la RFC 2142 les rend obligatoires, plusieurs blocklists vérifient qu'ils répondent, et c'est là qu'arrivent les notifications d'incidents.





<details>
<summary>
<h2>
 ⚠️ Si problème de mot de passe ⚠️

</h2>
</summary>

- Tester l'authentification contre Dovecot
````
sudo docker exec -ti mailserver doveadm auth test martin@nalsed.fr
# Attendu : passdb: martin@nalsed.fr auth succeeded
````

⚠️ Les deux mots de passe (DMS et SOGo) doivent être identiques ⚠️

- Changer le mot de passe DMS
````
sudo docker exec -ti mailserver setup email update martin@nalsed.fr

# Test
sudo docker exec mailserver setup email list

# Restart
sudo docker restart mailserver
````

- Changer le mot de passe SOGo
````
sudo docker exec -ti sogo-postgres psql -U sogo -d sogo

UPDATE sogo_users SET c_password = MD5('nouveau') WHERE c_uid = 'martin';

# Quitter
\q

# Restart
sudo docker restart sogo
````

</details>


### `- 5.3` Création de la table et de l'utilisateur SQL

`[NOTE]`

Sans cette table, le compte créé précédemment n'aura pas d'utilisateur, donc la connexion sur le WebUI de SOGo est impossible. 

SOGo ne supporte que deux types de sources utilisateurs, `sql` et `ldap` : il n'existe pas de source `imap`, la duplication du mot de passe est donc inévitable.

### ⚠️ Le mot de passe de l'utilisateur doit être le même que celui du compte mail. En cas de changement ou de révocation, penser à gérer les deux.

- Connexion à la `DB`
````
sudo docker exec -ti sogo-postgres psql -U sogo -d sogo
````

- Création de la table `sogo_users` dans PostgreSQL
````
CREATE TABLE sogo_users (
    c_uid VARCHAR(255) PRIMARY KEY,                -- Identifiant unique (nom d'utilisateur)
    c_name VARCHAR(255) NOT NULL,                  -- Nom unique ou adresse email
    c_password VARCHAR(255) NOT NULL,              -- Mot de passe haché
    mail VARCHAR(255) NOT NULL,                    -- Adresse email principale
    aliases TEXT,                                  -- Autres adresses email ou alias
    c_cn VARCHAR(255),                             -- Nom complet (Common Name)
    last_login TIMESTAMP                           -- Dernière date de connexion (facultatif)
);
````

- Ajout d'un compte utilisateur
````
# !!! Le mot de passe doit être identique à celui de DMS !!!
INSERT INTO sogo_users (c_uid, c_name, c_password, c_cn, mail, aliases)
VALUES ('martin', 'martin@nalsed.fr', MD5('MOT_DE_PASSE_DMS'), 'Martin', 'martin@nalsed.fr', 'contact@nalsed.fr');
````

`[NOTE]`

⚠️ Propre à mon Infra ⚠️

L'algorithme `md5` est celui configuré par défaut dans `sogo.conf` (`userPasswordAlgorithm = md5;`). Il n'est pas salé, à durcir en `ssha512` lors du passage sous gestionnaire de mots de passe.

- Redémarrer SOGo
````
sudo docker restart sogo
````


### `- 5.4` Configuration de `sogo.conf`

`[NOTE]` 

⚠️ Deux paramètres manquants empêchent le webmail de fonctionner correctement, même une fois la table créée. ⚠️

- Fichier côté hôte :
````
sudo vim /var/lib/docker/volumes/sogo_sogo-conf/_data/sogo.conf
````

- Ajouter dans le bloc principal :
````
    SOGoForceExternalLoginWithEmail = YES;
    WOWorkersCount = 5;
    SOGoSMTPServer = "smtp://mailserver:25";
````

- `SOGoForceExternalLoginWithEmail` : sans lui, SOGo se connecte en IMAP avec le seul `c_uid` (`martin`) alors que DMS attend l'adresse complète (`martin@nalsed.fr`). Symptôme : connexion au webmail réussie mais page blanche, et `IMAP4 login failed ... user=martin` dans les logs.
- `WOWorkersCount` : sans lui, `No child available to handle incoming request!` sature les logs et l'interface reste instable.
- `SOGoSMTPServer` : remplacer la ligne existante, pas en ajouter une seconde. Le port 587 échoue (`Must issue a STARTTLS command first`). Le port 25 en interne fonctionne sans authentification.

````
sudo docker restart sogo
````

### `- 5.5` DKIM

`[NOTE]` 

Rspamd ne signe que les messages authentifiés (`sign_local = false` par défaut). Le courrier venant de SOGo par le port 25 n'est donc pas signé.

````
mkdir -p ~/DMS/Mail_Server/docker-data/dms/config/rspamd/override.d/
vim ~/DMS/Mail_Server/docker-data/dms/config/rspamd/override.d/dkim_signing.conf

# Editer
sign_local = true;
````

- redemarrage
````
cd ~/DMS/Mail_Server/
sudo docker compose down
sudo docker compose up -d
````

- Générer la clé
````
sudo docker exec -ti mailserver setup config dkim
````

- Vérifier l'implémentation
````
sudo docker exec mailserver ls /tmp/docker-mailserver/rspamd/dkim/
# La clé doit être visible. 
````

- Récupérer la valeur publique
````
sudo docker exec mailserver cat /tmp/docker-mailserver/rspamd/dkim/rsa-2048-mail-nalsed.fr.public.dns.txt
# Ne récupérer que la partie entre guillemets.
````

- Dans OVH, créer un enregistrement TXT avec sous-domaine `mail._domainkey` et valeur `v=DKIM1; k=rsa; p=<clé>`

`[TEST]`

````
dig +short @1.1.1.1 mail._domainkey.nalsed.fr TXT
# Le résultat attendu est le même enregistrement que celui saisi dans OVH.
````

- À présent https://webmail.nalsed.fr/SOGo/ fonctionne.

- Test de bout en bout : envoyer un mail depuis la boîte vers `check-auth@verifier.port25.com`. Le rapport automatique dira si SPF, DKIM et DMARC passent tous les trois. 
````
# Resultat
The Port25 Solutions, Inc. team

==========================================================
Summary of Results
==========================================================
SPF check:          pass
"iprev" check:      pass
DKIM check:         pass

==========================================================
````


### `- 5.6` Test des deploy-hooks

`[NOTE]` 

Le `--dry-run` seul n'exécute **pas** les deploy-hooks. L'option `--run-deploy-hooks` les déclenche sans consommer de quota Let's Encrypt.

````
sudo certbot renew --dry-run --run-deploy-hooks

sudo docker ps --filter name=caddy
# Le STATUS doit montrer un démarrage récent.
````

- Vérifier les hooks enregistrés
````
sudo grep -r renew_hook /etc/letsencrypt/renewal/
````

### `- 5.7` Test Open Relay

`[NOTE]` 

Un serveur qui relaie pour des domaines qui ne lui appartiennent pas est repéré en quelques heures par les scanners, et l'IP est blacklistée pour plusieurs semaines. 

À retester après toute modification de `mynetworks` ou `PERMIT_DOCKER`.

- Depuis une machine extérieure au VPS
````
telnet mail.nalsed.fr 25

EHLO test.example.com
MAIL FROM:<test@example.com>
RCPT TO:<test@gmail.com>
QUIT
````

`[TEST]`

- Sortie attendue sur le `RCPT TO`
````
554 5.7.1 <test@gmail.com>: Relay access denied
````

⚠️ Un `250 Ok` sur le `RCPT TO` signifie que le serveur est un open relay. Corriger avant toute mise en production.

### `- 5.8` Durcissement TLS

`[NOTE]` 

`smtpd_tls_auth_only` n'est pas activé par défaut. Il interdit l'annonce de `AUTH` avant `STARTTLS`.

````
sudo vim ~/DMS/Mail_Server/docker-data/dms/config/user-patches.sh

# Editer
#!/bin/bash
postconf -e "smtpd_tls_auth_only = yes"
````

- Droits
````
sudo chmod +x ~/DMS/Mail_Server/docker-data/dms/config/user-patches.sh
````

- Recréer le conteneur
````
cd ~/DMS/Mail_Server/
sudo docker compose down
sudo docker compose up -d
````

⚠️ Un `docker restart` n'applique pas le script : DMS affiche `Container was restarted. Skipping most setup routines.` et saute la phase de configuration.

`[TEST]`
````
sudo docker exec mailserver postconf smtpd_tls_auth_only
sudo docker exec mailserver doveconf disable_plaintext_auth ssl
# Attendu : yes  et  ssl = required
````


### `- 5.9` Vérification fail2ban

- Prisons actives
````
sudo docker exec mailserver fail2ban-client status
sudo docker exec mailserver fail2ban-client status dovecot
````

- Mécanisme de bannissement
````
sudo docker exec mailserver grep -r banaction /etc/fail2ban/jail.local
````

`[NOTE]` DMS v16 utilise `nftables-allports`. Le binaire `iptables` n'existe pas dans le conteneur, les règles se consultent avec `nft`.

````
sudo docker exec mailserver nft list ruleset | grep -A5 f2b
````

- Liste blanche des réseaux Docker

⚠️ Sans elle, plusieurs échecs d'authentification légitimes depuis SOGo font bannir le webmail entier.
````
sudo vim ~/DMS/Mail_Server/docker-data/dms/config/fail2ban-jail.cf

# Editer
[DEFAULT]
ignoreip = 127.0.0.1/8 172.16.0.0/12
````

- Débannir une IP
````
sudo docker exec mailserver fail2ban-client set dovecot unbanip <IP>
````
