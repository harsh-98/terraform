terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.27.1"
    }
  }
}

provider "linode" {
  token = var.token
}

# https://www.linode.com/docs/guides/how-to-deploy-secure-linodes-using-cloud-firewalls-and-terraform/
##
resource "linode_sshkey" "main_key" {
    label = var.key_label
    # chomp removes newline character at the end of line
    ssh_key = chomp(file(var.key))
}

resource "linode_instance" "goerli" {
    image = var.image
    label = "Goerli"
    tags  = ["goerli"]
    group = "Goerli"
    # https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance#argument-reference
    #https://api.linode.com/v4/regions
    region = "eu-central"
    # https://api.linode.com/v4/linode/types
    type = "g6-standard-2"
    authorized_keys = [ linode_sshkey.main_key.ssh_key ]
    root_pass = var.root_pass

    
    provisioner "remote-exec" {
       connection {
        type     = "ssh"
        user     = "root"
        private_key = file(var.pvt_key)
        host = linode_instance.goerli.ip_address
        }
        inline = [
            "apt-get update",
            "apt-get install -y zsh make git gcc psmisc net-tools",
            "useradd -m debian -G sudo  -s /usr/bin/zsh",
            "mkdir /home/debian/.ssh",
            "cp ~/.ssh/authorized_keys /home/debian/.ssh/authorized_keys",
            "chown -R debian:debian /home/debian/.ssh",
            "echo 'debian     ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
        ]
    }


    connection {
        type     = "ssh"
        user     = "debian"
        private_key = file(var.pvt_key)
        host     = linode_instance.goerli.ip_address
    }

    provisioner "file" { # for transferring files from local to remote machine
        source      = "./config"
        destination = "/home/debian/config"
    }

    provisioner "remote-exec" {
        inline =[
            "bash ~/install.sh",
            "bash ~/scripts/go.sh 1.18.6",
            "ssh-keyscan github.com >> ~/.ssh/known_hosts",
            # services on that server 
            "mv ~/config/scripts/charts_server.service /etc/systemd/system",
            "mv ~/config/scripts/third-eye.service /etc/systemd/system",
            "mv ~/config/scripts/liquidator.service /etc/systemd/system",
            "mv ~/config/scripts/synctron.service /etc/systemd/system",
        ]
    }
}

resource "null_resource" "psql" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = linode_instance.goerli.ip_address
            agent=true
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/goerli/.env.liquidator"
        destination = "/home/debian/liquidator/.env"
    }

    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            # "setopt share_history", # not needed
            "zsh ./config/scripts/psql.sh ${var.db_database} ${var.db_username} ${var.password}",
        ]
    }
}

resource "null_resource" "nginx" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = linode_instance.goerli.ip_address
            agent=true
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            #
            "sudo apt-get install nginx",
            "sudo ~/config/nginx/goerli.gearbox-api.com.conf /etc/nginx/sites-available/",
            "sudo ln -s /etc/nginx/sites-available/goerli.gearbox-api.com.conf /etc/nginx/sites-enabled/",
            "sudo systemctl restart nginx"
        ]
    }
}

resource "null_resource" "liquidator" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = linode_instance.goerli.ip_address
            agent=true
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            # "setopt share_history", # not needed
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} liquidator",
            "go build ./..."
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/goerli/.env.liquidator"
        destination = "/home/debian/liquidator/.env"
    }
}

resource "null_resource" "third-eye" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = linode_instance.goerli.ip_address
            agent=true
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            # "setopt share_history", # not needed
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} third-eye",
            "go build ./..."
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/goerli/.env.third-eye"
        destination = "/home/debian/third-eye/.env"
    }
}

resource "null_resource" "charts_server" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = linode_instance.goerli.ip_address
            agent=true
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            # "setopt share_history", # not needed
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} charts_server",
            "go build ./..."
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/goerli/.env.charts_server"
        destination = "/home/debian/charts_server/.env"
    }
}

resource "null_resource" "synctron" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = linode_instance.goerli.ip_address
            agent=true
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            # "setopt share_history", # not needed
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} synctron",
            "go build ./..."
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/goerli/.env.synctron"
        destination = "/home/debian/synctron/.env"
    }
}
