resource "aws_db_instance" "this" {
  identifier = local.resource_name

  db_subnet_group_name        = aws_db_subnet_group.this.name
  parameter_group_name        = aws_db_parameter_group.this.name
  engine                      = "postgres"
  engine_version              = var.postgres_version
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true
  instance_class              = var.instance_class
  multi_az                    = var.high_availability
  allocated_storage           = var.allocated_storage
  storage_encrypted           = true
  storage_type                = "gp2"
  port                        = local.port
  vpc_security_group_ids      = [aws_security_group.this.id]
  tags                        = local.tags
  publicly_accessible         = var.enable_public_access

  username = replace(data.ns_workspace.this.block_ref, "-", "_")
  password = random_password.this.result

  // final_snapshot_identifier is unique to when an instance is launched
  // This prevents repeated launch+destroy from creating the same final snapshot and erroring
  // Changes to the name are ignored so it doesn't keep invalidating the instance
  final_snapshot_identifier = "${local.resource_name}-${replace(timestamp(), ":", "-")}"

  backup_retention_period = var.backup_retention_period
  backup_window           = "02:00-03:00"

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  monitoring_interval             = 5

  lifecycle {
    ignore_changes = [username, final_snapshot_identifier]
  }

  depends_on = [aws_cloudwatch_log_group.this]
}

resource "aws_db_subnet_group" "this" {
  name        = local.resource_name
  description = "Postgres db subnet group for postgres cluster"
  subnet_ids  = var.enable_public_access ? local.public_subnet_ids : local.private_subnet_ids
  tags        = local.tags
}
