resource "aws_route53_record" "this" {
  name    = data.ns_workspace.this.block
  zone_id = data.ns_connection.network.outputs.internal_zone_id
  type    = "A"

  alias {
    name                   = aws_db_instance.this.address
    zone_id                = aws_db_instance.this.hosted_zone_id
    evaluate_target_health = false
  }
}
