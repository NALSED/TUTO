## Tips `SSH`

---

- Créer un tunel `local`
   - **USE CASE** : une VM `CLI` à besoin d'une `UI` 
````
# Commande  Flag   PortLocal(UI):Hôte(vu depuis la VM):PortVM   User@VM (CLI)
ssh         -L     5001:127.0.0.1:5001                          sednal@192.168.0.24
# → navigateur sur la machine UI : http://localhost:5001
````


---

- Créer un Reverse tunel `WAN`
````
# Commande  Flag   PortVPS:Hôte(vu depuis ta machine):PortLocal   User@VPS
ssh         -R     8080:127.0.0.1:3000                            vps@<ip_publique>
# → sur le VPS : curl http://localhost:8080
````

`[NOTE]`
````
port_ouvert_ici : destination : port_destination
````
