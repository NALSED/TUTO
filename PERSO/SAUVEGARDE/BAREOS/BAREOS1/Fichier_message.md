# Ce fichier permet de recevoir des alerte par mail de l'état de bareos,, si non configuré, erreur bareos-dir
        
        
        
        
        
        
        Messages {
        Name = Standard
        Description = "Reasonable message delivery -- send most everything to email address and to the console."
        operatorcommand = "/usr/bin/bsmtp -h localhost -f \"\(Bareos\) \<MAIL>\" -s \"Bareos: Intervention needed for %j\" %r" # Remplacer MAIL par un adresse mail valide
        mailcommand = "/usr/bin/bsmtp -h localhost -f \"\(Bareos\) \<MAIL>\" -s \"Bareos: %t %e of %c %l\" %r" # Remplacer MAIL par un adresse mail valide
        operator = root = mount
        mail = root = all, !skipped, !saved, !audit
        console = all, !skipped, !saved, !audit
        append = "/var/log/bareos/bareos.log" = all, !skipped, !saved, !audit
        catalog = all, !skipped, !saved, !audit
      }

