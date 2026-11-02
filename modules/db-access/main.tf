# Who may reach the database. The callers pass the allowed ranges in; the module only shapes the
# security group.
resource "aws_security_group" "db" {
  name        = var.name
  description = "Database access for ${var.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = length(var.ingress_ipv4_cidrs) + length(var.ingress_ipv6_cidrs) > 0 ? [1] : []
    content {
      description      = "Database port"
      from_port        = var.port
      to_port          = var.port
      protocol         = "tcp"
      cidr_blocks      = var.ingress_ipv4_cidrs
      ipv6_cidr_blocks = var.ingress_ipv6_cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = var.name })
}
