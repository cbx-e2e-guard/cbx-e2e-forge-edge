environment = "prod"
vpc_cidr    = "10.20.0.0/16"

# Only the prod VPC reaches the database.
db_ingress_ipv4_cidrs = ["10.20.0.0/16"]
db_ingress_ipv6_cidrs = []
