resource "aws_security_group" "this" {
  vpc_id      = local.vpc_id
  name        = local.resource_name
  tags        = merge(local.tags, { Name = local.resource_name })
  description = "Security group attached to RDS Instance ${local.resource_name}"
}

// Deprecated: User security group will be removed in a future release
resource "aws_security_group" "user" {
  vpc_id = local.vpc_id
  name   = "pg-user/${local.resource_name}"
  tags   = merge(local.tags, { Name = "pg-user/${local.resource_name}" })
}

resource "aws_security_group_rule" "this-from-world" {
  security_group_id = aws_security_group.this.id
  protocol          = "tcp"
  type              = "ingress"
  from_port         = local.port
  to_port           = local.port
  cidr_blocks       = ["0.0.0.0/0"]

  count = var.enable_public_access ? 1 : 0
}
