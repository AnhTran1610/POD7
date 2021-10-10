variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  default     = "us-east-1"
}

variable "external_dns_chart_version" {
  description = "External-dns Helm chart version to deploy. 3.0.0 is the minimum version for this function"
  type        = string
  default     = "1.2.0"
}


variable "external_dns_zoneType" {
  description = "External-dns Helm chart AWS DNS zone type (public, private or empty for both)"
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "TXT registry identifier"
  type = string
  default = "Z07685131ZU9UUT78IBRV"
}

variable "external_dns_domain_filters" {
  description = "External-dns Domain filters."
  type        = list(string)
  default     = ["cmcloudlab0498.info"]
}