data "aws_ami" "this" {
  provider = aws.this

  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"] #["arm64"]
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
  instance_type = var.instance_type
  key_name = var.debug ? aws_key_pair.this[0].id : null
  user_data = <<EOF
#!/bin/bash -ex
DEBUG=${var.debug}
K6_ARCH=amd64
K6_RESULTS=test_results.csv
K6_VER=v0.46.0
PATH=${var.test_version}/${var.datestamp}/${var.hostname}

dnf install -y git-core
wget -O k6.tgz --tries=10 https://github.com/grafana/k6/releases/download/$K6_VER/k6-$K6_VER-linux-$K6_ARCH.tar.gz
tar zxvf k6.tgz
wget --tries=10 https://raw.githubusercontent.com/kevin-bockman/webhostreview/${var.test_version}/script.js
#aws s3 cp s3://${var.bucket}/${var.script} .
URL="https://${var.hostname}/${var.page_to_test}" ./k6-$K6_VER-linux-$K6_ARCH/k6 run --out csv=$K6_RESULTS ${var.script}
aws s3 cp $K6_RESULTS s3://${var.bucket}/$PATH/$${PATH//\//-}-${var.region}
[ -z "$DEBUG" ] || [ "$DEBUG" = "false" ] && shutdown -h now
EOF
  vpc_security_group_ids = var.debug ? [aws_security_group.ssh[0].id] : []
}
