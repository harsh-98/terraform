locals {
    folder = "${var.network_label}-gpointbot"
    db_url = "postgres://${var.db_username}:${var.db_password}@localhost:5432/${var.db_name}?sslmode=disable"
}
resource "null_resource" "gpointbot" {
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
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} gpointbot /${var.network_label}",
            "cd ${local.folder}; go build cmd/main.go",
            "migrate -path migrations -database '${local.db_url}' up",
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.gpointbot"
        destination = "/home/debian/${local.folder}/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/gpointbot.service /etc/systemd/system/${local.folder}.service",
            "sudo sed -i 's|gpointbot|${local.folder}|g' /etc/systemd/system/${local.folder}.service",
            "sudo systemctl enable ${local.folder}",
            "sudo systemctl stop ${local.folder}",
            "psql -U debian -d ${var.db_name} -c 'drop table last_snaps ; drop table user_points ; drop table events;'",
            "sudo systemctl restart ${local.folder}",
        ]
    }
}