module "mainnet_third-eye" {
    source = "./modules/services/third-eye"
    db_username  =var.postgres_db_username
    db_password  =var.postgres_db_password
    database =var.mainnet_database
    app_name ="third-eye"
    host = var.postgres_host

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    # ip_address = var.arbitrum_server_ip
    ip_address = var.mainnet_server_ip
    network_label = "mainnet"
}

module "mainnet_app_status" {
    source = "./modules/services/app_status"
    gh_token = var.gh_token
    ip_address = var.anvil_server_ip
    network_label = "mainnet"
}