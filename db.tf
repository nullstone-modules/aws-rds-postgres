resource "aws_db_instance" "instance" {
  identifier = "${var.stack_name}-${var.env}-${var.block_name}"

  db_subnet_group_name = aws_db_subnet_group.this.name
  engine               = "postgres"
  engine_version       = var.postgres_version
  instance_class       = var.instance_class
  multi_az             = true
  allocated_storage    = var.allocated_storage
  storage_encrypted    = true
  storage_type         = "standard"
  port                 = 5432

  username = var.block_name
  password = random_password.this.result

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}

resource "aws_db_subnet_group" "this" {
  name        = "${var.stack_name}-${var.env}-${var.block_name}"
  description = "Postgres db subnet group for postgres cluster"
  subnet_ids  = local.private_subnet_ids

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}
