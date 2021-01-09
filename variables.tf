variable "server_image" {
  type        = string
  description = "The server image"
  default     = "ubuntu-20.04"
}

variable "server_name" {
  type        = string
  description = "Server name"
  default     = "minecraft"
}

variable "location" {
  type        = string
  description = "Server location"
  default     = "fsn1"
}

variable "server_type" {
  type        = string
  description = "Server type"
  default     = "cx11"
}

variable "network_name" {
  type        = string
  description = "Network name"
  default     = "minecraft-network"
}

variable "network_ip_range" {
  type        = string
  description = "Network IP range"
  default     = "10.0.0.0/24"
}

variable "subnetwork_ip_range" {
  type        = string
  description = "Sunetwork IP range"
  default     = "10.0.0.0/28"
}

variable "server_local_ip" {
  type = string
  description = "Server IP addres in subnetwork"
  default     = "10.0.0.2"
}

variable "hcloud_token" {
  type        = string
  description = "Hcloud token"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key name"
  default     = "artemvang@kecyk.com"
}

variable "ssh_private_name" {
  type        = string
  description = "public SSH key"
  default     = "./ssh_keys/id_hcloud_minecraft"
}

variable "ssh_public_key" {
  type        = string
  description = "Admin SSH key"
  default     = "./ssh_keys/id_hcloud_minecraft.pub"
}
