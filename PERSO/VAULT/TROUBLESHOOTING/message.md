### Liste de message qui empéche la conection à vault_auto et leurs résolution

probléme d'adresse ou nom de domaine

`Error authenticating: error looking up token: Get "https://127.0.0.1:8200/v1/auth/token/lookup-self": dial tcp 127.0.0.1:8200: connect: connection refused`


=== Solution ==
      
      export VAULT_ADDR="https://vault_2.sednal.lan:8100"

---

probléme de CA

`Error authenticating: error looking up token: Get "https://vault_2.sednal.lan:8100/v1/auth/token/lookup-self": tls: failed to verify certificate: x509: certificate signed by unknown authority`

=== Solution ==

      export VAULT_CACERT="/home/sednal/Vault/Vault_Auto/Cert/public/CA.crt"
