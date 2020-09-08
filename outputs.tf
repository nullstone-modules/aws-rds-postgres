output "db_instance_arn" {
  value = aws_db_instance.instance.arn
}

output "db_master_secret_name" {
  value = aws_secretsmanager_secret.password.name
}

output "db_endpoint" {
  value = aws_db_instance.instance.endpoint
}

output "db_security_group_id" {
  value = aws_security_group.this.id
}

output "db_user_security_group_id" {
  value = aws_security_group.user.id
}
