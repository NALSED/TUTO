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

# === OS DISPO ===

Debian_11="https://download.bareos.org/current/Debian_11/add_bareos_repositories.sh"
Debian_12="https://download.bareos.org/current/Debian_12/add_bareos_repositories.sh"
Debian_13="https://download.bareos.org/current/Debian_13/add_bareos_repositories.sh"
Ubuntu_20="https://download.bareos.org/current/xUbuntu_20.04/add_bareos_repositories.sh"
Ubuntu_22="https://download.bareos.org/current/xUbuntu_22.04/add_bareos_repositories.sh"
Ubuntu_24="https://download.bareos.org/current/xUbuntu_24.04/add_bareos_repositories.sh"

# ====================================== INSTALL CONFIG BAREOS ======================================

echo -e "\n${YELLOW}#############################################"
echo -e "${YELLOW}###   Script d'installation Bareos        ###${NC}"
echo -e "${YELLOW}###---------------------------------------###${NC}"
echo -e "${YELLOW}###        Date    : 16/10/2025           ###${NC}"
echo -e "${YELLOW}#############################################${NC}\n\n"

echo -e "${YELLOW}Voici votre OS :${NC} $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')\n"


while true;do
      echo -e "Veuillez choisir une distribution  : \n"
      echo -e "${YELLOW}Si distribution absente : veuillez rechercher ici => ${NC}https://download.bareos.org/current/${NC}\n"
      echo "[1] Debian_11"
      echo "[2] Debian_12"
      echo "[3] Debian_13"
      echo "[4] Ubuntu_20.04"
      echo "[5] Ubuntu_22.04"
      echo "[6] Ubuntu_24.04"
      echo "[7] Quitter"
      
    
      read choix
      
      case $choix in

          1)
          echo -e "\n${GREEN}Téléchargement du script pour Debian 11...${NC}"
          wget -q $Debian_11 && chmod +x add_bareos_repositories.sh
          ;;

          2)
          echo -e "\n${GREEN}Téléchargement du script pour Debian 12...${NC}"
          wget -q $Debian_12 && chmod +x add_bareos_repositories.sh
          ;;

          3)
          echo -e "\n${GREEN}Téléchargement du script pour Debian 13...${NC}"
          wget -q $Debian_13 && chmod +x add_bareos_repositories.sh
          ;;

          4)
          echo -e "\n${GREEN}Téléchargement du script pour Ubuntu 20...${NC}"
          wget -q $Ubuntu_20 && chmod +x add_bareos_repositories.sh
          ;;


          5)
          echo -e "\n${GREEN}Téléchargement du script pour Ubuntu 22...${NC}"
          wget -q $Ubuntu_22 && chmod +x add_bareos_repositories.sh
          ;;


          6)
          echo -e "\n${GREEN}Téléchargement du script pour Ubuntu 24...${NC}"
          wget -q $Ubuntu_24 && chmod +x add_bareos_repositories.sh
          ;;

          7)
          echo -e "${RED}Vous avez choisi de quitter le script...${NC}"
          clear
          exit 0
          ;;


          *)
          
          echo -e "${RED}Veuillez entrer une valeur comprise entre 1 et 7${NC}"
          ;;

      esac


    echo -e "\nAppuyez sur Entrée pour continuer..."
    read
    clear

done










echo -e "https://download.bareos.org/current/"
