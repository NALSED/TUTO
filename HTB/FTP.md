

# `Connection à un ordinateur via FTP`

> Le FTP est une méthode simple pour transférer des fichiers entre ordinateurs sur un réseau ; il s'agit d'un service de messagerie numérique. Il permet de télécharger des fichiers vers un ordinateur distant (comme l'envoi de colis) ou d'en télécharger depuis celui-ci (comme la réception de colis). Étant l'une des méthodes les plus anciennes et les plus simples de partage de fichiers sur Internet, le FTP sert de passerelle entre deux ordinateurs pour le transfert de données. Cependant, il est important de noter que, dans sa forme la plus simple, le FTP transmet les données sans chiffrement, ce qui le rend inadapté au transfert sécurisé de fichiers sensibles.
> Lors de la recherche via Nmap un prtocol FTP Anonymous à été découvert (créer par l'admin pour les gens de passage ou le public), pour des raison de facilité, mais mauvaise pratique.



---

## 1️⃣ `Connection`
## 2️⃣ `recueille d'info`
## 3️⃣ ``
## 4️⃣ ``
## 5️⃣ ``
## 6️⃣ ``
## 7️⃣ ``
## 8️⃣ ``
## 9️⃣ ``



---
---

## 1️⃣  🖥️ `Connection`

###  La connection se fera via l'IP et le num de port. 

![image](https://github.com/user-attachments/assets/1507e202-f17f-4cd9-bcf2-a8fe47431295)

### Le service FTP nous demandera un nom d'utilisateur et un mot de passe, qui sont par défaut anonymous // whatever

---

## 2️⃣ `recueille d'info`

### Avec la commande `ls` répertorier tous les fichiers visibles dans le répertoire par défaut configuré pour le service FTP

![image](https://github.com/user-attachments/assets/b683a4d9-991e-441a-96b4-535d42905b67)

### Avec commande ls -al => répertorie  les fichiers visibles, et les fichiers et répertoires cachés.

![image](https://github.com/user-attachments/assets/8efb9290-0633-4c06-8e58-380832a27eb1)

### :heavy_exclamation_mark: fichiers intéréssant : 

> * .bash_history(ce qui peut révéler l'existence de certains programmes, fichiers, répertoires, accès, etc.). 

> * .ssh

### Récap (fictif)

> * Accès et environnement

> * L'accès FTP anonyme a été activé sur le port 21

> * Nous avons identifié ceci comme un répertoire personnel pour l'utilisateurjohn

> * Plusieurs fichiers de configuration et d'historique importants étaient accessibles

> * .bash_historyle fichier a révélé des informations d'identification potentielles :john:SuperSecurePass123

> * La clé privée SSH ( id_rsa) a été obtenue et n'est pas protégée par mot de passe

> * La documentation de configuration de WordPress a révélé une configuration FTP temporaire











---

## 3️⃣ ``

---

## 4️⃣ ``

---

## 5️⃣ ``

---

## 6️⃣ ``

---

## 7️⃣ ``

---

## 8️⃣ ``

---

## 9️⃣ ``



