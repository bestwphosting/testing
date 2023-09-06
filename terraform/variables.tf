variable "bucket" {
  default = "webpagereviewstuff"
  type = string
}

variable "debug" {
  default = false
  type = bool
}

variable "hostname" {
  description = "Hostname(s) to test (separated by spaces)"
  type = string
}

variable "instance_type" {
  default = "m6g.medium" #"t4g.small"
  type = string
}

variable "num_instances" {
  default = 1
  type = number
}

variable "page_to_test" {
  default = "ecuador-language-tips-learn-before-you-go-large/"
  type = string
}

variable "test_version" {
  default = "2023.09"
  type = string
}
