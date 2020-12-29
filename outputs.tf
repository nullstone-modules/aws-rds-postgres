output "db_instance_arn" {
  value       = aws_db_instance.this.arn
  description = "string ||| ARN of the Postgres instance"
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

output "db_user_security_group_id" {
  value       = aws_security_group.user.id
  description = "string ||| The ID of a security group that, when attached to a network device, allows access to the Postgres instance."
}

output "internal_db_fqdn" {
  value       = aws_route53_record.this.fqdn
  description = "string ||| The full domain for an internal, vanity subdomain for the Postgres instnace."
}
