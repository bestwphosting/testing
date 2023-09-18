data "aws_ami" "this" {
  provider = aws.this

  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["arm64"] #["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_key_pair" "this" {
  count = var.debug == true ? 1 : 0
  provider = aws.this

  key_name   = "testing"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "ssh" {
  count = var.debug == true ? 1 : 0
  provider = aws.this

  name        = "ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "this" {
  count = var.num_instances
  provider = aws.this

  ami = data.aws_ami.this.id
  iam_instance_profile = var.instance_profile
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.instance_type
  key_name = var.debug ? aws_key_pair.this[0].id : null
  user_data = <<EOF
#!/bin/bash -ex
DEBUG=${var.debug}
HOSTS=(${var.hostname})
K6_ARCH=arm64 #amd64
K6_RESULTS=test_results.csv
K6_RESULTS_SUMMARY=summary.csv
K6_VER=v0.46.0
SCRIPT=script.js

wget -O k6.tgz --tries=10 https://github.com/grafana/k6/releases/download/$K6_VER/k6-$K6_VER-linux-$K6_ARCH.tar.gz
tar zxvf k6.tgz
wget --tries=10 https://raw.githubusercontent.com/bestwphosting/testing/${var.test_version}/$SCRIPT

for HOST in "$${HOSTS[@]}"; do
  URL="https://$HOST/${var.page_to_test}" ./k6-$K6_VER-linux-$K6_ARCH/k6 run --out csv=$K6_RESULTS $SCRIPT;
  S3_PATH=${var.test_version}/${var.datestamp}/$HOST;
  aws s3 --region ${var.bucket_region} cp $K6_RESULTS s3://${var.bucket}/$S3_PATH/data/$${S3_PATH//\//-}-${var.region}.csv;
  aws s3 --region ${var.bucket_region} cp $K6_RESULTS_SUMMARY s3://${var.bucket}/$S3_PATH/summary/$${S3_PATH//\//-}-${var.region}-summary.csv;
  rm -f $K6_RESULTS $K6_RESULTS_SUMMARY;
done
[ -z "$DEBUG" ] || [ "$DEBUG" = "false" ] && sudo shutdown -h now || true
EOF
  vpc_security_group_ids = var.debug ? [aws_security_group.ssh[0].id] : []

  tags = {
    type = "tester"
  }
}
