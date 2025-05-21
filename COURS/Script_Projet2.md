

#!/bin/bash


# Définir les couleurs dans les variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\e[1;31m'
BLUE='\033[0;34m'
NC='\033[0m' # Aucune couleur
Continue="yes" # Variable de boucle du script

# i et j petites variables pour les "cases"
i=0
j=0

# Fonction qui vérifie si l'adresse IP est au bon format pour les connections SSH
function validate_ip() {
    local ip="$1"
   
    # Vérifie le format de l'adresse IP
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then		
        IFS='.' read -r i1 i2 i3 i4 <<< "$ip"
        
        # Vérifie que chaque octet est compris entre 0 et 255
        if [[ $i1 -le 255 && $i2 -le 255 && $i3 -le 255 && $i4 -le 255 ]]; then
            return 0  # IP valide
        fi
    fi
    return 1  # IP invalide
}


FORMATTED_DATE=$(date +'%Y%m%d') # Formatage de la date en YYYYMMDD
FORMATTED_TIME=$(date +'%T') # Formatage de l'heure en HH:MM:SS
choice=0
target="" # Cible pour les informations. Elle peut être un utilisateur ou un ordinateur



# Lancement du script, on envoie l'information dans le fichier log
echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-${GREEN}********StartScript********${NC}" >> /var/log/log_evt.log


