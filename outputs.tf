output "instance_public_ip" {
  value = aws_eip.minecraft.public_ip
}

output "instance_private_ip" {
  value = aws_instance.minecraft.private_ip
}


output "ssh_private_key_pem" {
  value = tls_private_key.ssh.private_key_pem
}

output "ssh_public_key_pem" {
  value = tls_private_key.ssh.public_key_pem
}