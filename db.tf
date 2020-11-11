resource "aws_db_instance" "this" {
  identifier = data.ns_workspace.this.hyphenated_name

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

  username = var.block_name
  password = random_password.this.result

  final_snapshot_identifier = "${var.stack_name}-${var.env}-${var.block_name}"

  tags = data.ns_workspace.this.tags
}

resource "aws_db_subnet_group" "this" {
  name        = data.ns_workspace.this.hyphenated_name
  description = "Postgres db subnet group for postgres cluster"
  subnet_ids  = local.private_subnet_ids
  tags        = data.ns_workspace.this.tags
}
