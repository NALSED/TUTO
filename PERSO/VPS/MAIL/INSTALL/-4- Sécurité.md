# `-4-` Gestions de la `Sécurité` des conteneurs et Services.

`[NOTE]`

## - `SOMMAIRE`

### `- 4.1` Enregistrement `PTR` sur OVH 

### `- 4.2` Pare-feu et ouverture des ports sur le VPS 

### `- 4.3` Sécuriser `SSH` et port `22`

### `- 4.4` SPF, DKIM et DMARC 

---

### `- 4.1` Enregistrement `PTR` sur OVH

- Bare Metal Cloud => Network => IP

<img width="363" height="466" alt="image" src="https://github.com/user-attachments/assets/c08b802e-77a5-4ab5-9fdc-d784aa0f8216" />

- Se rendre dans Configurer reverse DNS

<img width="1513" height="435" alt="image" src="https://github.com/user-attachments/assets/6f567437-01a2-4017-bf55-09699badd22d" />

- Changer le nom `Reverse DNS` par `mail.nalsed.fr`

`[NOTE]` 

L'enregistrement `A` du point `- 1.4` doit être propagé avant : OVH refuse un reverse dont le forward ne résout pas.

`[TEST]`
````
# Toujours interroger un résolveur public : le DNS local (pfSense) répond avant et masque le résultat réel
dig +short -x 176.31.163.227 @1.1.1.1
dig +short mail.nalsed.fr A @1.1.1.1
````



---

### `- 4.2` Pare-feu et ouverture des ports sur le VPS

- Ports volontairement **non** ouverts :
  - `5432` : le service `db` n'a aucun mapping `ports:`, il n'écoute que sur le réseau Docker interne.
  - `143` : IMAP en clair, utilisé uniquement en interne entre SOGo et DMS.

- `Pare-feu`
````
sudo iptables -I INPUT 1 -i lo -j ACCEPT
sudo iptables -I INPUT 2 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I INPUT 3 -p tcp --dport 22 -j ACCEPT
````

- `Ports`
````
ports="80 443 25 465 587 993"
for i in $ports; do
    sudo iptables -A INPUT -p tcp --dport "$i" -j ACCEPT
done
````

`[TEST]`
````
sudo iptables -L INPUT --line-numbers -n
# Vérifier que lo, ESTABLISHED,RELATED et 22 sont bien dans les trois premières lignes AVANT de basculer
````

- Bascule et persistance
````
sudo iptables -P INPUT DROP
sudo netfilter-persistent save
````

---

### `- 4.3` Sécuriser `SSH` et port `22`

`[INFO]`

- Pour se rendre compte de l'utilité de sécuriser `SSH` (4490 tentatives d'entrée en 24h !) :

<img width="871" height="41" alt="image" src="https://github.com/user-attachments/assets/b8502fef-06cd-4fc4-a69e-82546f50ac13" />

````
sudo journalctl -u ssh --since "24 hours ago" | grep -c "Failed password"
````

- Créer un fichier de configuration prioritaire sur celui d'OVH (`50-cloud-init.conf`, qui contient `PasswordAuthentication yes`).


⚠️ L'authentification par mot de passe ne sera plus possible après, penser à gérer un mode d'authentification, ici clé SSH. Vérifier au préalable que la connexion par clé fonctionne
````
sudo vim /etc/ssh/sshd_config.d/00-HardeningSSH.conf

# Editer
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
PubkeyAuthentication yes
````

- Vérification
````
sudo sshd -t
sudo systemctl restart ssh
````

---

### `- 4.4` SPF, DKIM et DMARC

`[INFO]`

- Ces protocoles ont pour but d'assurer que la personne qui envoie le mail y est autorisée, et que le message envoyé n'est pas corrompu.
En effet, à sa création en 1982, SMTP n'a aucune notion d'authentification de l'expéditeur.
SPF valide l'enveloppe (`MAIL FROM`), DKIM signe le message et couvre l'en-tête `From:`. DMARC vérifie que le domaine validé correspond bien à celui affiché au destinataire.

- Pour ce faire, mise en place de :

### - `SPF`
- Sender Policy Framework : publie dans le DNS (ici OVH) la liste des IP autorisées à émettre pour le domaine (nalsed.fr).
- Enregistrement `TXT` listant les émetteurs autorisés. Le mécanisme `mx` autorise les IP des serveurs déclarés en MX du domaine.

### - `DKIM`
(Sera implémenté plus tard en `-5-`, la clé étant générée par rspamd dans le conteneur)
- DomainKeys Identified Mail : le serveur signe chaque message sortant avec une clé privée, et publie la clé publique dans le DNS.
- La signature couvre le corps du message et une sélection d'en-têtes, dont `From:`. Elle survit aux transferts, contrairement à SPF.

### - `DMARC`
- Domain-based Message Authentication, Reporting and Conformance : c'est la politique qui relie le tout. SPF et DKIM produisent chacun un verdict mais ne disent pas quoi en faire.
- Un message passe DMARC si au moins un des deux est à la fois valide et **aligné** avec le domaine du `From:`.

---

### SPF

- Enregistrement `SPF` sur DNS OVH => Web Cloud => Noms de domaine => nalsed.fr => Zone Dns

Ici : `nalsed.fr. IN TXT "v=spf1 mx ~all"`, avec autorisation des serveurs `MX` et sous-domaine `@`.

### DMARC

- Enregistrement `DMARC` sur DNS OVH => Web Cloud => Noms de domaine => nalsed.fr => Zone Dns

Ici : `_dmarc.nalsed.fr. IN TXT "v=DMARC1; p=none; rua=mailto:dmarcnalsed@proton.me; sp=none; aspf=r"`


`[TEST]`
````
dig +short @1.1.1.1 _dmarc.nalsed.fr TXT
````
<img width="637" height="42" alt="image" src="https://github.com/user-attachments/assets/33206721-9cfd-4da7-ac7d-6868359bbfd9" />

