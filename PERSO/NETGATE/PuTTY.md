# 📝 Utilisation de PuTTY pour réinitialiser le boitier Netgate 1100.

[DOC](https://docs.netgate.com/manuals/pfsense/en/latest/sg-1100-security-gateway-manual.pdf) ==> Page 334

### 1️⃣ Driver 
[télécharger](https://prolificusa.com/product/pl2303gl-8-pin-usb-uart-bridge-controller/) le driver correspondant.

### 2️⃣ Gestinnaire de périphériques

### 2.1) Dans Ports (COM et LPT) Choisir `Prolific PL2303GL USB Serial COM Port` ici COM3
### 2.2) Dans les Propiétés de `Prolific PL2303GL USB Serial COM Port` => Port Settings => Changer les Bits per second : 115200 puis OK

<img width="810" height="467" alt="image" src="https://github.com/user-attachments/assets/6db7f41e-b43a-4c33-bd36-9aa98ddb6c3d" />

### 3️⃣ PuTTY 
### 3.1) Ouvrir PuTTY => Choisir Serial => Serial line COM3 et Speed 115200 => Open
### 3.2) Appuyer sur `Enter` et le menu du Netgate 1100 est maintenat accecible :

<img width="751" height="573" alt="image" src="https://github.com/user-attachments/assets/6d6e8f35-b2b6-49da-9b29-46750ccc71d6" />
### 3.3) choisir 4 et Valider 
