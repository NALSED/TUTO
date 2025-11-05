# Installation et configuration de Git sur Windows 11.

---

[LIENS INSTALLATION](https://git-scm.com/install/windows)

---

# 1️⃣ `Installation GIT`

### 1.1) Options ⬇️

<img width="492" height="383" alt="image" src="https://github.com/user-attachments/assets/9e702251-6c6b-4ca6-a9e4-7278badddd80" />

## 1.2) Editeur ⬇️
#### `Use Visual Studio Code as Git's default editor`

## 1.3) Branch

<img width="491" height="383" alt="image" src="https://github.com/user-attachments/assets/7a44b3de-613b-4bff-812a-c05268b4ad15" />

## 1.4) Path

<img width="493" height="387" alt="image" src="https://github.com/user-attachments/assets/820e90d1-f033-4e92-97e6-1428b4eb70d6" />

## 1.5) SSH
#### `Use bundled OpenSSH`

## 1.6) SSH suite
#### `Use the OpenSSL library`

## 1.7) `Line ending`

<img width="492" height="385" alt="image" src="https://github.com/user-attachments/assets/5124c417-b9ff-47a3-8db6-6d926d5c079f" />

> Cette option change le caractère invisible utilisé en fin de ligne qui est le CRLF pour Windows ("\r\n") et le LF pour Linux et Mac ("\n").
Sur un projet de groupe, avec des contributeurs pouvant avoir des OS différents, il est souvent préférable de configurer git localement pour faire des commits de type LF. Pour ce qui est du checkout, le "as-is" permettra d'éviter d'avoir des erreurs sur toutes les lignes sous Windows si un linter est configuré pour demander des fins de ligne en LF.

## 1.8) Terminal
#### `Use MinTTY (the default terminal of MSYS2)`

## 1.9) Git Pull
#### `fast-forward or merge`

## 1.10) Credential Helper
#### `None`

## 1.11) Extra Options

<img width="492" height="386" alt="image" src="https://github.com/user-attachments/assets/df2a81e4-b32f-4dc9-97d2-c5600ff8f069" />


---
---

## 2️⃣ `Configuration GIT`

## 2.1) renseigner Nom + Mail (identique que ceux dans GitHub)
#### Renseigner nom d'utilisateur: git config --global user.name "FIRST_NAME LAST_NAME"
#### Renseigne email : git config --global user.email "MY_NAME@example.com"
      git config --global pull.rebase false
      git config --global init.defaultBranch main
  
## 3️⃣ `VSCode + GIT`(en développement depuis WSL)

## 3.1) Ouvrir le projet dans VSCode.

<img width="939" height="389" alt="image" src="https://github.com/user-attachments/assets/d5c5348c-4214-4fbe-b157-b848a6de3340" />

## 3.2) Dans le dossier du programme
      git init
      git branch -M main

## 3.3) Clé SSH
      ssh-keygen -t ed25519 -C "MAIL@github.com"
      cat ~/.ssh/id_ed25519.pub
      
#### Copier la clé sur Github [ICI](https://github.com/NALSED/TUTO/settings/keys/new)

## 3.4) Ajouter les fichiers
      git add .

## 3.5) Commit
      git commit -m "TEXT"

#### ⚠️ Créer le repository ⚠️

## 3.6) Lier le projet au compte GitHub
      git remote add origin https://github.com/[USER]/gcert.git


## 3.7) Envoyer le projet
      git push -u origin main



















































