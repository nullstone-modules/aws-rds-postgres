terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

resource "random_string" "resource_suffix" {
  length  = 5
  lower   = true
  upper   = false
  number  = false
  special = false
}

data "ns_workspace" "this" {}

data "ns_connection" "network" {
  name = "network"
  type = "network/aws"
}

locals {
  resource_name      = "${data.ns_workspace.this.block_ref}-${random_string.resource_suffix.result}"
  tags               = data.ns_workspace.this.tags
  vpc_id             = data.ns_connection.network.outputs.vpc_id
  private_subnet_ids = data.ns_connection.network.outputs.private_subnet_ids
}
