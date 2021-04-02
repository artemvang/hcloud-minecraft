output "server_id" {
  value = local.server_id
}

output "public_ip" {
  value = module.minecraft-node.public_ip
}

output "ssh_private_key" {
  value       = module.minecraft-node.ssh_private_key
  description = "The private SSH key to minecraft server"
  sensitive   = true
}

output "ssh_public_key" {
  value = module.minecraft-node.ssh_public_key
}
