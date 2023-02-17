provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    vault = "~> 3.7.0"
  }
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

resource "aws_instance" "vault_server" {
  count                       = length(var.vault_server_name)
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance_type
  subnet_id                   = module.vault_test_vpc.public_subnets[0]
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.test.id]
  associate_public_ip_address = true
  private_ip                  = var.vault_server_ip[count.index]

  user_data = templatefile("${path.module}/templates/userdata-vault-server.tpl", {
    tpl_vault_node_name          = var.vault_server_name[count.index],
    tpl_vault_storage_path       = "/vault/${var.vault_server_name[count.index]}",
    tpl_vault_zip_file           = var.vault_zip_file,
    tpl_vault_service_name       = "vault-${var.environment_name}",
    tpl_vault_node_address_names = zipmap(var.vault_server_ip, var.vault_server_name)
  })

  tags = {
    Name         = "${var.environment_name}-vault-server-${var.vault_server_name[count.index]}"
    cluster_name = "vault-ec2"
  }

  lifecycle {
    ignore_changes = [ami, tags]
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("~/Saved/${var.key_name}.cer")}"
    host     = self.public_ip
  }

  provisioner "file" {
    source      = "init.sh"
    destination = "/tmp/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/init.sh",
      "/tmp/init.sh",
    ]
  }
}

resource "random_pet" "env" {
  length    = 2
  separator = "_"
}