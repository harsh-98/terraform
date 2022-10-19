# linode token
variable "linode_token" {
  description = " Linode API token"
}

variable "pub_key_file" {
  description = "Public SSH Key's path."
}
variable "pvt_key_file" {
  description = "Private SSH Key's path."
}

variable "key_label" {
  description = "New SSH key label."
}


variable "image" {
  description = "Image to use for Linode instance."
  default = "linode/ubuntu22.04"
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


# for third-eye
variable "database" {
  description = "username of db"
}

variable "db_username" {
  description = "username of db"
}
variable "db_password" {
  description = "db password"
}

variable "mainnet_db_username" {
  description = "mainnet username of db"
}
variable "mainnet_db_password" {
  description = "mainnet db password"
}



# https://registry.terraform.io/providers/linode/linode/latest/docs
# create token from https://cloud.linode.com/profile/tokens