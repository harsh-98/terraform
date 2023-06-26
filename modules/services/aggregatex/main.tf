
locals {
    db_url = "postgres://${var.db_username}:${var.db_password}@localhost:5432/${var.aggregatex_db}"
}

resource "null_resource" "aggregatex" {
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
            "zsh ./config/scripts/deploy_aggregatex_db.sh ${var.aggregatex_db} ${var.db_username}",
            "zsh ./config/scripts/clone_or_pull_repo.sh ${var.gh_token} aggregatex",
            "go install github.com/google/go-jsonnet/cmd/...@latest",
            "cd aggregatex; go build ./cmd/main.go; PATH=\"$PATH:$HOME/go/bin\" ./generate.sh",
            "migrate -path migrations -database \"${local.db_url}\" up"
        ]
    }
    # https://www.terraform.io/language/resources/provisioners/connection
    provisioner "file" { # for transferring files from local to remote machine
        source      = "./envs/${var.network_label}/.env.aggregatex"
        destination = "/home/debian/aggregatex/.env"
    }
    provisioner "remote-exec" {
        inline =[
            "sudo cp ~/config/services/aggregatex.service /etc/systemd/system",
            "sudo systemctl enable aggregatex.service",
            "sudo systemctl restart aggregatex",
        ]
    }
}