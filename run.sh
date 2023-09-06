#!/bin/bash -ex
REGIONS=(us-east-1 us-west-1 af-south-1 ap-east-1 ap-south-1 ap-southeast-1 ap-southeast-2 ap-northeast-1  ca-central-1 eu-central-1 eu-west-1 eu-south-1 eu-west-2 eu-north-1 me-south-1 me-central-1 il-central-1 sa-east-1)

cd terraform
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
