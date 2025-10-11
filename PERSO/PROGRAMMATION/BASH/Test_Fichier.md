# Tests de fichiers en Bash

## Options de test de fichiers

| Option | Description |
|--------|-------------|
| `-a`   | Le fichier existe. Identique à `-e`. **Déprécié**, son usage est déconseillé. |
| `-b`   | Le fichier est un périphérique en **bloc**. |
| `-c`   | Le fichier est un périphérique de **caractère**. <br>Exemple : `[ -b "/dev/sda2" ]` |
| `-d`   | Le fichier est un **répertoire**. |
| `-e`   | Le fichier **existe**. |
| `-f`   | Le fichier est un fichier **ordinaire** (pas un répertoire ni un périphérique). |
| `-G`   | Le **GID** du fichier est le même que le vôtre. |
| `-g`   | Le bit **set-group-ID (sgid)** est activé sur le fichier ou le répertoire. <br>Si un répertoire a le bit sgid, un fichier créé dedans appartiendra au **groupe** du répertoire. |
| `-h`   | Le fichier est un **lien symbolique**. |
| `-k`   | Le **sticky bit** est activé. |
| `-L`   | Le fichier est un **lien symbolique**. |
| `-N`   | Le fichier a été **modifié** depuis sa dernière lecture. |
| `-O`   | Vous êtes le **propriétaire** du fichier. |
| `-p`   | Le fichier est un **tube (pipe)**. <br>Exemple : `[ -p /dev/fd/0 ]` |
| `-r`   | Le fichier a la permission de **lecture** pour l'utilisateur exécutant le test. |
| `-S`   | Le fichier est un **socket**. |
| `-s`   | Le fichier a une **taille non nulle**. |
| `-t`   | Le descripteur de fichier est associé à un **terminal**. |
| `-u`   | Le bit **set-user-ID (suid)** est activé sur le fichier. |
| `-w`   | Le fichier a la permission d’**écriture** pour l’utilisateur courant. |
| `-x`   | Le fichier a la permission d’**exécution** pour l’utilisateur courant. |

## Comparaison de fichiers

| Option     | Description |
|------------|-------------|
| `f1 -nt f2` | Le fichier `f1` est **plus récent** que `f2`. |
| `f1 -ot f2` | Le fichier `f1` est **plus ancien** que `f2`. |
| `f1 -ef f2` | Les fichiers `f1` et `f2` sont des **liens physiques** (hard links) vers le même fichier. |

## Autres

| Symbole | Description |
|---------|-------------|
| `!`     | **Négation** — inverse le résultat du test (vrai si la condition est fausse). |
