## `-2-` Prérequis

### 2.1) Clé SSH de `sednal@192.168.0.240` autorisée sur le VPS

````
ssh -o BatchMode=yes debian@176.31.163.227 "hostname"
````

**Sortie attendue**

````
vps-sednal
````

### 2.2) `rsync` présent des deux côtés en `192.168.0.240` et `176.31.163.227`

- Verification 
````
which rsync
````

- Le cas échéant
````
sudo apt install -y rsync
````
