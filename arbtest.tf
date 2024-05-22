module "arbtest_third-eye" {
    source = "./modules/services/third-eye"

    db_username  =var.testnet_db_username
    db_password  =var.testnet_db_password
    database =var.arbtest_database
    ip_address = var.arbtest_server_ip
    app_name="third-eye"
    host="localhost"
    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    network_label = "arbtest"
}

module "arbtest_charts_server" {
    source = "./modules/services/charts_server"

    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = var.arbtest_server_ip
    network_label = "arbtest"
}






module "arbtest_webhook" {
    source = "./modules/services/webhook"
    gh_token = var.gh_token
    ip_address = var.arbtest_server_ip
    network_label = "arbtest"
}

module "arbtest_gearbox-ws" {
    source = "./modules/services/gearbox-ws"
    gh_token = var.gh_token
    ip_address = var.arbtest_server_ip
    network_label = "arbtest"
}