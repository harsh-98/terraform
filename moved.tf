moved {
  from   = module.third-eye.null_resource.third-eye
  to   = module.goerli_third-eye.null_resource.third-eye
}
moved {
  from   = module.third-eye.null_resource.nginx
  to   = module.goerli_third-eye.null_resource.nginx
}

moved {
  from   = module.definder.null_resource.definder
  to   = module.goerli_definder.null_resource.definder
}

moved {
  from   = module.liquidator.null_resource.liquidator
  to   = module.goerli_liquidator.null_resource.liquidator
}

moved {
  from   = module.charts_server.null_resource.charts_server
  to   = module.goerli_charts_server.null_resource.charts_server
}

moved {
  from   = module.synctron.null_resource.synctron
  to   = module.goerli_synctron.null_resource.synctron
}

moved {
  from   = module.server.linode_instance.server
  to   = module.goerli_server.linode_instance.server
}

# https://www.linode.com/docs/guides/how-to-deploy-secure-linodes-using-cloud-firewalls-and-terraform/
##

terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.27.1"
    }
  }
}
provider "linode" {
  token = var.linode_token
}
resource "linode_sshkey" "main_key" {
    label = var.key_label
    # chomp removes newline character at the end of line
    ssh_key = chomp(file(var.pub_key_file))
}