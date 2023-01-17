resource "null_resource" "dns_checker" {
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
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} dns-checker",
            "cd dns-checker; go build ./cmd/main.go"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.dns_checker"
        destination = "/home/debian/dns-checker/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/dns_checker.service /etc/systemd/system",
            "sudo systemctl enable dns_checker.service",
            "sudo systemctl restart dns_checker",
        ]
    }
}