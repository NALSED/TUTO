#!/bin/bash
# Ce script a pour fonction l'installation de Docker et la mise en place de certificats TLS pour Docker Context.

# Couleurs 
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

clear
echo -e "Script d'installation de Docker et/ou de mise en place de certificats TLS pour Docker Context."

while true; do
    # === Menu principal ===
    clear
    echo -e "${GREEN}========= MENU PRINCIPAL =========${NC}"
    echo -e "  [1] installer Docker"
    echo -e "  [2] Mise en place certificats"
    echo -e "  [3] Quitter"
    echo -e "${GREEN}==================================${NC}\n"

    read choix_top

    case $choix_top in 

        1)
        # Mise en place du dépôt docker
        sudo apt install -y ca-certificates curl gnupg

        # Créer un répertoire
        sudo mkdir -m 0755 -p /etc/apt/keyrings

        # Récupère la clé gpg de docker
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

        # Droits
        sudo chmod a+r /etc/apt/keyrings/docker.gpg

        # Inscrit le dépôt Docker dans les sources APT
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Installation docker
        sudo apt update
        sudo apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        if dpkg -l | grep -q "^ii.*docker"; then
            echo -e "${GREEN}docker installé avec succès${NC}\n"
        else
            echo -e "${RED}docker non installé${NC}"
        fi
        ;;

        2)
        # === Menu secondaire ===
        clear
        echo -e "\n${YELLOW}#####################################################################${NC}"
        echo -e "${YELLOW}##### Mise en place des certificats TLS/SSL pour Docker Context #####${NC}"
        echo -e "${YELLOW}#####################################################################${NC}\n"

        while true; do
           
            echo -e "${GREEN}========= MENU PRINCIPAL =========${NC}"
            echo -e "  [1] Prérequis"
            echo -e "  [2] Commencer l'obtention du certificat"
            echo -e "  [3] Quitter"
            echo -e "${GREEN}==================================${NC}\n"

            read -p "Votre choix : " menu_principal

            case $menu_principal in
                1)
                    # === PRÉREQUIS ===
                    clear
                    echo -e "\n${YELLOW}=========== PRÉREQUIS ===========${NC}\n"
                    echo -e " - Avoir l'IP de la machine cliente (celle qui exécute ce script)"
                    echo -e " - Avoir l'IP de la machine Admin (celle qui utilisera Docker Context)"
                    echo -e " - sudo installé"
                    echo -e " - expect installé"
                    echo -e "${RED}Si un ou plusieurs prérequis manquent, utilisez le menu suivant :${NC}\n"

                    while true; do
                        # === Liste PRÉREQUIS ===
                        echo -e "${GREEN}------ Menu des prérequis ------${NC}"
                        echo -e "  [1] Installer et configurer sudo"
                        echo -e "  [2] Installer expect"
                        echo -e "  [3] Obtenir l'IP de la machine cliente"
                        echo -e "  [4] Revenir au menu principal"
                        echo -e "  [5] Quitter le script"
                        echo -e "${GREEN}-------------------------------${NC}\n"

                        read -p "Votre choix : " choix_menu_2

                        case $choix_menu_2 in
                            # Marche à suivre pour configuration et installation sudo  
                            1)
                                clear
                                echo -e "\n${YELLOW}--- Instructions pour sudo ---${NC}"
                                echo -e "su -"
                                echo -e "apt update"
                                echo -e "apt install sudo"
                                echo -e "usermod -aG sudo [NOM_UTILISATEUR]"
                                echo -e "nano /etc/hosts  # Ajouter : 127.0.1.1 origin"
                                echo -e "${YELLOW}-------------------------------${NC}\n"
                                read -p "Appuyez sur Entrée pour continuer..."
                                ;;
                            # Marche à suivre pour installation expect
                            2)
                                
                                echo -e "expect est un outil en ligne de commande qui automatise, \nles interactions avec des programmes en mode texte qui attendent une saisie de l’utilisateur, comme :\n\no des mots de passe\n\no des confirmations\n\no des données de formulaire\n\n"
                                echo -e "Voulez-vous installer expect ?"
                                echo -e "Tappez ${GREEN}[yes]${NC} pour valider, ou ${RED}[no]${NC} pour annuler"
                                read choice

                                if [[ "$choice" == "yes" || "$choice" == "YES" ]]; then
                                    sudo apt update
                                    sudo apt install expect -y

                                    if dpkg -l | grep -q "^ii.*expect"; then
                                        echo -e "${GREEN}expect installé avec succès${NC}\n"
                                    else
                                        echo -e "${RED}expect non installé${NC}"
                                    fi
                                else
                                    echo -e "${RED}expect non installé (choix utilisateur)${NC}"
                                fi
                                ;;
                            # Affiche l'IP client
                            3)
                                clear
                                ip=$(hostname -I | awk '{print $1}')
                                echo -e "\n${GREEN}Adresse IP de cette machine : $ip${NC}\n"
                                read -p "Appuyez sur Entrée pour continuer..."
                                ;;
                            4)
                                clear
                                echo -e "${YELLOW}Retour au menu principal...${NC}\n"
                                break
                                ;;
                            5)
                                clear 
                               echo -e "${YELLOW}Fermeture du script. À bientôt !${NC}"
                                exit
                                ;;
                            *)
                                echo -e "${RED}Option invalide. Veuillez choisir entre 1 et 5.${NC}\n"
                                ;;
                        esac
                    done
                    ;;


                2)
             
          # Verification que docker est installé
             if dpkg -l | grep -q "^ii.*docker"; then
                echo -e "${GREEN}docker installé.s${NC}\n"
            else
                echo -e "${RED}docker non installé, veuillez installer docker avant de poursuivre, Merci.${NC}"
                break
            fi


             echo -e "\n${GREEN}Début du processus de génération du certificat...${NC}"

            # Fonction de validation IP
            validate_ip() {
                local ip="$1"
                if [[ $ip =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
                    IFS='.' read -r i1 i2 i3 i4 <<< "$ip"
                    if (( i1 <= 255 && i2 <= 255 && i3 <= 255 && i4 <= 255 )); then
                        return 0
                    fi
                fi
                return 1
            }

            # === Saisie IP Client ===
            while true; do
                read -p "Veuillez indiquer l'IP du client : " choix_ip_client
                if validate_ip "$choix_ip_client"; then
                    echo -e "${GREEN}IP client valide${NC}"
                    break
                else
                    echo -e "${RED}IP client invalide, veuillez réessayer.${NC}"
                fi
            done

            # === Saisie IP Admin ===
            while true; do
                read -p "Veuillez indiquer l'IP de l'admin : " choix_ip_admin
                if validate_ip "$choix_ip_admin"; then
                    echo -e "${GREEN}IP admin valide${NC}"
                    if ping -c 1 "$choix_ip_admin" &> /dev/null; then
                        echo -e "${GREEN}Ping réussi vers $choix_ip_admin${NC}"
                    else
                        echo -e "${RED}Ping échoué vers $choix_ip_admin${NC}"
                    fi
                    break
                else
                    echo -e "${RED}IP admin invalide, veuillez réessayer.${NC}"
                fi
            done
            clear
            echo -n "Veuillez indiquer un mot de passe pour les certificats (protège la CA uniquement) : "
            read -s password
            echo -e "\n${GREEN}Mot de passe enregistré.${NC}"

            # Création du dossier
            mkdir -p ~/docker-certs
            cd ~/docker-certs || { echo -e "${RED}Erreur: impossible d'accéder au dossier ~/docker-certs${NC}"; exit 1; }

            # Génération de la clé privée CA avec MDP
            echo "$password" | openssl genrsa -aes256 -passout stdin -out ca-key.pem 4096 || {
                echo -e "${RED}Erreur lors de la génération de la clé CA.${NC}"
                exit 1
            }

            # Génération du certificat CA via expect
expect <<EOF > /dev/null 2>&1
log_user 0
set timeout -1
set password "$password"
spawn openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
expect "Enter pass phrase for ca-key.pem:"
send "$password\r"
expect "Country Name*"
send ".\r"
expect "State or Province Name*"
send ".\r"
expect "Locality Name*"
send ".\r"
expect "Organization Name*"
send ".\r"
expect "Organizational Unit Name*"
send ".\r"
expect "Common Name*"
send "docker\r"
expect "Email Address*"
send ".\r"
expect eof
EOF

            # Génération clé serveur et CSR (NON CHIFFRÉE)
            openssl genrsa -out server-key.pem 4096
            openssl req -subj "/CN=$choix_ip_client" -new -key server-key.pem -out server.csr
            echo "subjectAltName = IP:$choix_ip_client" > extfile.cnf

            # Signature du certificat serveur
expect <<EOF > /dev/null 2>&1
log_user 0
set timeout -1
set password "$password"
spawn openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
expect "Enter pass phrase for ca-key.pem:"
send "$password\r"
expect eof
EOF 

            # Génération clé client et CSR
            openssl genrsa -out key.pem 4096
            openssl req -subj "/CN=client" -new -key key.pem -out client.csr
            echo "extendedKeyUsage = clientAuth" > extfile-client.cnf

            # Signature du certificat client
expect <<EOF > /dev/null 2>&1
log_user 0
set timeout -1
set password "$password"
spawn openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile-client.cnf
expect "Enter pass phrase for ca-key.pem:"
send "$password\r"
expect eof
EOF 

            # Création dossier et copie certs
            sudo mkdir -p /etc/docker/certs
            sudo cp ca.pem server-cert.pem server-key.pem /etc/docker/certs/

            # Sécurisation des fichiers
            sudo chown root:root /etc/docker/certs/*.pem
            sudo chmod 600 /etc/docker/certs/*.pem

            # Écriture du fichier daemon.json
            sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "hosts": ["tcp://$choix_ip_client:2376", "unix:///var/run/docker.sock"],
  "tls": true,
  "tlsverify": true,
  "tlscacert": "/etc/docker/certs/ca.pem",
  "tlscert": "/etc/docker/certs/server-cert.pem",
  "tlskey": "/etc/docker/certs/server-key.pem"
}
EOF
        #Opération importante pour supprimer le conflit de endpoints entre docker.service et /etc/docker/daemon.json
    
    sudo sed -i '/ExecStart/ s/ -H fd:\/\///' /lib/systemd/system/docker.service
            
            # Redémarrage de Docker
            echo -e "${YELLOW}Redémarrage de Docker...${NC}"
            sudo systemctl daemon-reexec
            sudo systemctl restart docker

            # Vérification du statut
       
            if systemctl is-active --quiet docker; then
                echo -e "${GREEN}Docker redémarré avec succès avec TLS/SSL activé.${NC}\n\n"
                
            # Posibilité de copier les certificats sur machine Admin    
                echo -e "Souhaitez vous, copier les certificats sur la machine Admin\n\n" 
                echo -e "Tappez ${GREEN}[yes]${NC} pour valider, ou ${RED}[no]${NC} pour annuler"
                read  choix_transfert

                if [[ "$choix_transfert" == "yes" || "$choix_transfert" == "YES" ]]; then
                
                read -p "Veuillez indiquer un nom d'utilisateur.\n" user 
                read -p "Veuillez indiquer un chemin pour le transfert." chemin                 
                
                sudo scp -r /etc/docker/certs $user@$choix_ip_admin:$chemin
                              
                else
                    echo -e "${RED}Certificats non copiés${NC}"
                    break
                fi
                                
            else
                echo -e "${RED}Docker n'a pas pu redémarrer. Vérifiez les logs :${NC}"
                echo -e "${YELLOW}journalctl -u docker.service -n 50 --no-pager${NC}"
            fi
            ;;


                3)
                    clear
                    echo -e "${YELLOW}Fermeture du script. Merci !${NC}"
                    exit
                    ;;
                *)
                    echo -e "${RED}Option invalide. Merci de choisir une option correcte.${NC}\n"
                    ;;
                    
            esac
        done
        ;;

        3)
        clear
        echo -e "${YELLOW}Fermeture du script. Merci !${NC}"
        exit
        ;;

        *)
        echo -e "${RED}Option invalide. Merci de choisir une option correcte.${NC}\n"
        ;;
    esac
done
