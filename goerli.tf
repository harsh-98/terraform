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

locals {
    db_url = "postgres://${var.db_username}:${var.db_password}@localhost:5432/${var.database}"
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
        private_key = file(var.pvt_key)
        host     = linode_instance.goerli.ip_address
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

            #
            "zsh ./config/scripts/psql.sh ${var.database} ${var.db_username} ${var.db_password}",
            "sudo apt-get install migrate",
            # services on that server 
            "sudo cp ~/config/services/charts_server.service /etc/systemd/system",
            "sudo cp ~/config/services/third-eye.service /etc/systemd/system",
            "sudo cp ~/config/services/liquidator.service /etc/systemd/system",
            "sudo cp ~/config/services/synctron.service /etc/systemd/system",
            "sudo cp ~/config/services/definder.service /etc/systemd/system",
        ]
    }
}

resource "null_resource" "nginx" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = linode_instance.goerli.ip_address
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            #
            "sudo apt-get install -y nginx",
            "sudo cp -r ~/config/nginx/goerli.gearbox-api.com.conf /etc/nginx/sites-available/",
            "sudo ln -s /etc/nginx/sites-available/goerli.gearbox-api.com.conf /etc/nginx/sites-enabled/ -f",
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
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            # "setopt share_history", # not needed
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} liquidator",
           "cd liquidator; go build ./cmd/main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/goerli/.env.liquidator"
        destination = "/home/debian/liquidator/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo systemctl enable liquidator.service",
            "sudo systemctl restart liquidator",
        ]
    }
}

resource "null_resource" "third-eye" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = linode_instance.goerli.ip_address
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            # "setopt share_history", # not needed
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} third-eye",
            "cd third-eye; go build ./cmd/main.go",
            "migrate -path migrations -database \"${local.db_url}\" up",
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/goerli/.env.third-eye"
        destination = "/home/debian/third-eye/.env"
    }
        provisioner "remote-exec" {
        inline =[
            "sudo systemctl enable third-eye.service",
            "sudo systemctl restart third-eye",
        ]
    }
}

resource "null_resource" "charts_server" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = linode_instance.goerli.ip_address
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            # "setopt share_history", # not needed
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} charts_server",
            "cd charts_server; go build ./cmd/main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/goerli/.env.charts_server"
        destination = "/home/debian/charts_server/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo systemctl enable charts_server.service",
            "sudo systemctl restart charts_server",
        ]
    }
}

resource "null_resource" "synctron" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = linode_instance.goerli.ip_address
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            # "setopt share_history", # not needed
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} synctron",
            "cd synctron; go build ./cmd/main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/goerli/.env.synctron"
        destination = "/home/debian/synctron/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo systemctl enable synctron.service",
            "sudo systemctl restart synctron",
        ]
    }
}

resource "null_resource" "definder" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = linode_instance.goerli.ip_address
            agent = true
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            # "setopt share_history", # not needed
            "git config --global url.'ssh://git@github.com/Gearbox-protocol/liquidator'.insteadOf 'https://github.com/Gearbox-protocol/liquidator'",
            "export GOPRIVATE=github.com/Gearbox-protocol/liquidator",
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} definder",
            "cd definder; go build ./cmd/main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/goerli/.env.definder"
        destination = "/home/debian/definder/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo systemctl enable definder.service",
            "sudo systemctl restart definder",
        ]
    }
}
