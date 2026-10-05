## Installation de l'agent Claude Code sur VM

---

### -1- Prérequis VM

VM Debian 13 existante sur Proxmox :

- IP : 192.168.0.23/24
- Passerelle : 192.168.0.1
- DNS : 192.168.0.241
- Options => Start at boot : Yes
- Options => QEMU Guest Agent : Enabled

`- 1.1` Installation des prérequis
````
sudo  -i
apt update && apt full-upgrade -y
apt install -y qemu-guest-agent ca-certificates curl jq git
systemctl enable --now qemu-guest-agent
timedatectl set-timezone Asia/Yerevan
````

- `jq` est requis par la boucle de l'agent (lecture du quota).
- `git` est requis : le projet est un dépôt git, l'agent commite à chaque changement.


### -3- Installation de Claude Code

`- 3.1` Installation du CLI

Claude Code s'installe en binaire autonome : **ni Node ni npm ne sont nécessaires** sur la VM.

````
su - sednal
curl -fsSL https://claude.ai/install.sh | bash
claude --version
````

Résultat attendu (version au moment de l'installation) :

````
2.1.278 (Claude Code)
````

Le binaire est déposé dans `/home/sednal/.local/bin/claude`

`- 3.2` Authentification

À faire **une seule fois**, en interactif, sous l'utilisateur `sednal` :

````
claude
````
