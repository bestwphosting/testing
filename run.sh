#!/bin/bash -ex
REGIONS=(us-east-1)
TERRAFORM_DIR=terraform

cd ${TERRAFORM_DIR}
rm -f regions.tf
for REGION in "${REGIONS[@]}"; do
cat << EOF >> regions.tf

provider "aws" {
  alias = "$REGION"
  region = "$REGION"
}

EOF
  sed "s/{{REGION}}/$REGION/g" regions.tmpl >> regions.tf
done

terraform init
terraform plan "$@" -out plan
read -p 'Continue? [y/N]' continue
! [[ "$continue" =~ ^[yY]$ ]] && exit
terraform apply plan
