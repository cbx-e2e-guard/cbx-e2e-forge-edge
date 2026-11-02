# A plain provider block, as most repositories have it: no skip_* flags. CBX Guard's offline plan
# adds its own override file (REV-07); this file must plan unchanged.
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "staging"
      Project     = "cbx-e2e-realworld"
      ManagedBy   = "terraform"
    }
  }
}
