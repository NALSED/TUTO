# Proxmox — Accès WebUI via hotspot iPhone (sans box)

## Contexte

- **Machine** : PC fixe HP (Intel X58 / i7-920), Proxmox VE installé
- **Objectif** : Accéder au WebUI Proxmox (`https://IP:8006`) depuis un iPhone SE via partage de connexion
- **Contrainte** : Aucune box, aucun câble RJ45, aucun accès internet sur Proxmox

---

## Problèmes rencontrés

| Problème | Cause |
|---|---|
| Interface Wi-Fi `wlp1s0` DOWN | `wpasupplicant` absent + firmware Realtek manquant |
| USB iPhone non reconnu en tethering | Module `ipheth` non chargé + AppArmor bloquait `dhclient` |
| Impossible d'installer des paquets | Pas de réseau → cercle vicieux |
| `firmware-realtek` en conflit | Proxmox fournit déjà `pve-firmware` |

---

## Résolution étape par étape

### 1. Identifier la carte Wi-Fi
```bash
lspci
```
→ **Realtek RTL8192EE PCIe Wireless Network Adapter**

### 2. Vérifier le firmware (déjà inclus dans pve-firmware)
```bash
modprobe -r rtl8192ee
modprobe rtl8192ee
dmesg | tail -20
```
→ `rtl8192ee: Using firmware rtlwifi/rt18192eefw.bin` ✓

### 3. Télécharger wpasupplicant depuis un autre ordi
Paquets `.deb` récupérés sur `packages.debian.org/bookworm/amd64` :
- `wpasupplicant`
- `libnl-3-200`
- `libnl-genl-3-200`
- `libpcsclite1`

Transférés via clé USB, installés avec :
```bash
mount /dev/sdb1 /mnt
dpkg -i /mnt/*.deb
```

### 4. Créer la config wpa_supplicant
```bash
wpa_passphrase "NomHotspot" "MotDePasse" > /etc/wpa_supplicant/wpa_supplicant.conf
```

### 5. Ajouter wlp1s0 dans /etc/network/interfaces
```bash
nano /etc/network/interfaces
```
Ajout :
```
auto wlp1s0
iface wlp1s0 inet dhcp
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

### 6. Activer l'interface
```bash
ifup wlp1s0
ip addr show wlp1s0
```
→ IP `172.20.10.x` attribuée par le hotspot iPhone ✓

### 7. Accès WebUI
```
https://172.20.10.x:8006
```
→ Interface Proxmox accessible depuis l'iPhone ✓

---

## Notes

- La config `auto wlp1s0` dans `/etc/network/interfaces` persiste au reboot
- Le firmware Realtek est déjà inclus dans `pve-firmware` — ne pas installer `firmware-realtek` séparément (conflit)
- AppArmor bloquait `dhclient` → désactivé via `apparmor_parser -R`
