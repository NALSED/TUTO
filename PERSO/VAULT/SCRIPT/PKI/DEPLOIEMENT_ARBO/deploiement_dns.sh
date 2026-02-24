#!/bin/bash

# ===============================================================
# ========== CRÉATION ARBORESCENCE SSL — DNS 192.168.0.241 =======
# ===============================================================

set -e

# === Création de l'arborescence ===
mkdir -p /etc/ssl/CA
mkdir -p /etc/ssl/Pihole/{Cert,Keys}
mkdir -p /etc/ssl/Upsnap/{Cert,Keys}
mkdir -p /etc/ssl/Cockpit/{Cert,Keys}

# === CA ===
chown sednal:sednal /etc/ssl/CA
chmod 755           /etc/ssl/CA

# === Pihole ===
chown root:root     /etc/ssl/Pihole
chmod 755           /etc/ssl/Pihole
chown sednal:sednal /etc/ssl/Pihole/Cert
chmod 755           /etc/ssl/Pihole/Cert
chown sednal:sednal /etc/ssl/Pihole/Keys
chmod 755           /etc/ssl/Pihole/Keys

# === Upsnap ===
chown root:root     /etc/ssl/Upsnap
chmod 755           /etc/ssl/Upsnap
chown sednal:sednal /etc/ssl/Upsnap/Cert
chmod 755           /etc/ssl/Upsnap/Cert
chown sednal:sednal /etc/ssl/Upsnap/Keys
chmod 755           /etc/ssl/Upsnap/Keys

# === Cockpit ===
chown root:root     /etc/ssl/Cockpit
chmod 755           /etc/ssl/Cockpit
chown sednal:sednal /etc/ssl/Cockpit/Cert
chmod 755           /etc/ssl/Cockpit/Cert
chown sednal:sednal /etc/ssl/Cockpit/Keys
chmod 755           /etc/ssl/Cockpit/Keys

echo "Arborescence Pi créée et droits appliqués "
