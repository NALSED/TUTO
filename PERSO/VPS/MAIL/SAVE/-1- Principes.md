## `-1-` Principe

- Le VPS produit ses propres sauvegardes localement, chaque nuit.

- Le serveur Bareos les rapatrie juste avant sa sauvegarde du dimanche, via un
`RunBeforeJob` du job `Lin_BackUp_Job_LAN`.

- Le dossier de dépôt `/home/sednal/VPS_Mail_BackUp` est inclus dans
`Lin_BackUp_FileSet_LAN`, il part donc sur le RAID10 dans la foulée.

⚠️ `[ATTENTION]` ⚠️

Le sens du transfert est imposé par le réseau : le VPS ne peut pas joindre une
adresse privée du LAN. C'est `192.168.0.240` qui sort vers le VPS sur le port 22,
sans redirection à créer sur pfSense.

Le VPS n'est **pas** déclaré comme client Bareos : aucun port 9102 à ouvrir,
aucune ressource `Client` à créer côté Director.
