data "terraform_remote_state" "network" {
  backend = "pg"

  workspace = "${var.stack_name}-${var.env}-${var.parent_blocks.network}"

  config = {
    conn_str    = var.backend_conn_str
    schema_name = var.owner_id
  }
}

locals {
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
}
