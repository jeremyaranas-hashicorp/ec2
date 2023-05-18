This repo will spin up a Vault instance in EC2 with TLS enabled. 

This is a fork from https://github.com/hashicorp/learn-vault-raft/tree/main/raft-storage/aws.

`terraform init`
`terraform plan`
`terraform apply -auto-approve`

Once server is up, configure Vault with TLS.

1. ssh to node
2. cd to `/tmp`
3. Run `init.sh`

Vault will initialize and unseal using an init script. The root token and recovery keys will be added to a file called init.json in the home directory.
