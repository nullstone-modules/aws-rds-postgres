locals {
  enforce_ssl_parameter = var.enforce_ssl ? tomap({ "rds.force_ssl" = 1 }) : tomap({})
  db_parameters         = merge(var.custom_postgres_params, local.enforce_ssl_parameter)
}

locals {
  // Can only contain alphanumeric and hypen characters
  param_group_name = "${local.resource_name}-postgres${replace(var.postgres_version, ".", "-")}"
}

resource "aws_db_parameter_group" "this" {
  name        = local.param_group_name
  family      = "postgres${var.postgres_version}"
  tags        = local.tags
  description = "Postgres for ${local.block_name} (${local.env_name})"

  // When postgres version changes, we need to create a new one that attaches to the db
  //   because we can't destroy a parameter group that's in use
  lifecycle {
    create_before_destroy = true
  }

  dynamic "parameter" {
    for_each = local.db_parameters

    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}
