output "public_ip" {
  value = hcloud_server.minecraft_server.ipv4_address
}

output "ssh_private_key" {
  value = tls_private_key.ssh.private_key_pem
}

output "ssh_public_key" {
  value = tls_private_key.ssh.public_key_openssh
}
