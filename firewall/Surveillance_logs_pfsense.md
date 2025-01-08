# Mise en place de la solution GrayLog
### Graylog est une solution open source de type "puits de logs" dont l'objectif est de permettre la centralisation, le stockage, et l'analyse en temps réel des journaux de vos machines et vos périphériques réseaux.

## SOMMAIRE :
### 1️⃣`Installation`
### 2️⃣
### 3️⃣
### 4️⃣
### 5️⃣

***
***

### 1️⃣`Installation`

## 1)
* ### Mettre le bon fuseau horaire
         timedatectl set-timezone Europe/Paris

* ### Mise à jour et instalation des outils:
         apt-get update
         apt-get install curl lsb-release ca-certificates gnupg2 pwgen
***

## 2) 
* ## `Installation de MongoDB` 
* ### Télécharger la clé GPG correspondante au dépôt MongoDB :
          curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc |  gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor

* ### ajouter le dépôt de MongoDB 6 sur la machine Debian 12 :
        echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg] http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" |  tee /etc/apt/sources.list.d/mongodb-org-6.0.list

* ### mise à jour du cache des paquets et installer MongoDB :
           apt-get update
           apt-get install -y mongodb-org

* ### Ici message d'erreur :

![image](https://github.com/user-attachments/assets/9e3ab8df-f290-4843-bd81-525aa3a8345b)

### Il faut donc installer manuellement la dépendance manquante : libssl1.1.

* ### Installation de libssl1.1.

        wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb
        dpkg -i libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb

* ### Relancer l'installation de MongoDB :

        apt-get install -y mongodb-org

* ### Relancer le service MongoDB et activer son démarrage automatique au lancement du serveur Debian

***

## 3)
* ## `Installation d'OpenSearch` 

* ### Ajouter la clé de signature pour les paquets OpenSearch
        curl -o- https://artifacts.opensearch.org/publickeys/opensearch.pgp | gpg --dearmor --batch --yes -o /usr/share/keyrings/opensearch-keyring

* ### Ajouter le dépôt OpenSearch
        echo "deb [signed-by=/usr/share/keyrings/opensearch-keyring] https://artifacts.opensearch.org/releases/bundle/opensearch/2.x/apt stable main" | tee /etc/apt/sources.list.d/opensearch-2.x.list

* ### Mettre à jour le cache
        apt-get update

* ### Installer OpenSearch  en créant le MDP  => ICI Azerty1*
        env OPENSEARCH_INITIAL_ADMIN_PASSWORD=Azerty1* apt-get install opensearch

* ### Faire la configuration minimale
        nano /etc/opensearch/opensearch.yml







