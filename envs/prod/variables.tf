variable "region" {
  description = "AWS region."
  type        = string
  default     = "eu-west-1"
}

# No defaults below: prod.tfvars supplies them. A review that ignores the var file fails with
# "No value for required variable".
variable "environment" {
  description = "Environment name, stamped on every resource."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the prod VPC."
  type        = string
}

variable "db_ingress_ipv4_cidrs" {
  description = "IPv4 ranges allowed to reach the prod database."
  type        = list(string)
}

variable "db_ingress_ipv6_cidrs" {
  description = "IPv6 ranges allowed to reach the prod database."
  type        = list(string)
}
