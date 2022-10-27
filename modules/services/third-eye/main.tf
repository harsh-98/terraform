# for nginx and psql
resource "null_resource" "nginx" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = var.ip_address
    }
    # all inlines are ran as script on remote host in form of /tmp/random.sh
    provisioner "remote-exec" {
        inline =[
            #
            "zsh ./config/scripts/psql.sh ${var.database} ${var.db_username} ${var.db_password}",
            #
            "sudo apt-get install -y nginx",
            "sudo cp -r ~/config/nginx/${var.network_label}.gearbox-api.com.conf /etc/nginx/sites-available/",
            "sudo ln -s /etc/nginx/sites-available/${var.network_label}.gearbox-api.com.conf /etc/nginx/sites-enabled/ -f",
            "sudo systemctl restart nginx"
        ]
    }
}

locals {
    db_url = "postgres://${var.db_username}:${var.db_password}@localhost:5432/${var.database}"
}

resource "null_resource" "third-eye" {
    connection {
            type     = "ssh"
            user     = "debian"
            private_key = file(var.pvt_key)
            host     = var.ip_address
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
        source      = "./envs/${var.network_label}/.env.third-eye"
        destination = "/home/debian/third-eye/.env"
    }
        provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/third-eye.service /etc/systemd/system",
            "sudo systemctl enable third-eye.service",
            "sudo systemctl restart third-eye",
        ]
    }
}