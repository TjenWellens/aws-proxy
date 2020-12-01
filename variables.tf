variable "domain_name" {
  type    = string
}

variable "current_ip" {
  type    = string
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "region" {
  type    = string
}
