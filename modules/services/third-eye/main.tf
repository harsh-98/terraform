# for nginx and psql
resource "null_resource" "nginx" {
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
            #
            "zsh ./config/scripts/psql.sh ${var.database} ${var.db_username} ${var.db_password}",
            #
            "sudo apt-get install -y nginx",
            "sudo cp -r ~/config/nginx/testnet.gearbox.foundation.conf /etc/nginx/sites-available/",
            "sudo ln -s /etc/nginx/sites-available/testnet.gearbox.foundation.conf /etc/nginx/sites-enabled/ -f",
            "sudo systemctl restart nginx"
        ]
    }
}

locals {
    db_url = "postgres://${var.db_username}:${var.db_password}@${var.host}:5432/${var.database}?sslmode=disable"
    folder = "${var.network_label}-${var.app_name}"
}

resource "null_resource" "third-eye" {
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
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} ${var.app_name} /${var.network_label}",
            "cd ${local.folder}; go build ./cmd/main.go",
            "migrate -path migrations -database '${local.db_url}' up",
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.${var.app_name}"
        destination = "/home/debian/${local.folder}/.env"
    }
    provisioner "remote-exec" {
        inline =[
            # "bash -x ./db_scripts/local_testing/local_test.sh '139.177.179.137' '' debian",
            "sudo cp ~/config/services/third-eye.service /etc/systemd/system/${local.folder}.service",
            "sudo sed -i 's|third-eye|${local.folder}|g' /etc/systemd/system/${local.folder}.service",
            "sudo systemctl enable ${local.folder}.service",
            "sudo systemctl restart ${local.folder}",
        ]
    }
}