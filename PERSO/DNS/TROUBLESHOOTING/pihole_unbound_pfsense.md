# Proposition de solution pour `résolution de nom de domain en local` avec pihole + unbound + pfsense

---
### === Contexte ===

Le probléme est survenu longtemps après lla mise ne place de pihole et unbound.
En effet dans cette infra, pihole est utilisé ppour bloquer les publicitées, et Unbound comme DNS récursif primaire.
Le bloquage de publicité ainsi que la résolution WAN fonctionait parfaitement pour la configuration voir [ICI : Pihole](https://github.com/NALSED/TUTO/blob/main/PERSO/DNS/Pihole.md) [ICI: unbound](https://github.com/NALSED/TUTO/blob/main/PERSO/DNS/unbound.md) .

Les problémes sont arrivés lorsque j'ai voulu implémenter des nom de domaine pour mes services, via pfsense.  

=== Architecture réseau [1] ===
                 
                  ┌─────────┐
                  │ Client  │
                  └────┬────┘
                       │
                       ▼
            ┌──────────────────────┐
            │   Pi-hole (53)       │
            │   (192.168.0.241)    │            
            └──────────┬───────────┘
                       │
                       │
                       ▼
            ┌──────────────────────┐
            │   Unbound (5335)     │
            │                      │
            └──────────┬───────────┘
                       │
                       ▼
                  pfSense (192.168.0.1)
                       │
                       ├──► sednal.lan (réseau local)
                       │
                       └──► Internet (WAN)


=== Flux de résolution DNS ===

-1. Le client envoie une requête DNS
-2. Pi-hole reçoit et transmet à Unbound
-3. Unbound analyse la requête :
     - Si sednal.lan → transfère à pfSense (résolution locale DHCP)
     - Sinon → résolution récursive sur Internet (WAN)
-4. La réponse remonte au client

---

### === Problémes ===

Impossible de résoudre ou d’effectuer des ping vers les domaines inscrits dans le résolveur DNS de pfSense (voir ci-dessous).

<img width="712" height="333" alt="image" src="https://github.com/user-attachments/assets/56b4db52-f7e6-43f3-9151-071781d51f4d" />

- === Ping ===

On voit ici que 192.168.0.241 ne peut pas pinguer les noms de domaine suivants (alors qu’ils sont bien en service), sauf s’ils sont inscrits dans le fichier `/etc/hosts`.
 
      - vault.sednal.lan
      - vault_2.sednal.lan
      - pihole.sednal.lan

- Démonstration :

<img width="726" height="349" alt="image" src="https://github.com/user-attachments/assets/3f5b1373-2671-471b-8056-152695feca53" />


- Suppression des lignes.

      -192.168.0.241   pihole.sednal.lan pihole
      -192.168.0.241   vault_2.sednal.lan vault_2

<img width="483" height="137" alt="image" src="https://github.com/user-attachments/assets/a4e84325-7461-4dd6-ab13-d217a5964e6e" />

- Flush ARP Pihole

<img width="475" height="285" alt="image" src="https://github.com/user-attachments/assets/d634b41c-1a2b-440e-a3a3-95cf5d8537b9" />

---

### === Diagnostique ===

-1. Test Ports

[ 53 ] => Pihole

      dig vault.sednal.lan @192.168.0.241 -p 53

Resultat => `NXDOMAIN` et `QUERY: 1, ANSWER: 0`

<img width="640" height="329" alt="image" src="https://github.com/user-attachments/assets/a5da0c51-ea7a-4820-a048-8688367cb10f" />

[ 5335 ] => Unbound

      dig vault.sednal.lan @192.168.0.241 -p 5335

Resultat => `NOERROR` ,`QUERY: 1, ANSWER: 1`, et `vault.sednal.lan.       3600    IN      A       192.168.0.238`

Donc probléme entre Pihole et Unbound

Confirmation ports utilisés

     sudo ss -tunlp | grep 53   

<img width="941" height="229" alt="image" src="https://github.com/user-attachments/assets/7c313cc2-eac2-47e1-bac1-58ae87ab0999" />



















      
