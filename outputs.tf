output "server_address" {
  value = hcloud_server.minecraft_server.ipv4_address
}

output "private_ssh_key" {
  value = tls_private_key.ssh.private_key_pem
}

output "public_ssh_key" {
  value = tls_private_key.ssh.public_key_openssh
}
