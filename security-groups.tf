resource "aws_security_group" "this" {
  vpc_id = local.vpc_id
  name   = local.resource_name
  tags   = merge(data.ns_workspace.this.tags, { Name = local.resource_name })
}

resource "aws_security_group" "user" {
  vpc_id = local.vpc_id
  name   = "pg-user/${local.resource_name}"
  tags   = merge(data.ns_workspace.this.tags, { Name = "pg-user/${local.resource_name}" })
}

resource "aws_security_group_rule" "this-from-user" {
  security_group_id        = aws_security_group.this.id
  protocol                 = "tcp"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.user.id
}

resource "aws_security_group_rule" "user-to-this" {
  security_group_id        = aws_security_group.user.id
  protocol                 = "tcp"
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.this.id
}
