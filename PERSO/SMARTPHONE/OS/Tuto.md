1) créer un compte xiaomi sur internet => [ICI](https://account.xiaomi.com/fe/service/login/password?_locale=fr_FR&sid=passport&qs=%253F_locale%253Dfr_FR&callback=https%3A%2F%2Faccount.xiaomi.com&_sign=2%26V1_passport%26NFXEb4E9codBsffJwtOnKhopIhQ%3D&serviceParam=%7B%22checkSafePhone%22%3Afalse%2C%22checkSafeAddress%22%3Afalse%2C%22lsrp_score%22%3A0.0%7D&showActiveX=false&theme=&needTheme=false&bizDeviceType=)

2) Instaler `minulock`
````
python3 -m venv ~/miunlock-env
source ~/miunlock-env/bin/activate
pip install miunlock
````

3) Télécharger un ROM recovery officiel (en cas de probléme) : [ICI](https://miuirom.org/load?o=redmi-12-5g&v=2.0.217.0.VMWEUXM&l=en&t=Recovery)

4) Activer le mode développeur, appuyer 7x sur la version de l'OS

5) insérer une sim valide

6) - Insérer un carte SIM valide.
- Se logger sur un compte `xiomi community`, et dans la section `Me` / ` Bootloader unlock`, le compte  xiomi doit être enregistré depuis au moins  **30** jours (region global).
- ⚠️ faire la demande à chinoise est primordiale **00h00** Heure chinoise (Pour être sur => [Heure](https://time.is/GMT+8) )
- Parfoit de faux `application quota limit reached`, à chaque essaie de demande d'unlock, `déconnecter` le compte xiomi, `redémarrer` le téléphone, et essayer de tester => `Developer Options` / `Mi Unlock status` / `Add account and device`
- Si la demande est acceptée, une durée comprise en `128h` et  `72h` est stipulé.

7) Débloquer le smartphone via `miunlock`
````
source ~/miunlock-env/bin/activate
miunlock
````
- Suivre les indications.


8) Télécharger les `Binaires`
- [Binaires](https://sourceforge.net/projects/crdroid/files/gemstone/13.x/recovery/)
- `boot.img` [ICI](https://sourceforge.net/projects/crdroid/files/gemstone/13.x/recovery/20261019-boot.img/download)
- `vendor_boot.img` [ICI](https://sourceforge.net/projects/crdroid/files/gemstone/13.x/recovery/20261019-vendor_boot.img/download)
- `dtbo.img` [ICI](https://sourceforge.net/projects/crdroid/files/gemstone/13.x/recovery/20261019-boot.img/download)
- `crDroid.zip` [ICI](https://sourceforge.net/projects/crdroid/files/gemstone/13.x/crDroidAndroid-17.0-20261006-gemstone-v13.0-BETA.zip/download)
- `MindTheGapps` (Intégration google) [ICI](https://github.com/MindTheGapps/17.0.0-arm64/releases)

10) lancer le programme  Mi Unlock Tool et suivre les instruction

11) passer en fastboot => touche volume - + allumer pendant 5 seconde

