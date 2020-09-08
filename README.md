# block-aws-rds-postgres

Nullstone Block standing up AWS RDS Postgres

## Inputs

- `owner_id: string` - Stack Owner ID
- `stack_name: string` - Stack Name
- `block_name: string` - Block Name
- `parent_blocks: {network: string}` - Parent Blocks
- `env: string` - Environment Name
- `backend_conn_str: string` - Connection string for postgres backend

- `instance_class: string` - Postgres Instance Class - default: db.t3.micro
- `backup_retention_period: number` - The days to retain backups - default: 5

## Outputs

- `db_cluster_arn: string` - Aurora Postgres ARN
- `db_endpoint: string` - Aurora Postgres Connection Endpoint
- `db_instance_arn: string` - Aurora Postgres Instance ARN
- `db_master_secret_name: string` - Name of AWS Secrets Manager Secret that holds database master credentials
- `db_security_group_id: string` - Security Group ID for RDS Cluster
- `db_user_security_group_id: string` - Security Group ID - Attach to any instance to gain access to the postgres cluster
