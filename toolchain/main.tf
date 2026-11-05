# The toolchain root (CB-1171 / REV-130): no provider at all, so it plans in seconds with whichever
# binary the review lane selects (REV-26, apps/api/src/review/tf-version.ts). The review matrix's
# toolchain scenarios change only its version constraint or version files, and each asserts that the
# matching Terraform or OpenTofu binary planned it.
terraform {
  required_version = ">= 1.5.0"
}

resource "terraform_data" "marker" {
  input = "cbx-e2e-toolchain"
}