function menu
{
    # Menu selection multiple


	echo -e "${PINK}   __      ___ _    _    ___         _       ___     _             _ ${NC}"
	echo -e "${PINK}   \ \    / (_) |__| |  / __|___  __| |___  / __| __| |_  ___  ___| |${NC}"
	echo -e "${PINK}    \ \/\/ /| | / _' | | (__/ _ \/ _``  / -_) \__ \/ _| ' \/ _ \/ _ \ |${NC}"
	echo -e "${PINK}     \_/\_/ |_|_\__,_|  \___\___/\__,_\___| |___/\__|_||_\___/\___/_|${NC}"
	echo -e "${PINK}                                                                    ${NC}"

	# Menu principal
	echo -e "${BLUE}Menu Principal : ${NC}"
	echo -e "[1] ${YELLOW}Utilisateur${NC}"
	echo -e "[2] ${YELLOW}Ordinateur client${NC}"
	read MainMenu

	case $MainMenu in
		# Menu UTILISATEUR / Choix entre ACTION ou INFORMATION
		1)
			
			echo -e "\n${BLUE}Quelle action utilisateur souhaitez vous réaliser ?\n"
			echo -e "${BLUE}PARTIE ACTION${NC}"
			echo -e "[1] ${YELLOW}Créer un compte utilisateur local${NC}"
			echo -e "[2] ${YELLOW}Changer de mot de passe${NC}"
			echo -e "[3] ${YELLOW}Supprimer le compte utilisateur${NC}"
			echo -e "[4] ${YELLOW}Désactiver le compte utilisateur${NC}"
			echo -e "[5] ${YELLOW}Ajouter un utilisateur à un groupe d'administration${NC}"
			echo -e "[6] ${YELLOW}Ajouter un utilisateur à un groupe local${NC}"
			echo -e "[7] ${YELLOW}Retirer un utilisateur d'un groupe local${NC}\n"

			echo -e "${BLUE}PARTIE INFORMATION${NC}"
			echo -e "[8] ${YELLOW}Date de dernière connexion de l'utilisateur${NC}"
			echo -e "[9] ${YELLOW}Date de dernière modification du mot de passe${NC}"
			echo -e "[10] ${YELLOW}Liste des sessions ouvertes par l'utilisateur${NC}"
			echo -e "[11] ${YELLOW}Groupe d'appartenance d'un utilisateur${NC}"
			echo -e "[12] ${YELLOW}Historique des commandes exécutées par l'utilisateur${NC}"
			echo -e "[13] ${YELLOW}Droits/permissions de l’utilisateur sur un dossier${NC}"
			echo -e "[14] ${YELLOW}Droits/permissions de l’utilisateur sur un fichier${NC}\n"
			echo -e "${BLUE}Rentrez le ou les chiffres correspondant(s) :${NC}"
			read -a choice

			# On vérifie chaque choix rentré dans le tableau
			for i in "${choice[@]}"
    		do
						case $i in
							
							# Créer un nouveau compte utilisateur
							1 )
								echo -e "[1] ${GREEN}Créer un compte utilisateur local${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[1] Créer un compte utilisateur local" >> /var/log/log_evt.log

								
								echo -e "\n${BLUE}Nous allons créer un compte utilisateur${NC}"
								echo -e "${BLUE}Comment souhaitez vous nommer ce nouveau compte utilisateur ?${NC}"
								read UserAccountName # Nom du nouveau compte utilisateur
								
								# On demande à l'utilisateur si il veut conserver ce nom de compte
								echo -e "Souhaitez vous conserver ${YELLOW}$UserAccountName${NC} comme nouveau compte ?"
								echo -e "Tappez ${GREEN}[yes]${NC} pour valider, ou ${RED}[no]${NC} pour annuler"
								read choice
								
								# Si utilisateur valide, le compte est créé.
								if [[ $choice = "yes" || $choice = "YES" ]]
								then

									# On vérifie que le compte utilisateur existe
									cat /etc/passwd	| grep -q "^$UserAccountName:"
									# Si il n'existe pas, la condition suivante devrait avoir 1 en entrée et donc on peut le créer
									if [ $? -ne 0 ]
									then
										sudo useradd $UserAccountName 
										sudo passwd $UserAccountName
										# Si la création du nouveau compte a fonctionné on prévient l'utilisateur
										if [ $? -eq 0 ]
										then
											echo -e "Le compte ${YELLOW}$UserAccountName${NC} a bien été créé"
										# Sinon il n'a pas été créé. On averti et on sort du programme
										else
											echo -e "${RED}Le compte n'a pas pu être créé${NC}"
										
										fi
									# La commande renvoie 0, donc le compte existe
									else
										echo "Le compte existe déjà"										
									fi


								# Si Utilisateur ne souhaite pas créer le compte il est prévenu et le programme ferme
								elif [[ $choice = "no" || $choice = "NO" ]]
								then
									echo -e "${BLUE}Vous ne souhaitez pas créer le nouveau compte $UserAccountName.\nLe programme va fermer${NC}"
								

								# Fermeture en cas d'erreur
								else
									echo -e "${RED}Il y a eu un problème${NC}"
								
								fi ;;

							# Utilisateur souhaite changer son mot de passe
							2 )
								echo -e "[2] ${GREEN}Changement de mot de passe d'un compte utilisateur${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[2] Changement de mot de passe d'un compte utilisateur" >> /var/log/log_evt.log


								read -p "$(echo -e '\n\033[34mVous souhaitez changer le mot de passe de quel compte utilisateur ? \033[0m')" UserAccountName
								# Confirmation de changer le mot de passe
								echo -e "${BLUE}Etes-vous sûr de vouloir changer le mot de passe de :${NC} ${YELLOW}$UserAccountName ?${NC}"
								echo -e "Tappez ${GREEN}[yes]${NC} pour valider, ou ${RED}[no]${NC} pour annuler"
								read choice

								# Si l'utilisateur valide
								if [[ $choice = "yes" || $choice = "YES" ]]
								then
									# On vérifie que l'utilisateur existe
									cat /etc/passwd	| grep -q "^$UserAccountName:"
									# Si il existe, la condition suivante devrait avoir 0 en entrée et donc on peut modifier le mot de passe
									if [ $? -eq 0 ]
									then
									# On execute la commande du changement de mot de passe
									sudo passwd $UserAccountName
									echo -e "Le mot de passe de ${YELLOW}$UserAccountName${NC} a bien été modifié"
									# Si le nom n'existe pas, utilisateur est averti et le programme ferme
									else
									echo -e "${RED}L'utilisateur n'existe pas${NC}"
									fi

								# Si Utilisateur ne souhaite pas modifier le mot de passe il est prévenu et le programme ferme
								elif [[ $choice = "no" || $choice = "NO" ]]
								then
									echo -e "${RED}Vous ne souhaitez pas modifier le mot de passe du compte $UserAccountName.\nLe programme va fermer${NC}"
									
								# Si bug, il est prévenu et le programme ferme
								else
									echo "Il y a eu un problème"
								fi ;;


								
							
							# Utilisateur souhaite supprimer compte utilisateur
							3 )
								echo -e "[3] ${GREEN}Suppression de compte utilisateur${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[3] Suppression de compte utilisateur" >> /var/log/log_evt.log


								# On rentre le nom du compte à supprimer
								read -p "$(echo -e '\n\033[34mQuel compte souhaitez vous supprimer ? \033[0m')" UserAccountName
								echo -e "${BLUE}Etes-vous sûr de vouloir supprimer${NC} ${YELLOW}$UserAccountName${NC} ?"
								echo -e "Tappez ${GREEN}[yes]${NC} pour valider, ou ${RED}[no]${NC} pour annuler"
								read choice

								# Si l'utilisateur valide
								if [[ $choice = "yes" || $choice = "YES" ]]
								then
									# On vérifie que le compte utilisateur existe
									cat /etc/passwd	| grep -q "^$UserAccountName:"
									# Si il existe, la condition suivante devrait avoir 0 en entrée et donc on peut le supprimer
									if [ $? -eq 0 ]
									then
										# Suppression du compte utilisateur			
										sudo deluser $UserAccountName
										# On vérifie que la suppression a bien marché
										if [ $? -eq 0 ]
										then
											echo -e "Le compte ${YELLOW}$UserAccountName${NC} a bien été supprimé"
										# Sinon il n'a pas été supprimé. On averti et on sort du programme
										else
											echo -e "${RED}Le compte n'a pas été supprimé${NC}"
										fi
									# La commande renvoie 1, donc le compte n'existe pas
									else
										echo -e "${RED}Le compte n'existe pas. Le programme va fermer${NC}"
									fi

								# Si Utilisateur ne souhaite pas créer le compte il est prévenu et le programme ferme
								elif [[ $choice = "no" || $choice = "NO" ]]
								then
									echo -e "${RED}Vous ne souhaitez pas supprimer le compte ${YELLOW}$UserAccountName${NC}.\nLe programme va fermer${NC}"
								
									# Fermeture en cas d'erreur
								else
									echo -e "${RED}Il y a eu un problème${NC}"
								fi ;;

							# Utilisateur souhaite désactiver un compte utilisateur
							4 )
								echo -e "[4] ${GREEN}Désactivation de compte utilisateur${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[4] Désactivation de compte utilisateur" >> /var/log/log_evt.log


								# On rentre le nom de compte à désactiver
								read -p "$(echo -e '\033[34mQuel est le nom de compte que vous souhaitez désactiver ? \033[0m')" UserAccountName
								echo -e "${BLUE}Etes-vous sûr de vouloir désactiver le compte${NC} ${YELLOW}$UserAccountName${NC} ?"
								echo -e "Tappez ${GREEN}[yes]${NC} pour valider, ou ${RED}[no]${NC} pour annuler"		
								read choice

								# Si l'utilisateur valide
								if [[ $choice = "yes" || $choice = "YES" ]]
								then
									# On vérifie que le compte utilisateur existe
									cat /etc/passwd	| grep -q "^$UserAccountName:"
									# Si il existe, la condition suivante devrait avoir 0 en entrée et donc on peut le désactiver
									if [ $? -eq 0 ]
									then
										# Désactivation du compte utilisateur. L'option -L le désactive. Option -U pour déverouiller			
										sudo usermod -L $UserAccountName
										# On vérifie que la désactivation a bien marché
										if [ $? -eq 0 ]
										then
											echo -e "${GREEN}Le compte $UserAccountName a bien été désactivé${NC}"
										# Sinon il n'a pas été désactivé. On averti et on sort du programme
										else
											echo -e "${RED}La désactivation n'a pas fonctionné${NC}"
										fi
									# La commande renvoie 1, donc le compte n'existe pas
									else
										echo -e "${RED}Le compte n'existe pas${NC}"
									fi

									# Si Utilisateur ne souhaite pas créer le compte il est prévenu et le programme ferme
								elif [[ $choice = "no" || $choice = "NO" ]]
								then
									echo -e "${RED}Vous ne souhaitez pas désactiver le compte ${YELLOW}$UserAccountName${NC}.\nLe programme va fermer${NC}"
									# Fermeture en cas d'erreur
								else
									echo -e "${RED}Il y a un eu un problème${NC}"
									
								fi ;;
							# Ajouter un utilisateur à un groupe d'administration
							5)
								echo -e "[5] ${GREEN}Ajouter un utilisateur à un groupe d'administration${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[5] Ajouter un utilisateur à un groupe d'administration" >> /var/log/log_evt.log


								# Fonction qui va mettre dans une liste les noms d'utilisateurs
								function list() {
									ls /home
								}

								echo -e "${BLUE}Liste des utilisateurs : ${NC}"
								list
								echo
								read -p "$(echo -e '\033[34mSur quel utilisateur voulez-vous agir ? \033[0m')" user

								if ! list | grep -qw "$user"; then
									echo -e "${RED}L'utilisateur '$user' n'existe pas.${NC}"									
								else
									read -p "Souhaitez-vous ajouter $user au groupe d'administration ?(y/n)" choix

								
									case $choix in
										y)
											sudo usermod -aG sudo "$user"
											echo -e "${GREEN}$user ajouté au groupe d'administration avec succès.${NC}"
											;;
								
										n)
											echo -e "${RED}Fin du script${NC}"
											exit 0
											;;
									esac
								fi
								;;
							# Ajouter un utilisateur à un groupe local
							6) 
								echo -e "[6] ${GREEN}Ajouter un utilisateur à un groupe local${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[6] Ajouter un utilisateur à un groupe local" >> /var/log/log_evt.log

								# Fonction qui va mettre dans une liste les noms d'utilisateurs
								function list() {
									ls /home
								}

								echo -e "${YELLOW}Liste des utilisateurs : ${NC}"
								list
								echo
								read -p "$(echo -e '\033[34mSur quel utilisateur voulez-vous agir ? \033[0m')" user

								if ! list | grep -qw "$user";
								then
									echo -e "${RED}L'utilisateur '$user' n'existe pas.${NC}"									
								else
									echo -e "${BLUE}A quel groupe local voulez-vous ajouter $user ? ${NC}"

									# Fonction qui va mettre dans une liste les noms des groupes d'utilisateur
									function groupList() {
									cut -d: -f1 /etc/group | sort | column
									}
													
									echo -e "${YELLOW}Liste des groupes :${NC}"
									groupList
									read -p "$(echo -e '\033[34mÀ quel groupe voulez-vous ajouter $user : \033[0m')" group
									if ! groupList | grep -qw "$group";
									then
										echo -e "${RED}Le groupe '$group' n'existe pas.${NC}"
									else
										sudo usermod -aG "$group" "$user"
										echo "${GREEN}$user ajouté au groupe $group avec succès.${NC}"
									fi
								fi
								;;
							# Retirer un utilisateur d'un groupe local
							7)
								echo -e "[7] ${GREEN}Retirer un utilisateur d'un groupe local${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[7] Retirer un utilisateur d'un groupe local" >> /var/log/log_evt.log

								
								# Fonction qui va mettre dans une liste les noms d'utilisateurs
								function list() {
									ls /home
								}

								echo -e "${YELLOW}Liste des utilisateurs : ${NC}"
								list
								echo
								read -p "$(echo -e '\033[34mSur quel utilisateur voulez-vous agir ? \033[0m')" user

								if ! list | grep -qw "$user";
								then
									echo -e "${RED}L'utilisateur '$user' n'existe pas.${NC}"									
								else
									echo "${YELLOW}Liste de(s) groupe(s) de $user : ${NC}"

									# Fonction qui va mettre dans une liste les noms des groupes de l'utilisateur sélectionné
									function groupList() {
									groups "$user"
									}				

									groupList
									echo
									read -p "$(echo -e '\033[34mQuel groupe voulez-vous retirer à $user : \033[0m')" group
									if ! groupList | grep -qw "$group";
									then
										echo -e "${RED}Le groupe '$group' n'existe pas.${NC}"
									else
										sudo gpasswd -d "$user" "$group"
										echo "${GREEN}$user retiré du groupe $group avec succès.${NC}"
									fi
								fi
								;;
							# Date de dernière connexion de l'utilisateur
							8) 
								echo -e "\n[8] ${GREEN}Date de dernière connexion de l'utilisateur ${NC}"
                                echo
								echo -e "${BLUE}Pour quel utilisateur voudriez vous connaître la dernière connexion ? ${NC}"
								read target

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[8] Date de dernière connexion de l'utilisateur" >> /var/log/log_evt.log


								# On vérifie que la cible existe bien
								cat /etc/passwd | grep -q "^$target:"
								# Si elle existe on execute le script  

								
								if [ $? -eq 0 ]
								then                
									# On compte le nombre d'éléments dans le tableau
									# Si il n'y en a qu'un on l'affiche
									if [ ${#choice[@]} -eq 1 ]
									then
									# On affiche le résultat de la commande à l'écran.
									# Les backticks servent à executer la commande, pendant que les "" l'affichent.
									echo -e "\n* ${GREEN}Date de dernière connexion de $target :\n`last $target`${NC}"
									fi
								# On copie dans le fichier info
								echo -e "\n* Date de dernière connexion de l'utilisateur $target\n`last $target`" >> ~/Documents/"info_"$target"_"$FORMATTED_DATE".txt"


								# Si elle n'existe pas on avertit et on quitte le programme
								else
									echo "${RED}La cible n'existe pas le programme va s'arrêter${NC}"									
								fi
								;;
							# Date de dernière modification du mot de passe
							9)
								echo -e "\n[9] ${GREEN}Date de dernière modification du mot de passe${NC}"
                                echo 
								echo -n "$(echo -e '\033[34mPour quel utilisateur voudriez vous connaître la date de dernière modification de mot de passe ? \033[0m')"
								read target

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[9] Date de dernière modification du mot de passe" >> /var/log/log_evt.log

								# On vérifie que la cible existe bien
								cat /etc/passwd | grep -q "^$target:"
								# Si elle existe on execute le script
								if [ $? -eq 0 ]
								then  
									
									# On rentre la date de dernière modification du MDP que l'on retravaille avec grep pour n'avoir que la date format MM/DD/YYYY
									PassWordDate=$(sudo passwd -S $target | grep -o "[0-9]*/[0-9]*/[0-9]*")

									# On compte le nombre d'éléments dans le tableau
									# Si il n'y en a qu'un on l'affiche
									if [ ${#choice[@]} -eq 1 ]
									then
									# On affiche le résultat de la commande à l'écran.
									echo -e "${GREEN}\n* La date de dernière modification du mot de passe de $target était le $PassWordDate\n${NC}"
									fi
									echo -e "\n* La date de dernière modification du mot de passe de $target était le $PassWordDate\n" >> ~/Documents/"info_"$target"_"$FORMATTED_DATE".txt"


								# Si la cible n'existe pas, on prévient et on ferme
								else
									echo "${RED}La cible n'existe pas${NC}"								
												
								fi
								;;
							# Liste des sessions ouvertes par l'utilisateur
							10)
								echo -e "\n[10] ${GREEN}Liste des sessions ouvertes par l'utilisateur${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[10] Liste des sessions ouvertes par l'utilisateur" >> /var/log/log_evt.log
								target=$(whoami)
									# On compte le nombre d'éléments dans le tableau
									# Si il n'y en a qu'un on l'affiche
									if [ ${#choice[@]} -eq 1 ]
									then
									# Affichage commande "w"
									echo -e "\n* ${GREEN}Liste des sessions ouvertes par $target :\n`w`${NC}"
									fi
								# Si plusieurs choix dans le tableau, on enregistre directement
								
								echo -e "\n* Liste des sessions ouvertes par l'utilisateur $target :\n`w`" >> ~/Documents/"info_"$target"_"$FORMATTED_DATE".txt"
								;;
							# Groupe d'appartenance d'un utilisateur
							11)
								echo -e "\n[11] ${GREEN}Groupe d'appartenance d'un utilisateur${NC}"
                                echo
								echo -e "${BLUE}Pour quel utilisateur voudriez vous connaître le groupe ? ${NC}"
								read target

								# On copie dans le log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[11] Groupe d'appartenance d'un utilisateur" >> /var/log/log_evt.log

								# On vérifie que la cible existe bien
								cat /etc/passwd | grep -q "^$target:"
								# Si elle existe on execute le script  

								if [ $? -eq 0 ]
								then                
									
									# On compte le nombre d'éléments dans le tableau
									# Si il n'y en a qu'un on l'affiche
									if [ ${#choice[@]} -eq 1 ]
									then
									# On affiche le résultat de la commande à l'écran.
									# Les backticks servent à executer la commande, pendant que les "" l'affichent.
									echo -e "\n${GREEN}* Voici les groupes d'appartenance de `groups $target`${NC}\n" 
									fi
								# On copie dans fichier info    
								echo -e "\* [11] Voici les groupes d'appartenance de `groups $target`\n" >> ~/Documents/"info_"$target"_"$FORMATTED_DATE".txt"
								# Si elle n'existe pas on avertit et on quitte le programme
								else
									echo -e "${RED}La cible n'existe pas${NC}"								
								fi
								;;
							# Historique des commandes exécutées par l'utilisateur
							12)
								echo -e "\n[12] ${GREEN}Historique des commandes exécutées par l'utilisateur${NC}"

								# On copie dans le log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[12] Historique des commandes exécutées par l'utilisateur" >> /var/log/log_evt.log

								# On redéfinit la cible pour pouvoir l'afficher dans le résultat avec plus de clarté
								target=$(whoami)

								# On compte le nombre d'éléments dans le tableau
								# Si il n'y en a qu'un on l'affiche
									if [ ${#choice[@]} -eq 1 ]
									then
									# On affiche les 10 dernières commandes de l'utilisateur courant
									HISTFILE=~/.bash_history
									set -o history
									echo -e "\n${YELLOW}* Historique des 10 dernières commandes exécutées par $target :\n`history 10`${NC}"
									
									fi
								# On copie dans fichier info
								echo -e "\n* [12] Historique des 10 dernières commandes exécutées par l'utilisateur $target :\n`history 10`" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"
								;;
							# Droits/permissions de l’utilisateur sur un dossier
							13)
								echo -e "\n[13] ${GREEN}Droits/permissions de l’utilisateur sur un dossier${NC}"
                                echo
								echo -n "$(echo -e '\033[034mPour quel dossier voudriez vous connaître les droits ? \033[0m')"
								read directory
								echo -n "$(echo -e '\033[034mIndiquez le chemin du dossier que vous recherchez :\033[0m')"
								read path

								# On copie dans le log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[13] Droits/permissions de l’utilisateur sur un dossier" >> /var/log/log_evt.log

									# On execute la commande find pour les dossiers et on renvoie avec un -ls.
									# On stock dans une variable et on envoie le résultat en sauvegarde.
									DirectoryRight=$(find $path -type d -name "$directory" -ls)
									
									# Si il trouve le dossier ou si le dossier n'existe pas il renvoie 0 mais la commande fonctionne
									if [ $? -eq 0 ]
									then
									# On envoie le résultat dans le fichier
									echo -e "\n* [13] Voici les droits de `whoami` pour le dossier $directory :\n $DirectoryRight" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"

									# Si un seul choix dans le menu, on affiche le résultat
										if [ ${#choice[@]} -eq 1 ]
										then
										echo -e "\n${YELLOW}* Droits/permissions de `whoami` pour le dossier $directory :\n${NC} $DirectoryRight"
											if [ -z "$DirectoryRight" ]
											then
											echo -e "${RED}Il n'y a pas de dossier de ce nom${NC}"
											fi
										fi

										# On vérifie si la commande n'a rien renvoyé et on informe qu'il n'y a rien (pour éviter un espace vide)
										# On affiche en console et on enregistre dans le fichier.
										if [ -z "$DirectoryRight" ]
										then
										echo -e "Il n'y a pas de dossier de ce nom" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"
										fi    

									else
										# Si le chemin n'existe pas le programme fermer
										echo -e "${RED}Erreur le programme va fermer${NC}"
									fi
									;;
							# Droits/permissions de l’utilisateur sur un fichier		
							14)

								echo -e "\n[14] ${GREEN}Droits/permissions de l’utilisateur sur un fichier${NC}"
                                echo
								echo -e "${BLUE}Pour quel fichier voudriez vous connaître les droits ?${NC}"
								read file
								 echo -e "\033[34mIndiquez le chemin du fichier que vous recherchez :${NC}"
								read path

								# On copie dans le log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[14] Droits/permissions de l’utilisateur sur un fichier" >> /var/log/log_evt.log


									# On execute la commande find pour les fichiers et on renvoie avec un -ls.
									# On stock dans une variable et on envoie le résultat en sauvegarde dans "Fileright"
									FileRight=$(find $path -type f -name "$file" -ls)


									# Si il trouve le fichier ou si le fichier n'existe pas il renvoie 0 mais la commande fonctionne
									if [ $? -eq 0 ]
									then
									# On envoie le résultat dans le fichier
									echo -e "\n* [14] Droits/permissions de `whoami` pour le fichier $file :\n $FileRight" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"
									
										# Si un seul choix dans le menu on affiche le résultat
										if [ ${#choice[@]} -eq 1 ]
										then
										echo -e "\n${YELLOW}* Voici les droits de `whoami` pour le fichier $file :\n${NC} $FileRight" 
											if [ -z "$FileRight" ]
											then
											echo "${RED}Il n'y a pas de fichier de ce nom${NC}"
											fi
										
										fi

										# On vérifie si la commande n'a rien renvoyé et on informe qu'il n'y a rien (pour éviter un espace vide)
										# On affiche en console et on enregistre dans le fichier.
										if [ -z "$FileRight" ]
										then
										echo "Il n'y a pas de fichier de ce nom" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"
										fi    
									
									else
										# Si le chemin n'existe pas le programme fermer
										echo -e "${RED}Erreur le programme va fermer${NC}"
										exit 1
									fi
									;;
					
						esac

			done
		;;
					
				
		# Menu ORDINATEUR CLIENT / Choix entre ACTION ou INFORMATION
		2)
					echo -e "${BLUE}Menu principal : ${NC}"
					echo -e "\n${BLUE}Quelle action utilisateur souhaitez vous réaliser ?\n"
					echo -e "${BLUE}PARTIE ACTION${NC}"
					echo -e "[1] ${YELLOW}Marche/Arret${NC}"
					echo -e "[2] ${YELLOW}Mise à jour${NC}"
					echo -e "[3] ${YELLOW}Gestion des répertoires${NC}"
					echo -e "[4] ${YELLOW}Gestion Pare-feu${NC}"
					echo -e "[5] ${YELLOW}Gestion logiciel${NC}"
					echo
					echo -e "${BLUE}PARTIE INFORMATION${NC}"
					echo -e "[6] ${YELLOW}Version de l'OS${NC}"
					echo -e "[7] ${YELLOW}Nombre de disques${NC}"
					echo -e "[8] ${YELLOW}Partition par disque${NC}"
					echo -e "[9] ${YELLOW}Espace disque restant${NC}"
					echo -e "[10] ${YELLOW}Nom et espace disque d'un dossier${NC}"
					echo -e "[11] ${YELLOW}Liste des lecteurs montés${NC}"
					echo -e "[12] ${YELLOW}Liste des applications/paquets installés${NC}"
					echo -e "[13] ${YELLOW}Liste des services en cours d'execution${NC}"
					echo -e "[14] ${YELLOW}Liste des utilisateurs locaux${NC}"
					echo -e "[15] ${YELLOW}Mémoire RAM totale${NC}"
					echo -e "[16] ${YELLOW}Utilisation de la RAM${NC}"
					echo -e "${BLUE}Rentrez le ou les chiffres correspondant(s) :${NC}"
					read -a choice

				# j parcourt tous les choix sélectionnés
				for j in "${choice[@]}"
				do
					case $j in
							# Marche/Arret
							1)
								echo -e "[1] ${GREEN}Marche/Arret${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[2] Gestion des repertoires" >> /var/log/log_evt.log

								while true
								do
									echo -e "${BLUE}Menu Marche/Arret:${NC}"
									echo -e "[1] ${YELLOW}Arrêter${NC}"
									echo -e "[2] ${YELLOW}Redémarer${NC}"
									echo -e "[3] ${YELLOW}Verrouiller${NC}"
									read choix

									case $choix in
										1)
												echo -e "${GREEN}Arrêt en cours...${NC}"
												sudo -S shutdown now
												;;
										2)
												echo -e "${GREEN}Redémarrage en cours...${NC}"
												reboot
												;;
										3)
												echo -e "${GREEN}Verrouillage de la session en cours...${NC}"
												sleep 3
												xdg-screensaver lock
												;;
										*)
												echo -e "${RED}Choix invalide. Veuillez entre 1, 2, ou 3${NC}"
												;;
									esac
									
								done
								;;
							# Mise à jour
							2)
								echo -e "[2] ${GREEN}Mise à jour${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[2] Gestion des repertoires" >> /var/log/log_evt.log

								while true;
								do
									echo -e "${BLUE}Menu Mise à jour :${NC}"
									echo -e "[1] ${YELLOW}Mettre à le système${NC}"
									echo -e "[2] ${YELLOW}Quitter${NC}"
									read choix

									case $choix in
											1)
													echo -e "${BLUE}Mise à jour du système en cours${NC}"
													sudo -S apt-get update -y
													sudo -S apt-get upgrade -y
													sudo -S apt-get autoremove -y
													sudo -S apt-get clean -y
													echo -e "${GREEN}Mise à jour effectuée avec succès.${NC}"
													;;

											2)
													echo -e "${GREEN}Sortie de la mise à jour${NC}"	
													exit 0												e
													;;

											*)		
													echo -e "${RED}Choix invalide. Veuillez entre 1 ou 2${NC}"
													;;
									esac
									
								done
								;;
							# Gestion des répertoires
							3)
								echo -e "[3] ${GREEN}Gestion des répertoires${NC}"
								
								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[3] Gestion des repertoires" >> /var/log/log_evt.log


								while true;
								do
									echo -e "${BLUE}Menu Gestion des répertoires :${NC}"
									echo -e "[1] ${YELLOW}Créer un répertoire${NC}"
									echo -e "[2] ${YELLOW}Modifier un répertoire${NC}"
									echo -e "[3] ${YELLOW}Supprimer un répertoire${NC}"
									echo -e "[4] ${YELLOW}Quitter${NC}"
									read choix

									case $choix in
											1)
													echo -n "$(echo -e '\033[34mEntrez le nom du répertoire à créer : \033[0m')"
													read folder
													if [ -d "$folder" ];
													then
														echo -e "${RED}Le répertoire '$folder' existe deja${NC}"
													else
														mkdir "$folder"
														echo -e "${GREEN}Répertoire '$folder' créé avec succès.${NC}"
													fi

													break
													;;

											2)
													echo -e "${YELLOW}Liste des répertoires :${NC}"
													ls -d */
													echo
													echo -n "$(echo -e '\033[34mEntrez le nom du répertoire à renommer : \033[0m')"
													read folderName
													if [ ! -d "$folderName" ]
													then
														echo -e "${RED}Le répertoire '$folderName' n'existe pas.${NC}"
													else
														echo -n "$(echo -e '\033[34mEntrez le nouveau nom du répertoire : \033[0m')"
														read newFolder
														mv "$folderName" "$newFolder"
														echo -e "${GREEN}Répertoire renommé en '$newFolder' avec succès.${NC}"
													fi

													break
													;;
												
											3)
													echo -e "${YELLOW}Liste des répertoires :${NC}"
													ls -d */
													echo
													echo -n "$(echo -e '\033[34mEntrez le nom du répertoire à supprimer : \033[0m')"
													read folderName
													if [ ! -d "$folderName" ]
													then
														echo -e "${RED}Le répertoire '$folderName' n'existe pas.${NC}"
													else
														rm -r "$folderName"
														echo -e "${GREEN}Répertoire '$folderName' a été supprimé avec succes.${NC}"
													fi

													break
													;;

											4)
													echo -e "${RED}Fin du script${NC}"
													exit 0
											;;

											*)		
													echo -e "${RED}Choix invalide. Veuillez entre 1, 2, ou 3${NC}"
													;;
									esac

								done
								;;
							# Gestion Pare-feu
							4)
								echo -e "[4] ${GREEN}Gestion Pare-feu${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[4] Gestion Parefeu" >> /var/log/log_evt.log
								echo
								echo -e "${YELLOW}**MENU**\n\n${NC}"
								echo -e "${GREEN}[1] Activer le pare feu\n${NC}"     
								echo -e "${GREEN}[2] Autoriser une adresse IP\n${NC}"    
								echo -e "${RED}[3] Bloquer une adresse IP\n${NC}"   
								echo -e "${YELLOW}[4] Voir le Statut\n${NC}"    
								echo -e "[5] Sortie\n"
								echo -e "${BLUE}Choisissez une option : ${NC}"
									
								read choix2

								case $choix2 in
									
									1)                                 
										sudo ufw enable
										;;
										
									2) 
										read -p "$(echo -e '\033[34mQuelle adresse voulez vous autoriser?\033[0m')" reponse1
										sudo ufw deny from $reponse1   
										;;
									3)
										read -p "$(echo -e '\033[34mQuelle adresse IP voulez vous bloquer?\033[0m')" reponse2
										sudo ufw allow from $reponse2
										;;
									4)                  
											
										sudo ufw status numbered
										;;
									5)
										exit
										;;
												
									*)
									echo -e "${RED}L'option est invalide, veuillez rentrer une option valide, merci. :${NC}"
									;;
								esac
								;;
							# Gestion logiciel
							5)
								echo -e "[5] ${GREEN}Gestion logiciel\n\n${NC}"

								# On copie dans fichier log
								echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[5] Gestion logiciel" >> /var/log/log_evt.log
								echo
								echo -e "${GREEN}[1] Instaler un logiciel\n${NC}"
								echo -e "${RED}[2] Désintaler un Logiciel\n${NC}"

								read choix3

								case $choix3 in 

									1) 
										xdg-open https://fr.wikipedia.org/wiki/Cat%C3%A9gorie:Logiciel_pour_Linux 2>/dev/null
										read -p "$(echo -e '\033[34mQuel logiciel voulez-vous installer ? \033[0m')" logiciel1

										if [ ! -d "./$logiciel1" ]; then
											echo -e "Installation du logiciel $logiciel1 en cours..."
											sudo apt install "$logiciel1"

				
											if [ $? -ne 0 ]; then
												echo -e "${RED}L'installation a échoué.${NC}"
											else
												echo -e "${GREEN}L'installation est un succès.${NC}"
											fi
										else
											echo -e "${RED}Le logiciel $logiciel1 est déjà installé ou n'est pas un dossier.${NC}"
										fi
										;;                    
								
									2)
										gnome-terminal -- dpkg --list

										read -p "$(echo -e '\033[34mQuel logiciel voulez vous désinstaller? \033[0m')" logiciel2

										read -p "$(echo -e '\033[34mEtes vous sur de vouloir désinstaller $logiciel2 Y\N \033[0m')" reponse3

											if [[ $reponse3 == Y ]] || [[ $reponse3 == y ]];then

											sudo apt remove $logiciel2
												if [ $? = 0 ];then
												echo -e "${GREEN}le logiciel $logiciel2 à été désinstallé.${NC}"
												fi
											elif [[ $reponse3 == N ]] || [[ $reponse3 == n ]];then

												echo -e "${RED}le logiciel $logiciel2, n'a pas été désinstallé${NC}"
												exit
											fi
											;;
								esac
								;;
	
					
							# Version de l'OS
							6)
								echo -e "\n[6] ${GREEN}Version de l'OS${NC}"

								# SSH or not SSH ?
								echo -e "${BLUE}Souhaitez vous avoir l'information sur :${NC}"
								echo -e "[1] ${YELLOW}La machine actuelle${NC}"
								echo -e "[2] ${YELLOW}Machine distante${NC}" 
								read z
								
								case $z in
									# Machine locale
									1)
										# on vérifie si mono choix
										if [ ${#choice[@]} -eq 1 ]
										then
											# On affiche le résultat de la commande à l'écran.
											echo -e "\n${YELLOW}La version de cet OS est :${NC} ${GREEN}$(cat /etc/os-release | grep -v "NAME" | grep -v "PRETTY_NAME" | grep -v "ID" | grep -v "ID_LIKE" | grep -v "HOME_URL" | grep -v "SUPPORT_URL" | grep -v "BUG_REPORT_URL" | grep -v "PRIVACY_POLICY_URL" | grep -v "UBUNTU_CODENAME")${NC}"
										fi
											# On enregistre dans fichier info
											echo -e "\n* [6] La version de cet OS est : $(cat /etc/os-release | grep -v "NAME" | grep -v "PRETTY_NAME" | grep -v "ID" | grep -v "ID_LIKE" | grep -v "HOME_URL" | grep -v "SUPPORT_URL" | grep -v "BUG_REPORT_URL" | grep -v "PRIVACY_POLICY_URL" | grep -v "UBUNTU_CODENAME")" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"
											# On copie dans fichier log
											echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[6] Version de l'OS" >> /var/log/log_evt.log
									;; 
									# SSH
									2)										
										# Demande d'IP pour la connexion
										echo -e "${YELLOW}Sur quelle machine souhaitez-vous vous connecter ? Veuillez entrer une adresse IP : ${NC}"
										read ip
										# Acitvation de la fonction de vérif de l'IP. Si ok on contiinue
										if validate_ip "$ip"
										then
										# Demande sur quel utilisateur se connecter
										echo -e "${YELLOW}Veuillez entrer un utilisateur : ${NC}"
										read user
										# Tentative de connexion
										echo -e "${YELLOW}Tentative de connexion à${NC} ${GREEN}$ip${NC} ${YELLOW}avec l'utilisateur${NC} ${GREEN}$user${NC}..."

										# On rentre toutes les commandes à faire dans une variable
										SSH6="cat /etc/os-release | grep -v "NAME" | grep -v "PRETTY_NAME" | grep -v "ID" | grep -v "ID_LIKE" | grep -v "HOME_URL" | grep -v "SUPPORT_URL" | grep -v "BUG_REPORT_URL" | grep -v "PRIVACY_POLICY_URL" | grep -v "UBUNTU_CODENAME""

										# Exécution des commandes SSH que l'on rentre dans une variable							
										returnSSH6=$(ssh "$user@$ip" "$SSH6")

										if [ ${#choice[@]} -eq 1 ]
										then
											# On affiche le résultat de la commande à l'écran.
											echo -e "\n${YELLOW}La version de cet OS est :${NC}${GREEN}$returnSSH6${NC}"
										fi
											# On enregistre dans fichier info
											echo -e "\n* [6] La version de cet OS est : $returnSSH6 @$ip user:$user" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"
											# On copie dans fichier log
											echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[6] Version de l'OS" >> /var/log/log_evt.log
									
										else
											echo -e "${RED}L'adresse IP fournie n'est pas valide.${NC}"
										fi
									;;
								
									*)
										echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
									;;
								esac;;
							# Nombre de disques
							7)
								echo -e "\n[7] ${GREEN}Nombre de disques${NC}"
                                
								# SSH or not SSH ?
								echo -e "${BLUE}Souhaitez vous avoir l'information sur :${NC}"
								echo -e "[1] ${YELLOW}La machine actuelle${NC}"
								echo -e "[2] ${YELLOW}Machine distante${NC}" 
								read z

								case $z in
									# Machine locale
									1)
										# On copie dans fichier log
										echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[7] Nombre de disques" >> /var/log/log_evt.log
									
										# Liste uniquement les disques
										echo -e "\n* [7] Nombre de disques :\n`lsblk | grep -v "loop" | grep -v "sr0"`" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"
										# Nombre de disques
										disk_count=$(lsblk -d -o NAME | grep -vE "loop|sr0" | wc -l)

										# Structure if pour ajouter ou enlever un "s" en fonction du nombre de disques
										if [ $disk_count -gt 1 ]; then
											echo "Nombre de disques de `whoami` : $disk_count" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"
										else
											echo "Nombre de disque de `whoami` : $disk_count" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"
										fi
										# Affichage si un seul choix
										if [ ${#choice[@]} -eq 1 ]
										then
											lsblk | grep -v "loop" | grep -v "sr0"  # Liste uniquement les disques
											disk_count=$(lsblk -d -o NAME | grep -vE "loop|sr0" | wc -l)  # Nombre de disques
												if [ $disk_count -gt 1 ]; then
													echo -e "${YELLOW}Nombre de disques de `whoami` :${NC} ${GREEN}$disk_count${NC}"
												else
													echo -e "${YELLOW}Nombre de disque de `whoami` :${NC} ${GREEN}$disk_count${NC}"
												fi
										fi
									;;
									# SSH
									2)																												
										# Demande d'IP pour la connexion
										echo -e "${YELLOW}Sur quelle machine souhaitez-vous vous connecter ? Veuillez entrer une adresse IP : ${NC}"
										read ip

										# Acitvation de la fonction de vérif de l'IP. Si ok on contiinue
										if validate_ip "$ip"
										then
										# Demande sur quel utilisateur se connecter
										echo -e "${YELLOW}Veuillez entrer un utilisateur : ${NC}"
										read user
										# Tentative de connexion
										echo -e "${YELLOW}Tentative de connexion à${NC} ${GREEN}$ip${NC} ${YELLOW}avec l'utilisateur${NC} ${GREEN}$user${NC}..."



										# On rentre toutes les commandes à faire dans une variable
										SSH7="lsblk | grep -v "loop" | grep -v "sr0""
										SSH7bis="disk_count=$(lsblk -d -o NAME | grep -vE "loop|sr0" | wc -l)"
										# Exécution des commandes SSH que l'on rentre dans une variable							
										returnSSH7=$(ssh "$user@$ip" "$SSH7")
										

										if [ ${#choice[@]} -eq 1 ]
										then
											# On affiche le résultat de la commande à l'écran.
											echo -e "\n${YELLOW}Le nombre de disque(s) est :\n${NC}${GREEN}$returnSSH7${NC}\n"
										fi

										# On enregistre dans fichier info
											echo -e "\n* [7] Le nombre de disque(s) @$ip user:$user est :\n $returnSSH7 " >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"
											# On copie dans fichier log
											echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[7] Nombre de disque(s)" >> /var/log/log_evt.log
									
										else
											echo -e "${RED}L'adresse IP fournie n'est pas valide.${NC}"
										fi




									;;
									*)
									echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
									;;

									esac;;
							# Partition des disques
							8)
								# SSH or not SSH ?
								echo -e "\n[8] ${GREEN}Partition par disque${NC}"

								echo -e "${BLUE}Souhaitez vous avoir l'information sur :${NC}"								
								echo -e "[1] ${YELLOW}La machine actuelle${NC}"
								echo -e "[2] ${YELLOW}Machine distante${NC}" 
								read z

								case $z in
									# Machine locale
									1)
											
										# On copie dans fichier log
										echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[8] Partition par disque" >> /var/log/log_evt.log

										# On copie dans fichier info
										echo -e "\n* [8] Partition par disque :\n $resultat1=$(df -h | grep -v "tmpfs" | grep -v " /dev/sr0")" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"
										
										if [ ${#choice[@]} -eq 1 ]
											then
											echo -e "${YELLOW}Voici les partitions sur cette machine :${NC}\n ${GREEN}$resultat1=$(df -h | grep -v "tmpfs" | grep -v " /dev/sr0")${NC}" 
										fi
									;;

									# SSH
									2)
										# Demande d'IP pour la connexion
										echo -e "${YELLOW}Sur quelle machine souhaitez-vous vous connecter ? Veuillez entrer une adresse IP : ${NC}"
										read ip

										# Acitvation de la fonction de vérif de l'IP. Si ok on contiinue
										if validate_ip "$ip"
										then
											# Demande sur quel utilisateur se connecter
											echo -e "${YELLOW}Veuillez entrer un utilisateur : ${NC}"
											read user
											# Tentative de connexion
											echo -e "${YELLOW}Tentative de connexion à${NC} ${GREEN}$ip${NC} ${YELLOW}avec l'utilisateur${NC} ${GREEN}$user${NC}..."

											# On rentre les commandes dans une variable
											SSH8="df -h | grep -v "tmpfs" | grep -v ' /dev/sr0'"
											# Execution des commandes SSH que l'on rentre dans une variable
											returnSSH8=$(ssh "$user@$ip" "$SSH8")
										
												if [ ${#choice[@]} -eq 1 ]
												then
													echo -e "${YELLOW}Voici les partitions sur cette machine :${NC}\n ${GREEN}$returnSSH8${NC}" 
												fi
											# On copie dans fichier log
											echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[8] Partition par disque" >> /var/log/log_evt.log

											# On copie dans fichier info
											echo -e "\n* [8] Partition par disque sur @$ip user:$user :\n $returnSSH8" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"
										
										else
											echo -e "${RED}L'adresse IP fournie n'est pas valide.${NC}"

										fi
										;;
									*)
										echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
									;;
								esac
								;;
							# Espace disque restant
							9)
								echo -e "\n[9] ${GREEN}Espace disque restant${NC}"
								# SSH or not SSH
								echo -e "${BLUE}Souhaitez vous avoir l'information sur :${NC}"
								echo -e "[1] ${YELLOW}La machine actuelle${NC}"
								echo -e "[2] ${YELLOW}Machine distante${NC}" 
								read z

								case $z in
									# Machine locale
									1)
										# On copie dans fichier log
										echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[9] Espace disque restant" >> /var/log/log_evt.log
										
										# Enregistrement dans fichir info
										echo -e "\n* [9] Voici la place disponible sur chaque partition :\n $resultat2=$(df -h | grep -v "tmpfs" | grep -v "/dev/sr0" | awk 'BEGIN {OFS="       "} {print $1,$2, $3, $4}')" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"


										if [ ${#choice[@]} -eq 1 ]
										then
											echo -e "${YELLOW}Voici la place disponible sur chaque partition ${NC}:\n ${GREEN}$resultat2=$(df -h | grep -v "tmpfs" | grep -v "/dev/sr0" | awk 'BEGIN {OFS="       "} {print $1,$2, $3, $4}')${NC}"
										fi          

									;;

									# SSH
									2)
										# Demande d'IP pour la connexion
										echo -e "${YELLOW}Sur quelle machine souhaitez-vous vous connecter ? Veuillez entrer une adresse IP : ${NC}"
										read ip

										# Acitvation de la fonction de vérif de l'IP. Si ok on contiinue
										if validate_ip "$ip"
										then
											# Demande sur quel utilisateur se connecter
											echo -e "${YELLOW}Veuillez entrer un utilisateur : ${NC}"
											read user
											# Tentative de connexion
											echo -e "${YELLOW}Tentative de connexion à${NC} ${GREEN}$ip${NC} ${YELLOW}avec l'utilisateur${NC} ${GREEN}$user${NC}..."
										
											# On rentre les commandes à envoyer dans une variables
											SSH9='df -h | grep -v "tmpfs" | grep -v "/dev/sr0" | awk '\''BEGIN {OFS="       "} {print $1,$2, $3, $4}'\'''
											# Exécution des commandes SSH à rentrer dans variable
											returnSSH9=$(ssh "$user@$ip" "$SSH9")

											# Si un seul choix
											if [ ${#choice[@]} -eq 1 ]
											then
												echo -e "${YELLOW}Voici la place disponible sur chaque partition ${NC}:\n ${GREEN}$returnSSH9${NC}"
											fi     

												# On copie dans fichier log
											echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[9] Espace disque restant" >> /var/log/log_evt.log
											
											# Enregistrement dans fichir info
											echo -e "\n* [9] Voici la place disponible sur chaque partition @$ip user:$user :\n $returnSSH9" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"

										else
											echo -e "${RED}L'adresse IP fournie n'est pas valide.${NC}"
										fi
									;;
									*)
										echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
									;;
									esac
                    
								;;

							# Nom et espace disque d'un dossier
							10)

								echo -e "\n[10] ${GREEN}Nom et espace disque d'un dossier${NC}"
								
								# SSH or not SSH
								echo -e "${BLUE}Souhaitez vous avoir l'information sur :${NC}"
								echo -e "[1] ${YELLOW}La machine actuelle${NC}"
								echo -e "[2] ${YELLOW}Machine distante${NC}" 
								read z

								case $z in
									# Machine locale
									1)
										
										# On copie dans fichier log
										echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[10] Nom et espace disque d'un dossier" >> /var/log/log_evt.log

										echo -e "${YELLOW}Sur quel dossier souhaitez-vous des indications ?${NC}" 
										read directory

										echo -e "${YELLOW}Veuillez renseigner un chemin :${NC}" 
										read path



										# Vérifier si le chemin existe et est un répertoire
										if [ -d "$path" ]; then
											# Chercher le répertoire spécifié dans le chemin
											Total=$(find "$path" -type d -name "$directory")
											if [ -n "$Total" ]; then
												if [ ${#choice[@]} -eq 1 ]
												then
													echo -e "${GREEN}La taille du répertoire $directory est :\n $resultat3=$(sudo du -sh "$Total")${NC}"
												fi

												echo -e "\n* [10] Nom et espace disque d'un dossier\nLa taille du répertoire $directory est :\n $resultat3=$(sudo du -sh "$Total")" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"

											else
												echo "Le répertoire '$directory' n'a pas été trouvé dans le chemin spécifié." 
											fi
										else
											echo -e "${RED}Le chemin spécifié '$path' n'est pas un répertoire valide.${NC}" 
										fi
									;;

									# SSH
									2)

										echo -e "${YELLOW}Sur quel dossier souhaitez-vous des indications ?${NC}" 
										read directory

										echo -e "${YELLOW}Veuillez renseigner un chemin :${NC}" 
										read path

										# Demande d'IP pour la connexion
										echo -e "${YELLOW}Sur quelle machine souhaitez-vous vous connecter ? Veuillez entrer une adresse IP : ${NC}"
										read ip

										# On copie dans fichier log
										echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[10] Nom et espace disque d'un dossier" >> /var/log/log_evt.log

										# Acitvation de la fonction de vérif de l'IP. Si ok on contiinue
										if validate_ip "$ip"
										then
											# Demande sur quel utilisateur se connecter
											echo -e "${YELLOW}Veuillez entrer un utilisateur : ${NC}"
											read user
											# Tentative de connexion
											echo -e "${YELLOW}Tentative de connexion à${NC} ${GREEN}$ip${NC} ${YELLOW}avec l'utilisateur${NC} ${GREEN}$user${NC}..."

											echo -e "${RED}En cours de dév${NC}\n"

										else
											echo -e "${RED}L'adresse IP fournie n'est pas valide.${NC}"
										fi

									;;
									*)
										echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
									;;

									esac
                                
								;;
							# Liste des lecteurs montées
							11)
								echo -e "\n[11] ${GREEN}Liste des lecteurs montés${NC}"
								# SSH or not SSH
								echo -e "${BLUE}Souhaitez vous avoir l'information sur :${NC}"
								echo -e "[1] ${YELLOW}La machine actuelle${NC}"
								echo -e "[2] ${YELLOW}Machine distante${NC}" 
								read z

								case $z in
									# Machine locale
									1)
											# On copie dans fichier log
										echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[11] Liste des lecteurs montés" >> /var/log/log_evt.log
										
										# On lance les commandes et on les rentre dans une variable
										resultat4=$(lsblk | grep -v "loop")
										
										#Si un seul choix, on affiche le résultat à l'écran
										if [ ${#choice[@]} -eq 1 ]
											then
											echo -e "${GREEN}Liste des lecteurs montés :\n$resultat4${NC}" 
										fi

										# On enregistre dans le fichier info
										echo -e "\n* [11] Liste des lecteurs montés :\n$resultat4" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"

										;;

									# SSH
									2)
										# Demande d'IP pour la connexion
										echo -e "${YELLOW}Sur quelle machine souhaitez-vous vous connecter ? Veuillez entrer une adresse IP : ${NC}"
										read ip

											# On copie dans fichier log
										echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[11] Liste des lecteurs montés" >> /var/log/log_evt.log

										# Acitvation de la fonction de vérif de l'IP. Si ok on contiinue
										if validate_ip "$ip"
										then
											# Demande sur quel utilisateur se connecter
											echo -e "${YELLOW}Veuillez entrer un utilisateur : ${NC}"
											read user
											# Tentative de connexion
											echo -e "${YELLOW}Tentative de connexion à${NC} ${GREEN}$ip${NC} ${YELLOW}avec l'utilisateur${NC} ${GREEN}$user${NC}..."
										
											# On rentre le package dans une variable
											SSH11="lsblk | grep -v "loop""
											# Execution à distance
											returnSSH11=$(ssh "$user@$ip" "$SSH11")
											#Si un seul choix, on affiche le résultat à l'écran
											if [ ${#choice[@]} -eq 1 ]
												then
												echo -e "${GREEN}Liste des lecteurs montés :\n$returnSSH11${NC}" 
											fi

											# On enregistre dans le fichier info
											echo -e "\n* [11] Liste des lecteurs montés @$ip user:$user :\n$returnSSH11" >> ~/Documents/"info_`whoami`_$FORMATTED_DATE.txt"

										else
											echo -e "${RED}L'adresse IP fournie n'est pas valide.${NC}"
										fi

									;;
									*)
										echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
									;;
								esac
                              
							;;
							# Lise des applications paquets/installés
							12)
								echo -e "\n[12] ${GREEN}Liste des applications paquets/installés${NC}"

								echo -e "${BLUE}Souhaitez vous avoir l'information sur :${NC}"	
								# SSh or not SSH							
								echo -e "[1] ${YELLOW}La machine actuelle${NC}"
								echo -e "[2] ${YELLOW}Machine distante${NC}" 
								read z

								case $z in
									# Machine locale
									1)
										# On copie dans fichier log
										echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[12] Liste des applications/paquets installées" >> /var/log/log_evt.log

										# Fonction qui va mettre dans une liste les applications/paquets installées
										function list() {
										apt list --installed
										}
																		
										if [ $? -eq 0 ]
										then                
											# On compte le nombre d'éléments dans le tableau
											# Si il n'y en a qu'un on l'affiche
											if [ ${#choice[@]} -eq 1 ]
											then
											# On affiche le résultat de la commande à l'écran.
											echo -e "${YELLOW}Voici les applications/paquets installées :${NC}"
											list
											fi
											echo -e "\n* [12] Voici les applications/paquets installés :\n `list`" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"
										fi
									;;

									# SSH
									2)
										# Demande d'IP pour la connexion
										echo -e "${YELLOW}Sur quelle machine souhaitez-vous vous connecter ? Veuillez entrer une adresse IP : ${NC}"
										read ip

										# On copie dans fichier log
										echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[12] Liste des applications/paquets installées" >> /var/log/log_evt.log


										# Acitvation de la fonction de vérif de l'IP. Si ok on continue
										if validate_ip "$ip"
										then
											# Demande sur quel utilisateur se connecter
											echo -e "${YELLOW}Veuillez entrer un utilisateur : ${NC}"
											read user
											# Tentative de connexion
											echo -e "${YELLOW}Tentative de connexion à${NC} ${GREEN}$ip${NC} ${YELLOW}avec l'utilisateur${NC} ${GREEN}$user${NC}..."

											# Enregistrement des commandes
											SSH12="apt list --installed"

											# Execution des commandes distantes dans variable
											returnSSH12=$(ssh "$user@$ip" "$SSH12")

											if [ $? -eq 0 ]
											then                
												# On compte le nombre d'éléments dans le tableau
												# Si il n'y en a qu'un on l'affiche
												if [ ${#choice[@]} -eq 1 ]
												then
												# On affiche le résultat de la commande à l'écran.
												echo -e "${YELLOW}Voici les applications/paquets installées :${NC}\n$returnSSH12"
												
												fi
												echo -e "\n* [12] Voici les applications/paquets installés @$ip user:$user:\n$returnSSH12" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"
											fi


										
										else
											echo -e "${RED}L'adresse IP fournie n'est pas valide.${NC}"
										fi
									
									;;
									*)
										echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
									;;

								esac
								
								;;
							# Liste de services en cours d'exécution
							13)
								echo -e "\n[13] ${GREEN}Liste des services en cours d'execution${NC}"

								# SSH or not SSH
								echo -e "${BLUE}Souhaitez vous avoir l'information sur :${NC}"								
								echo -e "[1] ${YELLOW}La machine actuelle${NC}"
								echo -e "[2] ${YELLOW}Machine distante${NC}" 
								read z

								case $z in
									# Machine locale
									1)
										# On copie dans fichier log
										echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[13] Liste des services en cours d'execution" >> /var/log/log_evt.log

										# Fonction qui va mettre dans une liste les services en cours d'execution
										function list() {
										systemctl --type=service --state=running --no-pager --quiet
										}

								
										if [ $? -eq 0 ]
										then                
											# On compte le nombre d'éléments dans le tableau
											# Si il n'y en a qu'un on l'affiche
											if [ ${#choice[@]} -eq 1 ]
											then
											# On affiche le résultat de la commande à l'écran.
											echo -e "${YELLOW}Voici les services en cours d'execution :${NC}"
											list

											fi
											echo -e "\n* [13] Services en cours d'execution :\n `list`" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"
										fi

									;;

									# SSH
									2)
										# Demande d'IP pour la connexion
										echo -e "${YELLOW}Sur quelle machine souhaitez-vous vous connecter ? Veuillez entrer une adresse IP : ${NC}"
										read ip

										# On copie dans fichier log
										echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[13] Liste des services en cours d'execution" >> /var/log/log_evt.log


										# Acitvation de la fonction de vérif de l'IP. Si ok on contiinue
										if validate_ip "$ip"
										then
											# Demande sur quel utilisateur se connecter
											echo -e "${YELLOW}Veuillez entrer un utilisateur : ${NC}"
											read user
											# Tentative de connexion
											echo -e "${YELLOW}Tentative de connexion à${NC} ${GREEN}$ip${NC} ${YELLOW}avec l'utilisateur${NC} ${GREEN}$user${NC}..."
										
											# On rentre la commande dans une variable
											SSH13="systemctl --type=service --state=running --no-pager --quiet"
											# Execution à distance des commandes
											returnSSH13=$(ssh "$user@$ip" "$SSH13")

											if [ $? -eq 0 ]
											then                
												# On compte le nombre d'éléments dans le tableau
												# Si il n'y en a qu'un on l'affiche
												if [ ${#choice[@]} -eq 1 ]
												then
													# On affiche le résultat de la commande à l'écran.
													echo -e "${YELLOW}Voici les services en cours d'execution @$ip user:$user${NC} :\n$returnSSH13"
												fi
												echo -e "\n* [13] Services en cours d'execution :\n $returnSSH13" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"
											fi

										
										
										else
											echo -e "${RED}L'adresse IP fournie n'est pas valide.${NC}"
										fi
									
									;;
									*)
										echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
									;;

								esac
								;;
							# Liste des utilisateurs locaux
							14)
								echo -e "\n[14] ${GREEN}Liste des utilisateurs locaux${NC}"


								echo -e "${BLUE}Souhaitez vous avoir l'information sur :${NC}"								
								echo -e "[1] ${YELLOW}La machine actuelle${NC}"
								echo -e "[2] ${YELLOW}Machine distante${NC}" 
								read z

								case $z in
									# Machine locale
									1)
										# On copie dans fichier log
										echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[14] Liste des utilisateurs locaux" >> /var/log/log_evt.log


										# Fonction qui va mettre dans une liste les services en cours d'execution
										function list() {
										cut -d: -f1 /etc/passwd
										}
									
										if [ $? -eq 0 ]
										then                
											# On compte le nombre d'éléments dans le tableau
											# Si il n'y en a qu'un on l'affiche
											if [ ${#choice[@]} -eq 1 ]
											then
												# On affiche le résultat de la commande à l'écran.
												echo -e "${YELLOW}Voici la liste des utilisateur locaux :${NC}"
												list												
											fi

											echo -e "\n* [14] Voici la liste des utilisateurs locaux :\n`list`" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"
										fi
									;;

									# SSH
									2)
										# Demande d'IP pour la connexion
										echo -e "${YELLOW}Sur quelle machine souhaitez-vous vous connecter ? Veuillez entrer une adresse IP : ${NC}"
										read ip

										# On copie dans fichier log
										echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[14] Liste des utilisateurs locaux" >> /var/log/log_evt.log


										# Acitvation de la fonction de vérif de l'IP. Si ok on contiinue
										if validate_ip "$ip"
										then
											# Demande sur quel utilisateur se connecter
											echo -e "${YELLOW}Veuillez entrer un utilisateur : ${NC}"
											read user
											# Tentative de connexion
											echo -e "${YELLOW}Tentative de connexion à${NC} ${GREEN}$ip${NC} ${YELLOW}avec l'utilisateur${NC} ${GREEN}$user${NC}..."

											# On rentre la commande dans une variable
											SSH14="cut -d: -f1 /etc/passwd"
											# Execution à distance
											returnSSH14=$(ssh "$user@$ip" "$SSH14")

											if [ $? -eq 0 ]
											then                
												# On compte le nombre d'éléments dans le tableau
												# Si il n'y en a qu'un on l'affiche
												if [ ${#choice[@]} -eq 1 ]
												then
													# On affiche le résultat de la commande à l'écran.
													echo -e "${YELLOW}Voici la liste des utilisateur locaux :\n${NC}$returnSSH14"
												fi
												echo -e "\n* [14] Voici la liste des utilisateurs locaux @$ip user:$user :\n$returnSSH14" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"
											fi
										else
											echo -e "${RED}L'adresse IP fournie n'est pas valide.${NC}"
										fi
									
									;;
									*)
										echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
									;;
								esac
				
								;;
							# Mémoire RAM totale
							15)
								echo -e "\n[15] ${GREEN}Mémoire RAM totale${NC}"

								# SSH or not SSH
								echo -e "${BLUE}Souhaitez vous avoir l'information sur :${NC}"								
								echo -e "[1] ${YELLOW}La machine actuelle${NC}"
								echo -e "[2] ${YELLOW}Machine distante${NC}" 
								read z

								case $z in
									# Machine locale
									1)
										# On copie dans fichier log
										echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[15] Mémoire RAM totale" >> /var/log/log_evt.log
										
										# On enregistre dans le fichier information
										echo -e "\n* [15] Votre RAM totale est de $(free -h | grep "Mem:" | awk '{print$2}')" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"

										# Si un seul choix dans le menu
										if [ ${#choice[@]} -eq 1 ]
										then
											# Affichage de la RAM totale avec free et découpe avec awk et grep
											echo -e "${YELLOW}Votre RAM totale est de${NC} ${GREEN}$(free -h | grep "Mem:" | awk '{print$2}')${NC}"
										fi

									;;

									# SSH
									2)
										# Demande d'IP pour la connexion
										echo -e "${YELLOW}Sur quelle machine souhaitez-vous vous connecter ? Veuillez entrer une adresse IP : ${NC}"
										read ip

										# On copie dans fichier log
										echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[15] Mémoire RAM totale" >> /var/log/log_evt.log


										# Acitvation de la fonction de vérif de l'IP. Si ok on contiinue
										if validate_ip "$ip"
										then
											# Demande sur quel utilisateur se connecter
											echo -e "${YELLOW}Veuillez entrer un utilisateur : ${NC}"
											read user
											# Tentative de connexion
											echo -e "${YELLOW}Tentative de connexion à${NC} ${GREEN}$ip${NC} ${YELLOW}avec l'utilisateur${NC} ${GREEN}$user${NC}..."
										
											# enregistrement du package de commandes à envoyer
											SSH15='free -h | grep "Mem:" | awk '\''{print$2}'\'''
											# Exécution à distance
											returnSSH15=$(ssh "$user@$ip" "$SSH15")

										# Si un seul choix dans le menu
										if [ ${#choice[@]} -eq 1 ]
										then
											# Affichage de la RAM totale avec free et découpe avec awk et grep
											echo -e "${YELLOW}Votre RAM totale est de${NC} ${GREEN}$returnSSH15${NC}"
										fi
										
										# On enregistre dans le fichier information
										echo -e "\n* [15] Votre RAM totale @$ip user:$user est de $returnSSH15" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"

										else
											echo -e "${RED}L'adresse IP fournie n'est pas valide.${NC}"
										fi
									
									;;
									*)
										echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
									;;
									esac

								;;
							# Utilisation de la RAM
							16)
								echo -e "\n[16] ${GREEN}Utilisation de la RAM${NC}"

							    # SSH or not SSH
								echo -e "${BLUE}Souhaitez vous avoir l'information sur :${NC}"								
								echo -e "[1] ${YELLOW}La machine actuelle${NC}"
								echo -e "[2] ${YELLOW}Machine distante${NC}" 
								read z

								case $z in
									# Machine locale
									1)
										# On copie dans fichier log
										echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[16] Utilisation de la RAM" >> /var/log/log_evt.log

										# On enregistre dans le fichier information
										echo -e "\n* [16] Votre RAM utilisée est de $(free -h | grep "Mem:" | awk '{print$3}')" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"

										# Si un seul choix dans le menu
										if [ ${#choice[@]} -eq 1 ]
										then
											# Affichage de la RAM totale avec free et découpe avec awk et grep
											echo -e "${YELLOW}Votre RAM utilisée est de${NC} ${GREEN}$(free -h | grep "Mem:" | awk '{print$3}')${NC}"
										fi
									;;

									# SSH
									2)
										# Demande d'IP pour la connexion
										echo -e "${YELLOW}Sur quelle machine souhaitez-vous vous connecter ? Veuillez entrer une adresse IP : ${NC}"
										read ip

										# On copie dans fichier log
										echo "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-[16] Utilisation de la RAM" >> /var/log/log_evt.log


										# Acitvation de la fonction de vérif de l'IP. Si ok on contiinue
										if validate_ip "$ip"
										then
											# Demande sur quel utilisateur se connecter
											echo -e "${YELLOW}Veuillez entrer un utilisateur : ${NC}"
											read user
											# Tentative de connexion
											echo -e "${YELLOW}Tentative de connexion à${NC} ${GREEN}$ip${NC} ${YELLOW}avec l'utilisateur${NC} ${GREEN}$user${NC}..."
											
											# On enregistre les commandes à envoyer dans une variable
											SSH16='free -h | grep "Mem:" | awk '\''{print$3}'\'''
											# Exécuter à distance
											returnSSH16=$(ssh "$user@$ip" "$SSH16")

										# Si un seul choix dans le menu
										if [ ${#choice[@]} -eq 1 ]
										then
											# Affichage de la RAM totale avec free et découpe avec awk et grep
											echo -e "${YELLOW}Votre RAM utilisée est de${NC} ${GREEN}$returnSSH16${NC}"
										fi

										# On enregistre dans le fichier information
										echo -e "\n* [16] Votre RAM utilisée @$ip user:$user est de $returnSSH16" >> ~/Documents/"info_`whoami`""_"$FORMATTED_DATE".txt"

										else
											echo -e "${RED}L'adresse IP fournie n'est pas valide.${NC}"
										fi
									
									;;
									*)
										echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
									;;
									esac

								;;

							*)
								echo -e "${RED}Veuillez choisir une option dans la liste${NC}"
								;;
					esac
					
			
				done
				
		;;	
	esac

}


# Tant que l'utilisateur tape yes, le programme continue
while [[ $Continue = "yes" || $Continue = "YES" ]]
do
    menu
    echo -e "\n"
    echo -e "${GREEN}[yes]${NC} ${YELLOW}pour Continuer${NC}"
	echo -e "${RED}[no]${NC} ${YELLOW}pour Quitter${NC}"
    read Continue
done

echo -e "${PINK}
      _                         _       _ 
     /_\ _  _   _ _ _____ _____(_)_ _  | |
    / _ \ || | | '_/ -_) V / _ \ | '_| |_|
   /_/ \_\_,_| |_| \___|\_/\___/_|_|   (_)
${NC}"    

# On enregistre la fin du script dans le fichier log
echo -e "$FORMATTED_DATE-$FORMATTED_TIME-`whoami`-${RED}********EndScript**********${NC}" >> /var/log/log_evt.log
