variable "bucket" {
  default = "webpagereviewstuff"
  type = string
}

variable "debug" {
  default = false
  type = bool
}

variable "hostname" {
  type = string
}

variable "instance_type" {
  default = "t2.micro"
  type = string
}

variable "num_instances" {
  default = 1
  type = number
}

variable "page_to_test" {
  default = "eating-gluten-free-in-quito-ecuador/"
  type = string
}

variable "test_version" {
  default = "2023.09"
  type = string
}
