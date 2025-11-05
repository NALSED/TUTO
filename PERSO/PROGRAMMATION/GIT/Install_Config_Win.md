# Installation et configuration de Git sur Windows 11.

---

[LIENS INSTALLATION](https://git-scm.com/install/windows)

---

## 1️⃣ `Installation GIT`

#### 1.1) Options ⬇️

<img width="492" height="383" alt="image" src="https://github.com/user-attachments/assets/9e702251-6c6b-4ca6-a9e4-7278badddd80" />

#### 1.2) Editeur ⬇️
#### `Use Visual Studio Code as Git's default editor`

#### 1.3) Branch

<img width="491" height="383" alt="image" src="https://github.com/user-attachments/assets/7a44b3de-613b-4bff-812a-c05268b4ad15" />

#### 1.4) Path

<img width="493" height="387" alt="image" src="https://github.com/user-attachments/assets/820e90d1-f033-4e92-97e6-1428b4eb70d6" />

#### 1.5) SSH
#### `Use bundled OpenSSH`

#### 1.6) SSH suite
#### `Use the OpenSSL library`

#### 1.7) `Line ending`

<img width="492" height="385" alt="image" src="https://github.com/user-attachments/assets/5124c417-b9ff-47a3-8db6-6d926d5c079f" />

> Cette option change le caractère invisible utilisé en fin de ligne qui est le CRLF pour Windows ("\r\n") et le LF pour Linux et Mac ("\n").
Sur un projet de groupe, avec des contributeurs pouvant avoir des OS différents, il est souvent préférable de configurer git localement pour faire des commits de type LF. Pour ce qui est du checkout, le "as-is" permettra d'éviter d'avoir des erreurs sur toutes les lignes sous Windows si un linter est configuré pour demander des fins de ligne en LF.
