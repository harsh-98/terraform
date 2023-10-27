locals {
    folder = "${var.network_label}-charts_server"
}
resource "null_resource" "charts_server" {
    connection {
            type     = "ssh"
            user     = "debian"
            agent       = true
            #private_key = file(var.pvt_key)
            host     = var.ip_address
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            # "setopt share_history", # not needed
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} charts_server /${var.network_label}",
            "cd ${local.folder}; go build ./cmd/main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.trading_price"
        destination = "/home/debian/${local.folder}/trading/.env"
    }
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.charts_server"
        destination = "/home/debian/${local.folder}/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/charts_server.service /etc/systemd/system/${local.folder}.service",
            "sudo sed -i 's|charts_server|${local.folder}|g' /etc/systemd/system/${local.folder}.service",
            "sudo systemctl enable ${local.folder}.service",
            "sudo systemctl restart ${local.folder}",
        ]
    }
}