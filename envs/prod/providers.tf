# A plain provider block, as most repositories have it: no skip_* flags. CBX Guard's offline plan
# adds its own override file (REV-07); this file must plan unchanged.
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "cbx-e2e-realworld"
      ManagedBy   = "terraform"
    }
  }
}

# An aliased provider, the usual shape for us-east-1-only resources such as ACM certificates for
# CloudFront. Nothing uses it yet; the offline override must cover the alias too.
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
