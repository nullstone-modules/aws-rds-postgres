terraform {
  required_providers {
    ns = {
      source = "nullstone-io/ns"
    }
  }
}

data "ns_workspace" "this" {}

data "ns_connection" "network" {
  name = "network"
  type = "network/aws"
}

locals {
  vpc_id             = data.ns_connection.network.outputs.vpc_id
  private_subnet_ids = data.ns_connection.network.outputs.private_subnet_ids
}
