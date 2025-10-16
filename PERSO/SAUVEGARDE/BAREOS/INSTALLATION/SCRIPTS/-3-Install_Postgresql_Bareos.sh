#!/bin/bash

# Couleurs 
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

# ====================================== ANIMATION CHARGEMENT SCRIPT ======================================

# Source: https://github.com/Silejonu/bash_loading_animations
BLA_bubble=( 0.2 · o O O o · )

declare -a BLA_active_loading_animation

BLA::play_loading_animation_loop() {
  while true ; do
    for frame in "${BLA_active_loading_animation[@]}" ; do
      printf "\r%s" "${frame}"
      sleep "${BLA_loading_animation_frame_interval}"
    done
  done
}

BLA::start_loading_animation() {
  BLA_active_loading_animation=( "${@}" )
  # Extract the delay between each frame from array BLA_active_loading_animation
  BLA_loading_animation_frame_interval="${BLA_active_loading_animation[0]}"
  unset "BLA_active_loading_animation[0]"
  tput civis # Hide the terminal cursor
  BLA::play_loading_animation_loop &
  BLA_loading_animation_pid="${!}"
}

BLA::stop_loading_animation() {
  kill "${BLA_loading_animation_pid}" &> /dev/null
  printf "\n"
  tput cnorm # Restore the terminal cursor
}

# ====================================== VARIABLES BAREOS ======================================

Debian_11="https://download.bareos.org/current/Debian_11/add_bareos_repositories.sh"
Debian_12="https://download.bareos.org/current/Debian_12/add_bareos_repositories.sh"
Debian_13="https://download.bareos.org/current/Debian_13/add_bareos_repositories.sh"
Ubuntu_20="https://download.bareos.org/current/xUbuntu_20.04/add_bareos_repositories.sh"
Ubuntu_22="https://download.bareos.org/current/xUbuntu_22.04/add_bareos_repositories.sh"
Ubuntu_24="https://download.bareos.org/current/xUbuntu_24.04/add_bareos_repositories.sh"

version_psql=18
path_pg_hba="/etc/postgresql/$version_psql/main/pg_hba.conf"

# === FONCTION EN-TETE ===
titre_post() {
    echo -e "\n${YELLOW}#############################################"
    echo -e "${YELLOW}###   Script d'installation PostgreSQL    ###${NC}"
    echo -e "${YELLOW}###---------------------------------------###${NC}"
    echo -e "${YELLOW}###        Date    : 16/10/2025           ###${NC}"
    echo -e "${YELLOW}#############################################${NC}\n"
}

titre_bareos() {
    echo -e "\n${YELLOW}#############################################"
    echo -e "${YELLOW}###   Script d'installation Bareos        ###${NC}"
    echo -e "${YELLOW}###---------------------------------------###${NC}"
    echo -e "${YELLOW}###        Date    : 16/10/2025           ###${NC}"
    echo -e "${YELLOW}#############################################${NC}\n\n"
}

# ====================================== INSTALL CONFIG POSTGRESQL ======================================
clear
titre_post

BLA::start_loading_animation "${BLA_bubble[@]}"
sleep 2
BLA::stop_loading_animation



echo -e "${RED}sudo doit être installé et configuré sur cette machine, est-ce le cas? (y/n)${NC}\n" 
read choix_sudo

