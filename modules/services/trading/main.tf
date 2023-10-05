resource "null_resource" "trading" {
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
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} charts_server",
            "cd charts_server/trading; go build main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.trading"
        destination = "/home/debian/charts_server/trading/.env"
    }
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.charts_server"
        destination = "/home/debian/charts_server/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/trading.service /etc/systemd/system",
            "sudo systemctl enable trading.service",
            "sudo systemctl restart trading",
        ]
    }
}