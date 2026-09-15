## Mise en place d'un VPN-WireGuard sur pfsense.

---

- Le VPN sera réalisé entre le `pfsense` local et le `VPS`

### `Labs`

`-1-` === Pfsense ===

- `Model` : Netgate 1100

- `Version` : 23.09-RELEASE (arm64)

- `CPU` : 2 Core, ARM Cortex-A53 r0p4 

- `RAM` : 1 Go

`-2-` === VPS ===

- `OS` : Debian 13

- `CPU` : 4 vCores

- `RAM` : 8 Go

---


[SOURCE-1-](https://www.youtube.com/watch?v=IvGjWndvTk0)
[SOURCE-2-](https://www.youtube.com/watch?v=XEGb3ajiyXA)
---

### `-1-` Installation de `Wireguard`

`- 1.1` `SystemPackage/ManagerAvailable/Packages`

- Rechercher : `Wireguard`

<img width="1136" height="537" alt="image" src="https://github.com/user-attachments/assets/6e4aa195-212c-43fa-9f04-8cbaba3ae99c" />

- `+ Install`

- Attendre `Success`


---

### `-2-` Ajout d'un Tunnel

`- 2.1` Dans le menu en haut `VPN` => `WireGuard` est maintenant disponible

- `VPN/WireGuard/Tunnels/Edit/Tunnels`

- Ici on changera le port d'écoute par défault .

<img width="1132" height="657" alt="image" src="https://github.com/user-attachments/assets/eec0598b-ea4d-43c2-aaaa-881f854b6471" />


---

### `-3-` Configuration Tunnel

`- 3.1` `VPN/WireGuard/Tunnels/Edit/Tunnels/Settings` => Enable WireGuard

- !!! Save + Apply Change !!!

---

### `-4-` Ajout interfaces et Régles Firewall

## === Interfaces ===

-`- 4.1` Dans le menu en haut Interfaces puis :

- `InterfacesInterface/Assignments` + `Add`

- `- 4.2` Sélectionner `tun_wg0(tun_wg0)`

<img width="1146" height="392" alt="image" src="https://github.com/user-attachments/assets/9b685fc6-1e5d-4ecd-a760-4889ea696546" />

- `- 4.3` Cliquer sur l'interface : Interfaces/OPT2 (tun_wg0)

- Opérations à réaliser :
````
Enable interface

Description : `WG_N8N`
   
IPv4 Configuration Type : `Static IPv4`
 
IPv4 Address : `10.100.0.2/24`
````
      
- `Save + Apply Change`


## `Firewall`

`- 4.4` - Dans le menu en haut `Firewall`

=> Deux régles :

`-1- WAN`
`-2- WG_N8N`

- Opérations à réaliser :

### `-1- WAN`
````
Action              : Pass
Disabled            : décoché (laisser actif)
Interface           : WAN
Address Family      : IPv4
Protocol            : UDP

Source
  Type              : Single host or alias
  Address           : IP VPS

Destination
  Type              : WAN address

Destination Port Range
  From              : Custom => *
  To                : Custom => *

Description         : Autoriser Lan => n8n
````

 ### `-2- WG_N8N`
````
Action           : Pass
Interface        : WG_N8N
Address Family   : IPv4
Protocol         : TCP
Source           : Address or Alias => 10.100.0.1
Destination      : Address or Alias => 192.168.0.239
Destination Port Range
  From              : 22
  To                : 22
````
---

### `-5-` Configuration Client `176.31.163.227`

Voir => [ICI](https://github.com/NALSED/TUTO/blob/main/PERSO/MONITORING/RAPPORT/VPN/Client.md)

