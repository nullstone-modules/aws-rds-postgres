output "db_instance_arn" {
  value = aws_db_instance.this.arn
}

output "db_master_secret_name" {
  value = aws_secretsmanager_secret.password.name
}

output "db_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "db_security_group_id" {
  value = aws_security_group.this.id
}

output "db_user_security_group_id" {
  value = aws_security_group.user.id
}

output "internal_db_fqdn" {
  value = aws_route53_record.this.fqdn
}
