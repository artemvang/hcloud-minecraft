terraform {
  required_version = "1.0.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.27.2"
    }
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "admin" {
  name       = "minecraft-${var.server_id}"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "hcloud_server" "minecraft_node" {
  name        = "minecraft-node-${var.server_id}"
  image       = var.server_image
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.admin.id]

  labels = {
    Name = "minecraft-node-${var.server_id}"
  }
}

locals {
  public_ip       = hcloud_server.minecraft_node.ipv4_address
  private_ssh_key = tls_private_key.ssh.private_key_pem
}

resource "null_resource" "setup" {
  triggers = {
    minecraft_version = hcloud_server.minecraft_node.id
  }

  connection {
    host        = local.public_ip
    type        = "ssh"
    user        = "root"
    private_key = local.private_ssh_key
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "apt update",
      "apt upgrade -y",
      "apt install -y openjdk-16-jdk screen python3",
      "useradd -m -d /opt/minecraft minecraft || true",
      "pip install --upgrade b2",
      "b2 authorize-account ${var.bucket_info["application_key_id"]} ${var.bucket_info["application_key"]}",
    ]
  }

    depends_on = [
      hcloud_server.minecraft_node,
    ]
}

data template_file backup {
  template = "${path.module}/scripts/backup.sh"
  vars = {
    bucket = var.bucket_info["bucket_name"]
  }
}

data template_file restore {
  template = "${path.module}/scripts/restore.sh"
  vars = {
    bucket = var.bucket_info["bucket_name"]
  }
}

resource "null_resource" "install_minecraft" {
  triggers = {
    minecraft_version = var.minecraft_version
  }

  connection {
    host        = local.public_ip
    type        = "ssh"
    user        = "root"
    private_key = local.private_ssh_key
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "mkdir -p /opt/minecraft/${var.minecraft_version} /opt/minecraft/current/world",
      "curl -s ${var.minecraft_url} --output /opt/minecraft/${var.minecraft_version}/minecraft_server.jar",
      "echo \"eula=true\" > /opt/minecraft/current/eula.txt",
      "cp /opt/minecraft/${var.minecraft_version}/* /opt/minecraft/current/",
      "chown minecraft:minecraft -R /opt/minecraft/",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/templates/minecraft.service"
    destination = "/usr/lib/systemd/system/minecraft@.service"
  }

  provisioner "file" {
    content = data.template_file.restore.rendered
    destination = "/opt/minecraft/restore.sh"
  }

  provisioner "file" {
    content = data.template_file.backup.rendered
    destination = "/opt/minecraft/backup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "systemctl daemon-reload",
      "systemctl enable minecraft@${var.minecraft_version}",
    ]
  }

  depends_on = [
    null_resource.setup,
  ]
}

resource "null_resource" "toggle_service" {
  triggers = {
    enable = var.is_enabled
  }

  connection {
    host        = local.public_ip
    type        = "ssh"
    user        = "root"
    private_key = local.private_ssh_key
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "systemctl ${var.is_enabled ? "start" : "stop"} minecraft@${var.minecraft_version}",
    ]
  }

  depends_on = [
    null_resource.install_minecraft,
  ]
}
