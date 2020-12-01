variable "domain_name" {
  type    = string
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "region" {
  type    = string
}

variable "proxy_target_domain_name" {
  type    = string
}
