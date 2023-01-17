resource "null_resource" "definder" {
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
            # make sure that ssh identity is added
            "git config --global url.'ssh://git@github.com/Gearbox-protocol/go-liquidator'.insteadOf 'https://github.com/Gearbox-protocol/go-liquidator'",
            "export GOPRIVATE=github.com/Gearbox-protocol/go-liquidator",
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} definder",
            "cd definder; go build ./cmd/main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        # source      = "./envs/${var.network_label}/.env.definder"
        source      = "./tmp_env/.env.definder"
        destination = "/home/debian/definder/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/definder.service /etc/systemd/system",
            "sudo systemctl enable definder.service",
            "sudo systemctl restart definder",
        ]
    }
}
