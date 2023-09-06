output "endpoints" {
  value = <<EOF

  vault_1 (${aws_instance.vault-transit.public_ip}) | internal: (${aws_instance.vault-transit.private_ip})

    - Transit node
    
  vault_2 (${aws_instance.vault-server[0].public_ip}) | internal: (${aws_instance.vault-server[0].private_ip})

    - Leader of Vault cluster

    ssh -l ubuntu ${aws_instance.vault-server[0].public_ip} -i ~/Saved/jeremyaranas.cer

    Root token:

    ssh -l ubuntu ${aws_instance.vault-server[0].public_ip} -i ${var.key_name}.pem "cat ~/root_token"

    Recovery key:
    
    ssh -l ubuntu ${aws_instance.vault-server[0].public_ip} -i ${var.key_name}.pem "cat ~/recovery_key"

  vault_3 (${aws_instance.vault-server[1].public_ip}) | internal: (${aws_instance.vault-server[1].private_ip})

    - Need to join to vault_2

    ssh -l ubuntu ${aws_instance.vault-server[1].public_ip} -i ~/Saved/jeremyaranas.cer

  vault_4 (${aws_instance.vault-server[2].public_ip}) | internal: (${aws_instance.vault-server[2].private_ip})

    - Need to join to vault_2

    ssh -l ubuntu ${aws_instance.vault-server[2].public_ip} -i ~/Saved/jeremyaranas.cer
EOF
}
