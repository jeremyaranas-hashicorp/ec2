#!/usr/bin/env bash

sleep 120
export VAULT_ADDR=http://127.0.0.1:8200
vault operator init -key-shares=1 -key-threshold=1 -format=json > /home/ec2-user/init.json
export VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" /home/ec2-user/init.json)
vault operator unseal $VAULT_UNSEAL_KEY
export VAULT_ROOT_TOKEN=$(jq -r ".root_token" /home/ec2-user/init.json)
vault login $VAULT_ROOT_TOKEN