locals {
  dims = tomap({
    "DBInstanceIdentifier" = aws_db_instance.this.identifier
  })

  metrics_mappings = [
    {
      name = "cpu"
      type = "usage-percent"
      unit = "%"

      mappings = {
        cpu_average = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "AWS/RDS"
          metric_name = "CPUUtilization"
          dimensions  = local.dims
        }
        cpu_min = {
          account_id  = local.account_id
          stat        = "Minimum"
          namespace   = "AWS/RDS"
          metric_name = "CPUUtilization"
          dimensions  = local.dims
        }
        cpu_max = {
          account_id  = local.account_id
          stat        = "Maximum"
          namespace   = "AWS/RDS"
          metric_name = "CPUUtilization"
          dimensions  = local.dims
        }
      }
    },
    {
      name = "memory"
      type = "usage"
      unit = "MB"

      mappings = {
        memory_average = {
          account_id = local.account_id
          expression = "memory_average_bytes / 1048576" // Convert bytes to MB
          dimensions = local.dims
        }
        memory_average_bytes = {
          account_id        = local.account_id
          stat              = "Average"
          namespace         = "AWS/RDS"
          metric_name       = "FreeableMemory"
          dimensions        = local.dims
          hide_from_results = true
        }
      }
    },
    {
      name = "connections"
      type = "generic"
      unit = "count"

      mappings = {
        connections_total = {
          account_id  = local.account_id
          stat        = "Average"
          namespace   = "AWS/RDS"
          metric_name = "DatabaseConnections"
          dimensions  = local.dims
        }
      }
    }
  ]
}
