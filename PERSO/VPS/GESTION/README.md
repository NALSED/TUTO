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

`- 1.2` Rédemmarage service
````
sudo wg-quick down wg0 && wg-quick up wg0
sudo wg 
````

- Les nouvelles `IP` doivent être ajoutées.

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
#!/bin/bash

# Script de menu SSH pour administrer les machines locales

# ========== VARIABLES ==========

#=== Infra ===
RELAIS="sednal@192.168.0.239"      # machine allumée qui envoie le WoL

#=== Proxmox ===
PROXMOX_HOST="root@192.168.0.242"
PROXMOX_IP="192.168.0.242"
PROXMOX_MAC="34:5A:60:E0:1C:72"

#=== Momo ===
AGENT_VMID=999

# Rad

# ========== SOUS-MENUS ==========

menu_proxmox() {
    local action
    action=$(gum choose --header "Proxmox" \
        "Allumer" \
        "Eteindre" \
        "SSH" \
        "Retour") || return

    case "$action" in
        "Allumer")  ssh "$RELAIS" "wakeonlan $PROXMOX_MAC" ;;
        "Eteindre") gum confirm "Éteindre Proxmox ?" && ssh "$PROXMOX_HOST" "init 0" ;;
        "SSH")      ssh "$PROXMOX_HOST" ;;
        "Retour")   return ;;
    esac
}

menu_agent_ai() {
    local action
    action=$(gum choose --header "Agent AI" \
        "Allumer" \
        "Eteindre" \
        "Générer une fenêtre Tmux + Claude code => /remote" \
        "Retour") || return

    case "$action" in
        "Allumer")
            if ping -c 2 -W 2 "$PROXMOX_IP" > /dev/null; then
                ssh "$PROXMOX_HOST" "qm start $AGENT_VMID"
            else
                gum style --foreground 196 "=== Proxmox n'est pas allumé. ==="
                sleep 3
            fi
            ;;
        "Eteindre")
            gum confirm "Éteindre Agent AI ?" && ssh "$PROXMOX_HOST" "qm shutdown $AGENT_VMID"
            ;;
        "Générer une fenêtre Tmux + Claude code => /remote")
            # TODO
            ;;
        "Retour") return ;;
    esac
}

# MENU OSINT PROVISOIRE
menu_osint() {
    gum style --foreground 214 "=== OSINT : non implémenté ==="
    sleep 2
}

# ========== MENU PRINCIPAL ==========

menu_machines() {
    local choix
    while true; do
        clear
        gum style --foreground 85 --border-foreground 32 --border double \
            --padding "0 2" '=== Gestion Machines Locales ==='

        choix=$(gum choose --header "Choisir une machine" --height 10 \
            "Proxmox" \
            "Agent AI" \
            "OSINT" \
            "Quitter") || exit 0

        case "$choix" in
            "Proxmox")  menu_proxmox ;;
            "Agent AI") menu_agent_ai ;;
            "OSINT")    menu_osint ;;
            "Quitter")  exit 0 ;;
        esac
    done
}

# ========== DEBUT SCRIPT ==========

clear
gum spin --spinner dot --title "Chargement Gestion VPS" -- sleep 1
menu_machines
````
