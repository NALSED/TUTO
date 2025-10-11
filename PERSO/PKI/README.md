# Projet : Gestionnaire local de certificats TLS sur Raspberry Pi5

## Objectif  
Développer une application Python dédiée à la gestion centralisée des certificats TLS, installée sur un Raspberry Pi 5, avec une architecture reposant sur un reverse proxy Nginx pour la terminaison TLS en local.

---

## Fonctionnalités principales

1. **Gestion des certificats WAN (Let’s Encrypt)**  
   - Création automatisée de certificats via le protocole ACME.  
   - Suppression des certificats obsolètes ou inutilisés.

2. **Gestion des certificats LAN (CA locale via OpenSSL)**  
   - Création de certificats internes avec possibilité de renouvellement automatique ou manuel.  
   - Renouvellement des certificats existants.  
   - Suppression des certificats.  
   - Scan réseau local (sur demande) via Nmap pour détecter les services TLS actifs.  
   - Proposition automatique de création de certificats pour les services détectés sans TLS.

3. **Tableau de bord dynamique**  
   - Visualisation en temps réel des services réseau avec indication de leur état TLS (présence ou absence de certificat valide).  
   - Scans déclenchés manuellement pour limiter la charge sur le Raspberry Pi.

---

## Infrastructure proposée

- **Raspberry Pi 5 dédié** servant de coffre-fort sécurisé pour le stockage des certificats et clés privées.  
- **Nginx reverse proxy** assurant la terminaison TLS et la distribution des certificats aux différents services du réseau local.  
- Interface utilisateur simple, intuitive, organisée en trois volets pour la gestion WAN, LAN et le monitoring.
---
