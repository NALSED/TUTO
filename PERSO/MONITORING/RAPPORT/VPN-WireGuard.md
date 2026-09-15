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


[SOURCE](https://www.youtube.com/watch?v=IvGjWndvTk0)

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

- Ici on changera le port d'écoute par défault et reintraindra le CIDR à 32.

<img width="1147" height="636" alt="image" src="https://github.com/user-attachments/assets/bdd88d10-cd66-4f88-a788-727b1da5a07c" />


---

### `-3-` Configuration Tunnel

`- 3.1` `VPN/WireGuard/Tunnels/Edit/Tunnels/Settings` => Enable WireGuard

- !!! Save + Apply Change !!!

---

### `-4-` Régles Firewall

- Dans le menu en haut Interface puis :

- `Firewall/Rules/WireGuard` + `Add`

---

### `--`

---


### `--`

---

### `--`

---
