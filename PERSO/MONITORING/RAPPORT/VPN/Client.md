## Configuration du client VPN sur VPS

---
[SOURCE-1-](https://www.wireguard.com/install/)

[SOURCE-2-](https://www.wireguard.com/quickstart/)

### `-1-` Installation WireGard sur `VPS`
````
sudo apt install -y wireguard
````

### `-2-` Configuration 

`- 2.1` Grénération des clés !!! Bien les noter !!!
````
# Private
wg genkey > private

# Public
wg pubkey < private
````

`- 2.2` IP et démarage Wireguard
````
sudo ip link add wg0 type wireguard
````
````
sudo ip addr add 10.100.0.1/24 dev wg0
````

- Fichier configuration 
````
vim /etc/wireguard/wg0.conf
````
````
[Interface]
PrivateKey = <clé privée VPS>
Address = 10.100.0.1/24
ListenPort = 51900

[Peer]
PublicKey = YKQXcztjuM9Y4iBk9FvIouHs1J+dkqGxlqA8bS0CpGI=
Endpoint = 5.77.130.104:51900
AllowedIPs = 10.100.0.2/32, 192.168.0.239/32
PersistentKeepalive = 25
````
````
wg down wg0 && wg up wg0
wg show wg0
````


````
ip link set wg0 up
````

### `-3-` Ajout peer `Pfsense`


