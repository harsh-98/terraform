module "bnb_third-eye" {
    source = "./modules/services/third-eye"

    db_username  =var.postgres_db_username
    db_password  =var.postgres_db_password
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




module "lisk_third-eye" {
    source = "./modules/services/third-eye"

    db_username  =var.postgres_db_username
    db_password  =var.postgres_db_password
    database =var.lisk_database
    ip_address = var.lisk_server_ip
    app_name="third-eye"
    host="localhost"
    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    network_label = "lisk"
}
module "hemibtc_third-eye" {
    source = "./modules/services/third-eye"

    db_username  =var.postgres_db_username
    db_password  =var.postgres_db_password
    database =var.hemibtc_database
    ip_address = var.hemibtc_server_ip
    app_name="third-eye"
    host="localhost"
    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    network_label = "hemibtc"
}
module "etherlink_third-eye" {
    source = "./modules/services/third-eye"

    db_username  =var.postgres_db_username
    db_password  =var.postgres_db_password
    database =var.etherlink_database
    ip_address = var.etherlink_server_ip
    app_name="third-eye"
    host="localhost"
    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    network_label = "etherlink"
}
module "plasma_third-eye" {
    source = "./modules/services/third-eye"

    db_username  =var.postgres_db_username
    db_password  =var.postgres_db_password
    database =var.plasma_database
    ip_address = var.plasma_server_ip
    app_name="third-eye"
    host="localhost"
    #
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    network_label = "plasma"
}