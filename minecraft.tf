terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
  region = var.region
}


resource "aws_vpc" "minecraft" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}


resource "aws_internet_gateway" "minecraft" {
  vpc_id = aws_vpc.minecraft.id
  tags = {
    "Name" = var.server_name
  }
}


resource "aws_route_table" "minecraft" {
  vpc_id = aws_vpc.minecraft.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.minecraft.id
  }
}


resource "aws_subnet" "minecraft" {
  vpc_id     = aws_vpc.minecraft.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = var.server_name
  }
}


resource "aws_route_table_association" "minecraft" {
  subnet_id = aws_subnet.minecraft.id
  route_table_id = aws_route_table.minecraft.id
}


resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name = var.ssh_key_name
  public_key = tls_private_key.ssh.public_key_openssh
}


resource "aws_security_group" "minecraft" {
  name = "${var.server_name}-security"
  description = "Security group for ${var.server_name}"
  vpc_id = aws_vpc.minecraft.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = {
    "Name" = var.server_name
  }
}


resource "aws_instance" "minecraft" {
  ami = var.ami
  instance_type = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.minecraft.id
  security_groups = [aws_security_group.minecraft.id]
  key_name = aws_key_pair.ssh.key_name

  tags = {
    Name = var.server_name
  }
}


resource "aws_eip" "minecraft" {
  instance = aws_instance.minecraft.id
  vpc = true
}


resource "local_file" "private_key" {
  content = tls_private_key.ssh.private_key_pem
  filename = "./ssh_keys/private_key"
}


resource "local_file" "public_key_key" {
  content = tls_private_key.ssh.public_key_pem
  filename = "./ssh_keys/public_key"
}


resource "local_file" "ansible_inventory" {
  content = templatefile("./inventory.tmpl",
    {
      ip_addr = aws_eip.minecraft.public_ip,
    }
  )
  filename = "./ansible/inventory"
}
