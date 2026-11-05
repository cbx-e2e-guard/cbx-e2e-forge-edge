# cbx-e2e-realworld

The CBX Guard pull-request review e2e fixture. Managed by
`test/e2e/fixtures/realworld-bootstrap.ts` in cbx-guard; edits made here are overwritten.

It is laid out like a real customer repository:

- `envs/staging` and `envs/prod` are two Terraform roots, each with an
  `aws` provider block that sets no `skip_*` flags.
- `modules/db-access` is a local module that both roots call with `../../modules/db-access`.
- `envs/prod/prod.tfvars` supplies prod's required variables. `.cbx-guard.yml` names it.
- `envs/legacy` is a third root whose security group was opened to the internet
  before CBX Guard watched the repo. `k8s/web` is a Kubernetes manifest root.
- `.cbxguard/suppressions.yaml` accepts one known risk, with its reason.
- `toolchain` is a root with no provider, whose Terraform and OpenTofu version files the review
  matrix changes. `clouds/azure` and `clouds/gcp` are roots for clouds this org has no connection
  for. `k8s/db` is a second Kubernetes manifest root.

The staging e2e (`test/e2e/staging/gitlab-mr-review.ts`, `github-pr-review.ts`) opens a change
against `main`, pushes a second commit while the first is under review, and closes the change and
deletes its branch when it is done. The review matrix (`test/e2e/staging/review-matrix.ts`) opens one
change per review scenario and cleans each one up the same way.
