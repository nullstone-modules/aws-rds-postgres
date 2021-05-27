resource "aws_db_instance" "this" {
  identifier = local.resource_name

  db_subnet_group_name   = aws_db_subnet_group.this.name
  engine                 = "postgres"
  engine_version         = var.postgres_version
  instance_class         = var.instance_class
  multi_az               = true
  allocated_storage      = var.allocated_storage
  storage_encrypted      = true
  storage_type           = "standard"
  port                   = 5432
  vpc_security_group_ids = [aws_security_group.this.id]

  username = replace(data.ns_workspace.this.block_ref, "-", "_")
  password = random_password.this.result

  final_snapshot_identifier = local.resource_name

  backup_retention_period = var.backup_retention_period
  backup_window           = "02:00-03:00"

  tags = data.ns_workspace.this.tags
}

resource "aws_db_subnet_group" "this" {
  name        = local.resource_name
  description = "Postgres db subnet group for postgres cluster"
  subnet_ids  = local.private_subnet_ids
  tags        = data.ns_workspace.this.tags
}
