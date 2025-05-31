      so-status
=> Si  ⌛ System appears to be starting. No highstate has completed since the system was restarted.

---
 vérifier le status de salt-minon
       sudo systemctl status salt-minion
       sudo systemctl restart salt-minion

--- 

consulter les logs
      sudo journalctl -u salt-minion 
      cd /var/log/salt/minion








