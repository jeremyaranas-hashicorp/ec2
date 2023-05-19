#!/usr/bin/env bash

echo "Updating permissions"
# # RHEL
# sudo chmod 755 /home/ec2-user/
# Ubuntu
sudo chmod 755 /home/ubuntu/
# # RHEL
# chmod 744 /home/ec2-user/certs/vault-primary.vaultsupport.local.key
# Ubuntu
chmod 744 /home/ubuntu/certs/vault-primary.vaultsupport.local.key
echo "Setting VAULT_ADDR"
export VAULT_ADDR=https://127.0.0.1:8200
echo "Starting Vault service"
sudo systemctl start vault
echo "Wait 30 seconds"
sleep 30
echo "Initializing Vault"
# # RHEL
# vault operator init -key-shares=1 -key-threshold=1 -format=json > /home/ec2-user/init.json
# Ubuntu
vault operator init -key-shares=1 -key-threshold=1 -format=json > /home/ubuntu/init.json
echo "Unsealing Vault"
# # RHEL
# export VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" /home/ec2-user/init.json)
# Ubuntu
export VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" /home/ubuntu/init.json)
vault operator unseal $VAULT_UNSEAL_KEY
echo "Logging in with root token"
# # RHEL
# export VAULT_ROOT_TOKEN=$(jq -r ".root_token" /home/ec2-user/init.json)
# Ubuntu
export VAULT_ROOT_TOKEN=$(jq -r ".root_token" /home/ubuntu/init.json)
vault login $VAULT_ROOT_TOKEN