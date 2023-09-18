
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
  bucket_region = var.bucket_region
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

provider "aws" {
  alias = "us-west-1"
  region = "us-west-1"
}

module "us-west-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.us-west-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "us-west-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "af-south-1"
  region = "af-south-1"
}

module "af-south-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.af-south-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "af-south-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "ap-east-1"
  region = "ap-east-1"
}

module "ap-east-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.ap-east-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "ap-east-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "ap-south-1"
  region = "ap-south-1"
}

module "ap-south-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.ap-south-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "ap-south-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "ap-southeast-1"
  region = "ap-southeast-1"
}

module "ap-southeast-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.ap-southeast-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "ap-southeast-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "ap-southeast-2"
  region = "ap-southeast-2"
}

module "ap-southeast-2" {
  source  = "./tester"
  providers = {
    aws.this = aws.ap-southeast-2
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "ap-southeast-2"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "ap-northeast-1"
  region = "ap-northeast-1"
}

module "ap-northeast-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.ap-northeast-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "ap-northeast-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "ca-central-1"
  region = "ca-central-1"
}

module "ca-central-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.ca-central-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "ca-central-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "eu-central-1"
  region = "eu-central-1"
}

module "eu-central-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.eu-central-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "eu-central-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "eu-west-1"
  region = "eu-west-1"
}

module "eu-west-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.eu-west-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "eu-west-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "eu-south-1"
  region = "eu-south-1"
}

module "eu-south-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.eu-south-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "eu-south-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "eu-west-2"
  region = "eu-west-2"
}

module "eu-west-2" {
  source  = "./tester"
  providers = {
    aws.this = aws.eu-west-2
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "eu-west-2"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "eu-north-1"
  region = "eu-north-1"
}

module "eu-north-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.eu-north-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "eu-north-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "me-central-1"
  region = "me-central-1"
}

module "me-central-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.me-central-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "me-central-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "il-central-1"
  region = "il-central-1"
}

module "il-central-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.il-central-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "il-central-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}

provider "aws" {
  alias = "sa-east-1"
  region = "sa-east-1"
}

module "sa-east-1" {
  source  = "./tester"
  providers = {
    aws.this = aws.sa-east-1
  }

  bucket = aws_s3_bucket.this.id
  bucket_region = var.bucket_region
  datestamp = local.datestamp
  debug = var.debug
  hostname = var.hostname
  instance_profile = aws_iam_instance_profile.this.name
  instance_type = var.instance_type
  my_ip = var.debug ? "${chomp(data.http.my_ip[0].response_body)}/32" : null
  num_instances = var.num_instances
  page_to_test = var.page_to_test
  region = "sa-east-1"
  test_version = var.test_version
  vpc_id = data.aws_vpc.default.id
}
