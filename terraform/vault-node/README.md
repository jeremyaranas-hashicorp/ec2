This repo will spin up a Vault instance in EC2. Vault will initialize and unseal using an init script. The root token and recovery keys will be added to a file called init.json in the home directory.

`terraform init`
`terraform plan`
`terraform apply -auto-approve`