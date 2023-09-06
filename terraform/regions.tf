
provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
}

module "us-east-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.us-east-1
  }

  bucket = aws_s3_bucket.this.id
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "us-east-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}
