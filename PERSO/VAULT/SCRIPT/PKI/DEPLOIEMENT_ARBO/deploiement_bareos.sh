#!/bin/bash

# ===============================================================
# ========== CRÉATION ARBORESCENCE SSL — BAREOS 192.168.0.240 ===
# ===============================================================

set -e

base="/etc/bareos/ssl"

# === Création de l'arborescence ===
mkdir -p "$base"/ca
mkdir -p "$base"/cert/{dir,fd,post,web}
mkdir -p "$base"/cert/sd/{local,remote}
mkdir -p "$base"/cert/client/{win,lin}
mkdir -p "$base"/keys/{dir,fd,post,web}
mkdir -p "$base"/keys/sd/{local,remote}
mkdir -p "$base"/keys/client/{win,lin}
mkdir -p "$base"/web

# === Propriétaire et droits — racine ===
chown bareos:bareos "$base"
chmod 2775          "$base"

# === ca ===
chown bareos:bareos "$base/ca"
chmod 2775          "$base/ca"

# === cert ===
chown bareos:bareos "$base/cert"
chmod 2775          "$base/cert"

for d in dir fd post web; do
    chown bareos:bareos "$base/cert/$d"
    chmod 2775          "$base/cert/$d"
done

chown root:bareos   "$base/cert/sd"
chmod 2775          "$base/cert/sd"
chown bareos:bareos "$base/cert/sd/local"
chmod 2775          "$base/cert/sd/local"
chown bareos:bareos "$base/cert/sd/remote"
chmod 2775          "$base/cert/sd/remote"

chown bareos:bareos "$base/cert/client"
chmod 2775          "$base/cert/client"
chown bareos:bareos "$base/cert/client/win"
chmod 2775          "$base/cert/client/win"
chown bareos:bareos "$base/cert/client/lin"
chmod 2775          "$base/cert/client/lin"

# === keys ===
chown bareos:bareos "$base/keys"
chmod 2775          "$base/keys"

for d in dir fd post web; do
    chown bareos:bareos "$base/keys/$d"
    chmod 2775          "$base/keys/$d"
done

chown bareos:bareos "$base/keys/sd"
chmod 2775          "$base/keys/sd"
chown bareos:bareos "$base/keys/sd/local"
chmod 2775          "$base/keys/sd/local"
chown bareos:bareos "$base/keys/sd/remote"
chmod 2775          "$base/keys/sd/remote"

chown bareos:bareos "$base/keys/client"
chmod 2775          "$base/keys/client"
chown bareos:bareos "$base/keys/client/win"
chmod 2775          "$base/keys/client/win"
chown bareos:bareos "$base/keys/client/lin"
chmod 2775          "$base/keys/client/lin"

# === web (PEM combiné WebUI) ===
chown bareos:bareos "$base/web"
chmod 2775          "$base/web"

echo "Arborescence Bareos créée et droits appliqués"
