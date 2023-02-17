# Create Vault nodes on EC2
---

This will spin up 2 clusters (primary and secondary) with 3 Raft nodes in each cluster. This cluster uses AWS KMS auto-unseal and Raft auto-join. Note that creating a KMS key cost $1 each time. 

1. Set your AWS credentials
2. Update `terraform.tfvars` and specify the `key_name`, be sure to set the correct
    [key
    pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
    name created in the AWS region that you are using
3.  Run Terraform commands to provision your cloud resources

    `terraform init`
    `terraform plan`
    `terraform apply -auto-approve`


* Run `export VAULT_ADDR=http://127.0.0.1:8200` on primary_1 and secondary_1
* Run `vault operator init` on primary_1 and secondary_1 to unseal primary_2, primary_3, secondary_2 and secondary_3
* primary_2, primary_3, secondary_2 and secondary_3 will auto-join cluster
* Login to primary_1 and secondary_1 `vault login <token>`
* Run `vault operator raft list-peers` to view cluster


# Clean Up Cloud Resources

`terraform destroy -auto-approve`


