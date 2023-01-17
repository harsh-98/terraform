terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.27.1"
    }
  }
}

resource "linode_instance" "server" {
    image = var.image
    tags  = [var.network_label]
    group = var.network_label
    # https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance#argument-reference
    #https://api.linode.com/v4/regions
    region = "eu-central"
    # https://api.linode.com/v4/linode/types
    type = var.node_type
    authorized_keys = [ var.pub_key ]
    root_pass = var.root_pass

    
    provisioner "remote-exec" {
       connection {
        type     = "ssh"
        user     = "root"
        agent       = true
        #private_key = file(var.pvt_key)
        host = linode_instance.server.ip_address
        }
        inline = [
            "apt-get update",
            "apt-get install -y zsh make git gcc psmisc net-tools",
            "useradd -m debian -G sudo  -s /usr/bin/zsh",
            "mkdir /home/debian/.ssh",
            "cp ~/.ssh/authorized_keys /home/debian/.ssh/authorized_keys",
            "chown -R debian:debian /home/debian/.ssh",
            "echo 'debian     ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers",
            # migrate
            "wget https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz",
            "tar -xf migrate.linux-amd64.tar.gz -C /tmp",
            "sudo mv /tmp/migrate /usr/bin/",
        ]
    }


    connection {
        type     = "ssh"
        user     = "debian"
        agent       = true
        #private_key = file(var.pvt_key)
        host     = linode_instance.server.ip_address
    }

    provisioner "file" { # for transferring files from local to remote machine
        source      = "./config"
        destination = "/home/debian/config"
    }

    provisioner "remote-exec" {
        inline =[
            "bash ~/config/scripts/install.sh",
            "bash ~/config/scripts/go.sh 1.18.6",
            "source ~/.zshrc",
            "ssh-keyscan github.com >> ~/.ssh/known_hosts",

            # "sudo apt-get install migrate",
            # "go install github.com/golang-migrate/migrate/v4@v4.15.2",
        ]
    }
}