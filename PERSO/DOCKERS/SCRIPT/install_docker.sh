#!/bin/bash

#mise en place dudépot docker
sudo apt install -y ca-certificates curl  gnupg

#Créer un répertoir
sudo mkdir -m 0755 -p /etc/apt/keyrings

#Récupére la clé gpg de docker
sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

#droits
sudo chmod a+r /etc/apt/keyrings/docker.gpg


echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


#instalation docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
