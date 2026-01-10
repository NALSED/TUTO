# 🤖 Installation et Configuration  d''un model Ai en Local. 🤖

---

##  1️⃣ 🥼 Labo + Solution 🥼

* #### `Labo`
    * #### RTX 4080super VRAM 16GB
    * #### i9 13900kf
    * #### 64 GB ddr5 4800

* #### `Solution`
    * #### CUDA (Compute Unified Device Architecture) : CUDA transforme la carte graphique NVIDIA en superprocesseur parallèle capable d’effectuer des milliers d’opérations en même temps.
    * #### Ollama Ollama est une plateforme et un outil conçu pour faciliter l’utilisation des grands modèles de langage (LLM) en local sur ton ordinateur.
    * #### DeepSeek Coder 6.7B : est un modèle de langage spécialisé dans la génération de code informatique, la configuration système, l’administration réseau, le DevOps.
    * #### OpenWebUI : interface web open-source qui permet d’interagir facilement avec des modèles de langage locaux (LLM) via un navigateur.

  ---
# 2️⃣ 💾 installation 💾

* ## 1) `CUDA`
#### [Télécharger](https://developer.nvidia.com/cuda-downloads) et installer CUDA.
#### On peux utiliser ces commande pour voir la carte et la version CUDA installée.
      nvidia-smi
      nvcc --version

* ## 2) `Ollama`
[SOURCE](https://www.youtube.com/@AdrienLinuxtricks/search?query=Ollama)
#### [Télécharger]() et installer Ollama.
#### Si besoin changer le chemin d'installation des models =>  Ouvrir  Ollama cliquer sur Settings et changer le chemin

* ## 3) `DeepSeek Coder 6.7B`
[Instaler](https://ollama.com/library/deepseek-coder:6.7b) DeepSeek Coder 6.7B via la commande suivante dans le terminal
         ollama run deepseek-coder:6.7b

<img width="859" height="218" alt="image" src="https://github.com/user-attachments/assets/e6bff45f-bb58-413d-bf8d-7a948b580a67" />


* ## 4) `OpenWebUI`
#### Aller ssur le [site](https://docs.openwebui.com/) et faire l'installation via docker
         docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
#### Se connecter via http://127.0.0.1:3000/
