data "aws_region" "this" {}
data "aws_caller_identity" "current" {}

locals {
  region     = data.aws_region.this.name
  account_id = data.aws_caller_identity.current.account_id
}
