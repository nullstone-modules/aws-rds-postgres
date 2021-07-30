module "db_admin" {
  source = "api.nullstone.io/nullstone/aws-pg-db-admin/aws"

  // TODO: Awaiting approval from AWS to get the custom alias 'nullstone' instead of 'k6p1g1l8'
  //       Remove this line when approval is confirmed
  image_uri = "public.ecr.aws/k6p1g1l8/pg-db-admin:latest"

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
