variable "region" {
  description = "AWS region."
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block of the staging VPC."
  type        = string
  default     = "10.10.0.0/16"
}
