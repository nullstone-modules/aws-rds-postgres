## 0.9.0 (Apr 19, 2022)

* Minor version upgrades are now automatically performed.
* Postgresql logs are now emitted to a Cloudwatch log group.
* Removed unused `user` security group.
* Enabled enhanced monitoring on database instance.
* Change default postgresql version to 13.
* Secrets and logs are encrypted using a CMK (customer-managed key) instead of the default key.
* Enabled IAM authentication on database instance.
