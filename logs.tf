resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/rds/instance/${aws_db_instance.this.identifier}/postgresql"

}
