variable "server_id" {
  type = string
}

variable "minecraft_url" {
  type        = string
  description = "Minecraft server download URL"
}

variable "minecraft_version" {
  type        = string
  description = "Minecraft version"
}

variable "server_image" {
  type        = string
  description = "The server image"
  default     = "ubuntu-20.04"
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

variable "bucket_info" {
  type = map(string)
  description = "Information about backups bucket"
}

variable "is_enabled" {
  type = bool
}
