locals {
    folder = "${var.network_label}-telegram-bot"
    service = "${var.network_label}-telebot"
}
resource "null_resource" "telebot" {
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
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} telegram-bot /${var.network_label}",
            "cd ${local.folder}; go build ./cmd/main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.telebot"
        destination = "/home/debian/${local.folder}/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/telebot.service /etc/systemd/system/${local.service}.service",
            "sudo sed -i 's|telegram-bot|${local.folder}|g' /etc/systemd/system/${local.service}.service",
            "sudo systemctl enable ${local.service}.service",
            "sudo systemctl restart ${local.service}",
        ]
    }
}