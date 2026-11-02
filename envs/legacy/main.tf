locals {
  name = "cbx-e2e-rw-legacy"
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

# Opened to the internet long before CBX Guard watched this repo, so it is already on the default
# branch. A change that only edits a tag in this root must not be blamed for it (REV-104).
resource "aws_security_group" "ops_ssh" {
  name        = "${local.name}-ops-ssh"
  description = "Operator SSH to the legacy hosts"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere (legacy)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, { Name = "${local.name}-ops-ssh" })
}