if [ "$choix_sudo" == "y" ] || [ "$choix_sudo" == "Y" ]; then

            if dpkg -l | grep -q "^ii.*postgresql"; then
                echo -e "${GREEN}postgresql déjà installé ${NC}\n"
                echo -e "Veuillez vérifier la version ,ainsi que les utilisteurs pour éviter tout conflit..."
                exit 1
                
            else            

                        # Installation de expect
                            
                            sudo apt -y -qq install expect > /dev/null 2>&1
                        

                            if dpkg -l | grep -q "^ii.*expect"; then
                                clear
                                titre_post
                                echo -e "${GREEN}expect installé avec succès${NC}\n"
                                sleep 2
                            else
                                echo -e "${RED}expect non installé${NC}"
                            fi
                        
                        # Installation de curl
                            

                        
                            
                            if dpkg -s curl &> /dev/null; then
                                clear
                                titre_post
                                echo -e "${GREEN}curl est déjà installé ${NC}\n"
                                sleep 2
                            else
                            
                            sudo apt -y -qq install curl ca-certificates >/dev/null 2>&1
                            
                                                            
                                if dpkg -l | grep -q "^ii.*curl"; then
                                    clear
                                    titre_post
                                    echo -e "${GREEN}curl installé avec succés${NC}\n"
                                    sleep 2
                                else 
                                    clear
                                    titre_post
                                    echo -e "${RED}Probléme lors de l'installation de curl...${NC}"    
                                    exit 1
                                fi
                            fi

                        # Installation Gnupg
                        
                            if dpkg -s gnupg &> /dev/null; then
                                echo -e "${GREEN}gnupg est déjà installé ${NC}\n"
                            else
                            
                            sudo apt -y -qq install gnupg > /dev/null 2>&1
                            
                                                            
                                if dpkg -l | grep -q "^ii.*gnupg"; then
                                    clear
                                    titre_post
                                    echo -e "${GREEN}gnupg installé avec succés${NC}\n"
                                    sleep 2
                                else 
                                    echo -e "${RED}Probléme lors de l'installation de gnupg...${NC}"    
                                    exit 1
                                fi
                            fi
                                        
                        # Création  du répertoire /usr/share/postgresql-common/pgdg avec droit administrateur

                            sudo install -d /usr/share/postgresql-common/pgdg > /dev/null 2>&1

                            if [ -d /usr/share/postgresql-common/pgdg ]; then
                                clear
                                titre_post
                                echo -e "${NC}Le répertoire ${YELLOW}/usr/share/postgresql-common/pgdg${NC} créé avec succès.\n"
                                sleep 2                            
                            else
                                echo -e "${RED}Probléme lors de la création du répertoire${NC}"
                                exit 1
                            fi

                        # Télécharger la clé GPG officielle de PostgreSQL depuis le site officiel,
                            
                            
                            sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc > /dev/null 2>&1
                            #test=$?
                            #echo -e "$test"
                            if [ $? -eq 0 ]; then
                                clear
                                titre_post
                                echo -e "${GREEN}Clé GPG télécharger avec succés${NC}\n"
                                sleep 2
                            else  
                                echo -e "${RED}Probléme lors du téléchargementde la clé GPG${NC}"
                                exit 1
                            fi

                    # Charger dans le shell les variables d’identification de la distribution Linux

                            . /etc/os-release

                    # Créer un fichier de dépôt APT pour PostgreSQL,
                            
                            sudo sh -c "echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
                            
                    # Installation de PostgreSQL
                            clear
                            titre_post
                            echo -e "${YELLOW}Veuillez patienter durant l'installation de ${NC}postgresql-18 ${NC}\n"
                            
                            BLA::start_loading_animation "${BLA_bubble[@]}"
                            sudo apt update  > /dev/null 2>&1
                            sudo apt -y -qq install  postgresql-18  > /dev/null 2>&1
                            BLA::stop_loading_animation    
                                if dpkg -l | grep -q "^ii.*postgresql-18"; then
                                    clear
                                    titre_post
                                    echo -e "${GREEN}postgresql-18 installé avec succès${NC}\n"
                                    sleep  2
                                else
                                    echo -e "${RED}postgresql-18 non installé${NC}"
                                fi

                
                    # Créez un utilisateur PostgreSQL
                                clear
                                titre_post
                                echo -e "${YELLOW}Création d’un utilisateur PostgreSQL...${NC}\n\n"
                                sleep 2

                                read -p "Veuillez indiquer un nom utilistateur pour PostgreSQL : " name
                                read -p "Voulez-vous que votre utilisateur ait le rôle super-utilisateur pour PostgreSQL (y/n) : " choix

                        while true; do
                
                if [[ "$choix" == "y" || "$choix" == "n" ]]; then

                    # Création de l'utilisateur PostgreSQL avec expect
sudo -u postgres expect <<EOF
log_user 0
spawn createuser --interactive
expect "Enter name of role to add:" 
send "$name\r"
expect "Shall the new role be a superuser? (y/n)" 
send "$choix\r"
expect eof
EOF

sudo -u postgres createdb "${name}_base"

# Vérification
if [ $? -eq 0 ]; then
    clear
    titre_post
    echo -e "\n${GREEN}Utilisateur PostgreSQL '$name' et base '${name}_base' créés avec succès.${NC}\n"
    sleep  3
else
    echo -e "${RED}Erreur lors de la création de la base PostgreSQL '$name'.${NC}"
    exit 1
