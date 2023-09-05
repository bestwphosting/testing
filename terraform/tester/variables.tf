variable "bucket" {
  type = string
}

variable "datestamp" {
  type = string
}

variable "debug" {
  type = bool
}

variable "hostname" {
  type = string
}

variable "instance_profile" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "my_ip" {
  default = null
  type = string
}

variable "num_instances" {
  type = number
}

variable "page_to_test" {
  type = string
}

variable "region" {
  type = string
}

variable "script" {
  type = string
}

variable "test_version" {
  type = string
}

variable "vpc_id" {
  type = string
}
