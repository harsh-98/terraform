variable "token" {
  description = " Linode API token"
}

variable "key" {
  description = "Public SSH Key's path."
}
variable "pvt_key" {
  description = "Private SSH Key's path."
}

variable "key_label" {
  description = "New SSH key label."
}


variable "image" {
  description = "Image to use for Linode instance."
  default = "linode/ubuntu22.04"
}

variable "db_username" {
  description = "username of db"
}

variable "database" {
  description = "username of db"
}
variable "db_password" {
  description = "db password"
}



variable "type" {
  description = "Your Linode's plan type."
  default = "g6-standard-1"
}
variable "gh_token" {
  description = ""
}

variable "root_pass" {
  description = "Your Linode's root user's password."
}

variable "linodes" {
  description = "List of Linode ids to which the rule sets will be applied"
  type        = list(string)
  default     = []
}

# https://registry.terraform.io/providers/linode/linode/latest/docs
# create token from https://cloud.linode.com/profile/tokens