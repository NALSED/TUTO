# Projet de sauvegarde locale et WAN via Bareos

## Étapes du projet

### -0–configuration
- Installation de PostgreSQL et Bareos sur le serveur `192.168.0.240`.
- Mise en place d’un tunnel SSH pour la connexion sécurisée au VPS.

### -1–bareos-sd
- Configuration des fichiers **Storage** dans Bareos SD pour les sauvegardes **LAN** et **WAN**.

### -2- à -8– Fichiers de sauvegarde
- Gestion des différents fichiers relatifs aux séquences de sauvegarde.
- Organisation des rôles et politiques de backup.

##### Format des fichiers de configuration
    format fichier Lin/Win_BackUp/Archive_Role_LAN/WAN
