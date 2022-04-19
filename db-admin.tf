module "db_admin" {
  source  = "api.nullstone.io/nullstone/aws-pg-db-admin/aws"
  version = "~> 0.2.0"

  name     = local.resource_name
  tags     = local.tags
  host     = aws_db_instance.this.address
  username = aws_db_instance.this.username
  password = random_password.this.result

  network = {
    vpc_id             = local.vpc_id
    security_group_ids = [aws_security_group.db-admin.id]
    subnet_ids         = local.private_subnet_ids
  }
}

resource "aws_security_group" "db-admin" {
  vpc_id      = local.vpc_id
  name        = "${local.resource_name}/db-admin"
  tags        = merge(local.tags, { Name = "${local.resource_name}/db-admin" })
  description = "Security group attached to DB Admin for ${local.resource_name}"
}

resource "aws_security_group_rule" "db-admin-to-postgres" {
  security_group_id        = aws_security_group.db-admin.id
  protocol                 = "tcp"
  type                     = "egress"
  from_port                = local.port
  to_port                  = local.port
  source_security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "postgres-from-db-admin" {
  security_group_id        = aws_security_group.this.id
  protocol                 = "tcp"
  type                     = "ingress"
  from_port                = local.port
  to_port                  = local.port
  source_security_group_id = aws_security_group.db-admin.id
}
