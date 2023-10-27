locals {
    folder = "${var.network_label}-charts_server"
    service = "${var.network_label}-trading_price"
}
resource "null_resource" "trading_price" {
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
            "cd ${local.folder}/trading; go build main.go"
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
            "sudo cp ~/config/services/trading_price.service /etc/systemd/system/${local.service}.service",
            "sudo sed -i 's|charts_server|${local.folder}|g' /etc/systemd/system/${local.service}.service",
            "sudo systemctl enable ${local.service}.service",
            "sudo systemctl restart ${local.service}",
        ]
    }
}