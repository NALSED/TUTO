#!/bin/bash

# ===============================================================
# ========== CRÉATION ARBORESCENCE SSL — DNS 192.168.0.241 =======
# ===============================================================

set -e

# === Pihole ===
mkdir -p /etc/pihole/ssl/{ca,cert,keys}

chown root:root     /etc/pihole/ssl
chmod 755           /etc/pihole/ssl
chown sednal:sednal /etc/pihole/ssl/ca
chmod 755           /etc/pihole/ssl/ca
chown sednal:sednal /etc/pihole/ssl/cert
chmod 755           /etc/pihole/ssl/cert
chown sednal:sednal /etc/pihole/ssl/keys
chmod 755           /etc/pihole/ssl/keys

# === Upsnap ===
mkdir -p /etc/upsnap/ssl/{ca,cert,keys}

chown root:root     /etc/upsnap/ssl
chmod 755           /etc/upsnap/ssl
chown sednal:sednal /etc/upsnap/ssl/ca
chmod 755           /etc/upsnap/ssl/ca
chown sednal:sednal /etc/upsnap/ssl/cert
chmod 755           /etc/upsnap/ssl/cert
chown sednal:sednal /etc/upsnap/ssl/keys
chmod 755           /etc/upsnap/ssl/keys

# === Cockpit ===
mkdir -p /etc/cockpit/ssl/{ca,cert,keys}

chown root:root     /etc/cockpit/ssl
chmod 755           /etc/cockpit/ssl
chown sednal:sednal /etc/cockpit/ssl/ca
chmod 755           /etc/cockpit/ssl/ca
chown sednal:sednal /etc/cockpit/ssl/cert
chmod 755           /etc/cockpit/ssl/cert
chown sednal:sednal /etc/cockpit/ssl/keys
chmod 755           /etc/cockpit/ssl/keys

echo "Arborescence DNS créée et droits appliqués "
