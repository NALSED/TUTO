### Raid
#### Le systéme Raid permet la sauvegarde de donnés, les disques ne sont pas accessibles directement mais via un contrôleur RAID. 
#### Pour ce faire il existe 4 types de Raid:
* #### `Raid 0` => deux disques mini, les données sont réparties sur les deux disques(très sensible à la panne, utilisé pour ça rapidité) 
![ad0](https://github.com/user-attachments/assets/22eeb378-d6e5-499f-bd12-9eb69ef178dd)


* ####  `Raid 1` => deux disques mini, les données sont copiées sur les deux disques
![ad1](https://github.com/user-attachments/assets/0ebeae76-87ce-42a7-831b-473131136871)

* ####  `Raid 5` => Les données sont réparties sur les en tant que donnés et parités .La parités est l'équivalent des donnés sauvegardées, en utilisant un OU logique

|XOR|0|1|
|:-:|:-:|:-:|
|0|0|1|
|1|1|0|

![ad5](https://github.com/user-attachments/assets/d5c7a1a5-b20f-4b81-be3e-6708c9ed1a66)

* ####  `Raid 10` est une combinaison de RAID 1 + RAID 0.
