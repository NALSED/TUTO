après installation

-1. `vault --version`

      Vault v1.21.3 (f4f0f4eb7f467bbc99ec89121e1d1ad9c3d78558), built 2026-02-03T14:56:30Z

-2. `sudo systemctl start vault`

      Key                Value
      ---                -----
      Seal Type          shamir
      Initialized        false
      Sealed             true
      Total Shares       0
      Threshold          0
      Unseal Progress    0/0
      Unseal Nonce       n/a
      Version            1.21.3
      Build Date         2026-02-03T14:56:30Z
      Storage Type       file
      HA Enabled         false

-3. `vault status`
     
      Key                Value
      ---                -----
      Seal Type          shamir
      Initialized        false
      Sealed             true
      Total Shares       0
      Threshold          0
      Unseal Progress    0/0
      Unseal Nonce       n/a
      Version            1.21.3
      Build Date         2026-02-03T14:56:30Z
      Storage Type       file
      HA Enabled         false


-4. `vault operator init` puis `vault operato unseal` x3     

      Unseal Key (will be hidden):
      Key             Value
      ---             -----
      Seal Type       shamir
      Initialized     true
      Sealed          false
      Total Shares    5
      Threshold       3
      Version         1.21.3
      Build Date      2026-02-03T14:56:30Z
      Storage Type    file
      Cluster Name    vault-cluster-f8c587b4
      Cluster ID      c5c591a9-1daa-7f5d-6a12-4fba70d9ac5e
      HA Enabled      false






      
