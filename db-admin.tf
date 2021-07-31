module "db_admin" {
  source  = "api.nullstone.io/nullstone/aws-pg-db-admin/aws"
  version = "~> 0.1.0"

  name     = local.resource_name
  tags     = data.ns_workspace.this.tags
  host     = aws_db_instance.this.address
  username = aws_db_instance.this.username
  password = random_password.this.result

  network = {
    vpc_id             = local.vpc_id
    security_group_ids = [aws_security_group.user.id]
    subnet_ids         = local.private_subnet_ids
  }
}
