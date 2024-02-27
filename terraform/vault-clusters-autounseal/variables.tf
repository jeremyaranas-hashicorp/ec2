variable "aws_region" {
  default = "us-east-1"
}

variable "availability_zones" {
  default = "us-east-1a"
}

variable "environment_name" {
  default = "vault-ec2"
}

variable "vault_primary_names" {
  type = list(string)
  default = [ "primary_1", "primary_2", "primary_3" ]
}

variable "vault_primary_private_ips" {
  type = list(string)
  default = [ "10.0.101.21", "10.0.101.22", "10.0.101.23" ]
}

variable "vault_secondary_names" {
  type = list(string)
  default = [ "secondary_1", "secondary_2", "secondary_3" ]
}

variable "vault_secondary_private_ips" {
  type = list(string)
  default = [ "10.0.101.24", "10.0.101.25", "10.0.101.26" ]
}

# URL for Vault OSS binary
variable "vault_zip_file" {
  default = "https://releases.hashicorp.com/vault/1.15.0+ent/vault_1.15.0+ent_linux_amd64.zip"
}

# Instance size
variable "instance_type" {
  default = "t2.micro"
}

# SSH key name to access EC2 instances in the AWS region 
variable "key_name" {
}