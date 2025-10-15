#!/bin/bash

# Couleurs 
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

#  VERIFIER LA  VERSION ACTUEL DE POSTGRESQL SINON LE  SCRIPT VA PLANTER.

# ====================================== INSTALL CONFIG POSTGRESQL ======================================
clear
if dpkg -l | grep -q "^ii.*postgresql"; then
    echo -e "${GREEN}postgresql déjà installé ${NC}\n"
    echo -e "Veuillez vérifier la version ,ainsi que les utilisteurs pour éviter tout conflit..."
    exit 1
    
else            

            # Installation de expect
                sudo apt -y -qq install expect > /dev/null 2>&1

                if dpkg -l | grep -q "^ii.*expect"; then
                    echo -e "${GREEN}expect installé avec succès${NC}\n"
                else
                    echo -e "${RED}expect non installé${NC}"
                fi
            
            # Installation de curl
                
                if dpkg -l | grep -q "^ii.*curl"; then
                            echo -e "${GREEN}curl est déjà installé ${NC}\n"
                        else
                            sudo apt -y -qq install curl ca-certificates > /dev/null 2>&1
                            
                            if dpkg -l | grep -q "^ii.*curl"; then
                                echo -e "${GREEN}curl installé avec succés${NC}\n"
                            else 
                                echo -e "${RED}Probléme lors de l'installation de curl...${NC}"    
                                exit 1
                            fi
                fi

            # Création  du répertoire /usr/share/postgresql-common/pgdg avec droit administrateur
                
                sudo install -d /usr/share/postgresql-common/pgdg

                if [ -d /usr/share/postgresql-common/pgdg ]; then
                    echo -e "${NC}Le répertoire ${YELLOW}/usr/share/postgresql-common/pgdg${NC} créé avec succès.\n"
                else
                    echo -e "${RED}Probléme lors de la création du répertoire${NC}"
                    exit 1
                fi

            # Télécharger la clé GPG officielle de PostgreSQL depuis le site officiel,
                
                sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc > /dev/null 2>&1

                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}Clé GPG télécharger avec succés${NC}\n"
                else  
                    echo -e "${RED}Probléme lors du téléchargementde la clé GPG${NC}"
                    exit 1
                fi

        # Charger dans le shell les variables d’identification de la distribution Linux

                . /etc/os-release

        # Créer un fichier de dépôt APT pour PostgreSQL,

                sudo sh -c "echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"

        # Installation de PostgreSQL
                
                sudo apt update  > /dev/null 2>&1
                sudo apt -y -qq install  postgresql-18  > /dev/null 2>&1
                    if dpkg -l | grep -q "^ii.*postgresql-18"; then
                        echo -e "${GREEN}postgresql-18 installé avec succès${NC}\n"
                    else
                        echo -e "${RED}postgresql-18 non installé${NC}"
                    fi

    
        # Créez un utilisateur PostgreSQL

                    echo -e "${YELLOW}Création d’un utilisateur PostgreSQL...${NC}\n\n"
                    
                    read -p "Veuillez indiquer un nom utilistateur pour PostgreSQL : " name
            while true; do
    read -p "Voulez-vous que votre utilisateur ait le rôle super-utilisateur pour PostgreSQL (y/n) : " choix

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

        if [ $? -eq 0 ]; then
            echo -e "\n${GREEN}Utilisateur PostgreSQL '$name' créé avec succès.${NC}\n"
        else
            echo -e "${RED}Erreur lors de la création de l’utilisateur PostgreSQL.${NC}"
            exit 1
        fi

        echo -e "\n${GREEN}Installation et configuration PostgreSQL terminées avec succès !${NC}"
        sleep 3
        break  # Sort de la boucle si le choix était valide

    else
        echo -e "${RED}Choix invalide. Veuillez entrer 'y' ou 'n'.${NC}"
    fi
done


fi
