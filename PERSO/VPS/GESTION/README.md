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
sudo vim /etc/wireguard/wg0.conf
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

### `-2-`  Ajout de règles **VPN** `Wireguard` sur le **Pfsense** 


`- 2.1` Allez dans **Firewall/Rules/WG_N8N**

<img width="1170" height="424" alt="image" src="https://github.com/user-attachments/assets/d4ee7164-4ba3-4ff2-baf1-3af62f1a2b69" />

`- 2.2` **Add** et éditer
````
Action           : Pass
Interface        : WG_N8N
Address Family   : IPv4
Protocol         : TCP
Source           : Address or Alias => 10.100.0.1
Destination      : Address or Alias => 192.168.0.242
Destination Port Range
  From              : 22
  To                : 22
````

---

### `-3-` Script de gestion sur le **VPS**.

````

````
