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
 Réaliser une doc technique afin de pouvoir palier rapidement au probléme si il se représente.






#### `Pendant la pause déjeuner, presque tout le personnel de votre entreprise est absent des locaux. Vous devez passer en urgence un correctif de sécurité. Ce correctif demande un redémarrage des ordinateurs clients. Que faites-vous ?`
J'attend le soir que tout le monde est sauvegardé son travail.






#### `Dans votre entreprise, les utilisateurs se plaignent de ne pas retrouver leurs fichiers et dossiers sur les “bureaux” des ordinateurs sur lesquels ils se connectent. Ils sont obligés de s’envoyer leurs documents par mail. Comment pouvez-vous faire évoluer cette situation ?`

Créer un dossier individuel qui sera chargé à la connection de l'utilisateur, via son login et MDP

***

#### `CCP2 - Exploiter des serveurs Windows et un domaine Active Directory`

#### `Quels sont les outils disponibles sur les serveurs Windows pour gérer les journaux d'événements ?`

* event viewer
* sysmon
* logparcer

#### `Qu'est-ce qu'une GPO ?`
Une GPO est une régle,qui permet au SI de gérer le parc informatique, administrer les utilisateur, gérer les accés, autoriser ou interdire des actions sur un PC.

#### `Est-ce une bonne pratique de partager des fichiers ou des dossiers sur un partage réseau, en mettant des permissions NTFS sur des utilisateurs ?`
Oui c'est une bonne pratique, car elle permet une gestion plus fine des droits d'accées.


#### `Si l'utilisateur jdoe existe sur un domaine Active Directory, sur une machine spécifique, utilisera-t-il le même bureau que l'utilisateur local jdoe ?`

Oui si l'AD est configuré corectement



#### `Active Directory contient-il une base de données hiérarchique ou relationnelle ? Explique avec au moins un exemple.`
Une base de donnée Hiérarchique, avec la foret, et les différents domains,OU,Groups,Users 

#### `Comment mettre en place une politique de mots de passe sur un domaine Active Directory ?`
En appliquant à une OU, des GPO en liens avec: 
* la complexité du MDP
* son renouvélement
* son changement dans le temps


#### `Qu'est-ce qu'un objet Active Directory ?`
Les objets en Active Directory, sont des objets unique gérer est administré par AD ex: user, group, imprimante, PC, etc...

#### `Est-ce une bonne pratique de supprimer un compte utilisateur le lendemain du départ d'un collaborateur d'une société ?`
Non car on peux avoir besoin de ces dossier, donnés, pour un audit, vérrifier des informations, ou récupérer des donnés.

#### `Comment gérer l'administration d'un serveur core ?`


### `CCP3 - Exploiter des serveurs Linux`

#### `Sur les systèmes Linux, avec quel utilitaire peut-on partitionner des disques durs de plus de 2 To ?`
fstab
#### `Sur un système Linux, que trouve-t'on dans les fichiers /etc/shadow, /etc/passwd, /etc/group ?`

/etc/shadow
/etc/passwd => Nom d'utilisateur et mot de passe chiffré
/etc/group => les Groups présent sur l'ordinateur


#### `Est-ce que "systemctl start" et "systemctl enable" ont le même effet ?`
Non systemctl start démart un service tandis que systemctl enable démare automatiquement au démarage.

#### `Est-ce que la commande dig sur Linux est la même chose que tracert sur Windows ?`





#### `Quelle commande permet d'afficher les 20 dernières lignes des logs du système en temps réel ?`




#### `Que fait la commande suivante : usermod -a -G admin sthomas`






#### `Un technicien a exécuté la commande suivante : chmod 777 startScript.sh . Est-ce une bonne idée ?`
Non car tout le monde aura les droit d'éxecution sur le script, sur les trois chiffres le premier représente l'utilisateur, le second les groupes, et le dernier les autres utilisateurs. C'est mieux de faire chmod 744 startScript.sh 


#### `Est-ce que mount et umount sur Linux ont la même fonctionnalité que dism mount et dism umount sur windows ?`
Non sur Linux créer un point de montage permet d'accéder au disque amovible ou non, alors que sur windows cela modifie l'image disque.


#### `A quoi sert Samba sur Linux ? Donne son équivalent sur Windows.`
Samba permet du partage de fichier, sur windows SMB

CCP4 - Exploiter un réseau IP

#### `Qu'est-ce qu'une topologie réseau ? Quels sont les 2 types de topologie ?`




#### `Donne 5 protocoles courants, avec leur nom, leur fonction, ainsi que leur port par défaut. Donne leur équivalence en mode sécurisé avec les mêmes informations.`

tcp 

udp

http 

ssh

icmp







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
GigabitInterfaces 1/2

#### `Combien y-a-t’il de vlans ?`
Trois Vlan 1/2/10

#### `Qu'est-ce qu'un trunk pour des vlans ?`
Un trunk est une configuration réseau qui permet de faire communiquer des machines appartenant au méme Vlan sur des Vlan différents, d'utiliser une interface physique pour faire communiquer plusieurs Vlan

#### `Quel est l’intérêt de faire des sous-réseaux du point de vue des tables de routage ?`
Cela permet de simplifier la table de routage, en effet si plusieur réseau sont "derière" la même Default Gateway , il est possible de regrouper les vlan corespondant sur une seul passerelle, en effet si les tables de routages sont corectement faites, les routeurs connaisent leurs voisins, et les paquets seront transmits.



#### `On a un réseau 132.45.0.0/16. On souhaite découper ce réseau en 8 sous-réseaux.`

#### `a. Combien de bits supplémentaires sont nécessaires pour définir ces 8 sous-réseaux ?`
Il faut rajouter 3 bits pour passer deu CIDR 16 à 19
car /16 permet 65536 hotes /8 = 8192 -2 = 8190 
On recherche la racine de 2 qui corespond 2^13 = 8192 
donc 32-13 = 19 pour le CIDR

#### `b. Quel est le masque correspondant ?`
19 => 255.255.224.0
#### `c. Donne l'adresse réseau de ces 8 sous-réseaux.`

1) 132.45.0.0
2) 132.45.32.0
3) 132.45.64.0
4) 132.45.128.0
5) 132.45.160.0
6) 132.45.192.0
7) 132.45.224.0
8) 132.45.255.0

#### `d. Quelle est l'adresse de diffusion du 4ème sous-réseau ?`

 132.45.128.255
 

