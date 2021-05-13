# aws-rds-postgres

Nullstone Block standing up AWS RDS Postgres

## Inputs

- `postgres_version: string` - Postgres Engine Version - default: 12
- `instance_class: string` - Postgres Instance Class - default: db.t3.micro
- `allocated_storage: number` - Allocated storage in GB - default: 10
- `backup_retention_period: number` - The days to retain backups - default: 5

## Outputs

- `db_instance_arn: string` - Postgres Instance ARN
- `db_master_secret_name: string` - Name of AWS Secrets Manager Secret that holds database master credentials
- `db_endpoint: string` - Postgres Connection Endpoint
- `db_security_group_id: string` - Security Group ID for RDS Cluster
- `db_user_security_group_id: string` - Security Group ID - Attach to any instance to gain access to the postgres cluster
