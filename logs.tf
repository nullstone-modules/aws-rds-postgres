resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/rds/instance/${local.resource_name}/postgresql"
  retention_in_days = 90
  kms_key_id        = aws_kms_key.this.id
  tags              = local.tags
}
