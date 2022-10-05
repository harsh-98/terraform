#!/bin/zsh

terraform destroy -var-file="secrets.tfvars" -var-file="terraform.tfvars" -target="null_resource.$1"  -auto-approve
terraform apply -var-file="secrets.tfvars" -var-file="terraform.tfvars" -target="null_resource.$1" 