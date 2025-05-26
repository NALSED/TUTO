# Ce fichier permet de recevoir des alerte par mail de l'état de bareos,, si non configuré, erreur bareos-dir
        
        
        
        
        
        
        Messages {
        Name = Standard
        Description = "Reasonable message delivery -- send most everything to email address and to the console."
        operatorcommand = "/usr/bin/bsmtp -h localhost -f \"\(Bareos\) \<landes_martin@yahoo.fr>\" -s \"Bareos: Intervention needed for %j\" %r"
        mailcommand = "/usr/bin/bsmtp -h localhost -f \"\(Bareos\) \<landes_martin@yahoo.fr>\" -s \"Bareos: %t %e of %c %l\" %r"
        operator = root = mount
        mail = root = all, !skipped, !saved, !audit
        console = all, !skipped, !saved, !audit
        append = "/var/log/bareos/bareos.log" = all, !skipped, !saved, !audit
        catalog = all, !skipped, !saved, !audit
      }

