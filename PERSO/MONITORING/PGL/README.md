## Monitoring 

---

- En plus de `Uptime-Kuma` => Voir [ICI](https://github.com/NALSED/TUTO/tree/main/PERSO/MONITORING/UPTIME-KUMA), implémentation de la solution `PGL` :

   - `Prometheus`
   - `Grafana`
   - `Loki`
   - `Promtail` 
   - `Consul`
---

🟥
🟩

### === Liste Taches ===
````
🟥 -1- Installer Prometheus (serveur) sur la VM métriques/logs
-2- Installer Node Exporter sur chaque machine à monitorer (Pi, VMs, VPS)
-3- Configurer Prometheus pour scraper les Node Exporters (liste statique de targets)
-4- Installer Grafana sur la même VM
-5- Ajouter Prometheus comme source de données dans Grafana
-6- Importer un dashboard (ex. Node Exporter Full) et vérifier l'affichage des métriques
-7- Installer Loki sur la VM (à côté de Prometheus)
-8- Installer Promtail sur chaque machine à monitorer (Pi, VMs, VPS)
-9- Configurer Promtail pour envoyer les logs locaux vers Loki
-10- Ajouter Loki comme source de données dans Grafana
-11- Vérifier l'affichage des logs dans Grafana (Explore ou dashboard dédié)
-12- Installer AlertManager sur la VM
-13- Configurer AlertManager pour l'envoi d'alertes mail (via ton serveur mail existant)
-14- Relier les règles d'alerte Prometheus à AlertManager et tester une alerte
-15- Installer le serveur Consul sur la VM métriques/logs (mode single-server, sans ACL ni TLS)
-16- Installer un agent Consul client sur chaque machine à enregistrer (Pi, VMs, VPS)
-17- Faire rejoindre les agents au serveur Consul
-18- Enregistrer les premiers services (fichiers de définition par service, ex. Uptime Kuma)
-19- Vérifier dans l'UI Consul que les services et machines apparaissent
-20- Remplacer la liste statique de targets Prometheus par la découverte via Consul (consul_sd_config)
-21- Vérifier que Prometheus scrape bien les services découverts dynamiquement
-22- Ajouter un nouveau service test et valider qu'il apparaît automatiquement dans Prometheus sans toucher la config

## Bonus — sécurisation ACL et TLS

-23- Bootstrap du système ACL sur le serveur Consul (génération du token racine)
-24- Créer les policies ACL (permissions par agent/service)
-25- Générer et attribuer un token à chaque agent client
-26- Générer et attribuer un token à chaque service enregistré
-27- Tester que le cluster fonctionne toujours avec ACL activé
-28- Générer les certificats TLS pour chaque agent Consul via la PKI Vault existante
-29- Distribuer les certificats (CA + cert + clé) à chaque agent
-30- Activer `verify_incoming` et `verify_outgoing` sur le serveur et les agents
-31- Redémarrer les agents et vérifier que le chiffrement inter-agents fonctionne
-32- Prévoir la rotation des certificats (manuelle ou automatisée via Vault)
````

