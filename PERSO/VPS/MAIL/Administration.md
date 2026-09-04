# 📬 Administration Serveur Mail

---

# `-1-` Ajouter un compte

### `- 1.1` Compte mail (DMS)
````
sudo docker exec -ti mailserver setup email add <user>@nalsed.fr
````

### `- 1.2` Utilisateur SOGo (SQL)
````
sudo docker exec -ti sogo-postgres psql -U sogo -d sogo

INSERT INTO sogo_users (c_uid, c_name, c_password, c_cn, mail, aliases)
VALUES ('<user>', '<user>@nalsed.fr', MD5('<PASSWORD>'), '<Nom Complet>', '<user>@nalsed.fr', NULL);

\q
````

### `- 1.3` Redémarrer
````
sudo docker restart sogo
````

⚠️ Le mot de passe doit être identique des deux côtés.

---

# `-2-` Ajouter un alias
````
sudo docker exec -ti mailserver setup alias add <alias>@nalsed.fr <user>@nalsed.fr
````

---

# `-3-` Changer un mot de passe

### `- 3.1` Côté DMS
````
sudo docker exec -ti mailserver setup email update <user>@nalsed.fr
````

### `- 3.2` Côté SOGo
````
sudo docker exec -ti sogo-postgres psql -U sogo -d sogo

UPDATE sogo_users SET c_password = MD5('<NOUVEAU>') WHERE c_uid = '<user>';

\q
````

### `- 3.3` Redémarrer
````
sudo docker restart mailserver
sudo docker restart sogo
````

---

# `-4-` Supprimer un compte

### `- 4.1` Côté DMS
````
sudo docker exec -ti mailserver setup email del <user>@nalsed.fr
````

### `- 4.2` Côté SOGo
````
sudo docker exec -ti sogo-postgres psql -U sogo -d sogo

DELETE FROM sogo_users WHERE c_uid = '<user>';

\q
````

### `- 4.3` Supprimer un alias
````
sudo docker exec -ti mailserver setup alias del <alias>@nalsed.fr <user>@nalsed.fr
````

---

# `-5-` Lister

````
# Comptes
sudo docker exec mailserver setup email list

# Alias
sudo docker exec mailserver setup alias list

# Utilisateurs SOGo
sudo docker exec -ti sogo-postgres psql -U sogo -d sogo -c "SELECT c_uid, mail FROM sogo_users;"
````

---

# `-6-` Vérifier

````
# Authentification
sudo docker exec -ti mailserver doveadm auth test <user>@nalsed.fr

# Conteneurs
sudo docker ps

# Logs
sudo docker logs mailserver --tail 50
sudo docker exec sogo tail -50 /var/log/sogo/sogo.log

# File d'attente
sudo docker exec mailserver postqueue -p
````

---
