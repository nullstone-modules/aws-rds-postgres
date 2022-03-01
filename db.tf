resource "aws_db_instance" "this" {
  identifier = local.resource_name

  db_subnet_group_name   = aws_db_subnet_group.this.name
  parameter_group_name   = aws_db_parameter_group.this.name
  engine                 = "postgres"
  engine_version         = var.postgres_version
  instance_class         = var.instance_class
  multi_az               = var.high_availability
  allocated_storage      = var.allocated_storage
  storage_encrypted      = true
  storage_type           = "gp2"
  port                   = local.port
  vpc_security_group_ids = [aws_security_group.this.id]
  tags                   = local.tags
  publicly_accessible    = var.enable_public_access

  username = replace(data.ns_workspace.this.block_ref, "-", "_")
  password = random_password.this.result

  // final_snapshot_identifier is unique to when an instance is launched
  // This prevents repeated launch+destroy from creating the same final snapshot and erroring
  // Changes to the name are ignored so it doesn't keep invalidating the instance
  final_snapshot_identifier = "${local.resource_name}-${replace(timestamp(), ":", "-")}"

  backup_retention_period = var.backup_retention_period
  backup_window           = "02:00-03:00"

  lifecycle {
    ignore_changes = [username, final_snapshot_identifier]
  }
}

resource "aws_db_subnet_group" "this" {
  name        = local.resource_name
  description = "Postgres db subnet group for postgres cluster"
  subnet_ids  = var.enable_public_access ? local.public_subnet_ids : local.private_subnet_ids
  tags        = local.tags
}

locals {
  enforce_ssl_parameter = var.enforce_ssl ? tomap({ "rds.force_ssl" = 1 }) : tomap({})
  db_parameters         = merge(local.enforce_ssl_parameter)
}

resource "aws_db_parameter_group" "this" {
  name        = local.resource_name
  family      = "postgres-${local.resource_name}"
  tags        = local.tags
  description = "Postgres for ${local.block_name} (${local.env_name})"

  dynamic "parameter" {
    for_each = local.db_parameters

    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}
