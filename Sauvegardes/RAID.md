### Raid
#### Le systéme Raid permet la sauvegarde de donnés, les disques ne sont pas accessibles directement mais via un contrôleur RAID. 
#### Pour ce faire il existe 4 types de Raid:
* #### Raid 0 => deux disques mini, les données sont réparties sur les deux disques(très sensible à la panne, utilisé pour ça rapidité) 
* #### Raid 1 => deux disques mini, les données sont copiées sur les deux disques
* #### Raid 5 => Les données sont réparties sur les en tant que donnés et parités .La parités est l'équivalent des donnés sauvegardées, en utilisant un OU logique

|XOR|0|1|
|:-:|:-:|:-:|
|0|0|1|
|1|1|0|

* #### Raid 10 est une combinaison de RAID 1 + RAID 0.
