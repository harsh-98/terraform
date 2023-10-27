locals {
    service = "${var.network_label}-gearbox-ws"
    folder = "${var.network_label}-go-liquidator"
}
resource "null_resource" "gearbox-ws" {
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
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} go-liquidator /${var.network_label}",
            "cd ${local.folder}/cmd/web_server; go build main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.gearbox-ws"
        destination = "/home/debian/${local.folder}/cmd/web_server/.env"
    }
    # provisioner "file" { # for transferring files from local to remote machine
    #     source      = "./envs/${var.network_label}/.env.go-liquidator"
    #     destination = "/home/debian/go-liquidator/.env"
    # }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/gearbox-ws.service /etc/systemd/system/${local.service}.service",
            "sudo sed -i 's|go-liquidator|${local.folder}|g' /etc/systemd/system/${local.service}.service",
            "sudo systemctl enable ${local.service}.service",
            "sudo systemctl restart ${local.service}",
        ]
    }
}