## Install RTK-AI

---

- `projet` [https://github.com/rtk-ai/rtk](https://github.com/rtk-ai/rtk)

---

-1- Configuration de  `~/.bashrc` / `~/.profile` / Répertoire d'installation.

````
mkdir -p ~/.local/bin
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.profile
````

- Pour plus d'information les causes sont les même que pour `npm` voir => [-2- Configuration User](https://github.com/NALSED/TUTO/blob/main/PERSO/IA/AGENT/-2-%20Install_OpenRouter.md#-2--configuration-user)

-2- Installation 
````
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
````

-3- Création du hook avec Claude
````
rtk init -g
````
