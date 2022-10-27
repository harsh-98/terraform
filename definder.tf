module "defserver" {
    source = "./modules/services/server"

    pub_key = linode_sshkey.main_key.ssh_key
    root_pass = var.root_pass
    image = var.image
    pvt_key_file= var.pvt_key_file
    network_label = "mainnet"
    node_type= "g6-nanode-1"
      providers = {
    linode = linode
  }
}

module "mainnet_definder" {
    source = "./modules/services/definder"
    pvt_key = var.pvt_key_file
    gh_token = var.gh_token
    ip_address = module.defserver.ip_address
    network_label = "mainnet"
}