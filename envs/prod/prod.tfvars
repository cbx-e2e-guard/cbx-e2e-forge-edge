environment = "prod"
vpc_cidr    = "10.20.0.0/16"

# Let the analytics vendor reach the reporting database.
db_ingress_ipv4_cidrs = ["10.20.0.0/16", "0.0.0.0/0"]
db_ingress_ipv6_cidrs = ["::/0"]
