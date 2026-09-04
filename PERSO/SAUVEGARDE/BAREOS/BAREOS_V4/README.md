# Projet de sauvegarde locale et WAN via Bareos

---

## `-1-` Étapes du projet

### `- 1.1` Configuration

- Installation de PostgreSQL et Bareos sur le serveur `192.168.0.240`.
- Mise en place d'un tunnel SSH pour la connexion sécurisée au VPS.

### `- 1.2` bareos-sd

- Configuration des fichiers **Storage** dans Bareos SD pour les sauvegardes **LAN** et **WAN**.

### `- 1.3` Fichiers de sauvegarde

- Gestion des différents fichiers relatifs aux séquences de sauvegarde.
- Organisation des rôles et politiques de backup.

## `-2-` Format des fichiers de configuration

````
Lin/Win_BackUp/Archive_Role_LAN/WAN
````
