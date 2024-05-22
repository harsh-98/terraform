module "arbitrum_third-eye" {
    source = "./modules/services/third-eye"
    db_username  =var.postgres_db_username
    db_password  =var.postgres_db_password
    database =var.arbitrum_database
    app_name ="third-eye"
    host = var.postgres_host

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.arbitrum_server_ip
    network_label = "arbitrum"
}


module "arbitrum_gearbox-ws" {
    source = "./modules/services/gearbox-ws"
    gh_token = var.gh_token
    ip_address = var.arbitrum_server_ip
    network_label = "arbitrum"
}

module "arbitrum_charts_server" {
    source = "./modules/services/charts_server"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.arbitrum_server_ip
    network_label = "arbitrum"
}