1) INTRO ### Raid
#### Le systéme Raid permet la sauvegarde de donnés, les disques ne sont pas accessibles directement mais via un contrôleur RAID. 
#### Pour ce faire il existe 4 types de Raid:
* #### `Raid 0`(striped ou spanned) => deux disques mini, les données sont réparties sur les deux disques(très sensible à la panne, utilisé pour ça rapidité) 
![ad0](https://github.com/user-attachments/assets/22eeb378-d6e5-499f-bd12-9eb69ef178dd)
#### ⚠️Différences entre 1️⃣Spanned (Fractionné) ou 2️⃣Striped (Abrégé par Bandes)
#### 1️⃣ Pour un disque fractionné, les données sont placées les unes après les autres. Une partition peut être étendue sur plusieurs disques de manière totalement transparente donnant l'impression qu'elle se trouve sur un seul disque. Cela est très pratique si une partition manque d'espace car elle peut être étendue en rajoutant un disque. Il n'y a aucun gain de performances. Si un disque tombe, seules les données sur ce disque sont perdues , le reste pouvant être récupéré avec des logiciels tiers.
#### 2️⃣ Les donnés sont répartie sue les N Disques
* ####  `Raid 1`(mirroring) => deux disques mini, les données sont copiées sur les deux disques
![ad1](https://github.com/user-attachments/assets/0ebeae76-87ce-42a7-831b-473131136871)

* ####  `Raid 5` => Les données sont réparties sur les en tant que donnés et parités .La parités est l'équivalent des donnés sauvegardées, en utilisant un OU logique

|XOR|0|1|
|:-:|:-:|:-:|
|0|0|1|
|1|1|0|

![ad5](https://github.com/user-attachments/assets/d5c7a1a5-b20f-4b81-be3e-6708c9ed1a66)

* ####  `Raid 10` est une combinaison de RAID 1 + RAID 0.
2 ) WINDOWS ### RAID
#### Se rendre dans Disk Manager, on peux y retrouver les différent disk
![ad1](https://github.com/user-attachments/assets/c1e33a78-1228-4172-aaab-89f01c2ed2e0)








LINUX











