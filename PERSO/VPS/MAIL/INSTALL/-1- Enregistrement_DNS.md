[DOCUMENTATION_OFFICIELLE](https://docker-mailserver.github.io/docker-mailserver/latest/examples/tutorials/basic-installation/)

[Eric O Meehan](https://www.youtube.com/watch?v=NhoSOPGk3q0)

# `-1-` Créer un enregistrement `MX` et `A` pour la section mail, sur le VPS.

## `- 1.1` Sur [OVH](https://manager.eu.ovhcloud.com/#/hub/) Web Cloud => Noms de domaine => nalsed.fr

<img width="1066" height="286" alt="image" src="https://github.com/user-attachments/assets/807d0392-3e26-4913-9933-7cded26ba222" />

## `- 1.2` Dans la section nom de domaine => `Zone Dns` => Ajouter une entrée => MX

<img width="597" height="715" alt="image" src="https://github.com/user-attachments/assets/1a27d56f-316e-42e2-96a4-7e9b54e1ac90" />

`- 1.3` Remplir les champs

Ici : `nalsed.fr. IN MX 1 mail.nalsed.fr.`

`- 1.4` Idem pour l'entrée `A` de `DMS` et `SOGo`
Ici

- DMS : `mail.nalsed.fr. IN A 176.31.163.227`

- SOGo : `webmail.nalsed.fr. IN A 176.31.163.227`

`[NOTE]`

- Aucun enregistrement `AAAA` n'est créé : le PTR IPv6 du VPS reste générique, donc le FCrDNS échouerait côté IPv6. La sortie est forcée en IPv4 au point `- 3.7`.

`[TEST]`

<img width="543" height="114" alt="image" src="https://github.com/user-attachments/assets/5704b5f1-9c58-4d29-baf5-e60a9495e38f" />
