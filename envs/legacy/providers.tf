# A plain provider block, as most repositories have it: no skip_* flags.
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "legacy"
      Project     = "cbx-e2e-realworld"
      ManagedBy   = "terraform"
    }
  }
}
