# Proxychains

---

### 1️⃣ Instalation
### 2️⃣ Configuration
### 3️⃣ Utilisation

---
---

### 1️⃣ Instalation
      sudo apt install proxychains
      sudo apt install proxychains4 proxycheck proxytrack proxytunnel torsocks torbrowser-launcher
      
### 2️⃣ Configuration
#### Se rendre sur les liens suivant pour récupérer des liste de proxy gratuit et anonymes
[PROXY-TOOLS](https://fr.proxy-tools.com/proxy/socks)

[FREE PROXY](http://free-proxy.cz/fr/)

[LISTE MALEKAL](https://www.malekal.com/liste-des-meilleurs-proxy-gratuits-2022/)

#### Editer le fichier de conf
      
      sudo nano /etc/proxychains.conf

#### Décommenter la ligne dynamic_chain et commenter strict_chain, comme ça proxychains passera automatiquement d'un proxy à l'autre.

![image](https://github.com/user-attachments/assets/01bf0e66-9382-4e39-a92a-d3f3a2844c17)

#### Dans [Proxy list] en bas entrer les infos des proxys récupéré sur les sites ci dessus.
#### Avec la syntaxe suivante => TYPE(socks//http) // IP // PORT // USER(optionnel) // MDP(optionnel)



### 3️⃣ Utilisation

