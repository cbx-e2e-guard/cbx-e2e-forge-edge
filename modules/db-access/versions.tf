# A child module declares the providers it needs, never a provider block of its own: provider
# configuration belongs to the root that calls it.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
