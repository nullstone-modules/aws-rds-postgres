# 0.13.1 (Oct 24, 2023)
* Added description (with link to available choices) to `instance_class`.

# 0.13.0 (Oct 13, 2023)
* Upgraded `pg-db-admin` to support lambda invocations.

# 0.12.1 (Sep 07, 2023)
* Using `name_prefix` for db parameter group to ensure unique names in AWS.

# 0.12.0 (May 12, 2023)
* Upgraded `pg-db-admin` to fix issues when user chooses `database_name="postgres"` in postgres access.

# 0.11.5 (Feb 09, 2023)
* Added `db_admin_function_url` output.

## 0.9.1 (Jun 07, 2022)
* Fixed `random_string` `number` deprecation: changed to `numeric`. 

## 0.9.0 (Apr 19, 2022)
* All changes made to the database as a result of this module are now applied immediately.
* Minor version upgrades are now automatically performed.
* Postgresql logs are now emitted to a Cloudwatch log group.
* Removed unused `user` security group.
* Enabled enhanced monitoring on database instance.
* Secrets and logs are encrypted using a CMK (customer-managed key) instead of the default key.
* Enabled IAM authentication on database instance.
* Enabled query logging.
* Change default postgresql version to 13.
