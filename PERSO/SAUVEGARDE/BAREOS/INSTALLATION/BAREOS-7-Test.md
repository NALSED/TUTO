# Test avant sauvegarde :

### Cette commande permet simuler une sauvegarde, sans la faire réelement, elle permet donc de tester la config en condition réel,, et estimer le temps de sauvegarde, par defaut sauvegarde Full
### Voir [TUTO](https://docs.bareos.org/TasksAndConcepts/BareosConsole.html#bareos-console)
        estimate job=<job-name> listing client=<client-name> accurate=<yes|no> fileset=<fileset-name> level=<level-name>
### ⚠️Cette commande fera defiler tous les fichiers!

---

# Ici test des backup mis en place

### une fois le dernier fichier de conf éditer et tester 
    bconsole 
    run => 5
  ![image](https://github.com/user-attachments/assets/e79288b4-a0ef-4d55-9b54-bf7cbae94515)
### ⚠️Si la console ne s'affiche pas, probléme de droit!
       sudo chmod -R u+rw /etc/bareos/bareos-dir.d/ 
       sudo chown -R bareos:bareos /etc/bareos/bareos-dir.d/    
       sudo systemctl restart bareos-dir
### demander la sortie du message   
    message
![image](https://github.com/user-attachments/assets/7c8ed369-0211-4870-81ec-a49ce38523ae)

### Voir leJobId ou la tache qui viens d'être réalisé
        list jobid=13


![image](https://github.com/user-attachments/assets/2bf821f6-267b-4bfd-894f-06d856c67f57)

### Tout semble en ordre, on voit ici 28,294,462 jobytes et 1jobutes = 1 octets donc 274.88 Mo sauvé sur le serveur.

### lister les actions
        status director
![image](https://github.com/user-attachments/assets/52ccbc41-a1de-4b59-a033-c275e4a86fc2)

        
