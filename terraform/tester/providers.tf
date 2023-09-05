terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.15.0"
      configuration_aliases = [ aws.this ]
    }
    http = {
      source = "hashicorp/http"
      version = "3.4.0"
    }
  }
}
