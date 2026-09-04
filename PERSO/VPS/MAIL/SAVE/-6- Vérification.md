## `-6-` Vérification

`- 6.1` Test du dump sur le VPS `176.31.163.227`
````
/home/debian/script_dms/backup_mail.sh
ls -lh /home/debian/backup/
````

`- 6.2` Test complet du job sur `192.168.0.240`
````
printf "run job=Lin_BackUp_Job_LAN level=Full yes\nquit\n" | sudo bconsole
sleep 30
printf "list jobs\nmessages\nquit\n" | sudo bconsole
````

**RESULTAT ATTENDU**

Le journal du job contient :
````
Rapatriement des sauvegardes mail : OK
````

Et `jobbytes` passe de quelques dizaines de Ko à environ 1,3 Go.

`- 6.3` Journaux
````
ls -lh /home/sednal/VPS_Mail_BackUp/
cat /home/sednal/logs/pull_mail.log
ssh debian@176.31.163.227 "tail -20 /home/debian/backup/backup.log"
````

