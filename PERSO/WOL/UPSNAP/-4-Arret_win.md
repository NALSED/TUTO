# Shutdown Win 11

---

#### Configuration du systeme Windows 11 (192.168.0.235) et Linux (192.168.0.241) pour pouvoir éteindre Win 11 avec Upsnap.

---

### 1️⃣ Vérifier sshd (sur 192.168.0.235)

        Get-Service sshd

<img width="433" height="69" alt="image" src="https://github.com/user-attachments/assets/bf8f25c2-e11c-4971-ad68-468e188e0569" />

### 2️⃣ Vérifier les droit Administreur

#### Pour exécuter la commande à distance d'extinction, un utilisateur faisant partie du groupe admin ou un administrateur doit être présent et configuré sur le systeme Win 11.

#### 2.1) Utilisateur présent 

        Get-LocalUser

<img width="607" height="122" alt="image" src="https://github.com/user-attachments/assets/629149a0-1ad1-4755-be30-5e94e463158b" />

#### `sednal` existe et est actif, mais ce n’est PAS un administrateur.

#### 2.2) Activer `sednal` en Admin (Avec Powershell en Administrateur)























