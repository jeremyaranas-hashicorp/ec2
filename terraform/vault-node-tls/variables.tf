variable "aws_region" {
  default = "us-east-1"
}

variable "availability_zones" {
  default = "us-east-1a"
}

variable "environment_name" {
  default = "vault-ec2"
}

variable "vault_server_name" {
  type    = list(string)
  default = ["vault_server"]
}

variable "vault_server_ip" {
  type    = list(string)
  default = ["10.0.101.21"]
}

# URL for Vault OSS binary
variable "vault_zip_file" {
  default = "https://releases.hashicorp.com/vault/1.15.3+ent/vault_1.15.3+ent_linux_amd64.zip"
}

# Instance size
variable "instance_type" {
  default = "t2.micro"
}

# SSH key name to access EC2 instances in the AWS region 
variable "key_name" {
}
