resource "null_resource" "liquidator" {
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
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} liquidator",
           "cd liquidator; go build ./cmd/main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        # source      = "./envs/${var.network_label}/.env.liquidator"
        source      = "./tmp_env/.env.go-liquidator"
        destination = "/home/debian/liquidator/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/${var.service_file}.service /etc/systemd/system/liquidator.service",
            "sudo systemctl enable liquidator.service",
            "sudo systemctl restart liquidator",
        ]
    }
}