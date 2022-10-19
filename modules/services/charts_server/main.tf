resource "null_resource" "charts_server" {
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
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} charts_server",
            "cd charts_server; go build ./cmd/main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.charts_server"
        destination = "/home/debian/charts_server/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/charts_server.service /etc/systemd/system",
            "sudo systemctl enable charts_server.service",
            "sudo systemctl restart charts_server",
        ]
    }
}