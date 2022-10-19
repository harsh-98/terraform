resource "null_resource" "synctron" {
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
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} synctron",
            "cd synctron; go build ./cmd/main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.synctron"
        destination = "/home/debian/synctron/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/synctron.service /etc/systemd/system",
            "sudo systemctl enable synctron.service",
            "sudo systemctl restart synctron",
        ]
    }
}