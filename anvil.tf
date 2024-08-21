# module "anvil_server" {
#     source = "./modules/services/server"

#     pub_key = chomp(file(var.pub_key_file))
#     root_pass = var.root_pass
#     image = var.image
#     pvt_key_file= var.pvt_key_file
#     network_label = "anvil"
#     node_type= "g6-standard-2"
#       providers = {
#     linode = linode
#   }
# }


module "anvil_charts_server" {
    source = "./modules/services/charts_server"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
}


###
module "anvil_definder" {
    source = "./modules/services/definder"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
}

module "anvil_liquidator" {
    source = "./modules/services/liquidator"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
    service_file = "liquidator"
}

module "anvil_telebot" {
    source = "./modules/services/telebot"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
}

//
module "anvil_gpointbot" {
    source = "./modules/services/gpointbot"

    #
    # pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
    db_name = "anvil_gpointbot"
    db_username = var.testnet_db_username
    db_password = var.testnet_db_password
}

module "anvil_trading_price" {
    source = "./modules/services/trading_price"
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
}

module "anvil_gearbox-ws" {
    source = "./modules/services/gearbox-ws"
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
}

module "anvil_webhook" {
    source = "./modules/services/webhook"
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
}

module "anvil_app_status" {
    source = "./modules/services/app_status"
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
}
module "anvil_dns_checker" {
    source = "./modules/services/dns_checker"
    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
}

module "anvil_third-eye" {
    source = "./modules/services/third-eye"

    db_username  =var.testnet_db_username
    db_password  =var.testnet_db_password
    database =var.anvil_database
    host = "localhost"
    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
    app_name="third-eye"
}


module "anvil_http-logger" {
    source = "./modules/services/http-logger"
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "anvil"
}


module "anvil_aggregatex" {
    source = "./modules/services/aggregatex"

    #
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    db_host = var.postgres_host
    db_username  =var.postgres_db_username
    db_password  =var.postgres_db_password
    aggregatex_db ="aggregatex"
    network_label = "anvil"
}