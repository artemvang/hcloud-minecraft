output "public_ip" {
  value = hcloud_server.minecraft_node.ipv4_address
}

output "node_id" {
  value = hcloud_server.minecraft_node.id
}

output "ssh_private_key" {
  value       = tls_private_key.ssh.private_key_pem
  description = "The private SSH key to minecraft server"
  sensitive   = true
}

output "ssh_public_key" {
  value = tls_private_key.ssh.public_key_openssh
}

