resource "null_resource" "deviator" {
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
            "mkdir -p deviator; cd deviator",
            "zsh ./config/scripts/get_release.sh ${var.gh_token} Gearbox-protocol/deviator"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./tmp_env/.env.deviator"
        destination = "/home/debian/deviator/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/deviator.service /etc/systemd/system",
            "sudo systemctl enable deviator.service",
            "sudo systemctl restart deviator",
        ]
    }
}
