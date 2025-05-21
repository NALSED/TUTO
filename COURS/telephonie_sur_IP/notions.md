# SOMMAIRE 
## 1️⃣ `Différence entre la VoIP et la ToIP`
## 2️⃣ `Protocoles`
## 3️⃣ `Infra`

***
***


## 1️⃣ `Différence entre la VoIP et la ToIP`

### 1) La VoIP

### C'est la technologie utilisée, ce qui permet de pouvoir passer des appels vocaux par internet.
### Les signaux audio analogiques sont convertis en paquets de données numériques. Cette conversion se fait à l'aide de codec (pour Codeur/Decodeur).
### Ces paquets IP sont ensuite transmis sur Internet.
### Plusieurs protocoles réseaux sont implémentés.
### Ainsi on peut dire que VoIP = `technologie utilisée (protocoles).`

### 2) La ToIP

### C'est une infrastructure réseau qui va s'appuyer sur la VoIP pour gérer la téléphonie d'entreprise, ainsi que les services associés sur un réseau IP.
### On va utiliser les technologie de la VoIP pour pouvoir sortir du réseau interne d'entreprise les appels téléphoniques.
### Donc, ToIP = `une infrastructure.`

***
***

## 2️⃣ `Protocoles`

### `Le SIP` (Session Initiation Protocol) est un protocole de signalisation basé sur l'IP.
### Il est utilisé pour établir, modifier et terminer des sessions de communication en temps réel telles que les appels vocaux et vidéo, les conférences, les messageries instantanées, etc.
### Il gère les sessions de communication entre les différentes parties impliquées.
### Dans son fonctionnement, il utilise des requêtes et des réponses pour établir et terminer des sessions de communication.
### Il fonctionne avec d'autres protocoles, comme le SDP (Session Description Protocol) qui est un autre protocole de signalisation, et qui décrit les caractéristiques d'une session en cours.

### `Le RTP` (Real-time Transport Protocol) est un protocole de transport.
### Il est utilisé pour transmettre des données audio et vidéo en temps réel sur des réseaux IP. Il fonctionne avec le protocole SIP.
### RTP utilise le protocole UDP (User Datagram Protocol) pour envoyer des paquets de données audio et vidéo entre les différents appareils participant à la session de communication. Dans le message RTP on trouve le temps d'échantillonnage, le numéro de séquence et la synchronisation des médias pour permettre une reconstruction précise du flux de données audio ou vidéo à l'arrivée.


![f](https://d33wubrfki0l68.cloudfront.net/6cc14709cd073b25be67330cdeb908f8638fc6a7/31426/assets/images/protocole-sip/lucidchart/9ca7f7c3-f1e7-4e86-92e7-c194871df934.png)


## 3️⃣ `Infra`

### Sur le schéma généraliste ci-dessous, on peut voir les différents éléments de l'infrastructure ToIP :

### Les terminaux IP représentés par le téléphone et l'ordinateur
### L’autocommutateur, représenté par l'IP PBX
### La passerelle VoIP
### Le réseau téléphonique RTC, représenté par le nuage PSTN (Public Switched Telephone Network)

![f](https://d33wubrfki0l68.cloudfront.net/2fb300b48f9fee61f67a744c1e6576f5eb1b12b6/decc1/assets/images/protocole-sip/lucidchart/fb60f8c4-32e1-4174-8b80-a6d140d65300.png)





