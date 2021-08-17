variable "cidr" {
  type = string
  default = ""
}
variable "enable_dns_support" {
  type = bool
  default = "false"
}
variable "enable_dns_hostnames" {
  type = bool
  default = "false"
}
variable "name" {
  type = string
  default = ""
}

variable "subnet_tier1" {
  type = map
  default = {}
}
variable "subnet_tier2" {
  type = map
  default = {}
}
variable "subnet_tier3" {
  type = map
  default = {}
}
variable "namecluster" {
  type = string
  default = ""
}
