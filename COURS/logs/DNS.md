## Filtres pour le receuille de log DNS

## 🥼 `Labo` 
#### ➡️ Un serveur Windows 2022 avec le rôle DNS et un client windows 10 sur le même réseau.
## 1️⃣ `Configurer le serveur DNS` 
#### le serveur est configurer pour que client et serveur puisse "se reconnaitre"
![image](https://github.com/user-attachments/assets/c617af29-7b50-4f49-ac71-e008c6475554)
## 2️⃣ `Configurer event viewer`
#### 1 ) Sources 
* #### DNS-Server-Service
* #### DNS Client Events
![image](https://github.com/user-attachments/assets/8646e993-ac97-4e51-b4c4-6fa5465367e9)
#### 2 ) Evénements avec ID
* #### 2: Démarrage du serveur DNS
* #### 4: Arrêt du serveur DNS
* #### 409: Erreur de résolution de nom
* #### 501-502: Échec de chargement de zone
* #### 6001-6002: Problèmes de réplication DNS
![image](https://github.com/user-attachments/assets/51a903bb-affa-47d7-97d9-87a661b6961b)

## 3️⃣`XML`

      <QueryList>
        <Query Id="0" Path="DNS Server">
          <Select Path="DNS Server">*[System[Provider[@Name='Microsoft-Windows-DNSServer' or @Name='Microsoft-Windows-DNS-Server-Service' or @Name='Microsoft-Windows-Narrator'] and (EventID=2 or EventID=4 or EventID=409 or        (EventID &gt;= 501 and EventID &lt;= 502)  or  (EventID &gt;= 6001 and EventID &lt;= 6002) )]]</Select>
          <Select Path="Microsoft-Windows-Narrator/Diagnostic">*[System[Provider[@Name='Microsoft-Windows-DNSServer' or @Name='Microsoft-Windows-DNS-Server-Service' or @Name='Microsoft-Windows-Narrator'] and (EventID=2 or         EventID=4 or EventID=409 or  (EventID &gt;= 501 and EventID &lt;= 502)  or  (EventID &gt;= 6001 and EventID &lt;= 6002) )]]</Select>
        </Query>
      </QueryList>



