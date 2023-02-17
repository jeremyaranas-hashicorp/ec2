provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon-linux-2" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_instance" "primary" {
  count                       = length(var.vault_primary_names)
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance_type
  subnet_id                   = module.vault_test_vpc.public_subnets[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [ aws_security_group.test.id ]
  associate_public_ip_address = true
  private_ip                  = var.vault_primary_private_ips[count.index]

  user_data = templatefile("${path.module}/templates/userdata-vault-primary.tpl", {
    tpl_vault_node_name = var.vault_primary_names[count.index],
    tpl_vault_storage_path = "/vault/${var.vault_primary_names[count.index]}",
    tpl_vault_zip_file = var.vault_zip_file,
    tpl_vault_service_name = "vault-${var.environment_name}",
    tpl_vault_node_address_names = zipmap(var.vault_primary_private_ips, var.vault_primary_names)
  })

  tags = {
    Name = "${var.environment_name}-vault-server-${var.vault_primary_names[count.index]}"
    cluster_name = "vault-ec2"
  }

  lifecycle {
    ignore_changes = [ami, tags]
  }
}

resource "aws_instance" "secondary" {
  count                       = length(var.vault_secondary_names)
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance_type
  subnet_id                   = module.vault_test_vpc.public_subnets[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [ aws_security_group.test.id ]
  associate_public_ip_address = true
  private_ip                  = var.vault_secondary_private_ips[count.index]

  user_data = templatefile("${path.module}/templates/userdata-vault-secondary.tpl", {
    tpl_vault_node_name = var.vault_secondary_names[count.index],
    tpl_vault_storage_path = "/vault/${var.vault_secondary_names[count.index]}",
    tpl_vault_zip_file = var.vault_zip_file,
    tpl_vault_service_name = "vault-${var.environment_name}",
    tpl_vault_node_address_names = zipmap(var.vault_secondary_private_ips, var.vault_secondary_names)
  })

  tags = {
    Name = "${var.environment_name}-vault-server-${var.vault_secondary_names[count.index]}"
    cluster_name = "vault-ec2"
  }

  lifecycle {
    ignore_changes = [ami, tags]
  }
}

resource "random_pet" "env" {
  length    = 2
  separator = "_"
}