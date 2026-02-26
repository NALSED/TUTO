#!/bin/bash

set -e

# === INFRA === 
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.239:/etc/infra/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.239:/etc/infra/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.239:/etc/infra/ssl/keys

# === BAREOS === 
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos /etc/vault/test sednal@192.168.0.240:/etc/bareos/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos /etc/vault/test sednal@192.168.0.240:/etc/bareos/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=bareos:bareos /etc/vault/test sednal@192.168.0.240:/etc/bareos/ssl/keys


# === DNS === 
# PIHOLE
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/pihole/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/pihole/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/pihole/ssl/keys

# UPSANP
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/upsnap/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/upsnap/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/upsnap/ssl/keys

#COCKPIT
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/cockpit/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/cockpit/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=sednal:sednal /etc/vault/test sednal@192.168.0.241:/etc/cockpit/ssl/keys

# === PROMOX === 
rsync -e ssh --no-p --chmod=F644 --chown=root:root /etc/vault/test sednal@192.168.0.242:/etc/proxmox/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=root:root /etc/vault/test sednal@192.168.0.242:/etc/proxmox/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=root:root /etc/vault/test sednal@192.168.0.242:/etc/proxmox/ssl/keys


# === VPS === 
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian /etc/vault/test debian@176.31.163.227:/etc/vps/ssl/ca
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian /etc/vault/test debian@176.31.163.227:/etc/vps/ssl/cert
rsync -e ssh --no-p --chmod=F644 --chown=debian:debian /etc/vault/test debian@176.31.163.227:/etc/vps/ssl/keys

