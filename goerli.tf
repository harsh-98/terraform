module "goerli_server" {
    source = "./modules/services/server"

    pub_key = linode_sshkey.main_key.ssh_key
    root_pass = var.root_pass
    image = var.image
    pvt_key_file= var.pvt_key_file
    network_label = "goerli"
    node_type= "g6-standard-2"
      providers = {
    linode = linode
  }
}

module "goerli_third-eye" {
    source = "./modules/services/third-eye"

    db_username  =var.db_username
    db_password  =var.db_password
    database =var.database
    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.goerli_server.ip_address
    network_label = "goerli"
}

module "goerli_charts_server" {
    source = "./modules/services/charts_server"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.goerli_server.ip_address
    network_label = "goerli"
}

module "goerli_synctron" {
    source = "./modules/services/synctron"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.goerli_server.ip_address
    network_label = "goerli"
}

###
module "goerli_definder" {
    source = "./modules/services/definder"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.goerli_server.ip_address
    network_label = "goerli"
}

module "goerli_liquidator" {
    source = "./modules/services/liquidator"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.goerli_server.ip_address
    network_label = "goerli"
    service_file = "liquidator"
}

module "goerli_telebot" {
    source = "./modules/services/telebot"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.goerli_server.ip_address
    network_label = "goerli"
}