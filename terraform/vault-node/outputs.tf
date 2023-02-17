output "endpoints" {
  value = <<EOF

  vault_server (${aws_instance.vault_server[0].public_ip}) | internal: (${aws_instance.vault_server[0].private_ip})
  
    ssh ec2-user@${aws_instance.vault_server[0].public_ip} -i ~/Saved/${var.key_name}.cer
  
EOF
}
