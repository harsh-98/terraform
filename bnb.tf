module "bnb_third-eye" {
    source = "./modules/services/third-eye"

    db_username  =var.testnet_db_username
    db_password  =var.testnet_db_password
    database =var.bnb_database
    ip_address = var.bnb_server_ip
    app_name="third-eye"
    host="localhost"
    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    network_label = "bnb"
}

module "bnb_charts_server" {
    source = "./modules/services/charts_server"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.bnb_server_ip
    network_label = "bnb"
}


