# Présentation de Bareos

---

## `Ce document à pour but de présenter la solution Bareos.`

---

## 1️⃣ `Services`
## 2️⃣ `Fichiers de configuration`
## 3️⃣ `Bconsole` 

---
---

<details>
<summary>
<h2>
1️⃣ Services
</h2>
</summary>

![cartographie de parcours utilisateur](https://github.com/user-attachments/assets/a9e90c68-b42c-4522-b262-428a2a5f6723)


## Composants ou services Bareos

### Bareos est composé des principaux composants ou services suivants : 

* ### Director
* ### Console
* ### File
* ### Storage
* ### Monitor.

---
---

## `Daemon Director`

### Le Director est le programme de contrôle central de tous les autres daemon. 
### Planifie et supervise toutes les opérations de sauvegarde, restauration, vérification et archivage. 
### Utilisation de Director pour planifier les sauvegardes et restaurer les fichiers. 
### ⚠️ Le Director s'exécute en tant que daemon (ou service) en arrière-plan.


---

## `Console`

### La console Bareos ( bconsole ) est le programme qui permet à l'administrateur ou à l'utilisateur de communiquer avec Bareos Director. 
### Elle s'exécute dans une fenêtre shell (interface TTY).

--- 

## `Daemon File ou ordinateur client ou FD`

### Le file deamon est un programme qui doit être installé sur chaque machine (cliente) à sauvegarder. À la demande du director Bareos, il recherche les fichiers à sauvegarder et les envoie (leurs données) au daemon de storage Bareos.
### Spécifique au système d'exploitation sur lequel il s'exécute et chargé de fournir les attributs, données,  du fichier lorsque demandé par le director Bareos.

---

## `Daemon Storage ou SD`

### Le daemon storage ,à la demande du director , reçoit les données d'un deamon de file et  stock les attributs et données des fichiers sur les supports ou volumes de sauvegarde physiques. En cas de demande de restauration, il est chargé de rechercher les données et de les envoyer au daemon de file.

---

## `Monitor`

### Les services de catalogue regroupent les logiciels responsables de la maintenance des index de fichiers et des bases de données de volumes pour tous les fichiers sauvegardés. Ils permettent de localiser et de restaurer rapidement tout fichier souhaité. Le catalogue conserve un enregistrement de tous les volumes utilisés, de toutes les tâches exécutées et de tous les fichiers enregistrés.


[terminologie](https://docs.bareos.org/IntroductionAndTutorial/WhatIsBareos.html#terminology)



</details>

---
---

<details>
<summary>
<h2>
2️⃣ Fichiers de configurations
</h2>
</summary>

## 📝
## Ce chapitre a pour but de `présenter` les  `fichiers de configuration`, pour une première utilisation de `Bareos`, il faut approfondir le sujet pour pouvoir complexifier les sauvegardes, les supports ainsi que la fréquence ou le type de fichier sauvegardés.
## Bareos-dir est le chef d'orchestre du logiciel, via le shell (ssh conseillé car beaucoup de fichier de conf) configuration des fichier pour déterminer toutes les otions de sauvegarde
## ⚠️Bareos-dir est le dossier de configuration principal ou l'on passe le plus de temps.⚠️

---
# I) `Bareos-DIR`
# II) `Bareos-SD`
# III) `Bareos -FD`
# IV) `Dépendances` 

---



# I) `Bareos-DIR`

### Ces fichiers de configuration se trouver dans le dossier `/etc/bareos/bareos-dir.d` :

* ## 1.1) `catalog`
### Catalog sert à définir la base de données utilisée pour stocker toutes les métadonnées de sauvegarde.
### Il est édité lors de l'instalation de Bareos.

  Exemple
    Catalog {
      Name = MyCatalog
      dbname = "bareos"
      dbuser = "bareos"
      dbpassword = "<PASSWORD>"
      dbaddress = localhost
    }

[RESSOURCE](https://docs.bareos.org/Configuration/Director.html#directorresourcecatalog)

---

* ## 1.2) `client`
### Client sert à identifier le client sur lequel on veut réaliser la sauvegarde/restauration.
    
    Client {
      Name = clientwin1-fd
      Address = 192.168.0.111      # IP du client Windows
      FDPort = 9102
      Catalog = MyCatalog
      Password = "<PASSWORD>"
    }

[RESSOURCE](https://docs.bareos.org/Configuration/Director.html#client-resource)

---

* ## 1.3) `console`
### Console est installé et configuré lors de l''intallation de Bareos-WebUi

 
    #
    # Restricted console used by bareos-webui
    #
    Console {
      Name = admin
      Password = "admin"
      Profile = "webui-admin"


      # As php does not support TLS-PSK,
      # and the director has TLS enabled by default,
      # we need to either disable TLS or setup
      # TLS with certificates.
      #
      # For testing purposes we disable it here
      TLS Enable = No
    }

---

* ## 1.4) `director` 
### Director contient les information pour l'execution de tache du daemon Bareos-dir, configuré lors de l'instalation de Bareos

    Director {                            # define myself
      Name = bareos-dir
      QueryFile = "/usr/lib/bareos/scripts/query.sql" # Fichier contenant des requêtes SQL pré-définies utilisables via la console (bconsole) pour générer des rapports personnalisés.
      Maximum Concurrent Jobs = 10
      Password = "<PASSWORD>"         # Console password
      Messages = Daemon
      Auditing = yes

      # Enable the Heartbeat if you experience connection losses
      # (eg. because of your router or firewall configuration).
      # Additionally the Heartbeat can be enabled in bareos-sd and bareos-fd.
      #
      # Heartbeat Interval = 1 min

      # remove comment from "Plugin Directory" to load plugins from specified directory.
      # if "Plugin Names" is defined, only the specified plugins will be loaded,
      # otherwise all director plugins (*-dir.so) from the "Plugin Directory".
      #
      # Plugin Directory = "/usr/lib/bareos/plugins"
      # Plugin Names = ""
    }


[RESSOURCE](https://docs.bareos.org/Configuration/Director.html#director-resource)

* ## 1.5) `fileset`

### Fichier qui indique ce qui doit être sauvegardé et où, permet d'inclure et d'exclure des données/fichier etc...
### Particulier pour les clients Windows voir ce [TUTO](https://svennd.be/creating-a-windows-fileset-for-bareos/)

    FileSet {
      # Nom du FileSet
    Name = "windowsbackup"

      # Active la copie de volume shadow (VSS) pour sauvegarder les fichiers ouverts
      Enable VSS = yes

      # Dossier    inclure dans la sauvegarde
      Include {
        File = "C:/Users/sednal/Documents/testbareos"

        Options {
          # Configurations suppl  mentaires
          Signature = MD5        # Algorithme de signature pour verifier l'integrite   des fichiers
          IgnoreCase = yes       # Ignore la casse des noms de fichiers (utile sous Windows)
          noatime = yes          # Ne met pas a jour les horodatages d'accees des fichiers
        }
      }
    }







[RESSOURCE](https://docs.bareos.org/Configuration/Director.html#fileset-resource)

* ## 1.6) `job`
### Fichier très important qui créer une tache pour les sauvegarde ou restauration et qui coordonne les différent fichier de configuration


[RESSOURCE](https://docs.bareos.org/Configuration/Director.html#job-resource)

* ## 1.7) `jobdefs`


[RESSOURCE]()

* ## 1.8) `messages`


[RESSOURCE]()

* ## 1.9) `pool`


[RESSOURCE]()

* ## 1.10) `profile`


[RESSOURCE]()

* ## 1.11) `schedule`


[RESSOURCE]()

* ## 1.12) `storage`


[RESSOURCE]()

* ## 1.13) `user`




[RESSOURCE]()

---
---

# II) `Bareos-SD`



# III) `Bareos -FD`

---

### Ce [TUT0](https://docs.bareos.org/Configuration/Director.html#director-configuration) présente tous les fichiers de configuration de Bareos-dir
### A retrouver dans /etc/bareos/bareo-dir.d


# IV) `Dépendances` 



</details>

---




<details>
<summary>
<h2>
3️⃣ Bconsole 
</h2>
</summary>



</details>
