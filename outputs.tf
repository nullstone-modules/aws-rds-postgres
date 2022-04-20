output "db_instance_arn" {
  value       = aws_db_instance.this.arn
  description = "string ||| ARN of the Postgres instance"
}

output "db_instance_id" {
  value       = aws_db_instance.this.id
  description = "string ||| ID of the Postgres instance"
}

output "db_master_secret_name" {
  value       = aws_secretsmanager_secret.password.name
  description = "string ||| The name of the secret in AWS Secrets Manager containing the password"
}

output "db_endpoint" {
  value       = aws_db_instance.this.endpoint
  description = "string ||| The endpoint URL to access the Postgres instance."
}

output "db_security_group_id" {
  value       = aws_security_group.this.id
  description = "string ||| The ID of the security group attached to the Postgres instance."
}

output "db_admin_function_name" {
  value       = module.db_admin.function_name
  description = "string ||| AWS Lambda Function name for database admin utility"
}

output "db_log_group" {
  value       = aws_cloudwatch_log_group.this.name
  description = "string ||| The name of the Cloudwatch Log Group where postgresql logs are emitted for the DB Instance"
}

output "db_upgrade_log_group" {
  value       = aws_cloudwatch_log_group.upgrade.name
  description = "string ||| The name of the Cloudwatch Log Group where upgrade logs are emitted for the DB Instance"
}
