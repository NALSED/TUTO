# Proposition de solution pour `résolution de nom de domain en local` avec pihole + unbound + pfsense

---
### === Contexte ===

Le probléme est survenu longtemps après la mise ne place de pihole et unbound.

En effet dans cette infra, pihole est utilisé pour bloquer les publicitées, et Unbound comme DNS récursif primaire.

Le bloquage de publicité ainsi que la résolution WAN fonctionait parfaitement pour la configuration voir [ICI : Pihole] et (https://github.com/NALSED/TUTO/blob/main/PERSO/DNS/Pihole.md) [ICI: unbound](https://github.com/NALSED/TUTO/blob/main/PERSO/DNS/unbound.md) .

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
            └──────┬───────┬───────┘
                   |       │
                   |       ▼
                   |    pfSense (192.168.0.1)
                   |       │
                   |       └──► sednal.lan (réseau local)
                   │
                   └──► Internet (WAN)


=== Flux de résolution DNS ===

-1. Le client envoie une requête DNS
-2. Pi-hole reçoit et transmet à Unbound
-3. Unbound analyse la requête :
     - Si sednal.lan → transfère à pfSense (résolution locale DHCP)
     - Sinon → résolution récursive sur Internet (WAN)
-4. La réponse remonte au client via pfsense => unbound

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

[DOC_PIHOLE](https://docs.pi-hole.net/ftldns/configfile/)

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

La connection ne se fait pas entre `Pihole` et `Unbound`, loption forward vers pfsense, à la fin du finchier de configuration + des incohérence su celui de pihole doivent bloquer la connestion.


<details>
<summary>
<h2>

  === Liste causes probable PiHole ===
 
</h2>
</summary>

## Dans le fichier de configuration `/etc/pihole/pihole.toml`

        liste probleme potentiel

        ---------------
        ---------------
        
        
        - Niveau probable : TOP 
        
        
        
        existant :
        
        
        
         # Reverse server (former also called "conditional forwarding") feature
          # Array of reverse servers each one in one of the following forms:
          # "<enabled>,<ip-address>[/<prefix-len>],<server>[#<port>][,<domain>]"
          #
          # Individual components:
          #
          # <enabled>: either "true" or "false"
          #
          # <ip-address>[/<prefix-len>]: Address range for the reverse server feature in CIDR
          # notation. If the prefix length is omitted, either 32 (IPv4) or 128 (IPv6) are
          # substituted (exact address match). This is almost certainly not what you want here.
          # Example: "192.168.0.0/24" for the range 192.168.0.1 - 192.168.0.255
          #
          # <server>[#<port>]: Target server to be used for the reverse server feature
          # Example: "192.168.0.1#53"
          #
          # <domain>: Domain used for the reverse server feature (e.g., "fritz.box")
          # Example: "fritz.box"
          #
          # Possible values are:
          #     array of reverse servers each one in one of the following forms:
          #     "<enabled>,<ip-address>[/<prefix-len>],<server>[#<port>][,<domain>]", e.g.,
          #     "true,192.168.0.0/24,192.168.0.1,fritz.box"
          revServers = [
            "true,192.168.0.241/24,192.168.0.1,pihole.lan"
          ] ### CHANGED, default = []
        
        
        changement :
        
         # Reverse server (former also called "conditional forwarding") feature
          # Array of reverse servers each one in one of the following forms:
          # "<enabled>,<ip-address>[/<prefix-len>],<server>[#<port>][,<domain>]"
          #
          # Individual components:
          #
          # <enabled>: either "true" or "false"
          #
          # <ip-address>[/<prefix-len>]: Address range for the reverse server feature in CIDR
          # notation. If the prefix length is omitted, either 32 (IPv4) or 128 (IPv6) are
          # substituted (exact address match). This is almost certainly not what you want here.
          # Example: "192.168.0.0/24" for the range 192.168.0.1 - 192.168.0.255
          #
          # <server>[#<port>]: Target server to be used for the reverse server feature
          # Example: "192.168.0.1#53"
          #
          # <domain>: Domain used for the reverse server feature (e.g., "fritz.box")
          # Example: "fritz.box"
          #
          # Possible values are:
          #     array of reverse servers each one in one of the following forms:
          #     "<enabled>,<ip-address>[/<prefix-len>],<server>[#<port>][,<domain>]", e.g.,
          #     "true,192.168.0.0/24,192.168.0.1,fritz.box"
          revServers = [
            "true,192.168.0.0,192.168.0.1#53,sednal.lan"
          ] ### CHANGED, default = []
        
        
        ---------------
        ---------------
         
        - Niveau probable : +++++
        
        existant :
        
        # List of upstream DNS server
        server=127.0.0.1#5335
        
        changement :
        
        # List of upstream DNS server
        server=192.168.0.1
        
        changer configuration unbound voir claude
        
        
        ---------------
        ---------------
        
        - Niveau probable : +++
        
        existant :
         piholePTR = "PI.HOLE"
        
        changement :
         piholePTR = "HOSTNAMEFQDN"
        
        # Controls whether and how FTL will reply with for address for which a local interface
          # exists. Changing this setting causes FTL to restart.
          #
          # Possible values are:
          #   - "NONE"
          #       Pi-hole will not respond automatically on PTR requests to local interface
          #       addresses. Ensure pi.hole and/or hostname records exist elsewhere.
          #   - "HOSTNAME"
          #       Serve the machine's hostname. The hostname is queried from the kernel through
          #       uname(2)->nodename. If the machine has multiple network interfaces, it can
          #       also have multiple nodenames. In this case, it is unspecified and up to the
          #       kernel which one will be returned. On Linux, the returned string is what has
          #       been set using sethostname(2) which is typically what has been set in
          #       /etc/hostname.
          #   - "HOSTNAMEFQDN"
          #       Serve the machine's hostname (see limitations above) as fully qualified domain
          #       by adding the local domain. If no local domain has been defined (config option
          #       dns.domain), FTL tries to query the domain name from the kernel using
          #       getdomainname(2). If this fails, FTL appends ".no_fqdn_available" to the
          #       hostname.
          #   - "PI.HOLE"
          #       Respond with "pi.hole".
          piholePTR = "PI.HOLE"
        
        ----------
        ----------
        
        - Niveau probable : ++
        
        existant :
        
          hosts = []
        
        changement :
        
          hosts = ["192.168.0.238 vault", "192.168.0.240 bareos"] etc …
        
        
        
         # Array of custom DNS records
          # Example: hosts = [ "127.0.0.1 mylocal", "192.168.0.1 therouter" ]
          #
          # Possible values are:
          #     Array of custom DNS records each one in HOSTS form: "IP HOSTNAME"
          hosts = []
        
        
        ---------------
        ---------------
        
        - Niveau probable : a voire
         
        Pour que seul pfsense gére ça 
        
        existant :
        
        [resolver]
          # Should FTL try to resolve IPv4 addresses to hostnames?
          resolveIPv4 = true
        
          # Should FTL try to resolve IPv6 addresses to hostnames?
          resolveIPv6 = true
        
        changement :
        
        [resolver]
          # Should FTL try to resolve IPv4 addresses to hostnames?
          resolveIPv4 = false
        
          # Should FTL try to resolve IPv6 addresses to hostnames?
          resolveIPv6 = false
        
        +++++++++++++++++++
        +++++++++++++++++++
        
        
        Vérifier si ### commente ou pas 
        
        [webserver]
          # On which domain is the web interface served?
          #
          # Possible values are:
          #     <valid domain>
          domain = "pihole.sednal.lan" ### CHANGED, default = "pi.hole"
        














</details>

















### === SOLUTIONS ===











      
