## `-7-` Restauration

---

### `- 7.1` Récupérer les archives depuis Bareos `192.168.0.240`

````
printf "restore client=lin\nquit\n" | sudo bconsole
````

Sélectionner les fichiers sous `/home/sednal/VPS_Mail_BackUp/`.

### `- 7.2` Transférer vers le VPS `176.31.163.227`

````
scp /home/sednal/VPS_Mail_BackUp/dms_AAAA-MM-JJ.tar.gz \
    /home/sednal/VPS_Mail_BackUp/sogo_pgdump_AAAA-MM-JJ.sql.gz \
    debian@176.31.163.227:/home/debian/
````

### `- 7.3` Restaurer les bases SoGo

````
gunzip -c sogo_pgdump_AAAA-MM-JJ.sql.gz | docker exec -i sogo-postgres psql -U sogo
````

⚠️ `[ATTENTION]` ⚠️

L'utilisateur PostgreSQL du conteneur est `sogo`. Avec `-U postgres`, la
restauration échoue sur `FATAL: role "postgres" does not exist`.

### `- 7.4` Restaurer le dossier DMS

````
docker compose -f /home/debian/DMS/compose.yml down
tar xzf dms_AAAA-MM-JJ.tar.gz -C /home/debian
docker compose -f /home/debian/DMS/compose.yml up -d
````

`[NOTE]`

L'archive contient le dossier `DMS` lui-même : l'extraire dans `/home/debian`
recrée `/home/debian/DMS`.
