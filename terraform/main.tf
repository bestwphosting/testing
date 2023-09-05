locals {
  datestamp = formatdate("YYMMDD",plantimestamp())
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "http" "my_ip" {
  count = var.debug == true ? 1 : 0
  url = "http://ipv4.icanhazip.com"
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket
}

resource "aws_s3_object" "script" {
  bucket = aws_s3_bucket.this.id
  key    = "script.js"
  source = "../script.js"
}

resource "aws_iam_policy" "this" {
  name        = "allow-bucket-upload"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.this.arn}/*",
        ]
      }
    ]
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name                = "loadtest"
  assume_role_policy  = data.aws_iam_policy_document.assume_role.json
  managed_policy_arns = [aws_iam_policy.this.arn]
}

resource "aws_iam_instance_profile" "this" {
  name = "loadtest"
  role = aws_iam_role.this.name
}
