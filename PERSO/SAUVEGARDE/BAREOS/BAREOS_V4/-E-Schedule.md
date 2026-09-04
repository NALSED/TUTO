# Configuration du fichier Schedule

---

[SCHEDULE-BAREOS](https://docs.bareos.org/Configuration/Director.html#schedule-resource)

---

## `-1-` LAN

### `- 1.1` Win_Schedule_LAN.conf

````
vim /etc/bareos/bareos-dir.d/schedule/Win_Schedule_LAN.conf
````

````
Schedule {
    Name = Win_Schedule_LAN

    # Full chaque 1er dimanche du mois
    Run = Full 1st sun at 12:10

    # Incremental les autres dimanches
    Run = Incremental 2nd-5th sun at 12:10
}
````

### `- 1.2` Lin_Schedule_LAN.conf

````
vim /etc/bareos/bareos-dir.d/schedule/Lin_Schedule_LAN.conf
````

````
Schedule {
    Name = Lin_Schedule_LAN

    # Full chaque 1er dimanche du mois
    Run = Full 1st sun at 12:00

    # Incremental les autres dimanches
    Run = Incremental 2nd-5th sun at 12:00
}
````

---

## `-2-` WAN

### `- 2.1` Win_Schedule_WAN.conf

````
vim /etc/bareos/bareos-dir.d/schedule/Win_Schedule_WAN.conf
````

````
Schedule {
    Name = Win_Schedule_WAN

    Run = Full 1st sun jan mar may jul sep nov at 12:15
    Run = Incremental 1st sun feb apr jun aug oct dec at 12:15
}
````

### `- 2.2` Lin_Schedule_WAN.conf

````
vim /etc/bareos/bareos-dir.d/schedule/Lin_Schedule_WAN.conf
````

````
Schedule {
    Name = Lin_Schedule_WAN

    # Full chaque 1er dimanche du mois
    Run = Full 1st sun at 12:05

    # Incremental les autres dimanches
    Run = Incremental 2nd-5th sun at 12:05
}
````
