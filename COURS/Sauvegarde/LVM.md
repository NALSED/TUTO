#### 📝 LVM est à la fois une méthode et un logiciel de gestion de l'utilisation des espaces de stockage d'un ordinateur
[LVM](https://doc.ubuntu-fr.org/lvm)
[IT](https://www.it-connect.fr/chapitres/creation-et-gestion-dune-structure-lvm/)
[AVANCE](https://www.linuxtricks.fr/wiki/lvm-avance-les-snapshots)
### `Création et visualisation`
![ad1](https://github.com/user-attachments/assets/af28c1c7-7a03-443a-8b76-cc3d76962a6f)
##### Partition de disques :
![ad1](https://github.com/user-attachments/assets/39405afa-4475-4c8d-b5a8-d8770528b9ac)
##### Puis :
![ad1](https://github.com/user-attachments/assets/97fc0d32-f4ca-4745-9383-96ae34b199bb)
![ad1](https://github.com/user-attachments/assets/a008b316-9d9e-4b74-bcf4-f05d5081f973)
##### Commande ⏬
### `les partitions LVM`
![ad1](https://github.com/user-attachments/assets/42397d5a-0971-484a-a741-9ccddcfc3c50)
### `liste courtes pvs, vgs et lvs`
![ad1](https://github.com/user-attachments/assets/2b29b5d1-4b1e-4ad2-a049-9a5a43aab270)
<details>
<summary>
<h2> 
Commandes pour plus de détails
</h2>
</summary>

![ad1](https://github.com/user-attachments/assets/51248f55-6837-446f-82c2-7666f83a5c86)
![ad1](https://github.com/user-attachments/assets/fb4dfa65-aa27-41e6-a2e8-ad057e2f5d4a)
![ad1](https://github.com/user-attachments/assets/01575591-2218-43a6-962e-c0fbd36009f5)

</details>

##### On peux vérifier si ces système sont bien monté au démarrage : 
![ad1](https://github.com/user-attachments/assets/385a872e-1a4d-4de2-b655-27c259907b25)
### `Actions`
<details>
<summary>
<h2> 
🖥️Commandes🖥️
</h2>
</summary>

### `PV`
![ad1](https://github.com/user-attachments/assets/70ffd8ca-c3d9-442e-819e-c7cf9be9d06d)

après la commande rajouter le disque souhaité :
       pvcreate /dev/sdb1

### `VG`
![ad1](https://github.com/user-attachments/assets/078b4dee-47d9-4f63-871b-3956d975d42b)

### `LV`
![ad1](https://github.com/user-attachments/assets/e80ce2f7-5a07-4abe-b13e-44833ad4f384)


</details>

#### Ordre => 1️⃣ Initialiser un Volume => 2️⃣ Créer un groupe => 3️⃣ Créer un volume logique.

### Exercice :

## 1️⃣ `Renomer en vg-debian et ajouter un disque`
![ad1](https://github.com/user-attachments/assets/5013e7ea-3ea5-495e-93b4-6dec2ba12844)
### ➡️ Ajout de sdb => debian-vg
![ad1](https://github.com/user-attachments/assets/698fd0df-0a44-4a39-b4fd-eaa003b809da)
## 2️⃣ `Snapshot de LV home`
![ad1](https://github.com/user-attachments/assets/175f6dbc-6902-4c88-97d2-602d78ad51c1)
![ad1](https://github.com/user-attachments/assets/82df2bca-83bc-4422-95a2-264b3cfd3fff)
![ad1](https://github.com/user-attachments/assets/23df7fee-51b5-47a3-93e4-47b3ec2ac8e2)
## 3️⃣ `Montage`
![image](https://github.com/user-attachments/assets/02576552-0cd4-4227-b700-f00cc402b663)
## 4️⃣ `Vérification copie`
![image](https://github.com/user-attachments/assets/11332af6-3f33-4e14-ac35-6cba502391e2)
## 5️⃣ `Démontage et supression`
![image](https://github.com/user-attachments/assets/1d3588fb-b015-4b84-b437-19c8161e5859)























