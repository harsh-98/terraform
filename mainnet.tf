module "mainnet_server" {
    source = "./modules/services/server"

    pub_key = chomp(file(var.pub_key_file))
    root_pass = var.root_pass
    image = var.image
    pvt_key_file = var.pvt_key_file
    network_label = "mainnet"
    node_type= "g6-standard-2"
  providers = {
    linode = linode
  }
}

module "mainnet_third-eye" {
    source = "./modules/services/third-eye"

    db_username  =var.mainnet_db_username
    db_password  =var.mainnet_db_password
    database =var.database
    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.mainnet_server.ip_address
    network_label = "mainnet"
}

module "mainnet_charts_server" {
    source = "./modules/services/charts_server"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.mainnet_server.ip_address
    network_label = "mainnet"
}

module "mainnet_dns_checker" {
    source = "./modules/services/dns_checker"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.mainnet_server.ip_address
    network_label = "mainnet"
}

module "mainnet_aggregatex" {
    source = "./modules/services/aggregatex"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.mainnet_server.ip_address
    db_username  =var.mainnet_db_username
    db_password  =var.mainnet_db_password
    aggregatex_db ="aggregatex"
    network_label = "mainnet"
}

module "mainnet_deviator" {
    source = "./modules/services/deviator"
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.mainnet_server.ip_address
    network_label = "mainnet"
}