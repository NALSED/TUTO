## Installation du programme du offre

---

- Ce programme à pour but d'automatiser la recherche d'emploie / alternance.

---

### `-1-` créer dossier et clonner le repo.
````
sudo mkdir -p /opt/offre
sudo chown sednal:sednal /opt/offre
git clone https://github.com/NALSED/offre /opt/offre
cd /opt/offre
cp .env.example .env
````

### `-2-` Ajouter $USER au groupe `docker`
````
usermod -aG docker $USER
````

### `-3-` Générer le token "import secrets"
````
python3 -c "import secrets; print(secrets.token_urlsafe(48))"
````

### -4- Editer le .env
````
vim /opt/offre/.env
````

### -5- Lancer le programme
````
cd /opt/offre
sudo make up
````
