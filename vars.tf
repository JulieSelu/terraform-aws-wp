variable "username" {
  description = "DB username"
}

variable "password" {
  description = "DB password"
}

variable "dbname" {
  description = "db name"
}

variable "ssh_key_name" {
  default     = "aws_key"
  description = "Default pub key"
}

variable "ssh_priv_key" {
  default     = "~/.ssh/id_rsa"
  description = "Default private key"
}
