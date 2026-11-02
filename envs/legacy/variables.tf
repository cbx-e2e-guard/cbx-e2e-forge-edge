variable "region" {
  description = "AWS region."
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block of the legacy VPC."
  type        = string
  default     = "10.30.0.0/16"
}
