terraform {
  required_providers {
    hcloud = {
      source  = "registry.terraform.io/hetznercloud/hcloud"
      version = "1.23.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "admin" {
  name       = var.ssh_key_name
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "hcloud_server" "minecraft_server" {
  name        = var.server_name
  image       = var.server_image
  server_type = var.server_type
  ssh_keys    = [hcloud_ssh_key.admin.id]

  labels = {
    Name = var.server_name
  }
}

resource "hcloud_network" "minecraft_network" {
  name     = var.network_name
  ip_range = var.network_ip_range
}

resource "hcloud_network_subnet" "minecraft_subnetwork" {
  network_id   = hcloud_network.minecraft_network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.subnetwork_ip_range
}

resource "hcloud_server_network" "server_network" {
  server_id = hcloud_server.minecraft_server.id
  subnet_id = hcloud_network_subnet.minecraft_subnetwork.id
  ip        = var.server_local_ip
}

resource "local_file" "ansible_inventory" {
  content = templatefile("./inventory.tmpl",
    {
      ip_addr = hcloud_server.minecraft_server.ipv4_address,
    }
  )
  filename = "./ansible/inventory"
}

resource "local_file" "private_ssh_key" {
  content = tls_private_key.ssh.private_key_pem
  file_permission = "0600"
  filename = "./ssh_keys/id_key"
}

resource "local_file" "public_ssh_key" {
  content = tls_private_key.ssh.public_key_openssh
  filename = "./ssh_keys/id_key.pub"
}
