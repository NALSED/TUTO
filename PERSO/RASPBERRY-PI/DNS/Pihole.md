# Tuto  `d'installation` et de `configuration` de `PihoLe` sur un raspberry pi 4

---

[SOURCE1](https://www.crosstalksolutions.com/the-worlds-greatest-pi-hole-and-unbound-tutorial-2023/)  // [SOURCE2](https://docs.pi-hole.net/guides/dns/unbound/)  // [SOURCE3](https://unbound.docs.nlnetlabs.nl/en/latest/use-cases/local-stub.html)

---
# `SYSTEME`

## 1️⃣ 📘 `Ressources système du Raspberry Pi 4`📘
* ### 🧠 **Mémoire** : 1 Go LPDDR4-3200 SDRAM
* ### 🖥️ **Processeur** :
   *  #### Modèle : Broadcom BCM2711
   *  #### Architecture : ARM Cortex-A72 (ARMv8-A, 64-bit)
   *  #### Nombre de cœurs : 4 cœurs @ 1.5 GHz
   *  #### Type : 64-bit (mais compatible 32-bit) 
* ###  🌐 **Réseau** :
   *  #### Ethernet Gigabit (limitée à ~300 Mbps en pratique via USB 2.0 interne)
   *  #### Wi-Fi 802.11 b/g/n/ac (2.4/5 GHz)
   *  #### Bluetooth 5.0

---

## 2️⃣ 🚀 Installation OS

* #### 1) Télécharger [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
* #### 2) Choisir Modèle / Système / Stockage en fonction.
* #### 3) Suivant et modifier les réglages.
<img width="573" height="260" alt="image" src="https://github.com/user-attachments/assets/c7a20413-3dc8-4de8-8ff9-dcd3feb92453" />

* #### 4) Renseigner Général et Services
<img width="431" height="669" alt="image" src="https://github.com/user-attachments/assets/1f1dd177-f0b8-4386-a266-167e798f6132" />

<img width="1243" height="343" alt="image" src="https://github.com/user-attachments/assets/9608ddc1-6182-4f45-af01-b9f36b9a1ebb" />

* #### 5) Lancer l'installation.

---

## 3️⃣ Configuration IP fixe.
* #### 1) Tapper la commande suivante, éditer le fichier texte.
      sudo nano -w /etc/dhcpcd.conf
  
<img width="332" height="95" alt="image" src="https://github.com/user-attachments/assets/d3c3b0b4-9b98-431b-b47e-5f3b5ac8a11e" />



#### 2) Redemmarer service
      sudo systemctl restart dhcpcd


      
--- 

# `PIHOLE`

## 1️⃣ `Installation`
#### OK - Ok -CONTINUE
#### Choisir eth0
#### Choisir le DNS  déclaré dans /etc/dhcpcd.conf => ICI Cloudflare
#### Ici show everything car réseau perso
#### Une fois l'installation terminée chnger MDP  
      sudo pihole setpassword

## 2️⃣ `Configuration`

### `Listes`
#### ⚠️  Plus le blocage est agressif, plus les sites web/services (légitimes) risquent de tomber en panne. Un blocage agressif peut également augmenter la fréquence des faux positifs.
#### Donc si vous envisagez d'exécuter une configuration de blocage agressive, vous ne devez pas avoir peur de mettre certains domaines sur liste blanche.

*  #### Article + Ressources [SITE](https://avoidthehack.com/best-pihole-blocklists)
* #### Black listes
    *  #### [Starter Pack](https://cdn.jsdelivr.net/gh/jerryn70/GoodbyeAds@master/Hosts/GoodbyeAds.txt)
    * #### Propose des listes en foction de la politique de blocage souhaitée [GitHub](https://github.com/hagezi/dns-blocklists?tab=readme-ov-file#pro)
    * #### Propose des listes en foction de ce que l'on veux  bloquer [SITE](https://firebog.net/)

* #### Script pour bloquer pub Youtube => [GitHub](https://github.com/kboghdady/youTube_ads_4_pi-hole)





































