# Ajout d'un agent sur `Elastic` via la solution `Security Onion`.

---          ```

### 1.1) Dans la webUi de `SO`, choisir `Elastic Fleet`
![image](https://github.com/user-attachments/assets/296c7980-638a-4ea2-9fab-afe5e92aee09)

### 1.2) Dans le page `Fleet` choisir `Add agent`
![image](https://github.com/user-attachments/assets/d283d01d-123c-4efd-8b9e-bfeb22134c5c)

### 1.3) Dans la fenetre pour le point 1 choisir endpoints-initial

### Deux options :
* ### via la page `download page` et choisir pour la bonne distribution.
![image](https://github.com/user-attachments/assets/a9b3fb47-106d-48f5-8d8e-b5f1bc110d38)
* ### Execution  du scrit
![image](https://github.com/user-attachments/assets/37990778-9ba4-4529-bced-88c5676c34c1)

### 1.4) tester l'écoute du ports 8220 sur le serveur ainsi que le client.

### ici :
* ### Serveur => sudo netstat -tulnp | grep 8220
![image](https://github.com/user-attachments/assets/b2167572-c8a2-4f8c-92df-cbc96e9a4011)

* ### Client =>  Test-NetConnection 192.168.0.103 -Port 8220
![image](https://github.com/user-attachments/assets/5c37f585-d9bc-4880-92fd-e123f6a08f0d)
### ⚠️  Probléme 2 choses à faire 
* ### 1️⃣ Créer une régle par feu sur le client pour autoriser le port 8220
### 1.4.1) Régle trafic entrant => Nouvelle régle / Port / TCP + 8220 / Autoriser la connection / all / Nom +terminer.

* ### 2️⃣ Autoriser sur le parfeu de `SO` l'IP du client.
### 1.4.2) Se rendre dans configuration
![image](https://github.com/user-attachments/assets/1e0d034b-0348-4d2f-99b5-f716e687d435)

### 1.4.3) Se rendre dans elastic_agent_endpoint
![image](https://github.com/user-attachments/assets/8c08cf7a-e0ec-4da9-8327-495c4477ff9f)

### 1.4.4) Ajouter l'IP sans CIDR
![image](https://github.com/user-attachments/assets/62bfb12d-272b-4ef0-896a-dbb2d57d03d7)

### Attendre 
![image](https://github.com/user-attachments/assets/298e41aa-62aa-40e0-8861-4aba4c07d08e)

### 1.5) Ouvrir le fichier télécharger le elastic agentet lancer le script 
### ⚠️ Si certificat ssl non gérer sur l'infra ajouter `--insecure` aprèes le TOKEN.
      cd C:\Users\sednal\Desktop\elastic-agent-8.17.3-windows-x86_64
      .\elastic-agent.exe install --url=https://192.168.0.103:8220 --enrollment-token=NUVydkpwY0JRZzkxV1hNYWJqVmc6ZWJlSmhfMTFSaWlxdFc2dkY3alE5UQ==

### 1.6) l'agent à bien été trouvé
![image](https://github.com/user-attachments/assets/c83d0371-e91a-482f-a6e5-ecc115e7e041)










































