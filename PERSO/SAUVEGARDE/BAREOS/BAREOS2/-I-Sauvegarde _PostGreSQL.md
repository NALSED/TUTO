# Sauvegarde de la  base de  données  PostGreSQL

---
#### Sauvegarder une base de données est essentiel pour garantir la **sécurité, la continuité et la fiabilité** des données. Voici les principaux points :

## 1. Protection contre la perte de données
- Prévenir la perte due à une corruption, une suppression accidentelle ou un bug logiciel.
- Permet de restaurer la base à un état antérieur.

## 2. Reprise après sinistre
- En cas de panne matérielle, attaque informatique ou catastrophe, la sauvegarde permet de revenir rapidement à un fonctionnement normal.

## 3. Historique et versionnement
- Conserver différentes versions de la base.
- Revenir à un état précis après une erreur humaine ou un bug.

## 4. Migration et duplication
- Migrer la base vers un autre serveur.
- Créer un environnement de test ou un clone pour le développement.

---

#### Ici Utilisation de cron pour automatiser la commande  
      
      crontab -e
      55 11 * * 0 /usr/bin/pg_dump -U bareos -F c -b -v -f /home/sednal/BackUp_SQL_Bareos_$(date +\%F_\%H-\%M).backup bareos

#### Le  backUp sera  réalisé deans se dossier /home/sednal/BackUp_SQL_Bareos
































