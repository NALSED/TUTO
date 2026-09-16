## APT-FILE

- Pour trouver le binaire d'une commande (équivalent de `dnf provide`)
````
# Installer apt-file
sudo apt install -y apt-file

# Update la liste
apt list --upgradable

# Rechercher
apt-list search /usr/bin/etcdctl
# Sortie
etcd-client: /usr/bin/etcdctl

# Donc apt installl -y etcd-client
```` 
