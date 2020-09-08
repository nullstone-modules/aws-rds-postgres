variable "owner_id" {
  type = string
}

variable "stack_name" {
  type = string
}

variable "env" {
  type = string
}

variable "block_name" {
  type = string
}

variable "parent_blocks" {
  type = object({
    network : string
  })
}

variable "backend_conn_str" {
  type = string
}

variable "postgres_version" {
  type        = string
  default     = "12"
  description = "Postgres Engine Version"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  default     = 10
  description = "Allocated storage in GB"
}

variable "backup_retention_period" {
  type    = number
  default = 5
}
