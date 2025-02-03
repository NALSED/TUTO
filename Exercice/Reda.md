## Activité 1 : Exploiter les éléments de l’infrastructure et assurer le support aux utilisateurs

#### 4 compétences types :
#### Assurer le support utilisateur en centre de services
#### Exploiter des serveurs Windows et un domaine Active Directory
#### Exploiter des serveurs Linux
#### Exploiter un réseau IP


#### Durée : 2h


### `CCP1 - Assurer le support utilisateur en centre de service`

#### `De nouvelles stations de travail viennent d’être acquises par une entreprise. Cependant les disques sont de capacités insuffisantes. On souhaiterait les remplacer par des disques de 4 To minimum. Quelles sont les précautions et vérifications à prendre avant d’installer le système pour que ces derniers puissent être reconnus ?`

#### Vérifier le formatage des disque en fontiond des Os à installer



#### `Citer différents logiciels permettant de prendre le contrôle à distance d’un équipement numérique et préciser leurs caractéristiques.`

#### RDP: Bureau à distance, permet de prendre la main sur un ordinateur, avvec son interface visuel
#### ssh wirrm?




#### `Rédiger une note de service sous forme d’un email à destination des utilisateurs de votre entreprise les prévenant d’une opération de maintenance du service SI sur la base de données du serveur d’applications de l’entreprise (pendant cette période, la base de données ne sera pas accessible).`
Bonjour, 
durant 24 h du 12.01.25 au 13.12.25, le service de stockage/sauvegardes ne sera pas disponible, nous vous invvitons à télécharger les documents sur lesquels vous travaillé actuelement et à les stocker en physique sur votre machine.
Veulliez nous excuser pour la gêne occasionés


#### `Vous devez former les utilisateurs à l’utilisation d’une solution de stockage de fichiers en ligne. Quels sont les points que vous évoquez dans votre document de présentation ?`





#### `Quelle procédure est à réaliser pour récupérer un fichier supprimé par un utilisateur sur son ordinateur professionnel ?`





#### `Un utilisateur ne peut pas consulter sa messagerie sur son smartphone professionnel. De quels renseignements avez-vous besoin pour lui configurer ?`
Son adresse mail, numéro de téléphone, nom prénom





#### `Après différents tests, vous venez de résoudre un problème remonté par un utilisateur sur son poste de travail. Que devez-vous faire après avoir trouvé cette solution technique ?`
#### Réaliser une doc technique afin de pouvoir palier rapidement au probléme si il se représente.






#### `Pendant la pause déjeuner, presque tout le personnel de votre entreprise est absent des locaux. Vous devez passer en urgence un correctif de sécurité. Ce correctif demande un redémarrage des ordinateurs clients. Que faites-vous ?`
#### J'attend le soir que tout le monde est sauvegardé son travail.






#### `Dans votre entreprise, les utilisateurs se plaignent de ne pas retrouver leurs fichiers et dossiers sur les “bureaux” des ordinateurs sur lesquels ils se connectent. Ils sont obligés de s’envoyer leurs documents par mail. Comment pouvez-vous faire évoluer cette situation ?`
#### Créer un dossier undivviduel qui sera chargé à la connection de l'utilisateur, via son login et MDP

***

#### `CCP2 - Exploiter des serveurs Windows et un domaine Active Directory`

#### `Quels sont les outils disponibles sur les serveurs Windows pour gérer les journaux d'événements ?`




#### `Qu'est-ce qu'une GPO ?`

#### `Est-ce une bonne pratique de partager des fichiers ou des dossiers sur un partage réseau, en mettant des permissions NTFS sur des utilisateurs ?`

#### `Si l'utilisateur jdoe existe sur un domaine Active Directory, sur une machine spécifique, utilisera-t-il le même bureau que l'utilisateur local jdoe ?`

#### `Active Directory contient-il une base de données hiérarchique ou relationnelle ? Explique avec au moins un exemple.`

#### `Comment mettre en place une politique de mots de passe sur un domaine Active Directory ?`

#### `Qu'est-ce qu'un objet Active Directory ?`

#### `Est-ce une bonne pratique de supprimer un compte utilisateur le lendemain du départ d'un collaborateur d'une société ?`

#### `Comment gérer l'administration d'un serveur core ?`


### `CCP3 - Exploiter des serveurs Linux`

#### `Sur les systèmes Linux, avec quel utilitaire peut-on partitionner des disques durs de plus de 2 To ?`

#### `Sur un système Linux, que trouve-t'on dans les fichiers /etc/shadow, /etc/passwd, /etc/group ?`

#### `Est-ce que "systemctl start" et "systemctl enable" ont le même effet ?`

#### `Est-ce que la commande dig sur Linux est la même chose que tracert sur Windows ?`

#### `Quelle commande permet d'afficher les 20 dernières lignes des logs du système en temps réel ?`

#### `Que fait la commande suivante : usermod -a -G admin sthomas`

#### `Un technicien a exécuté la commande suivante : chmod 777 startScript.sh . Est-ce une bonne idée ?`

#### `Est-ce que mount et umount sur Linux ont la même fonctionnalité que dism mount et dism umount sur windows ?`

#### `A quoi sert Samba sur Linux ? Donne son équivalent sur Windows.`


CCP4 - Exploiter un réseau IP

#### `Qu'est-ce qu'une topologie réseau ? Quels sont les 2 types de topologie ?`

#### `Donne 5 protocoles courants, avec leur nom, leur fonction, ainsi que leur port par défaut. Donne leur équivalence en mode sécurisé avec les mêmes informations.`

#### `Pour les lignes de commandes suivantes :`


VLAN Name                              Status      Ports
----      -------------------------------- ---------     -------------------------------
1         default                             active      Gi0/1, Gi0/2, Gi0/3, Gi2/0
                                                                  Gi2/1, Gi2/2, Gi2/3, Gi3/0
                                                                  Gi3/1, Gi3/2, Gi3/3
2         DSI                                 active       Gi0/0
10       FINANCES                     active       Gi1/0, Gi1/1, Gi1/2, Gi1/3
1002   fddi-default                     act/unsup 
1003   token-ring-default           act/unsup 
1004   fddinet-default                act/unsup 
1005   trnet-default                    act/unsup

#### `Que peut-on dire des interfaces Gi0/3, Gi1/2, Gi1/3 ?`
#### `Combien y-a-t’il de vlans ?`

#### `Qu'est-ce qu'un trunk pour des vlans ?`

#### `Quel est l’intérêt de faire des sous-réseaux du point de vue des tables de routage ?`

#### `On a un réseau 132.45.0.0/16. On souhaite découper ce réseau en 8 sous-réseaux.`
#### `a. Combien de bits supplémentaires sont nécessaires pour définir ces 8 sous-réseaux ?`
#### `b. Quel est le masque correspondant ?`
#### `c. Donne l'adresse réseau de ces 8 sous-réseaux.`
#### `d. Quelle est l'adresse de diffusion du 4ème sous-réseau ?`



