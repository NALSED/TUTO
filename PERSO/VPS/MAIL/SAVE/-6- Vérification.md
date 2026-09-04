## `-6-` Vérification

---

### `- 6.1` Test du dump sur le VPS `176.31.163.227`

````
sudo /root/script_dms/backup_mail.sh
ls -lh /home/debian/backup/
````

### `- 6.2` Test complet du job sur `192.168.0.240`

````
printf "run job=Lin_BackUp_Job_LAN level=Full yes\nquit\n" | sudo bconsole
sleep 30
printf "list jobs\nmessages\nquit\n" | sudo bconsole
````

**RÉSULTAT OBTENU**

````
JobId 35  Lin_BackUp_Job_LAN  Full  91 fichiers  117,3 Mo  Termination: Backup OK
BeforeJob: Rapatriement des sauvegardes mail : OK

JobId 36  Lin_BackUp_Job_WAN  Full  87 fichiers   28,2 Ko  Termination: Backup OK
````

### `- 6.3` Journaux

````
ls -lh /home/sednal/VPS_Mail_BackUp/
cat /home/sednal/logs/pull_mail.log
ssh debian@176.31.163.227 "tail -20 /home/debian/backup/backup.log"
````

---

### `- 6.4` Limites connues

- Le dossier `/home/sednal/VPS_Mail_BackUp` n'est pas envoyé en hors-site :
  l'envoyer sur le VPS d'où il provient n'apporterait aucune protection.

- Les archives sont en clair sur les deux disques ; le dump contient les hachages
  de mots de passe PostgreSQL.

- Les archives rapatriées datent au plus du matin même.

- Volume : environ 117 Mo par jeu, 7 jours de rétention sur le VPS.
