## Mise en place d'un outil de gestion 

---

- Ce tuto détail la mise en place d'un outil de gestion depuis un `smatphone` via `Haven`(Connection SSH) en passant par un `VPS`, pour pouvoir atteindre des  `VM` en local. 

- Utilisation du tunel `VPN` (créé pour l'utilisation des notification `Telegram` via `n8n`) => [ICI](https://github.com/NALSED/TUTO/tree/main/PERSO/MONITORING/RAPPORT/-2-%20VPN)

PLAN ASCII
````
A faire
````

---

### `-1-` Ajout de règles **VPN** `Wireguard` sur le **VPS**

- Ajout des `IP` de l'agent `AI` et `Grappes`

   - **AI** : 192.168.0.250
   - **Grappes** 192.168.0.A FIXER

`- 1.1` configuration du fichier 
````
vim /etc/wireguard/wg0.conf
````
````
interface: wg0
  public key: <pub key>
  private key: (hidden)
  listening port: 51900

peer: <pub key>
  endpoint: 5.77.130.104:9376
  allowed ips: 10.100.0.2/32, 192.168.0.239/32, 192.168.0.235/32, 192.168.0.240/32, 192.168.0.242/32, 192.168.0.250/32, <AJOUTER GRAPPES>
  latest handshake: 3 seconds ago
  transfer: 180 B received, 272 B sent
  persistent keepalive: every 25 seconds
````

---
