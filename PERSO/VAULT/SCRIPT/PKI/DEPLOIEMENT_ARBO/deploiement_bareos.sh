#!/bin/bash

# ===============================================================
# ========== CRÉATION ARBORESCENCE SSL — BAREOS 192.168.0.240 ===
# ===============================================================

set -e

base="/etc/bareos/ssl"

# === Création de l'arborescence ===
mkdir -p "$base"/CA
mkdir -p "$base"/Cert/{dir,fd,post,web}
mkdir -p "$base"/Cert/sd/{local,remote}
mkdir -p "$base"/Cert/client/{win,lin}
mkdir -p "$base"/Keys/{dir,fd,post,web}
mkdir -p "$base"/Keys/sd/{local,remote}
mkdir -p "$base"/Keys/client/{win,lin}

# === Propriétaire et droits — racine ===
chown bareos:bareos "$base"
chmod 2775          "$base"

# === CA ===
chown bareos:bareos "$base/CA"
chmod 2775          "$base/CA"

# === Cert ===
chown bareos:bareos "$base/Cert"
chmod 2775          "$base/Cert"

chown bareos:bareos "$base/Cert/dir"
chmod 2775          "$base/Cert/dir"

chown bareos:bareos "$base/Cert/fd"
chmod 2775          "$base/Cert/fd"

chown bareos:bareos "$base/Cert/post"
chmod 2775          "$base/Cert/post"

chown bareos:bareos "$base/Cert/web"
chmod 2775          "$base/Cert/web"

# Cert/sd — root:bareos observé sur machine réelle
chown root:bareos   "$base/Cert/sd"
chmod 2775          "$base/Cert/sd"
chown bareos:bareos "$base/Cert/sd/local"
chmod 2775          "$base/Cert/sd/local"
chown bareos:bareos "$base/Cert/sd/remote"
chmod 2775          "$base/Cert/sd/remote"

chown bareos:bareos "$base/Cert/client"
chmod 2775          "$base/Cert/client"
chown bareos:bareos "$base/Cert/client/win"
chmod 2775          "$base/Cert/client/win"
chown bareos:bareos "$base/Cert/client/lin"
chmod 2775          "$base/Cert/client/lin"

# === Keys ===
chown bareos:bareos "$base/Keys"
chmod 2775          "$base/Keys"

chown bareos:bareos "$base/Keys/dir"
chmod 2775          "$base/Keys/dir"

chown bareos:bareos "$base/Keys/fd"
chmod 2775          "$base/Keys/fd"

chown bareos:bareos "$base/Keys/post"
chmod 2775          "$base/Keys/post"

chown bareos:bareos "$base/Keys/web"
chmod 2775          "$base/Keys/web"

chown bareos:bareos "$base/Keys/sd"
chmod 2775          "$base/Keys/sd"
chown bareos:bareos "$base/Keys/sd/local"
chmod 2775          "$base/Keys/sd/local"
chown bareos:bareos "$base/Keys/sd/remote"
chmod 2775          "$base/Keys/sd/remote"

chown bareos:bareos "$base/Keys/client"
chmod 2775          "$base/Keys/client"
chown bareos:bareos "$base/Keys/client/win"
chmod 2775          "$base/Keys/client/win"
chown bareos:bareos "$base/Keys/client/lin"
chmod 2775          "$base/Keys/client/lin"

echo "Arborescence Bareos créée et droits appliqués"
