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

resource "random_id" "server_id" {
  byte_length = 4
}

locals {
  server_id = random_id.server_id.hex
}

module "minecraft-node" {
  source = "../../modules/minecraft-node"

  server_name  = "minecraft-${local.server_id}"
  network_name = "minecraft-network-${local.server_id}"
  server_image = var.server_image
  server_type  = var.server_type
  location     = var.location
  ssh_key_name = var.ssh_key_name

  hcloud_token = var.hcloud_token
}

