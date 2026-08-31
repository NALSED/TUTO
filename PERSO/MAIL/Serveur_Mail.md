# 🐋 Création d'un serveur mail via 'Docker MailServer' 🐋

---

Ici utilisation de 'Docker MailServer', pour créer un serveur de messagerie, sur un 'VPS'.

### VPS

- 'IP' : 176.31.163.227
- 'Nom domaine' : nalsed.fr
- 'Ram' : 8 Go
- 'CPU' : 4 vCore
- 'Disk' : 275 Go
- 'OS' : Debian 13

---
---

[DOCUMENTATION_OFFICIELLE](https://docker-mailserver.github.io/docker-mailserver/latest/examples/tutorials/basic-installation/)

### '-1-' Créer un enregistrement 'MX', sur le VPS.

'- 1.1' Sur [OVH](https://manager.eu.ovhcloud.com/#/hub/) Web Cloud => Noms de domaine => nalsed.fr

<img width="1066" height="286" alt="image" src="https://github.com/user-attachments/assets/807d0392-3e26-4913-9933-7cded26ba222" />

'- 1.2' Dans la section nom de domaine => 'Zone Dns' => Ajouter une entrée => MX

<img width="597" height="715" alt="image" src="https://github.com/user-attachments/assets/1a27d56f-316e-42e2-96a4-7e9b54e1ac90" />

'-1.3' Remplir les champs

Ici : 'nalsed.fr. IN MX 1 sednal.fr.'
---

### '-2-' Création du Docker compose

'- 2.1' 
