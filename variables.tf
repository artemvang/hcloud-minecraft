variable "server_name" {
  type        = string
  description = "Server name"
  default     = "minecraft"
}


variable "region" {
  type        = string
  description = "The AWS region."
  default     = "eu-central-1"
}


variable "instance_type" {
  type        = string
  description = "The instance type to launch."
  default     = "t2.micro"
}


variable "ami" {
  type        = string
  description = "AMI of server"
  default     = "ami-0502e817a62226e03"
}


variable "ssh_key_name" {
  type        = string
  description = "SSH key name"
  default     = "artemvang@kecyk.com"
}
