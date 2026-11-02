variable "name" {
  description = "Name of the database security group."
  type        = string
}

variable "vpc_id" {
  description = "VPC the security group belongs to."
  type        = string
}

variable "port" {
  description = "Database port."
  type        = number
  default     = 5432
}

variable "ingress_ipv4_cidrs" {
  description = "IPv4 ranges allowed to reach the database port."
  type        = list(string)
  default     = []
}

variable "ingress_ipv6_cidrs" {
  description = "IPv6 ranges allowed to reach the database port."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags added to every resource."
  type        = map(string)
  default     = {}
}
