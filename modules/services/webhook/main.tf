locals {
    service = "${var.network_label}-webhook"
    folder = "${var.network_label}-app_status"
}
resource "null_resource" "webhook" {
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
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} app_status harsh-98/${var.network_label}",
            "cd ${local.folder}/cmd/webhook; go build main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.app_status"
        destination = "/home/debian/${local.folder}/.env"
    }
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.webhook"
        destination = "/home/debian/${local.folder}/cmd/webhook/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/webhook.service /etc/systemd/system/${local.service}.service",
            "sudo sed -i 's|app_status|${local.folder}|g' /etc/systemd/system/${local.service}.service",
            "sudo systemctl enable ${local.service}.service",
            "sudo systemctl restart ${local.service}",
        ]
    }
}