fi
                    clear
                    titre_post
                    echo -e "\n${GREEN}Installation et configuration PostgreSQL terminées avec succès !${NC}"
                    sleep  3
                    break  # Sort de la boucle si le choix était valide

                else
                    echo -e "${RED}Choix invalide. Veuillez entrer 'y' ou 'n'.${NC}"
                fi
            done


            fi



     

        # ====================================== INSTALL BAREOS ======================================
        clear
        titre_bareos

        echo -e "${YELLOW}Voici votre OS :${NC} $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')\n"

        while true; do
            echo -e "Veuillez choisir une distribution  : \n"
            echo -e "${YELLOW}Si distribution absente : veuillez rechercher ici => ${NC}https://download.bareos.org/current/${NC}\n"
            echo "[1] Debian_11"
            echo "[2] Debian_12"
            echo "[3] Debian_13"
            echo "[4] Ubuntu_20.04"
            echo "[5] Ubuntu_22.04"
            echo "[6] Ubuntu_24.04"
            echo "[7] Quitter"
            echo -e "\n${YELLOW}Votre choix${NC}\n"
            read choix
            case $choix in
                1) wget -q $Debian_11 && chmod +x add_bareos_repositories.sh ; break ;;
                2) wget -q $Debian_12 && chmod +x add_bareos_repositories.sh ; break ;;
                3) wget -q $Debian_13 && chmod +x add_bareos_repositories.sh ; break ;;
                4) wget -q $Ubuntu_20 && chmod +x add_bareos_repositories.sh ; break ;;
                5) wget -q $Ubuntu_22 && chmod +x add_bareos_repositories.sh ; break ;;
                6) wget -q $Ubuntu_24 && chmod +x add_bareos_repositories.sh ; break ;;
                7) echo -e "${RED}Vous avez choisi de quitter le script...${NC}"; clear; exit 0 ;;
                *) echo -e "${RED}Veuillez entrer une valeur comprise entre 1 et 7${NC}" ;;
            esac
        done

        status=$?
        if [ $status -eq 0 ]; then
            echo -e "${GREEN}Le dépôt a été ajouté avec succès.${NC}"
        else
            echo -e "${RED}Problème lors de l’ajout du dépôt ...${NC}"
        fi 

        sudo sh ./add_bareos_repositories.sh > /dev/null 2>&1
        sudo apt -y -qq update > /dev/null 2>&1
        sudo apt -y install bareos bareos-database-postgresql 
        status=$?
        if [ $status -eq 0 ]; then
            clear
            titre_bareos
            echo -e "${GREEN}Installation réussie${NC}"
            sleep 3
        else
            clear
            titre_bareos
            echo -e "${RED}Échec de l'installation${NC}"
            exit 1
        fi

        if [ -f "$path_pg_hba" ]; then
            clear
            titre_bareos
            echo -e "${YELLOW}Configuration du fichier pg_hba.conf...${NC}"
            BLA::start_loading_animation "${BLA_bubble[@]}"
            sleep 2
            BLA::stop_loading_animation
            sudo sed -i "/^local\s\+all\s\+postgres\s\+peer/i local   all             bareos                                  md5" "$path_pg_hba"
            clear
            titre_bareos
            echo -e "${GREEN}Configuration OK ${NC}"
            sleep 3
        else
            echo -e "${RED}Fichier pg_hba.conf pour PostgreSQL $version_psql absent ${NC}\n"
            echo -e "${YELLOW}Appuyez sur Entrée pour connaître la version de PostgreSQL${NC}"
            read
            psql --version
            echo -e "\nVeuillez changer la valeur de la version de psql dans les variables de ce script :\n"
            echo -e "# === VERSION PSQL + CHEMIN DU FICHIER ==="
            echo -e "version_psql=18"
            echo -e "path_psql=/etc/postgresql/$version_psql/main/pg_hba.conf"
            exit 0
        fi
        
        sudo systemctl enable --now bareos-director.service
        sudo systemctl enable --now bareos-storage.service
        sudo systemctl enable --now bareos-filedaemon.service

        clear
        titre_bareos

        echo -e "\n${YELLOW}ETAT DES  SERVICES :${NC}\n\n"

        sudo systemctl status bareos-director.service --no-pager -n 5
        sudo systemctl status bareos-storage.service --no-pager -n 5
        sudo systemctl status bareos-filedaemon.service --no-pager -n 5
        sudo systemctl status postgresql --no-pager -n 5

        echo -e "\nAppuyez sur Entrée pour quitter..."
        read
        BLA::start_loading_animation "${BLA_bubble[@]}"
        sleep 2
        BLA::stop_loading_animation
        clear
        exit 0
    fi

else
    echo -e "${RED}Veuillez installer et configurer sudo avant de continuer.${NC}"
    exit 0
fi
