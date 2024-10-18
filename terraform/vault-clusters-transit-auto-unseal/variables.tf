# AWS region and AZs in which to deploy
variable "aws_region" {
  default = "us-east-1"
}

variable "availability_zones" {
  default = "us-east-1a"
}

# All resources will be tagged with this
variable "environment_name" {
  default = "vault-test"
}

variable "vault_transit_private_ip" {
  default = "10.0.101.21"
}

variable "vault_server_names" {
  type = list(string)
  default = [ "vault_2", "vault_3", "vault_4" ]
}

variable "vault_server_private_ips" {
  type = list(string)
  default = [ "10.0.101.22", "10.0.101.23", "10.0.101.24" ]
}

# URL for Vault OSS binary
variable "vault_oss_zip_file" {
  default = "https://releases.hashicorp.com/vault/1.17.3/vault_1.17.3_linux_amd64.zip"
}

# URL for Vault ent binary
variable "vault_ent_zip_file" {
  default = "https://releases.hashicorp.com/vault/1.17.3+ent/vault_1.17.3+ent_linux_amd64.zip"
}


# Instance size
variable "instance_type" {
  default = "t2.micro"
}

# SSH key name to access EC2 instances (should already exist) in the AWS Region
variable "key_name" {
}
