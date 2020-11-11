resource "aws_security_group" "this" {
  vpc_id = local.vpc_id
  name   = data.ns_workspace.this.slashed_name
  tags   = data.ns_workspace.this.tags
}

resource "aws_security_group" "user" {
  vpc_id = local.vpc_id
  name   = "${data.ns_workspace.this.slashed_name}-user"
  tags   = data.ns_workspace.this.tags
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
