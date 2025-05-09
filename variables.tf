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



variable "linodes" {
  description = "List of Linode ids to which the rule sets will be applied"
  type        = list(string)
  default     = []
}


# for third-eye
variable "anvil_server_ip" {
  description = "anvil server"
}
variable "anvil_database" {
  description = "name of db"
}
variable "arbtest_server_ip" {
  description = "anvil arbitrum server"
}
variable "arbtest_database" {
  description = "name of db"
}
variable "opttest_server_ip" {
  description = "opttest arbitrum server"
}
variable "opttest_database" {
  description = "name of db"
}




variable "testnet_db_username" {
  description = "username of db"
}
variable "testnet_db_password" {
  description = "db password"
}

# mainnet
variable "postgres_db_username" {
  description = "username of db"
}
variable "postgres_db_password" {
  description = "db password"
}
variable "postgres_host" {
  description = "mainnet host"
}

variable "mainnet_database" {
  description = "mainnet database"
}
variable "mainnet_server_ip" {
  description = "mainnet server ip"
}
variable "arbitrum_database" {
  description = "arbitrum database"
}
variable "arbitrum_server_ip" {
  description = "arbitrum server ip"
}
variable "optimism_database" {
  description = "optimism database"
}
variable "optimism_server_ip" {
  description = "optimism server ip"
}
variable "sonic_database" {
  description = "sonic database"
}
variable "sonic_server_ip" {
  description = "sonic server ip"
}
variable "bnbtest_database" {
  description = "bnbtest database"
}
variable "bnbtest_server_ip" {
  description = "bnbtest server ip"
}

variable "bnb_database" {
  description = "bnb database"
}
variable "bnb_server_ip" {
  description = "bnb server ip"
}



variable "root_pass" {
  description = "Your Linode's root user's password."
}

# https://registry.terraform.io/providers/linode/linode/latest/docs
# create token from https://cloud.linode.com/profile/tokens