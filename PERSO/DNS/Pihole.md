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
  
<img width="326" height="157" alt="image" src="https://github.com/user-attachments/assets/3933ac7a-9fb5-40d4-9c8e-f5c4dadbac24" />


#### 2) Redemmarer service
      sudo systemctl restart dhcpcd


      
--- 

# `PIHOLE`

## 1️⃣ `Installation`
      apt update && sudo apt upgrade -y
      curl -sSL https://install.pi-hole.net | bash
#### OK - Ok -CONTINUE
#### Choisir eth0
#### Choisir le DNS  déclaré dans /etc/dhcpcd.conf => ICI Cloudflare
#### Ici show everything car réseau perso
#### Une fois l'installation terminée changer MDP  
      sudo pihole setpassword

## 2️⃣ `Configuration`
## `Certificats`
      win+R
      certmgr.msc

<img width="619" height="438" alt="image" src="https://github.com/user-attachments/assets/6bbc4bde-f9fb-4ff4-97ed-4925e7aa294b" />

#### Clique droit dans la partie droite => Toutes les tâches => Importer
#### Suivant
#### Importer le fichier tls_ca.crt

<img width="527" height="493" alt="image" src="https://github.com/user-attachments/assets/737bed77-6842-4b3e-923b-fc53cd2a48bd" />


## `Listes`
#### ⚠️  Plus le blocage est agressif, plus les sites web/services (légitimes) risquent de tomber en panne. Un blocage agressif peut également augmenter la fréquence des faux positifs.
#### Donc si vous envisagez d'exécuter une configuration de blocage agressive, vous ne devez pas avoir peur de mettre certains domaines sur liste blanche.

*  #### Article + Ressources [SITE](https://avoidthehack.com/best-pihole-blocklists)
* #### Black listes
    *  #### [Starter Pack](https://cdn.jsdelivr.net/gh/jerryn70/GoodbyeAds@master/Hosts/GoodbyeAds.txt)
    * #### Propose des listes en foction de la politique de blocage souhaitée [GitHub](https://github.com/hagezi/dns-blocklists?tab=readme-ov-file#pro)
    * #### Propose des listes en foction de ce que l'on veux  bloquer [SITE](https://firebog.net/)

* #### Script pour bloquer pub Youtube => [GitHub](https://github.com/kboghdady/youTube_ads_4_pi-hole)
---
---

## `Unbound`

#### Cette partie commence  après [ICI](https://github.com/NALSED/TUTO/blob/main/PERSO/RASPBERRY-PI/DNS/unbound.md#installation--et-configuration-de-unbound)

#### Se rendre dans Settings => DNS et Décocher le DNS choisi  pour l'installation
#### Entrer un Custom DNS

<img width="669" height="244" alt="image" src="https://github.com/user-attachments/assets/eb85f2a3-781d-4cad-9d4e-cfc6b3c24fa9" />

#### Changer le fichier /etc/dhcpcd.conf => static domain_name_servers=127.0.0.1

### ⚠️Pour solutions installées sur `Debian  Bullseyes` ⬇️ 

#### À partir de Debian Bullseye, un paquet appelé openresolv est automatiquement installé avec une configuration qui cause des problèmes inattendus pour Pi-hole et Unbound. En effet, le service unbound-resolvconf.service demande à resolvconf d’écrire dans le fichier /etc/resolv.conf une ligne indiquant le serveur DNS 127.0.0.1 (Unbound local), mais sans préciser le port 5335 utilisé par Unbound.

#### Or, ce fichier /etc/resolv.conf est utilisé par les services locaux pour connaître les serveurs DNS configurés. Cette absence de port provoque des dysfonctionnements.

#### Pour contourner ce problème, il faut modifier la configuration et désactiver ce service.

#### Désactiver le service unbound-resolvconf.service
      sudo systemctl disable --now unbound-resolvconf.service

#### Éditer /etc/resolvconf.conf pour désactiver l’option Unbound
      sudo sed -Ei 's/^unbound_conf=/#unbound_conf=/' /etc/resolvconf.conf

####  Supprimer le fichier généré /etc/unbound/unbound.conf.d/resolvconf_resolvers.conf
      sudo rm /etc/unbound/unbound.conf.d/resolvconf_resolvers.conf

#### Redémarrer Unbound
      sudo service unbound restart

#### Status Unbound
      sudo service unbound status




















