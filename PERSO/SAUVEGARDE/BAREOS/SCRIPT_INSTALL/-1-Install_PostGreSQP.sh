#!/bin/bash

# Couleurs 
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

# ====================================== CHARGEMENT ======================================
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

# ====================================== CHARGEMENT ======================================


# === FONCTION EN-TETE ===
titre_post() {
    echo -e "\n${YELLOW}#############################################"
    echo -e "${YELLOW}###   Script d'installation PostgreSQL    ###${NC}"
    echo -e "${YELLOW}###---------------------------------------###${NC}"
    echo -e "${YELLOW}###        Date    : 16/10/2025           ###${NC}"
    echo -e "${YELLOW}#############################################${NC}\n"
}
#  VERIFIER LA  VERSION ACTUEL DE POSTGRESQL SINON LE  SCRIPT VA PLANTER.

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
    echo -e "\n${GREEN}Utilisateur PostgreSQL '$name' et base '${name}_base' créés avec succès.${NC}\n"
else
    echo -e "${RED}Erreur lors de la création de la base PostgreSQL '$name'.${NC}"
    exit 1
fi
                    echo -e "\n${GREEN}Installation et configuration PostgreSQL terminées avec succès !${NC}"
                    
                    break  # Sort de la boucle si le choix était valide

                else
                    echo -e "${RED}Choix invalide. Veuillez entrer 'y' ou 'n'.${NC}"
                fi
            done


            fi
else
    echo -e "${RED}Veuillez installer et configurer sudo avant de continuer.${NC}"
    exit 0
fi
