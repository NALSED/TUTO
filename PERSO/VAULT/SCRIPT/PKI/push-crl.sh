#!/bin/bash

curl -s https://vault.sednal.lan:8200/v1/PKI_Sednal_Root_RSA/crl \
    -o /tmp/root_r.crl
curl -s https://vault.sednal.lan:8200/v1/PKI_Sednal_Root_ECDSA/crl \
    -o /tmp/root_e.crl
curl -s https://vault.sednal.lan:8200/v1/PKI_Sednal_Inter_RSA/crl \
    -o /tmp/intermediate_r.crl
curl -s https://vault.sednal.lan:8200/v1/PKI_Sednal_Inter_ECDSA/crl \
    -o /tmp/intermediate_e.crl

scp /tmp/root_r.crl /tmp/root_e.crl \
    /tmp/intermediate_r.crl /tmp/intermediate_e.crl \
    sednal@infra.sednal.lan:/var/www/pki/
