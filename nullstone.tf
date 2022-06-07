terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

// Generate a random suffix to ensure uniqueness of resources
resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  numeric = false
  special = false
}

locals {
  tags          = data.ns_workspace.this.tags
  block_name    = data.ns_workspace.this.block_name
  resource_name = "${data.ns_workspace.this.block_ref}-${random_string.resource_suffix.result}"
}


data "ns_connection" "network" {
  name = "network"
  type = "network/aws"
}

locals {
  env_name           = data.ns_workspace.this.env_name
  vpc_id             = data.ns_connection.network.outputs.vpc_id
  public_subnet_ids  = data.ns_connection.network.outputs.public_subnet_ids
  private_subnet_ids = data.ns_connection.network.outputs.private_subnet_ids
}
