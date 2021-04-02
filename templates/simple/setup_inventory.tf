resource "local_file" "ansible_inventory" {
  content = templatefile("./inventory.tmpl",
    {
      public_ip = module.minecraft-node.public_ip,
      server_id = local.server_id,
    }
  )
  filename = "./ansible/inventory-${local.server_id}"
}

resource "local_file" "private_ssh_key" {
  content = module.minecraft-node.ssh_private_key
  file_permission = "0400"
  filename = "./.ssh_keys/id_key-${local.server_id}"
}
