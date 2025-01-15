Bonjour j'ai plusieurs questions..

Alors hier soir j'ai créer un serveur Plex:

Labo

1) 	OS débian 12 => installé sur un ssd 120Gb (sda)
	Stockage HDD 1To (sdb)
	(Sur un second PC, pas de VM ici)

![image](https://github.com/user-attachments/assets/a8cd78d0-7485-4d34-abb3-4fe4e91b204f)


2) 	Partage mise en place avec plex via NFS

3)	Connection avec Plex en WebUI OK
	  Point de montage OK

4) Il ne me reste plus qu'à transférer les fichier vidéo:
    J'ai formaté un clé USB en NTFS, j'ai copié le dossier de vidéo, mais impossible de créer un point de montage pour la clé

![image](https://github.com/user-attachments/assets/aae7e23e-4d88-47c1-9edb-91a2d6de102b)

quand je tente un point de montage: 

![image](https://github.com/user-attachments/assets/83805b9e-c729-4e61-a1f8-102db0351775)

         fdisk -l /dev/sdc

![image](https://github.com/user-attachments/assets/c66044d8-3847-4101-b83e-921bddcb082b)


        dmesg -W


![image](https://github.com/user-attachments/assets/a7afb0af-4cc4-4b6a-a1a8-1cf3bc3021f0)



5) Alors mes questions sont de savoir si tu as une autre technique pour transférer des fichier vidéo sur le serveur, et si tu a une idée de pourquoi je ne peux pas créer un point de montage pour sdc1.

Si il manque des infos ou autre dit moi, je suis sur mon ordi là.

Merciiiiii


