output "endpoints" {
  value = <<EOF

  primary_1 (${aws_instance.primary[0].public_ip}) | internal: (${aws_instance.primary[0].private_ip})
  
    ssh ec2-user@${aws_instance.primary[0].public_ip} -i ~/Saved/${var.key_name}.cer
   
  primary_2 (${aws_instance.primary[1].public_ip}) | internal: (${aws_instance.primary[1].private_ip})
   
    ssh ec2-user@${aws_instance.primary[1].public_ip} -i ~/Saved/${var.key_name}.cer

  primary_3 (${aws_instance.primary[2].public_ip}) | internal: (${aws_instance.primary[2].private_ip})
    
    ssh ec2-user@${aws_instance.primary[2].public_ip} -i ~/Saved/${var.key_name}.cer

  secondary_1 (${aws_instance.secondary[0].public_ip}) | internal: (${aws_instance.secondary[0].private_ip})

    ssh ec2-user@${aws_instance.secondary[0].public_ip} -i ~/Saved/${var.key_name}.cer

  secondary_2 (${aws_instance.secondary[1].public_ip}) | internal: (${aws_instance.secondary[1].private_ip})
    
    ssh ec2-user@${aws_instance.secondary[1].public_ip} -i ~/Saved/${var.key_name}.cer
  
  secondary_3 (${aws_instance.secondary[2].public_ip}) | internal: (${aws_instance.secondary[2].private_ip})
  
    ssh ec2-user@${aws_instance.secondary[2].public_ip} -i ~/Saved/${var.key_name}.cer
EOF
}
