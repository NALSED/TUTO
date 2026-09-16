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
AllowedIPs = 10.100.0.2/32, 192.168.0.239/32, 192.168.0.235/32, 192.168.0.234/32
PersistentKeepalive = 25
````
````
wg down wg0 && wg up wg0
wg show wg0
````

- Sortie attendue
````
interface: wg0
  public key: <pub key>
  private key: (hidden)
  listening port: 51900

peer: <pub key>
  endpoint: 5.77.130.104:9376
  allowed ips: 10.100.0.2/32, 192.168.0.239/32
  latest handshake: 3 seconds ago
  transfer: 180 B received, 272 B sent
  persistent keepalive: every 25 seconds
````

### `-3-` Firewall

`- 3.1` Editer `iptable`
````
sudo iptables -I INPUT -p udp --dport 51900 -j ACCEPT
````


### `-4-` Test

- Test avec ssh car uniquement le port 22 est ouvert
````
debian@vps-sednal:~$ ssh sednal@192.168.0.239
````


### `-5-` Troubleshooting

[Liens](https://oneuptime.com/blog/post/2026-01-28-debug-wireguard-connection-issues/view)
