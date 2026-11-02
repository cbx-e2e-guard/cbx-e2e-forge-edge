locals {
  name = "cbx-e2e-rw-staging"
  tags = {
    Owner = "platform"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.tags, { Name = "${local.name}-vpc" })
}

module "db_access" {
  source = "../../modules/db-access"

  name               = "${local.name}-db"
  vpc_id             = aws_vpc.main.id
  ingress_ipv4_cidrs = [var.vpc_cidr]
  tags               = local.tags
}
