# Create Vault Nodes on EC2
---

This will spin up 6 Vault nodes (3 for primary cluster and 3 for secondary cluster)

1. Set your AWS credentials
2. Update `terraform.tfvars` and specify the `key_name`, be sure to set the correct
    [key
    pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
    name created in the AWS region that you are using
3.  Run Terraform commands to provision your cloud resources

    `terraform init`
    `terraform plan`
    `terraform apply -auto-approve`

# Clean Up Cloud Resources

`terraform destroy -auto-approve`

# How to Use

1. SSH to primary_1 and initialize and unseal Vault

`export VAULT_ADDR=http://127.0.0.1:8200`
`vault operator init \
    -key-shares=1 \
    -key-threshold=1 \
    -format=json > cluster-keys.json`

`VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" cluster-keys.json)`
`vault operator unseal $VAULT_UNSEAL_KEY`

`VAULT_ROOT_TOKEN=$(jq -r ".root_token" cluster-keys.json)`
`vault login $VAULT_ROOT_TOKEN`

2. SSH to primary_2 and primary_3 
3. Add primary_2 and primary_3 to cluster `vault operator raft join http://primary_1:8200`
4. Unseal primary_2 and primary_3 with unseal key `vault operator unseal <key>`
5. Run `vault operator raft list-peers` to confirm cluster has been created
6. Repeat for secondary