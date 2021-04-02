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

variable "hcloud_token" {
  type        = string
  description = "Hcloud token"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key name"
  default     = "artemvang@kecyk.space"
}
