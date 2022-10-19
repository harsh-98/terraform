
variable "pvt_key_file" {
  description = "Private SSH Key's path."
}

variable "root_pass" {
  description = "Your Linode's root user's password."
}

variable "pub_key" {
  description = "SSH resource for linode"
}
variable "network_label" {
  description = "mainnet, goerli like network name"
}
variable "node_type" {
  description = "g6-standard-2"
}
variable "image" {
  description = "image"
}