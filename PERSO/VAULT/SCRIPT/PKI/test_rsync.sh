#!/bin/bash

set -e

# === INFRA === 
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.239:/etc/infra/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.239:/etc/infra/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.239:/etc/infra/ssl/keys
echo "rsync sur infra ok"

# === BAREOS === 
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos /etc/vault/test sednal@192.168.0.240:/etc/bareos/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos /etc/vault/test sednal@192.168.0.240:/etc/bareos/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos /etc/vault/test sednal@192.168.0.240:/etc/bareos/ssl/keys
echo "rsync sur bareos ok"

# === DNS === 
# PIHOLE
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/pihole/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/pihole/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/pihole/ssl/keys
echo "rsync sur pihole ok"

# UPSANP
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/upsnap/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/upsnap/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/upsnap/ssl/keys
echo "rsync sur upsnap ok"

#COCKPIT
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/cockpit/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/cockpit/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/cockpit/ssl/keys
echo "rsync sur cockpit ok"

# === PROMOX === 
rsync -e ssh --no-p --chmod=F644 --chown=root:root /etc/vault/test sednal@192.168.0.242:/etc/proxmox/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=root:root /etc/vault/test sednal@192.168.0.242:/etc/proxmox/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=root:root /etc/vault/test sednal@192.168.0.242:/etc/proxmox/ssl/keys
echo "rsync sur proxmox ok"

# === VPS === 
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian /etc/vault/test debian@176.31.163.227:/etc/vps/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian /etc/vault/test debian@176.31.163.227:/etc/vps/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian /etc/vault/test debian@176.31.163.227:/etc/vps/ssl/keys
echo "rsync sur vps ok"
