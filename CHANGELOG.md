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
