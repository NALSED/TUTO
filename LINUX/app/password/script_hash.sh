#!bin/bash

# Hash originel à comparer
read -p 'Entrer le hash :' hash
# Dictionnaire
fichier=
# Type de hash utilisé pour le hash originel
type hash=

#Affiche le fichier, met chaque ligne dans une variable appelé line
cat $fichier | while read line
    do
        #Créer la variable digest, qui sera comparé à hash
        #Cette variable va écrire pour chaque ligne du fichier le hash.
        #-n sypprime le retour à la ligne et awk ne va afficher que la premiere colone
        digest=$(echo -n $line | $type hash | awk '{print $1}')
        if [$digest=$hash]
        then
              echo'bingo le pot de passe est :'$line
              break
        else
              continue
        fi
    done
