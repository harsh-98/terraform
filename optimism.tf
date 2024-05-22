module "optimism_third-eye" {
    source = "./modules/services/third-eye"
    db_username  =var.postgres_db_username
    db_password  =var.postgres_db_password
    database =var.optimism_database
    app_name ="third-eye"
    host = var.postgres_host

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.optimism_server_ip
    network_label = "optimism"
}

module "optimism_gearbox-ws" {
    source = "./modules/services/gearbox-ws"
    gh_token = var.gh_token
    ip_address = var.optimism_server_ip
    network_label = "optimism"
}

module "optimism_charts_server" {
    source = "./modules/services/charts_server"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.optimism_server_ip
    network_label = "optimism"
}